# oliver_tom.g -- every conjugacy class of subgroups of S_n from the table of marks, filtered
# to Oliver groups, with each group's strongest condition and its orbitals on pairs.
#
# Output line:  order | transitive | condition | orbitals
#   condition "exact": some p has G/O_p(G) cyclic, so a non-evasive property has chi = 1 exactly;
#   otherwise the list of top primes q (O^q(G/O_p(G)) cyclic for some p): chi = 1 mod each q.
#
# Checked 2026-09: n = 6 gives 56 classes, 50 Oliver; n = 10 gives 1,593 classes, 1,294 Oliver,
# of which 1,111 have at most 12 orbitals -- exactly the count small-degree-computation.md's TOM
# stage emitted at MAXT = 12, from an independently written Oliver predicate.
#
# SETUP (GAP 4.14 built from the core tarball): needs packages gapdoc, primgrp, smallgrp,
# transgrp, tomlib, and tomlib's dependencies atlasrep and utils, all pure GAP code, copied into
# gap-4.14.0/pkg/ from the full distribution.  Run:  gap -q -A oliver_tom.g
# Every conjugacy class of subgroups of S_n (table of marks), filtered to Oliver groups.
# Condition: "exact" if some p has G/O_p(G) cyclic (chi = 1 forced), else the top primes q with
# O^q(G/O_p(G)) cyclic for some p (chi = 1 mod q forced for each).  Orbitals exported for each.
LoadPackage("tomlib");;
OupperQ := function(Q, q)
  local rs, S;
  if Size(Q) = 1 then return Q; fi;
  rs := Filtered(PrimeDivisors(Size(Q)), r -> r <> q);
  S := Subgroup(Q, Concatenation(List(rs, r -> GeneratorsOfGroup(SylowSubgroup(Q, r)))));
  return NormalClosure(Q, S);
end;
OliverData := function(G)
  local ps, exact, qs, p, q, Q;
  ps := Set(Concatenation([2,3,5,7], PrimeDivisors(Maximum(2,Size(G)))));
  exact := false; qs := [];
  for p in ps do
    Q := Image(NaturalHomomorphismByNormalSubgroup(G, PCore(G,p)));
    if IsCyclic(Q) then exact := true; fi;
    for q in ps do if IsCyclic(OupperQ(Q,q)) then AddSet(qs,q); fi; od;
  od;
  if exact then return "exact"; fi;
  if qs = [] then return fail; fi;
  return qs;
end;
Run := function(n, file)
  local t, k, H, d, orbs, out, nol;
  t := TableOfMarks(Concatenation("S", String(n)));
  out := OutputTextFile(file, false); SetPrintFormattingStatus(out, false); nol := 0;
  for k in [1..Length(OrdersTom(t))] do
    H := RepresentativeTom(t, k); d := OliverData(H);
    if d <> fail then
      nol := nol + 1;
      orbs := OrbitsDomain(H, Combinations([1..n],2), OnSets);
      AppendTo(out, String(Size(H)), "|", String(IsTransitive(H,[1..n])), "|",
               ReplacedString(String(d)," ",""), "|", ReplacedString(String(orbs)," ",""), "\n");
    fi;
  od;
  CloseStream(out);
  Print("n=", n, ": ", Length(OrdersTom(t)), " classes, ", nol, " Oliver\n");
end;
Run(6, "tom6.txt");
Run(10, "tom10.txt");
QUIT;
