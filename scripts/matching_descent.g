# matching_descent.g -- for n = 2m, find Oliver groups on n points whose orbitals on pairs are exactly
# {a perfect matching M, all other edges}.  Each gives D(f) >= C(n,2) - m for every nontrivial monotone graph property
# (two-step descent: (M, K_n) and (empty, K_n - M'); see restriction-game.md section 6a addendum).
# Candidates: E : H inside C_2 wr H, H a solvable 2-homogeneous transitive group of degree m, E = C_2^m or its
# even-weight subgroup.  Oliver test as in oliver_tom.g.
LoadPackage("transgrp");;
OupperQ := function(Q, q)
  local rs, S;
  if Size(Q) = 1 then return Q; fi;
  rs := Filtered(PrimeDivisors(Size(Q)), r -> r <> q);
  S := Subgroup(Q, Concatenation(List(rs, r -> GeneratorsOfGroup(SylowSubgroup(Q, r)))));
  return NormalClosure(Q, S);
end;
IsOliver := function(G)
  local ps, p, q, Q;
  ps := Set(Concatenation([2,3,5,7,11,13], PrimeDivisors(Maximum(2,Size(G)))));
  for p in ps do
    Q := Image(NaturalHomomorphismByNormalSubgroup(G, PCore(G,p)));
    if IsCyclic(Q) then return true; fi;
    for q in ps do if IsCyclic(OupperQ(Q,q)) then return true; fi; od;
  od;
  return false;
end;
for m in MS do
  found := [];
  for k in [1..NrTransitiveGroups(m)] do
    H := TransitiveGroup(m, k);
    if not IsSolvableGroup(H) then continue; fi;
    if Length(Orbits(H, Combinations([1..m], 2), OnSets)) <> 1 then continue; fi;
    W := WreathProduct(CyclicGroup(IsPermGroup, 2), H);          # on 2m points, blocks {2i-1, 2i}
    base := Image(Embedding(W, 1)); base := NormalClosure(W, base);
    flips := List([1..m], i -> (2*i-1, 2*i));
    even := Group(List([1..m-1], i -> flips[i] * flips[i+1]));
    tops := List(GeneratorsOfGroup(H), h -> Image(Embedding(W, m + 1), h));
    for flipgrp in [Group(flips), even] do
      G := ClosureGroup(flipgrp, tops);
      orbs := Orbits(G, Combinations([1..2*m], 2), OnSets);
      if Length(orbs) = 2 and Set(List(orbs, Length)) = Set([m, 2*m*(m-1)]) and IsOliver(G) then
        Add(found, [k, Size(H), Size(G), Size(flipgrp) = 2^m]);
      fi;
    od;
  od;
  Print("m = ", m, "  n = ", 2*m, ": ", Length(found), " groups [H index, |H|, |G|, E full?] ", found{[1..Minimum(4, Length(found))]}, "\n");
od;
QUIT;
