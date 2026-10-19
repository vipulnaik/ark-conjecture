# halfsplit_large.g -- A44 remainder: transitive groups of degree 12-14 with |G| > 5000 (halfsplit_scan.g covered <= 5000).
# Step 1: does G contain a transitive Oliver subgroup?  Oliver groups are solvable, so it suffices to list the transitive
# Oliver groups K of the same degree (TransitiveGroup library, OliverData from ws_oliver.g) and test whether G contains a
# conjugate of K (ContainedConjugates in S_d).  Step 2, only for groups with none: the half-split graph, as in halfsplit_scan.g.
# Usage: gap -q halfsplit_large.g < /dev/null
Read("ws_oliver.g");
for deg in [12..14] do
  Sd := SymmetricGroup(deg);
  Ks := Filtered(List([1..NrTransitiveGroups(deg)], k -> TransitiveGroup(deg, k)), K -> IsSolvable(K) and OliverData(K) <> fail);
  Ks := List(Ks, K -> K);  SortBy(Ks, Size);
  Print("degree ", deg, ": ", Length(Ks), " transitive Oliver groups (orders ", List(Ks, Size), ")\n");
  for k in [1..NrTransitiveGroups(deg)] do
    G := TransitiveGroup(deg, k);
    if Size(G) <= 5000 then continue; fi;
    wit := First(Ks, K -> Size(G) mod Size(K) = 0 and ContainedConjugates(Sd, G, K) <> []);
    if wit <> fail then
      Print("  ", deg, "T", k, " |G|=", Size(G), ": contains a transitive Oliver subgroup of order ", Size(wit), " -> settled\n");
    else
      Print("  ", deg, "T", k, " |G|=", Size(G), " (", StructureDescription(G), "): NO transitive Oliver subgroup -> half-split graph needed\n");
    fi;
  od;
od;
QUIT;
