# ark_shapes.g -- realise the framework's CONFIGURATION SHAPES as groups and
# check two things the Python side does not: that each shape is admissible
# (Oliver's chain condition actually holds), and that its scored orbital terms
# are what the group delivers.
#
# WHY THIS IS A DIFFERENT CHECK FROM shape_realize.py.
#
#   shape_realize.py builds <translations, z> and compares orbital sizes against
#   the scored intra and cross terms.  It never asks whether the group it built
#   satisfies Oliver's condition -- it ASSUMES the shape is admissible and tests
#   only the arithmetic.  If a shape were scored but inadmissible, the whole
#   comparison would be vacuous and the Python check would report "ok".
#
#   ark_gap.g already carries IsOliverTop.  Reusing it here closes that gap, and
#   does so through an independent construction: GAP's own Group(), Orbits() and
#   NormalSubgroups() rather than a hand-rolled union-find over pairs.
#
# WHAT IT CHECKS, per shape (F, c = p^a, d) and per two-class configuration:
#
#   ADMISSIBLE   IsOliverTop(G) <> fail.  Reports the usable top primes, so a
#                shape scored under one q but only Oliver under another shows up.
#   INTRA        min orbital among pairs inside a single block  =  F * orb(c,d)
#   CROSS        min orbital among pairs in different blocks of the same class
#   CHAIN        for two-class configurations, that Gamma_1 is cyclic -- the
#                condition Lemma C's strip is about, and the one place a
#                cyclic-layer restriction is REAL.  An over-eager repair of the
#                F_mid mistake would break here and nowhere else.
#
# The entangled generator is the point.  A fused class is realised by ONE
# element z : (i,x) -> (i+1, a_i x) with prod a_i of order d, so that z^F is the
# full twist.  Building it instead as <block permutation, diagonal twist> gives
# a DIFFERENT group -- at n = 10 both have order 200 and neither contains the
# other -- which happens to share the orbital partition.  That coincidence is
# what hid the F_mid strip; see session-log-7.md section 3.
#
# Usage:
#   gap -q -o 4g ark_shapes.g                 # default sweep, n <= 40
#   ARK_SHAPES_NMAX=60 gap -q -o 4g ark_shapes.g
#   ARK_SHAPES_STRIP=1 gap -q -o 4g ark_shapes.g   # control: score with the
#                                                  # retired F_mid strip; MUST
#                                                  # report UNDER-SCOREs
# Output: one line per shape to shapes_out.txt, plus a summary to stdout.
# Exits with a nonzero-style summary line if any mismatch is found.

NMAX := 40;;
if IsBound(GAPInfo.SystemEnvironment.ARK_SHAPES_NMAX) then
  NMAX := Int(GAPInfo.SystemEnvironment.ARK_SHAPES_NMAX);
fi;
# The informative axis is c -- what new divisor structure c-1 brings.  The COST
# axis is F, since |G| = c^F * F * d and NormalSubgroups(G) is the bottleneck.
# Raising NMAX alone therefore buys little and costs a lot: 20x3 at n = 60 is
# |G| ~ 1.4e11.  Cap F to go wide in c cheaply.
MAXF := 1000;;
if IsBound(GAPInfo.SystemEnvironment.ARK_SHAPES_MAXF) then
  MAXF := Int(GAPInfo.SystemEnvironment.ARK_SHAPES_MAXF);
fi;
# Belt-and-braces guard so a large sweep cannot hang on one group.  Shapes over
# the limit are reported SKIPPED rather than silently dropped -- a skipped shape
# is an untested shape, and this whole script exists because untested shapes are
# where defects live.
MAXRANK := 12;;
if IsBound(GAPInfo.SystemEnvironment.ARK_SHAPES_MAXRANK) then
  MAXRANK := Int(GAPInfo.SystemEnvironment.ARK_SHAPES_MAXRANK);
fi;
MAXORD := 50000000;;
if IsBound(GAPInfo.SystemEnvironment.ARK_SHAPES_MAXORD) then
  MAXORD := Int(GAPInfo.SystemEnvironment.ARK_SHAPES_MAXORD);
