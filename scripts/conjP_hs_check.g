# conjP_hs_check.g -- Conjecture P, Step 5, types HS: for N = PrimitiveGroup(n, i) of type HS, collect the soluble
# transitive Gamma <= N (up to N-conjugacy, through the maximal-subgroup descent of conjP_soluble_filter.g) whose
# orbitals pass the necessary test of conjP_soluble_filter.g, and decide the real condition: does Gamma-hat =
# TwoClosure(Gamma) contain a minimal normal subgroup of N?  (Step 5 needs that, with N = N*(Gamma) primitive.)
# The necessary test is vacuous for a regular minimal normal subgroup, which is why type HS gives hits there.  usage: gap -q conjP_hs_check.g  (CASES set below) -> /tmp/conjP_hs.txt
qn := function(n) return Maximum(List(Collected(Factors(n)), x -> x[1]^x[2])); end;;
reading := function(G)   # some prime p: Q = G/O_p(G); exact if Q cyclic; mod q if O^q(Q) cyclic
  local p, q, Q, hom, res;
  res := [];
  for p in Set(Factors(Size(G))) do
    hom := NaturalHomomorphismByNormalSubgroup(G, PCore(G, p)); Q := Image(hom);
    if IsCyclic(Q) then Add(res, [p, "exact"]); fi;
    for q in Set(Factors(Size(G))) do
      if IsCyclic(Intersection(List(NormalSubgroups(Q), function(M) if IsPGroup(Q / M) and
           (Size(Q / M) = 1 or Factors(Size(Q / M))[1] = q) then return M; else return Q; fi; end))) then
        Add(res, [p, q]);
      fi;
    od;
  od;
  return res;
end;;
out := OutputTextFile("/tmp/conjP_hs.txt", true);; SetPrintFormattingStatus(out, false);;
for c in CASES do
  n := c[1]; i := c[2]; N := PrimitiveGroup(n, i); B := n * (qn(n) - 1) / 2;
  Ls := Filtered(MinimalNormalSubgroups(N), M -> not IsSolvableGroup(M));
  bound := n;
  found := []; stack := [N];
  while Length(stack) > 0 do
    H := Remove(stack);
    if IsSolvableGroup(H) and IsTransitive(H, [1..n]) then
      if ForAny(Ls, L -> ForAll(Orbits(Stabilizer(L, 1), [2..n]), o -> IsSubset(Orbit(Stabilizer(H, 1), o[1]), o))) then
        if ForAll(found, F -> Size(F) <> Size(H) or RepresentativeAction(N, F, H) = fail) then Add(found, H); fi;
      fi;
    fi;
    if IsTransitive(H, [1..n]) then
      for M in List(ConjugacyClassesMaximalSubgroups(H), Representative) do
        if Size(M) >= bound and IsTransitive(M, [1..n]) then Add(stack, M); fi;
      od;
    fi;
  od;
  for G in found do
    Gh := TwoClosure(G);
    AppendTo(out, n, " ", i, " |Gamma|=", Size(G), " |Gammahat|=", Size(Gh),
      " Gammahat-contains-a-minimal-normal-subgroup-of-N=", ForAny(Ls, L -> IsSubgroup(Gh, L)), "\n");
  od;
  if found = [] then AppendTo(out, n, " ", i, " none\n"); fi;
od;
CloseStream(out);
QUIT;
