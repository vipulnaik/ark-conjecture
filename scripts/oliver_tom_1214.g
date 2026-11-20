# oliver_tom_1214.g -- (functions copied from oliver_tom.g) Oliver groups with their conditions and orbitals on pairs.
#   RunTom(n, file):   every conjugacy class of subgroups of S_n (table of marks), filtered to Oliver groups.
#   RunTrans(n, file): every transitive group of degree n (transitive-groups library), filtered likewise.
# Output line:  order | transitive | exact | top primes | nontrivial-top primes | orbitals
#   exact:  some p has G/O_p(G) cyclic -- a trivial-top reading, so chi = 1 is forced exactly;
#   top primes: q with O^q(G/O_p(G)) cyclic for some p (the Oliver congruences mod q);
#   nontrivial-top primes: those q for which that reading has a NONTRIVIAL q-top (O^q proper).
# Checked: S4 11, S5 17, S6 50, S10 1,294 Oliver classes (of 11, 19, 56, 1,593); of the S10 ones, 1,111 have
# at most 12 orbitals, exactly small-degree-computation.md's TOM emission.  Transitive: degree 14, 29 of 63;
# degree 18, 391 of 983; degree 22, 25 of 59.  Every group but the trivial one has a nontrivial-top prime.
# SETUP (GAP 4.14 built from the core tarball): packages gapdoc, primgrp, smallgrp, transgrp, tomlib, atlasrep,
# utils -- all pure GAP code -- copied into gap-4.14.0/pkg/ from the full distribution.  Run: gap -q -A oliver_tom.g
LoadPackage("tomlib");; LoadPackage("transgrp");;
OupperQ := function(Q, q)
  local rs, S;
  if Size(Q) = 1 then return Q; fi;
  rs := Filtered(PrimeDivisors(Size(Q)), r -> r <> q);
  S := Subgroup(Q, Concatenation(List(rs, r -> GeneratorsOfGroup(SylowSubgroup(Q, r)))));
  return NormalClosure(Q, S);
end;
# exact: some p with G/O_p(G) cyclic.  qs: top primes of Oliver readings (O^q(G/O_p) cyclic).
# ntq: primes q for which some reading has a NONTRIVIAL q-top (O^q(G/O_p) cyclic and proper).
OliverData := function(G)
  local ps, exact, qs, ntq, p, q, Q, O;
  ps := Set(Concatenation([2,3,5,7,11,13], PrimeDivisors(Maximum(2,Size(G)))));
  exact := false; qs := []; ntq := [];
  for p in ps do
    Q := Image(NaturalHomomorphismByNormalSubgroup(G, PCore(G,p)));
    if IsCyclic(Q) then exact := true; fi;
    for q in ps do
      O := OupperQ(Q,q);
      if IsCyclic(O) then AddSet(qs,q); if Size(O) < Size(Q) then AddSet(ntq,q); fi; fi;
    od;
  od;
  if not exact and qs = [] then return fail; fi;
  return [exact, qs, ntq];
end;
Emit := function(out, n, H, d)
  AppendTo(out, String(Size(H)), "|", String(IsTransitive(H,[1..n])), "|",
    ReplacedString(String(d[1])," ",""), "|", ReplacedString(String(d[2])," ",""), "|",
    ReplacedString(String(d[3])," ",""), "|",
    ReplacedString(String(OrbitsDomain(H, Combinations([1..n],2), OnSets))," ",""), "\n");
end;
RunTom := function(n, file)
  local t, k, H, d, out, c;
  t := TableOfMarks(Concatenation("S", String(n)));
  out := OutputTextFile(file, false); SetPrintFormattingStatus(out, false); c := 0;
  for k in [1..Length(OrdersTom(t))] do
    H := RepresentativeTom(t, k); d := OliverData(H);
    if d <> fail then Emit(out, n, H, d); c := c + 1; fi;
  od;
  CloseStream(out); Print("S", n, ": ", c, " Oliver classes\n");
end;
RunTrans := function(n, file)
  local k, H, d, out, c;
  out := OutputTextFile(file, false); SetPrintFormattingStatus(out, false); c := 0;
  for k in [1..NrTransitiveGroups(n)] do
    H := TransitiveGroup(n, k);
    if IsSolvableGroup(H) then d := OliverData(H);
      if d <> fail then Emit(out, n, H, d); c := c + 1; fi; fi;
  od;
  CloseStream(out); Print("transitive degree ", n, ": ", NrTransitiveGroups(n), " groups, ", c, " Oliver\n");
end;
# RunPairs(n, file): direct products H1 x H2 of soluble transitive groups on disjoint supports {1..a}, {a+1..a+b},
# a + b <= n, a >= b >= 1, the remaining n - a - b points fixed; filtered to Oliver.  Together with RunTrans this is a
# SAMPLE of the Oliver subgroups of S_n (it misses subdirect products and three-part products), which is enough for
# lower bounds by forcing: dropping groups only drops conditions.
RunPairs := function(n, file)
  local a, b, i, j, H1, H2, H, d, out, c, seen, key;
  out := OutputTextFile(file, false); SetPrintFormattingStatus(out, false); c := 0;
  for a in [1..n] do for b in [1..Minimum(a, n - a)] do
    for i in [1..NrTransitiveGroups(a)] do
      H1 := TransitiveGroup(a, i); if not IsSolvableGroup(H1) then continue; fi;
      for j in [1..NrTransitiveGroups(b)] do
        if a = b and j < i then continue; fi;
        H2 := TransitiveGroup(b, j); if not IsSolvableGroup(H2) then continue; fi;
        H := Group(Concatenation([()], GeneratorsOfGroup(H1),
               List(GeneratorsOfGroup(H2), g -> PermList(Concatenation([1..a], List([1..b], x -> x^g + a))))));
        d := OliverData(H);
        if d <> fail then Emit(out, n, H, d); c := c + 1; fi;
      od;
    od;
  od; od;
  CloseStream(out); Print("pairs at n = ", n, ": ", c, " Oliver\n");
end;
RunTom(12, "../outputs/tom12.txt");
RunTrans(14, "/tmp/trans14.txt"); RunPairs(14, "/tmp/pairs14.txt");
QUIT;
