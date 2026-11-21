# star_cyclic_export.g -- for nlevel_star.py: the star on the n-cycle h, with EVERY conjugate of a transitive p-by-cyclic group
# that contains h (complete: one RepresentativeAction per T-class of n-cycles, times the normaliser of <h>).  usage: set NN, fname.
n := NN;; S := SymmetricGroup(n);; h := CycleFromList([1..n]);; H := Group(h);; NH := Normalizer(S, H);;
ptt := G -> ForAny(Set(Factors(Size(G))), p -> IsCyclic(G / PCore(G, p)));;
res := [H];;
for i in [1..NrTransitiveGroups(n)] do
  T := TransitiveGroup(n, i);
  if ptt(T) then
    for cl in ConjugacyClasses(T) do
      x := Representative(cl);
      if CycleStructurePerm(x) = [] or CycleLengths(x, [1..n]) <> [n] then continue; fi;
      c := RepresentativeAction(S, x, h);
      for nu in NH do K := T^(c*nu); if not ForAny(res, R -> R = K) then Add(res, K); fi; od;
    od;
  fi;
od;
SortBy(res, Size);
out := OutputTextFile(fname, false);; SetPrintFormattingStatus(out, false);;
AppendTo(out, "N ", Size(NH), " ", List(GeneratorsOfGroup(NH), g -> ListPerm(g, n)), "\n");
for K in res do AppendTo(out, "K ", Size(K), " ", IsTransitive(K,[1..n]), " ", List(GeneratorsOfGroup(K), g -> ListPerm(g, n)), "\n"); od;
CloseStream(out); QUIT;