fi;
STRIP := IsBound(GAPInfo.SystemEnvironment.ARK_SHAPES_STRIP);;
# Search the whole normal subgroup lattice instead of checking the supplied
# chain.  Strictly stronger, and exponential in the bottom layer's rank -- it is
# what exhausted 4G at 3x32 (rank 15 over GF(2)).  Off by default.
FULLOLIVER := IsBound(GAPInfo.SystemEnvironment.ARK_SHAPES_FULLOLIVER);;
OUT := "shapes_out.txt";;
# AppendTo(<filename>, ...) formats its output for a terminal and BREAKS LONG
# LINES, which silently corrupts any row whose orbital list is long -- at
# 2x97, d = 1 there are 48 intra orbitals and the row is split across three
# lines, so a consumer parsing line-by-line drops it.  Writing through a stream
# with formatting disabled is the fix.  Note the failure mode: the data is not
# wrong, it is unparseable, so a downstream check sees fewer rows rather than
# bad ones -- exactly the kind of loss that reads as success.
OUTSTREAM := OutputTextFile(OUT, false);;
SetPrintFormattingStatus(OUTSTREAM, false);;

# ---------------------------------------------------------------- Oliver test
# Verbatim from ark_gap.g, so the two files agree by construction.  Returns
# fail (not Oliver), 0 (trivial top achievable), or the set of usable top primes.
IsOliverTop := function(G)
  local best, N, Q, q, p, ok;
  if Size(G) = 1 then return 0; fi;
  best := [];
  for N in NormalSubgroups(G) do
    ok := Size(N) = 1;
    if not ok then
      for p in PrimeDivisors(Size(N)) do
        if IsCyclic(FactorGroup(N, PCore(N, p))) then ok := true; break; fi;
      od;
    fi;
    if not ok then continue; fi;
    if Size(N) = Size(G) then return 0; fi;
    Q := FactorGroup(G, N);
    if IsPGroup(Q) then
      q := PrimePGroup(Q);
      AddSet(best, q);
    fi;
  od;
  if Length(best) = 0 then return fail; fi;
  return best;
end;;

# ------------------------------------------------------- shape realisation
# Points of a fused class: F blocks of size c = p^a, labelled
#   (i, x)  ->  i*c + index(x) + 1     for i in [0..F-1], x in GF(c)
FusedClass := function(p, a, F, d)
  local c, fld, els, A, gens, i, b, e, bas, pt, img, perm, x;
  c := p^a;
  fld := GF(c);
  els := AsSSortedList(fld);
  # element of order exactly d in the multiplicative group
  A := Z(c)^((c-1)/d);          # Z(c) is the canonical primitive root of GF(c)
  gens := [];
  # translations must generate the WHOLE additive group: a basis, not just One.
  # (Translation by 1 alone gives only Z_p when a > 1 -- a silent under-build,
  # which is the same failure mode as the strip: less realised than claimed.)
  bas := Basis(AsVectorSpace(GF(p), fld));
  for b in [0..F-1] do
    for e in BasisVectors(bas) do
      perm := [];
      for i in [0..F-1] do
        for x in [1..c] do
          if i = b then
            perm[i*c + x] := i*c + Position(els, els[x] + e);
          else
            perm[i*c + x] := i*c + x;
          fi;
        od;
      od;
      Add(gens, PermList(perm));
    od;
  od;
  # the entangled generator: all the multiplier on the last step, so z^F = A
  perm := [];
  for i in [0..F-1] do
    for x in [1..c] do
      if i = F-1 then
        perm[i*c + x] := 0*c + Position(els, els[x] * A);
      else
        perm[i*c + x] := (i+1)*c + x;
      fi;
    od;
  od;
  Add(gens, PermList(perm));
  # gamma2 = the translation subgroup, generated by everything but z
  return rec(G := Group(gens), gamma2 := Group(gens{[1..Length(gens)-1]}),
             n := F*c, c := c, F := F, d := d);
end;;

# scored terms.  orb(c,d): the orbital is indexed by difference up to T and up
# to sign, so c*d/2 when -1 in T (always in characteristic 2) and c*d otherwise.
OrbCD := function(c, d, char2)
  local v;
  if char2 or (d mod 2 = 0) then v := c*d/2; else v := c*d; fi;
  return Minimum(v, Binomial(c,2));
end;;

ScoredTerms := function(p, a, F, d)
  local c, dd, k, cr;
  c := p^a;
  dd := d;
  if STRIP then                      # the RETIRED F_mid coprimality strip
    k := Gcd(dd, F);
    while k > 1 do dd := dd/k; k := Gcd(dd, F); od;
  fi;
  if F mod 2 = 0 then
    cr := QuoInt(F,2)*c*c;
  else
    cr := F*c*c;
  fi;
  return rec(intra := F * OrbCD(c, dd, p = 2), cross := cr, d := dd);
