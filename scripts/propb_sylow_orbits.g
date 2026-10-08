# orbits of a Sylow p-subgroup of S_n on 3-subsets, for n in NS and every prime p <= n, as JSON-ish lines
for n in NS do
  trip := Combinations([1..n], 3);
  for p in Filtered([2..n], IsPrime) do
    Q := SylowSubgroup(SymmetricGroup(n), p);
    orbs := Orbits(Q, trip, OnSets);
    PrintTo("*stdout*", n, "|", p, "|", Size(Q), "|", List(orbs, o -> List(o, t -> t - 1)), "\n");
  od;
od;
QUIT;
