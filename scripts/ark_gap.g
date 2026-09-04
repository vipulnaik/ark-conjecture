# ark_gap.g -- enumerate permutation groups on [1..N] for the ARK CSP
# (N set below; tested at 10, designed for 12).
#
# Output: one line per group in groups_out_<N><suffix>.txt, where <suffix> is
# "" for the hand-built stages and "_tom" for the exhaustive one, format
#     KEY|DESC|OLIVERQ|ORBMAP
#   KEY     unique checkpoint key (also written to done_keys_<N>.txt)
#   DESC    human-readable description
#   OLIVERQ top prime q of a valid Oliver chain, 0 if top layer can be trivial
#           (chi = 1 exactly), or P<p> for pure p-groups (Smith battery)
#   ORBMAP  45 comma-separated integers: for each pair {i<j} of [1..10] in
#           lexicographic order ((1,2),(1,3),...,(9,10)), the orbital index
#           (1-based) of that pair under the group.
#
# Anytime-stoppable: each completed item appends its KEY to its done_keys file
# and its data line to its groups_out file; on restart, completed KEYs are
# skipped.  All three output filenames carry BOTH the degree and the battery,
# so runs at different N, or the two batteries at one N, cannot overwrite each
# other -- which matters because both batteries are worth keeping (the TOM one
# is exhaustive, the hand-built one has readable keys and cross-checks it).
# Safe to Ctrl-C between items (worst case: one item recomputed).
# Progress is logged to ark_gap_<N>.log with millisecond runtimes.
#
# Stages (edit STAGES below to select; each is independent):
#   "A"    transitive groups of degree 10 (library; 45 groups)      ~minutes
#   "B"    direct products of transitive groups over partitions      ~minutes
#   "B2"   imprimitive wreath products for 10 = 2*5 and 5*2          ~minutes
#   "C"    p-subgroups: all subgroups of Sylow_p(S10), p=2,3,5,7     ~min-hours
#   "TOM"  ALL subgroup classes of S_N from the table of marks       ~50s; off
#          -- exhaustive at N <= 13; closes the subdirect-product hole
#          -- (verification item 5a).  RUN THIS ONE FOR THE CSP.
#   "FULL" ALL subgroup classes of S_N by direct computation         HEAVY; off
#          -- same content as TOM; use only if no table of marks exists
#
# Tunables:
# DEGREE: taken from the ARK_N environment variable, default 10.
# Usage:   ARK_N=12 gap -q -o 4g /path/to/ark_gap.g     (run from the
# per-degree working directory; all output files are written to the CWD).
if IsBound(GAPInfo.SystemEnvironment.ARK_N) then
  N := Int(GAPInfo.SystemEnvironment.ARK_N);;
else
  N := 10;;
fi;;
Print("ark_gap.g running with degree N = ", N, "\n");
# STAGE SELECTION.  Default is the four hand-built stages, NOT "TOM", and that
# is deliberate:
#   * TOM needs a table of marks for this degree.  TomLib has S_N for N <= 13;
#     past that the stage prints a message and emits nothing, so a TOM default
#     would silently write an empty file at N = 14 rather than fail.
#   * The two batteries agreeing is the only independent check IsOliverTop has.
#     At N = 10 they agree on all 131 orbital partitions the hand-built stages
#     produce, by two unrelated generation paths.  If TOM became the default
#     that comparison stops being made.
#   * A/B/B2/C emit MEANINGFUL KEYS -- "B2:5x2:3.1" is T(5,3) wr T(2,1), the
#     wreath product attaining mu(10) = 20 -- where TOM emits "T:1468", an index
#     into a table.  The attainer discussions in small-degree-computation.md are
#     written against those names.
#
# BUT RUN TOM FOR THE CSP.  At N <= 13 it is exhaustive over conjugacy classes
# of subgroups of S_N and strictly contains the hand-built stages (at N = 10:
# 186 orbital partitions to 131, 55 new, 0 lost; 242 conditions to 167), so it
# is the battery that makes an UNSAT verdict a theorem rather than a statement
# about which groups someone thought to enumerate.  ~50 s at N = 10.
#
# Override without editing:  ARK_STAGES=TOM ark_gap.g
#                            ARK_STAGES=A,B,B2,C  (the default)
if IsBound(GAPInfo.SystemEnvironment.ARK_STAGES) then
  STAGES := SplitString(GAPInfo.SystemEnvironment.ARK_STAGES, ",");;
