# two_p_groups.g -- the three groups of burnside-ring-view.md §7.5 on [2p] = {0,1} x Z_p: order, whether p-by-cyclic
# (some prime q with G/O_q(G) cyclic), and the sizes of their orbitals on pairs.  usage: gap -q two_p_groups.g
# vertices (e,x), e in {0,1}, x in Z_p  ->  point 1 + e*p + x
Chk := function(p)
  local pt, n, lam, K1, K2, K3, ptt, orbsz, sq, mk, res;
  n := 2*p; pt := function(e, x) return 1 + (e mod 2)*p + (x mod p); end;
  mk := f -> PermList(List([0..n-1], i -> f(QuoInt(i, p), i mod p)));
  lam := PrimitiveRootMod(p);
  ptt := G -> ForAny(Set(Factors(Size(G))), q -> IsCyclic(G / PCore(G, q)));
  orbsz := G -> SortedList(List(Orbits(G, Combinations([1..n], 2), OnSets), Length));
  # K1 = Z_2 x (Z_p : squares): translations, parity swap, multiplication by lam^2
  K1 := Group(mk(function(e,x) return pt(e, x+1); end), mk(function(e,x) return pt(e+1, x); end),
              mk(function(e,x) return pt(e, lam^2*x); end));
  # K2 = (Z_p x Z_p) : <g>, g(e,x) = (e+1, lam x)
  K2 := Group(mk(function(e,x) if e = 0 then return pt(e, x+1); else return pt(e, x); fi; end),
              mk(function(e,x) if e = 1 then return pt(e, x+1); else return pt(e, x); fi; end),
              mk(function(e,x) return pt(e+1, lam*x); end));
  # K3 = C_2 wr C_p: flip block 0, translate blocks
  K3 := Group(mk(function(e,x) if x = 0 then return pt(e+1, x); else return pt(e, x); fi; end),
              mk(function(e,x) return pt(e, x+1); end));
  return [p, p mod 4, [Size(K1), ptt(K1), orbsz(K1)], [Size(K2), ptt(K2), orbsz(K2)], [Size(K3), ptt(K3), orbsz(K3)]];
end;;
for p in [3,5,7,11,13,19,23] do Print(Chk(p), "\n"); od;
QUIT;