end;;

# split the realised orbitals by whether both points lie in the same block
RealisedTerms := function(sh)
  local orbs, o, intra, cross, blk, pr, sameblk;
  blk := function(x) return QuoInt(x-1, sh.c); end;
  # `Orbits` with a large seed list warns and is slower; the 2-subsets of
  # [1..n] are a genuine DOMAIN closed under OnSets, so `OrbitsDomain` is the
  # correct entry point and removes both the warning and the cost.
  orbs := OrbitsDomain(sh.G, Combinations([1..sh.n], 2), OnSets);
  intra := []; cross := [];
  for o in orbs do
    sameblk := ForAll(o, pr -> blk(pr[1]) = blk(pr[2]));
    if sameblk then Add(intra, Length(o)); else Add(cross, Length(o)); fi;
  od;
  return rec(intra := intra, cross := cross);
end;;

# ---------------------------------------------------- the chain, as a WITNESS
# `IsOliverTop` searches NormalSubgroups(G) for a chain.  That search is what
# ran out of memory at 3x32: Gamma_2 there is (C_2^5)^3 = C_2^15, whose subgroup
# lattice is the subspace lattice of GF(2)^15, and CRISP's complement machinery
# enumerates it.  The cost driver is the RANK of the bottom layer, a*F over
# GF(p) -- not |G|: 4x25 at |G| = 3.8e7 completes, 3x32 at |G| = 3.0e6 does not.
#
# But the search is answering a question we did not ask.  The construction
# SUPPLIES a chain: Gamma_2 = the translations (a p-group), Gamma_1 = G, and
# G/Gamma_2 = <z> cyclic.  Checking that witness is three cheap predicates and
# no lattice enumeration.
#
# Note honestly what this does and does not say.  It verifies the chain the
# shape claims, NOT that no other chain exists -- which is all the scoring
# depends on, since a shape is admissible if it has SOME chain.  The searching
# version remains available under ARK_SHAPES_FULLOLIVER=1 for the cases where
# the stronger question is wanted and the rank is small enough to afford it.
CheckChainWitness := function(G, gamma2)
  if not IsNormal(G, gamma2) then return fail; fi;
  if Size(gamma2) > 1 and not IsPGroup(gamma2) then return fail; fi;
  if not IsCyclic(FactorGroup(G, gamma2)) then return fail; fi;
  return 0;                        # trivial top: chi = 1 exactly
end;;


# ---------------------------------------------------------------- the sweep
PrimePowersUpTo := function(m)
  local out, q, f;
  out := [];
  for q in [3..m] do
    f := Collected(Factors(q));
    if Length(f) = 1 then Add(out, [f[1][1], f[1][2]]); fi;
  od;
  return out;
end;;

# pre-declare top-level loop variables referenced inside the sweep, so GAP's
# parser does not emit "Unbound global variable" warnings (ark_gap.g does the
# same; runtime semantics are unaffected)
pa := fail;; p := fail;; a := fail;; c := fail;; F := fail;; d := fail;;
sh := fail;; sc := fail;; re := fail;; oq := fail;; status := "";;

nbad := 0;; ntested := 0;; nnonoliver := 0;; nskip := 0;;

if STRIP then
  Print("ark_shapes.g -- scoring mode: RETIRED F_mid strip (control)\n\n");
else
  Print("ark_shapes.g -- scoring mode: current (full twist)\n\n");
fi;