else
  STAGES := [ "A", "B", "B2", "C" ];;
fi;;
MAXT    := 12;;   # skip groups with more than MAXT u-orbitals (CSP cost 2^t)
MAXPARTS:= 4;;    # stage B: max number of parts in the partition
# Output filenames are SUFFIXED BY DEGREE.  Both degrees previously wrote
# "groups_out.txt", so an upload of one overwrote the other and a census was
# silently swapped rather than a run failing -- it cost two rounds of the
# verification note before anyone noticed.  A consumer given the wrong file
# sees a well-formed file whose orbital maps have the wrong length (45 at
# N = 10, 66 at N = 12), which is the only cheap check available downstream.
# ...AND BY BATTERY, because the batteries are different objects and both are
# worth keeping: TOM is the exhaustive one, A/B/B2/C is the readable one and the
# cross-check.  Writing both to one name would make the second run silently
# replace the first, which is the same failure the degree suffix fixes.
#   A/B/B2/C -> groups_out_10.txt        TOM -> groups_out_10_tom.txt
# ARK_SUFFIX overrides, e.g. for a partial or experimental battery.
if IsBound(GAPInfo.SystemEnvironment.ARK_SUFFIX) then
  SUFFIX := Concatenation("_", GAPInfo.SystemEnvironment.ARK_SUFFIX);;
elif "TOM" in STAGES then
  SUFFIX := "_tom";;
elif "FULL" in STAGES then
  SUFFIX := "_full";;
else
  SUFFIX := "";;
fi;;
# Mixing an exhaustive stage with the hand-built ones gives a file that is
# neither battery cleanly: the exhaustive stage already contains the others, so
# the extra lines are duplicates that stage 1 of consume_gap.py will dedup away
# anyway.  Harmless, but say so rather than let it look intentional.
if ("TOM" in STAGES or "FULL" in STAGES) and
   ForAny(["A","B","B2","C"], s -> s in STAGES) then
  Print("### NOTE: exhaustive stage combined with hand-built stages; the ",
        "hand-built\n###       lines are redundant (consume_gap.py stage 1 ",
        "will dedup them).\n");
fi;;
Print("stages ", STAGES, " -> writing groups_out_", N, SUFFIX, ".txt\n");
OUTFILE := Concatenation("groups_out_", String(N), SUFFIX, ".txt");;
DONEFILE:= Concatenation("done_keys_", String(N), SUFFIX, ".txt");;
LOGFILE := Concatenation("ark_gap_", String(N), SUFFIX, ".log");;

# ---------------------------------------------------------------- utilities
LoadPackage("transgrp");   # transitive groups library; usually bundled

PAIRS := Combinations([1..N], 2);;

# pre-declare top-level loop variables that are referenced inside lambdas,
# so GAP's parser does not emit "Unbound global variable" warnings (the
# runtime semantics were already correct; this is warning hygiene only)
g := fail;;   # lexicographic, length C(N,2)
tom := fail;;  nsub := 0;;  H := fail;;  i := 0;;   # stage TOM / FULL
SUFFIX := "";;

CustomLog := function(msg)
  AppendTo(LOGFILE, String(Runtime()), "ms  ", msg, "\n");
  Print(msg, "\n");
end;;

ReadDone := function()
  local s, done, line;
  done := rec();
  if IsExistingFile(DONEFILE) then
    s := StringFile(DONEFILE);           # StringFile is from GAPDoc (standard)
    for line in SplitString(s, "\n") do
      if Length(line) > 0 then done.(line) := true; fi;
    od;
  fi;
  return done;
end;;

DONE := ReadDone();;
CustomLog(Concatenation("resuming with ", String(Length(RecNames(DONE))), " done keys"));

