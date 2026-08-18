# oliver_negative.g -- give the Oliver test something it can fail.
#
# THE PROBLEM THIS SOLVES.  In ark_shapes.g every row returns oliver=0.  That is
# correct -- a single fused class always has the chain (translations, cyclic
# quotient, trivial top) -- but it means the column is not evidence: a predicate
# that returned 0 unconditionally would produce identical output.  R6 item 1 of
# pending-checks.md asks for shapes the test CAN fail, so that seeing it pass is
# informative.
#
# WHAT THIS SCRIPT DOES, in four parts of increasing strength:
#
#   A  ASSERTED NEGATIVES.  Groups that MUST return fail, for a reason that is a
#      theorem rather than a computation: a simple nonabelian G has only N = 1
#      and N = G available, and N = 1 leaves G/N = G which is not a p-group,
#      while N = G needs G/O_p(G) = G cyclic, which is false.  So every simple
#      nonabelian group is non-Oliver.  If any of these returns anything but
#      fail, IsOliverTop is broken and nothing else here matters.
#
#   B  A POPULATION WHERE THE ANSWER VARIES.  Sweep the transitive groups of
#      degrees 6..DEGMAX and report the distribution of verdicts.  This is the
#      part that makes the column evidence: the predicate is shown to separate a
#      real population rather than to say 0 always.  It also produces the
#      SOLVABLE non-Oliver groups, which are the interesting negatives -- the
#      insoluble ones in part A fail for a reason so cheap it tests little.
#
#   C  THE TWO PREDICATES AGAINST EACH OTHER.  ark_shapes.g checks a supplied
#      chain (CheckChainWitness); under ARK_SHAPES_FULLOLIVER it searches the
#      lattice (IsOliverTop).  These answer different questions -- "is THIS
#      chain good" versus "is there ANY chain" -- so witness = 0 must imply
#      search <> fail, and a disagreement in that direction is a bug in one of
#      them.  Checked on the fused-class shapes small enough to afford.
#
#   D  BROKEN CHAINS THAT MUST BE REJECTED.  Two-class configurations built to
#      violate one chain condition each, with the other conditions intact:
#        D1  Gamma_2 not a p-group   -- blocks of size 4 and 9 both downstairs,
#                                       so Gamma_2 = C_2^2 x C_3^2
#        D2  G/Gamma_2 not cyclic    -- two independent twists of equal order,
#                                       giving quotient C_d x C_d
#        D3  Gamma_2 not normal      -- a subgroup that is not the full kernel
#      Each MUST return fail from CheckChainWitness.  D1 and D2 are the two
#      failures a mis-built two-class configuration would actually produce, so
#      these are the controls for the item-4 work as well.
#
# Note what D does NOT claim.  CheckChainWitness rejecting a chain does not mean
# the GROUP is non-Oliver -- another chain may exist, and for D2 one does.  The
# distinction is the whole point of the witness-versus-search split, and part D
# reports both so the difference is visible rather than assumed.
#
# Usage:
#   gap -q -o 8g oliver_negative.g
#   OLIVER_NEG_DEGMAX=12 gap -q -o 8g oliver_negative.g     # default 11
#
# Output: oliver_negative_out.txt, plus a summary.  The last line is PASS or
# FAIL; every individual expectation is asserted, so the summary is the result.

DEGMAX := 11;;
if IsBound(GAPInfo.SystemEnvironment.OLIVER_NEG_DEGMAX) then
  DEGMAX := Int(GAPInfo.SystemEnvironment.OLIVER_NEG_DEGMAX);
fi;
# Part C's cost is NormalSubgroups on the fused-class groups, which blows up in
# the RANK of the bottom layer (a*F over GF(p)), not in |G| -- the lesson from
# ark_shapes.g's 3x32 case.  Guard on rank.
CRANK := 8;;
if IsBound(GAPInfo.SystemEnvironment.OLIVER_NEG_CRANK) then
  CRANK := Int(GAPInfo.SystemEnvironment.OLIVER_NEG_CRANK);
