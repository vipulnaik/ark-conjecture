# rv_orbits.g -- subset orbits (as bitmasks) of TransitiveGroup(NN, k) for each k with at most MAXO orbits
for k in [1..NrTransitiveGroups(NN)] do
  G := TransitiveGroup(NN, k);
  cnt := Sum(ConjugacyClasses(G), c -> Size(c) * 2^Length(CycleLengths(Representative(c), [1..NN]))) / Size(G);
  if cnt <= MAXO then
    orbs := Orbits(G, Combinations([1..NN]), OnSets);
    Print("G ", k, " ", Size(G), " ", List(orbs, o -> List(o, s -> Sum(s, i -> 2^(i-1)))), "\n");
  fi;
od;
QUIT;