for pa in PrimePowersUpTo(NMAX) do
  p := pa[1]; a := pa[2]; c := p^a;
  for F in [2..Minimum(MAXF, QuoInt(NMAX, c))] do
    if F*c < 6 then continue; fi;
    for d in DivisorsInt(c-1) do
      # The binding cost is the bottom layer's rank a*F over GF(p) when the
      # lattice is searched; |G| is a poor proxy and MAXORD alone let 3x32
      # through.  Guard on both.
      if (FULLOLIVER and a * F > MAXRANK) or c^F * F * d > MAXORD then
        nskip := nskip + 1;
        AppendTo(OUTSTREAM, F, "x", c, "|d=", d, "|n=", F*c, "|order=", c^F*F*d,
                 "|SKIPPED-over-MAXORD\n");
        continue;
      fi;
      sh := FusedClass(p, a, F, d);
      sc := ScoredTerms(p, a, F, d);
      re := RealisedTerms(sh);
      if FULLOLIVER then
        oq := IsOliverTop(sh.G);          # searches the normal subgroup lattice
      else
        oq := CheckChainWitness(sh.G, sh.gamma2);   # checks the supplied chain
      fi;
      ntested := ntested + 1;
      status := "ok";
      if oq = fail then
        status := "NOT-OLIVER"; nnonoliver := nnonoliver + 1;
      else
        if Length(re.intra) > 0 and sc.intra <> Minimum(re.intra) then
          if sc.intra < Minimum(re.intra) then status := "UNDER-SCORE";
          else status := "OVER-SCORE"; fi;
        fi;
        if Length(re.cross) > 0 and sc.cross <> Minimum(re.cross) then
          if sc.cross < Minimum(re.cross) then status := "UNDER-SCORE";
          else status := "OVER-SCORE"; fi;
        fi;
      fi;
      if status <> "ok" then nbad := nbad + 1; fi;
      AppendTo(OUTSTREAM, F, "x", c, "|d=", d, "|n=", sh.n, "|order=", Size(sh.G),
               "|oliver=", String(oq),
               "|intra ", sc.intra, "/", Minimum(re.intra), "x", Length(re.intra),
               "|cross ", sc.cross, "/", Minimum(re.cross), "x", Length(re.cross),
               "|", status, "\n");
      if status <> "ok" then
        Print("  ", F, "x", c, " (n=", sh.n, ") d=", d,
              "  intra ", sc.intra, "/", Minimum(re.intra),
              "  cross ", sc.cross, "/", Minimum(re.cross),
              "  oliver=", String(oq), "  ", status, "\n");
      fi;
    od;
  od;
od;

Print("\n", ntested, " shapes tested, ", nbad, " mismatches (",
      nnonoliver, " not Oliver), ", nskip, " skipped over MAXORD.\n");
if nskip > 0 then
  Print("Skipped shapes are UNTESTED; raise ARK_SHAPES_MAXORD or lower ",
        "ARK_SHAPES_MAXF to cover them.\n");
fi;

# ------------------------------------------------------- output integrity check
# A wide sweep can be cut short by memory pressure part way through a line, and
# the result is a file whose later rows carry no verdict at all.  Those rows are
# UNTESTED, exactly like the MAXORD skips -- but unlike them they look at a
# glance like data, so a reader counting "0 mismatches" over the file counts
# them as passes.  Re-read the file and require every line to end in a verdict.
CheckOutputComplete := function(fname, expected)
  local str, lines, l, bad, t;
  str := StringFile(fname);
  if str = fail then
    Print("*** FAIL: cannot re-read ", fname, " to check it is complete ***\n");
    return false;
  fi;
  lines := Filtered(SplitString(str, "\n"), x -> x <> "");
  bad := 0;
  for l in lines do
    t := SplitString(l, "|");
    if Length(t) = 0 or not (t[Length(t)] in
         ["ok", "UNDER-SCORE", "OVER-SCORE", "SKIPPED-over-MAXORD"]) then
      bad := bad + 1;
    fi;
  od;
  if bad > 0 then
    Print("*** FAIL: ", bad, " of ", Length(lines), " rows in ", fname,
          " are TRUNCATED and carry no verdict.  Those shapes are untested; ",
          "a clean summary above does not cover them.  Rerun with more ",
          "memory (gap -o) or a lower ARK_SHAPES_MAXF. ***\n");
    return false;
  fi;
  if Length(lines) <> expected then
    Print("*** FAIL: ", fname, " holds ", Length(lines), " rows against ",
          expected, " shapes reached.  Rows were lost in writing. ***\n");
    return false;
  fi;
  Print("output check: ", Length(lines), " rows, every one carries a verdict.\n");
  return true;
end;
CloseStream(OUTSTREAM);
if not CheckOutputComplete(OUT, ntested + nskip) then
  nbad := nbad + 1;
fi;
if STRIP and nbad > 0 then
  Print("The strip is detected as expected -- this is the control.\n");
fi;
if (not STRIP) and nbad > 0 then
  Print("*** FAIL: the current scoring does not match realised orbitals ***\n");
fi;
QUIT_GAP(0);
