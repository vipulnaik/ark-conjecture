# three_p_groups.g -- the groups of burnside-ring-view.md §7.7 on [3p] = Z_3 x Z_p (point (i,x) -> 1 + i*p + x):
# H = <(i,x) -> (i+1, x+1)> (cyclic of order 3p), K1 = Z_3 x AGL(1,p), K2 = (Z_p)^3 : <g>, g(i,x) = (i+1, lam x),
# K3 = Z_3 wr Z_p.  Prints order, p-by-cyclic, orbital sizes; with EXPORT := true also writes a star file for
# nlevel_star.py (N = N(H), then H, K1, K2, K3).  usage: set P (and EXPORT, fname) then read this file.
p := P;; n := 3*p;;
pt := function(i, x) return 1 + (i mod 3)*p + (x mod p); end;;
mk := f -> PermList(List([0..n-1], j -> f(QuoInt(j, p), j mod p)));;
lam := PrimitiveRootMod(p);;
ptt := G -> ForAny(Set(Factors(Size(G))), q -> IsCyclic(G / PCore(G, q)));;
orbsz := G -> SortedList(List(Orbits(G, Combinations([1..n], 2), OnSets), Length));;
H := Group(mk(function(i,x) return pt(i+1, x+1); end));;
K1 := Group(mk(function(i,x) return pt(i+1, x); end), mk(function(i,x) return pt(i, x+1); end),
            mk(function(i,x) return pt(i, lam*x); end));;
K2 := Group(mk(function(i,x) if i = 0 then return pt(i, x+1); else return pt(i, x); fi; end),
            mk(function(i,x) return pt(i+1, lam*x); end));;
K3 := Group(mk(function(i,x) if x = 0 then return pt(i+1, x); else return pt(i, x); fi; end),
            mk(function(i,x) return pt(i, x+1); end));;
Print([p, p mod 3, List([K1, K2, K3], K -> [Size(K), ptt(K), orbsz(K), IsSubgroup(K, H)])], "\n");
if IsBound(EXPORT) and EXPORT then
  out := OutputTextFile(fname, false);; SetPrintFormattingStatus(out, false);;
  NH := Normalizer(SymmetricGroup(n), H);;
  AppendTo(out, "N ", Size(NH), " ", List(GeneratorsOfGroup(NH), g -> ListPerm(g, n)), "\n");
  for K in [H, K1, K2, K3] do AppendTo(out, "K ", Size(K), " ", IsTransitive(K, [1..n]), " ", List(GeneratorsOfGroup(K), g -> ListPerm(g, n)), "\n"); od;
  CloseStream(out);
fi;
QUIT;
