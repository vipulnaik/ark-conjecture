# conjP_flag_points.g -- Conjecture P, Step 5, the two point-hyperplane (flag) groups left to degree 1000:
# PSL(4,3).2^2 on 520 and PSL(3,9).2^2 on 910.  Gamma_0 = Gamma minus the graph automorphism induces on the P points a
# soluble group with at most two orbits on ordered pairs of distinct points (the projection argument of §6.3), so of
# rank <= 3, with a suborbit of length >= (P - 1)/2.  Search PGammaL(n, q) on points for soluble transitive subgroups
# of order >= P (P - 1)/2 with rank <= 3.  usage: gap -q conjP_flag_points.g -> ../outputs/conjP_flag_points.txt
out := OutputTextFile("../outputs/conjP_flag_points.txt", false);; SetPrintFormattingStatus(out, false);;
for c in [[4, 3], [3, 9]] do
  G := PGammaL(c[1], c[2]);   # GAP: already the action on projective points
  P := NrMovedPoints(G); bound := P * (P - 1) / 2;
  found := []; stack := [G]; seen := 0;
  while Length(stack) > 0 do
    H := Remove(stack); seen := seen + 1;
    if IsSolvableGroup(H) and IsTransitive(H, [1..P]) and Length(Orbits(Stabilizer(H, 1), [1..P])) <= 3 then Add(found, H); fi;
    for M in List(ConjugacyClassesMaximalSubgroups(H), Representative) do
      if Size(M) >= bound and IsTransitive(M, [1..P]) then Add(stack, M); fi;
    od;
  od;
  AppendTo(out, "PGammaL(", c[1], ",", c[2], ") on ", P, " points: soluble transitive subgroups of rank <= 3: ",
    Length(found), " (", seen, " subgroups visited, order bound ", bound, ")\n");
od;
CloseStream(out);
QUIT;