fi;

OUT := "oliver_negative_out.txt";;
OUTSTREAM := OutputTextFile(OUT, false);;
SetPrintFormattingStatus(OUTSTREAM, false);;

nfail := 0;;
Expect := function(name, got, want)
  local ok, tag, tag2;
  ok := (got = want);
  if ok then tag := "ok"; tag2 := "ok";
        else tag := "*** FAIL ***"; tag2 := "FAIL"; nfail := nfail + 1; fi;
  Print("  ", name, ": got ", String(got), ", expected ", String(want),
        "  ", tag, "\n");
  AppendTo(OUTSTREAM, name, "|got=", String(got), "|want=", String(want),
           "|", tag2, "\n");
  return ok;
end;;

# ---------------------------------------------------------------- predicates
# Verbatim from ark_shapes.g / ark_gap.g so the three files agree by
# construction.  If this copy is edited, edit those too.
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

CheckChainWitness := function(G, gamma2)
  if not IsNormal(G, gamma2) then return fail; fi;
  if Size(gamma2) > 1 and not IsPGroup(gamma2) then return fail; fi;
  if not IsCyclic(FactorGroup(G, gamma2)) then return fail; fi;
  return 0;
end;;

# --------------------------------------------------------------------- part A
Print("\n=== A. asserted negatives: simple nonabelian groups must be non-Oliver ===\n");
AppendTo(OUTSTREAM, "# part A: asserted negatives\n");

Expect("A5 on 5 points",        IsOliverTop(AlternatingGroup(5)), fail);
Expect("A6 on 6 points",        IsOliverTop(AlternatingGroup(6)), fail);
Expect("A7 on 7 points",        IsOliverTop(AlternatingGroup(7)), fail);
Expect("PSL(2,7) on 7 points",  IsOliverTop(PSL(2,7)), fail);
Expect("PSL(2,11)",             IsOliverTop(PSL(2,11)), fail);
Expect("S5 on 5 points",        IsOliverTop(SymmetricGroup(5)), fail);
Expect("S6 on 6 points",        IsOliverTop(SymmetricGroup(6)), fail);

# and the matching positives, so the predicate is not merely always-fail
Print("\n  positives (same predicate, must NOT be fail):\n");
Expect("C6 cyclic",             IsOliverTop(CyclicGroup(IsPermGroup, 6)), 0);
Expect("elementary abelian 8",  IsOliverTop(ElementaryAbelianGroup(IsPermGroup, 8)), 0);
Expect("S4 (solvable, Oliver via A4)",
       IsOliverTop(SymmetricGroup(4)) <> fail, true);
Expect("AGL(1,5) = F20",
       IsOliverTop(Group((1,2,3,4,5),(2,3,5,4))) <> fail, true);

# --------------------------------------------------------------------- part B
Print("\n=== B. the transitive groups of degrees 6..", DEGMAX,
      ": does the verdict vary? ===\n");
AppendTo(OUTSTREAM, "# part B: transitive-group population\n");

if LoadPackage("transgrp") <> true then
  Print("  *** the transgrp package is not available; part B skipped.\n");
  Print("  *** Part B is the part that makes the column evidence -- rerun\n");
  Print("  *** with transgrp loaded if at all possible.\n");
  AppendTo(OUTSTREAM, "partB|SKIPPED-no-transgrp\n");
  nfail := nfail + 1;