OrbMap := function(G)
  local orbs, map, i, o, p;
  orbs := Orbits(G, PAIRS, OnSets);
  map := [];
  for i in [1..Length(orbs)] do
    for p in orbs[i] do
      map[PositionSorted(PAIRS, p)] := i;
    od;
  od;
  return rec(map := map, t := Length(orbs));
end;;

# Oliver's condition: exists N normal in G with G/N a q-group (or trivial),
# and N/O_p(N) cyclic for some prime p (or N trivial).  Returns:
#   fail  if not Oliver
#   0     if achievable with trivial top layer (chi = 1 exactly)
#   otherwise the SORTED SET of usable top primes.
#
# Two notes on why this is correct and why it now returns a set.
#
# Taking Gamma_2 = PCore(N, p) is without loss of generality: any normal
# p-subgroup of N with cyclic quotient lies inside O_p(N), and N/O_p(N) is then a
# quotient of a cyclic group, hence cyclic.  Normality in G is automatic rather
# than assumed, since O_p(N) is characteristic in N and N is normal in G.
#
# This previously returned only the SMALLEST usable q, which is the WEAKEST
# condition: chi = 1 mod 5 is strictly stronger than chi = 1 mod 2.  A group
# admitting chains with top primes q1 and q2 forces the congruence modulo both,
# hence modulo Lcm(q1, q2).  Returning the full set lets the consumer enforce the
# lcm -- the gain that Appendix B / Part G.0 of the proof document identifies as
# available and unused.  Trivial top is still preferred and short-circuits, since
# chi = 1 exactly implies chi = 1 mod q for every q.
IsOliverTop := function(G)
  local best, N, Q, q, p, ok;
  if Size(G) = 1 then return 0; fi;
  best := [];
  for N in NormalSubgroups(G) do
    # bottom+middle check on N
    ok := Size(N) = 1;
    if not ok then
      for p in PrimeDivisors(Size(N)) do
        if IsCyclic(FactorGroup(N, PCore(N, p))) then ok := true; break; fi;
      od;
    fi;
    if not ok then continue; fi;
    if Size(N) = Size(G) then
      return 0;                              # trivial top: strongest
    fi;
    Q := FactorGroup(G, N);
    if IsPGroup(Q) then
      q := PrimePGroup(Q);
      AddSet(best, q);
    fi;
  od;
  if Length(best) = 0 then return fail; fi;
  return best;
end;;

EmitGroup := function(key, desc, G)
  local om, tag, oq;
  if IsBound(DONE.(key)) then return; fi;
  om := OrbMap(G);
  if om.t > MAXT then
    AppendTo(DONEFILE, key, "\n"); DONE.(key) := true;
    return;                                  # skipped (too many orbitals)
  fi;
  if IsPGroup(G) and Size(G) > 1 then
    tag := Concatenation("P", String(PrimePGroup(G)));   # Smith battery entry
  else
    oq := IsOliverTop(G);
    if oq = fail then
      AppendTo(DONEFILE, key, "\n"); DONE.(key) := true;
      return;                                # not Oliver: skip
    fi;
    if oq = 0 then
      tag := "0";                            # trivial top: chi = 1 exactly
    else
      # ALL usable top primes, "+"-separated (e.g. "2+3").  A consumer that only
      # understands a single prime should read the FIRST field and is then exactly
      # as strong as the old output; one that understands the list should enforce
      # chi = 1 mod Lcm(oq).
      tag := JoinStringsWithSeparator(List(oq, String), "+");
    fi;
  fi;
  AppendTo(OUTFILE, key, "|", desc, "|", tag, "|",
           JoinStringsWithSeparator(List(om.map, String), ","), "\n");
  AppendTo(DONEFILE, key, "\n");
  DONE.(key) := true;
  CustomLog(Concatenation("emitted ", key, "  t=", String(om.t), "  tag=", tag));
end;;

