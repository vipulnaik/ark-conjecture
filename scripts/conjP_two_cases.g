# conjP_two_cases.g -- the two cases left by conjP_hall_chk.g: J2.2 on 1800 (K = L3(2).2 x 2) and HS.2 on 1100
# (K = L3(4).2^2).  Build G from the primitive groups library (degree 100), find a maximal K of the right order with
# index n, and decide (i) whether K cap L is maximal in L (by conjugacy) and (ii) whether G has a soluble subgroup
# transitive on G/K: descent through classes of maximal subgroups, keeping subgroups of order divisible by n.
# usage: gap -q conjP_two_cases.g -> ../outputs/conjP_two_cases.txt
out := OutputTextFile("../outputs/conjP_two_cases.txt", false);; SetPrintFormattingStatus(out, false);;
for c in [["J2.2", 1800, 604800], ["HS.2", 1100, 44352000]] do
  G := First(List([1..NrPrimitiveGroups(100)], i -> PrimitiveGroup(100, i)),
             g -> Size(g) = 2 * Size(Socle(g)) and Size(Socle(g)) = c[3]);
  L := Socle(G); n := c[2];
  Ks := Filtered(List(ConjugacyClassesMaximalSubgroups(G), Representative), K -> Index(G, K) = n);
  for K in Ks do
    KL := Intersection(K, L);
    maxL := ForAny(List(ConjugacyClassesMaximalSubgroups(L), Representative), M -> Size(M) = Size(KL) and IsConjugate(L, M, KL));
    act := ActionHomomorphism(G, RightCosets(G, K), OnRight);
    found := false; stack := [G];
    while Length(stack) > 0 and not found do
      H := Remove(stack);
      if IsSolvableGroup(H) then
        if IsTransitive(Image(act, H), [1..n]) then found := true; fi; continue;
      fi;
      for M in List(ConjugacyClassesMaximalSubgroups(H), Representative) do
        if Size(M) mod n = 0 then Add(stack, M); fi;
      od;
    od;
    AppendTo(out, c[1], " on ", n, ": |K| = ", Size(K), ", K cap L maximal in L: ", maxL,
      "; soluble transitive subgroup: ", found, "\n");
  od;
od;
CloseStream(out);
QUIT;