else
  deg := fail;; i := fail;; G := fail;; v := fail;;
  nf := 0;; nk := 0;;
  totfail := 0;; totok := 0;; solvfail := [];;
  for deg in [6..DEGMAX] do
    nf := 0; nk := 0;
    for i in [1..NrTransitiveGroups(deg)] do
      G := TransitiveGroup(deg, i);
      v := IsOliverTop(G);
      if v = fail then
        nf := nf + 1;
        if IsSolvable(G) then Add(solvfail, [deg, i, Size(G)]); fi;
      else
        nk := nk + 1;
      fi;
      AppendTo(OUTSTREAM, "T(", deg, ",", i, ")|order=", Size(G),
               "|solvable=", String(IsSolvable(G)),
               "|oliver=", String(v), "\n");
    od;
    totfail := totfail + nf; totok := totok + nk;
    Print("  degree ", deg, ": ", nk, " Oliver, ", nf, " NOT Oliver, of ",
          nk + nf, "\n");
  od;
  Print("\n  totals: ", totok, " Oliver, ", totfail, " not.\n");
  Expect("the predicate separates the population (some fail)", totfail > 0, true);
  Expect("and does not reject everything (some pass)", totok > 0, true);
  Print("\n  SOLVABLE non-Oliver groups -- the informative negatives:\n");
  if Length(solvfail) = 0 then
    Print("    none in this range.  Every non-Oliver transitive group here is\n");
    Print("    insoluble, so part A's reason covers all of them and the\n");
    Print("    population adds breadth but not a new failure mode.\n");
  else
    for i in solvfail do
      Print("    T(", i[1], ",", i[2], ") of order ", i[3], "\n");
    od;
  fi;
  AppendTo(OUTSTREAM, "partB|oliver=", totok, "|notoliver=", totfail,
           "|solvable_notoliver=", Length(solvfail), "\n");
fi;

# --------------------------------------------------------------------- part C
Print("\n=== C. witness vs search on the fused-class shapes ===\n");
Print("  (witness = 0 must imply search <> fail; the converse need not hold)\n");
AppendTo(OUTSTREAM, "# part C: witness vs search\n");

FusedClass := function(p, a, F, d)
  local c, fld, els, A, gens, i, b, e, bas, perm, x;
  c := p^a;
  fld := GF(c);
  els := AsSSortedList(fld);
  A := Z(c)^((c-1)/d);
  gens := [];
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
  return rec(G := Group(gens), gamma2 := Group(gens{[1..Length(gens)-1]}));
end;;

pa := fail;; F := fail;; d := fail;; sh := fail;; w := fail;; sr := fail;;
ncmp := 0;; ndisagree := 0;;
for pa in [[3,1],[5,1],[7,1],[11,1],[13,1],[2,2],[2,3],[3,2],[5,2],[2,4]] do
  for F in [2,3,4] do
    if pa[2] * F > CRANK then continue; fi;
    if pa[1]^pa[2] * F > 40 then continue; fi;
    for d in DivisorsInt(pa[1]^pa[2] - 1) do
      sh := FusedClass(pa[1], pa[2], F, d);
      w := CheckChainWitness(sh.G, sh.gamma2);
      sr := IsOliverTop(sh.G);
      ncmp := ncmp + 1;
      if w = 0 and sr = fail then
        ndisagree := ndisagree + 1;
        Print("  *** DISAGREE: ", F, "x", pa[1]^pa[2], " d=", d,
              " witness says Oliver, search says not ***\n");
      fi;
      AppendTo(OUTSTREAM, F, "x", pa[1]^pa[2], "|d=", d, "|witness=",
               String(w), "|search=", String(sr), "\n");
    od;
  od;
od;
Print("  ", ncmp, " shapes compared under both predicates.\n");
Expect("no shape where the witness passes and the search fails", ndisagree, 0);
Expect("the comparison actually ran on a nonempty set", ncmp > 0, true);

# --------------------------------------------------------------------- part D
Print("\n=== D. deliberately broken chains: the witness must reject each ===\n");
AppendTo(OUTSTREAM, "# part D: broken chains\n");