# ---------------------------------------------------------------- stage A
if "A" in STAGES then
  CustomLog("=== stage A: transitive groups of degree 10 ===");
  for k in [1..NrTransitiveGroups(N)] do
    EmitGroup(Concatenation("A:", String(k)),
              Concatenation("T(", String(N), ",", String(k), ") order ",
                            String(Size(TransitiveGroup(N,k)))),
              TransitiveGroup(N, k));
  od;
  CustomLog("stage A complete");
fi;

# ---------------------------------------------------------------- stage B
# direct products of transitive groups over partitions of 10 (parts >= 1);
# part of size 1 contributes the trivial group.
if "B" in STAGES then
  CustomLog("=== stage B: direct products over partitions ===");
  for part in Partitions(N) do
    if Length(part) < 2 or Length(part) > MAXPARTS then continue; fi;
    # index ranges per part (size-1 parts: single trivial choice)
    ranges := List(part, d -> Maximum(1, NrTransitiveGroups(Maximum(d,2))));
    ranges := List([1..Length(part)],
                   i -> Filtered([1..ranges[i]],
                        k -> part[i] > 1 or k = 1));
    for combo in Cartesian(ranges) do
      key := Concatenation("B:", JoinStringsWithSeparator(List(part,String),"+"),
                           ":", JoinStringsWithSeparator(List(combo,String),"."));
      if IsBound(DONE.(key)) then continue; fi;
      gens := []; off := 0;
      for i in [1..Length(part)] do
        d := part[i];
        if d > 1 then
          T := TransitiveGroup(d, combo[i]);
          for g in GeneratorsOfGroup(T) do
            Add(gens, PermList(Concatenation([1..off],
                    List([1..d], x -> off + x^g),
                    [off+d+1..N])));
          od;
        fi;
        off := off + d;
      od;
      if Length(gens) = 0 then continue; fi;
      EmitGroup(key,
        Concatenation("prod ", JoinStringsWithSeparator(List(part,String),"+")),
        Group(gens));
    od;
    CustomLog(Concatenation("stage B partition ",
        JoinStringsWithSeparator(List(part,String),"+"), " done"));
  od;
  CustomLog("stage B complete");
fi;

# ---------------------------------------------------------------- stage B2
# imprimitive wreath products G wr H on 10 = d*r points
if "B2" in STAGES then
  CustomLog("=== stage B2: imprimitive wreath products ===");
  wr_pairs := [];;
  for d in [2..N-1] do
    if N mod d = 0 and N/d >= 2 then Add(wr_pairs, [d, N/d]); fi;
  od;
  for dr in wr_pairs do
    d := dr[1]; r := dr[2];
    for k in [1..NrTransitiveGroups(Maximum(d,2))] do
      for j in [1..NrTransitiveGroups(Maximum(r,2))] do
        key := Concatenation("B2:", String(d), "x", String(r), ":",
                             String(k), ".", String(j));
        if IsBound(DONE.(key)) then continue; fi;
        W := WreathProduct(TransitiveGroup(d,k), TransitiveGroup(r,j));
        EmitGroup(key,
          Concatenation("T(",String(d),",",String(k),") wr T(",
                        String(r),",",String(j),")"), W);
      od;
    od;
  od;
  CustomLog("stage B2 complete");
fi;

# ---------------------------------------------------------------- stage C
# all subgroups (up to Sylow-conjugacy) of each Sylow_p(S10): Smith battery
if "C" in STAGES then
  CustomLog("=== stage C: p-subgroups of Sylow subgroups ===");
  SN := SymmetricGroup(N);
  for p in Filtered(Primes, q -> q <= N) do
    key0 := Concatenation("C:", String(p), ":ALLDONE");
    if IsBound(DONE.(key0)) then
      CustomLog(Concatenation("stage C p=", String(p), " already done"));
      continue;
    fi;
    P := SylowSubgroup(SN, p);
    CustomLog(Concatenation("Sylow_", String(p), " order ", String(Size(P)),
                      "; computing subgroup classes (may take a while for p=2)"));
    ccs := ConjugacyClassesSubgroups(P);
    CustomLog(Concatenation("  ", String(Length(ccs)), " classes"));
    for i in [1..Length(ccs)] do
      H := Representative(ccs[i]);
      if Size(H) > 1 then
        EmitGroup(Concatenation("C:", String(p), ":", String(i)),
                  Concatenation("p", String(p), "-subgroup #", String(i),
                                " order ", String(Size(H))), H);
      fi;
    od;
    AppendTo(DONEFILE, key0, "\n"); DONE.(key0) := true;
    CustomLog(Concatenation("stage C p=", String(p), " complete"));
  od;
