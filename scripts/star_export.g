# star_export.g -- for nlevel_star.py: N(H) and the p-by-cyclic overgroups of H = <h> in S_NN, namely those inside N(H)
# and every conjugate of a transitive p-by-cyclic group that contains h.  usage: set NN, h, fname, then read this file.
n := NN;;
S := SymmetricGroup(n);; H := Group(h);; N := Normalizer(S, H);;
ptt := G -> Size(G) = 1 or ForAny(Set(Factors(Size(G))), p -> IsCyclic(G / PCore(G, p)));;
res := Filtered(AllSubgroups(N), K -> IsSubgroup(K, H) and ptt(K));;
ct := CycleStructurePerm(h);;
for i in [1..NrTransitiveGroups(n)] do
  T := TransitiveGroup(n, i);
  if ptt(T) then
    for x in Filtered(Elements(T), x -> CycleStructurePerm(x) = ct) do
      K := T^RepresentativeAction(S, x, h);
      if not ForAny(res, R -> R = K) then Add(res, K); fi;
    od;
  fi;
od;
SortBy(res, Size);
out := OutputTextFile(fname, false);; SetPrintFormattingStatus(out, false);;
AppendTo(out, "N ", Size(N), " ", List(GeneratorsOfGroup(N), g -> ListPerm(g, n)), "\n");
for K in res do AppendTo(out, "K ", Size(K), " ", IsTransitive(K,[1..n]), " ", List(GeneratorsOfGroup(K), g -> ListPerm(g, n)), "\n"); od;
CloseStream(out); QUIT;