# D1: Gamma_2 not a p-group.  A 4-block (points 1..4, translations of GF(4))
# and a 3-block (points 5..7, translations of GF(3)), BOTH placed downstairs,
# so Gamma_2 = C_2^2 x C_3 of order 12.  Upstairs is the order-3 twist of the
# 4-block, which normalises the translations, so the quotient is C_3 -- cyclic.
# Only the p-group clause is violated, which is what makes this a clean control.
# (Orders verified independently: |Gamma_2| = 12, |G| = 36, quotient 3, normal.)
d1g2 := Group( (1,2)(3,4), (1,3)(2,4), (5,6,7) );;
d1G  := Group( (1,2)(3,4), (1,3)(2,4), (5,6,7), (2,3,4) );;
Expect("D1 |Gamma_2| = 12 = C_2^2 x C_3, as constructed", Size(d1g2), 12);
Expect("D1 |G| = 36 and the quotient has order 3", Size(d1G), 36);
Expect("D1 Gamma_2 normal and quotient cyclic, so ONLY the p-group clause fires",
       IsNormal(d1G, d1g2) and IsCyclic(FactorGroup(d1G, d1g2)),
       true);
Expect("D1 Gamma_2 is not a p-group -> witness rejects",
       CheckChainWitness(d1G, d1g2), fail);
# As with D2, the group may still be Oliver by a different chain.  Report it.
Print("  D1 search verdict (a different chain may exist): ",
      String(IsOliverTop(d1G)), "\n");
AppendTo(OUTSTREAM, "D1|search=", String(IsOliverTop(d1G)), "\n");

# D2: G/Gamma_2 not cyclic.  Two blocks of size 5, each with its own INDEPENDENT
# twist of order 4, so the quotient is C_4 x C_4 -- abelian, not cyclic.  This is
# exactly the shape a two-class configuration degenerates to when the twists are
# not carried diagonally on one generator.
d2g2 := Group( (1,2,3,4,5), (6,7,8,9,10) );;
d2G  := Group( (1,2,3,4,5), (6,7,8,9,10), (2,3,5,4), (7,8,10,9) );;
Expect("D2 G/Gamma_2 = C_4 x C_4 is not cyclic -> witness rejects",
       CheckChainWitness(d2G, d2g2), fail);
Expect("D2 Gamma_2 is a normal 5-group, so only the cyclic clause fires",
       IsNormal(d2G, d2g2) and IsPGroup(d2g2), true);
# ...but the GROUP may still be Oliver by another chain.  Report, do not assert:
Print("  D2 search verdict (may differ from the witness, and that is the point): ",
      String(IsOliverTop(d2G)), "\n");
AppendTo(OUTSTREAM, "D2|search=", String(IsOliverTop(d2G)), "\n");

# D2': the SAME two blocks with the twists carried diagonally on ONE generator.
# Quotient is C_4, cyclic, so this one must PASS -- the minimal pair showing the
# witness is responding to the chain and not to the point set.
d2pG := Group( (1,2,3,4,5), (6,7,8,9,10), (2,3,5,4)(7,8,10,9) );;
Expect("D2' the same blocks, twists diagonal on one generator -> witness accepts",
       CheckChainWitness(d2pG, d2g2), 0);

# D3: Gamma_2 not normal.  A point stabiliser inside AGL(1,5).
d3G  := Group( (1,2,3,4,5), (2,3,5,4) );;
d3g2 := Group( (2,3,5,4) );;
Expect("D3 Gamma_2 not normal -> witness rejects",
       CheckChainWitness(d3G, d3g2), fail);
Expect("D3 but the group itself IS Oliver, so this is the witness clause only",
       IsOliverTop(d3G) <> fail, true);

# --------------------------------------------------------------------- summary
Print("\n================================================================\n");
if nfail = 0 then
  Print("PASS -- every expectation met.  The Oliver test is now known to be\n");
  Print("able to fail, on both asserted and searched negatives, and the two\n");
  Print("predicates agree where they must.\n");
  AppendTo(OUTSTREAM, "SUMMARY|PASS\n");
else
  Print("FAIL -- ", nfail, " expectation(s) not met.  See the *** lines above.\n");
  AppendTo(OUTSTREAM, "SUMMARY|FAIL|", nfail, "\n");
fi;
CloseStream(OUTSTREAM);
QUIT_GAP(0);