fi;

# ---------------------------------------------------------------- stage FULL
# every subgroup class of S10, filtered to Oliver.  VERY heavy (hours, GB of
# RAM).  Run only on a machine you can leave alone; the single call
# ConjugacyClassesSubgroups(S10) is not checkpointable -- if it completes,
# per-group emission below is checkpointed as usual.
# ---------------------------------------------------------------- stage TOM
# ALL subgroup classes of S_N, taken from the TABLE OF MARKS rather than
# computed.  This is the cheap route to closing the subdirect-product hole
# (`small-degree-verification.md` item 5a): stages A/B/B2 build transitive
# groups, blockwise direct products and wreath products, so an intransitive
# group that is a PROPER SUBDIRECT product -- a fibre product of transitive
# constituents over a common quotient -- is generated by none of them, and
# stage C reaches it only if it happens to be a p-group.  Enumerating every
# conjugacy class of subgroups closes that by construction.
#
# TomLib ships precomputed tables of marks for the symmetric groups in this
# range, so RepresentativeTom hands back a representative of each class with no
# subgroup computation -- which is why this is worth trying before the FULL
# stage below, whose ConjugacyClassesSubgroups call is the expensive step that
# was never confirmed to finish at N = 10 (item 5b).
#
# If the table is unavailable for this N, the stage says so and does nothing;
# fall back to FULL.  Nothing here is assumed about the table's size: the count
# is logged rather than predicted.
if "TOM" in STAGES then
  CustomLog(Concatenation("=== stage TOM: all subgroup classes of S",
                          String(N), " from the table of marks ==="));
  tom := fail;
  LoadPackage("tomlib");
  tom := TableOfMarks(Concatenation("S", String(N)));
  if tom = fail then
    CustomLog("stage TOM: no table of marks for this degree; use FULL instead");
  else
    nsub := Length(OrdersTom(tom));
    CustomLog(Concatenation("stage TOM: ", String(nsub), " subgroup classes"));
    for i in [1..nsub] do
      H := RepresentativeTom(tom, i);
      # The table's group need not be S_N on [1..N] with our point labelling;
      # what EmitGroup needs is a permutation group of degree N, and the orbital
      # map is computed from the action, so any faithful degree-N representative
      # gives the same partition up to relabelling -- which is exactly what the
      # downstream dedup canonicalises over.
      if H <> fail and Size(H) > 1 and LargestMovedPoint(H) <= N then
        EmitGroup(Concatenation("T:", String(i)),
                  Concatenation("TOM subgroup #", String(i),
                                " order ", String(Size(H))), H);
      fi;
      if i mod 200 = 0 then
        CustomLog(Concatenation("TOM progress ", String(i), "/", String(nsub)));
      fi;
    od;
    CustomLog("stage TOM complete");
  fi;
fi;

# ---------------------------------------------------------------- stage FULL
if "FULL" in STAGES then
  CustomLog(Concatenation("=== stage FULL: all subgroup classes of S",
                          String(N), " by direct computation (heavy) ==="));
  SN := SymmetricGroup(N);
  ccs := ConjugacyClassesSubgroups(SN);
  CustomLog(Concatenation(String(Length(ccs)), " subgroup classes"));
  for i in [1..Length(ccs)] do
    H := Representative(ccs[i]);
    if Size(H) > 1 then
      EmitGroup(Concatenation("F:", String(i)),
                Concatenation("SN subgroup #", String(i),
                              " order ", String(Size(H))), H);
    fi;
    if i mod 200 = 0 then CustomLog(Concatenation("FULL progress ", String(i))); fi;
  od;
  CustomLog("stage FULL complete");
fi;

CustomLog("ALL SELECTED STAGES COMPLETE");
QUIT;
