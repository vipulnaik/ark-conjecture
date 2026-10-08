# bip_sylow_check.g -- the Sylow form (F) of the largest-invariant-bipartite-graph conjecture (pending-checks A38
# item 2; oen 7.4).  For every transitive group of degree n = 2 (mod 4) with a bipartite orbital: W = union of the
# bipartite orbitals, D = the W-component of point 1, L = its setwise stabiliser, T = a Sylow 2-subgroup of L_1, and
# S a Sylow 2-subgroup of L containing T (then [S:T] = 2).  (F): every point stabiliser S_z, z in D, lies in T --
# equivalently no element of S outside T fixes a point of D.  (F) is equivalent to the conjecture (oen 7.4).
# USAGE  gap -q bip_sylow_check.g      (about 50 minutes in all, most of it at n = 42)
DEGREES := [6,10,14,18,22,26,30,34,38,42,46];
IsBipCol := function(n, edges)
    local adj, col, e, s, queue, u, v;
    adj := List([1..n], i -> []);
    for e in edges do Add(adj[e[1]], e[2]); Add(adj[e[2]], e[1]); od;
    col := ListWithIdenticalEntries(n, 0);
    for s in [1..n] do
        if col[s] = 0 and adj[s] <> [] then
            col[s] := 1; queue := [s];
            while queue <> [] do
                u := Remove(queue);
                for v in adj[u] do
                    if col[v] = 0 then col[v] := 3 - col[u]; Add(queue, v);
                    elif col[v] = col[u] then return fail; fi;
                od;
            od;
        fi;
    od;
    return [adj, col];
end;
Comps := function(adj, pts)
    local seen, res, p, C, i, v;
    seen := []; res := [];
    for p in pts do
        if not p in seen and adj[p] <> [] then
            C := [p]; i := 1;
            while i <= Length(C) do for v in adj[C[i]] do if not v in C then Add(C, v); fi; od; i := i + 1; od;
            Append(seen, C); Add(res, Set(C));
        fi;
    od;
    return res;
end;
# (F): with L the stabiliser of the W-component D of point 1 and S a Sylow 2-subgroup of L containing a Sylow
# 2-subgroup of L_1: every point stabiliser S_z (z in D) lies inside S_1.
for n in DEGREES do
  pairs := Combinations([1..n], 2); tested := 0; bad := 0;
  for k in [1..NrTransitiveGroups(n)] do
    G := TransitiveGroup(n, k);
    orbs := Orbits(G, pairs, OnSets);
    bip := Filtered(orbs, o -> IsBipCol(n, o) <> fail);
    if bip = [] then continue; fi;
    tested := tested + 1;
    rW := IsBipCol(n, Concatenation(bip));
    D := Comps(rW[1], [1])[1]; L := Stabilizer(G, D, OnSets);
    T := SylowSubgroup(Stabilizer(L, 1), 2);
    S := SylowSubgroup(Normalizer(L, T), 2);   # contains T with index 2
    if not IsSubgroup(S, T) then S := First(ConjugateSubgroups(L, SylowSubgroup(L,2)), P -> IsSubgroup(P, T)); fi;
    if ForAny(D, z -> not IsSubgroup(Stabilizer(S, 1), Stabilizer(S, z))) then bad := bad + 1; fi;
  od;
  Print("n=", n, " groups ", tested, "  (F) fails: ", bad, "\n");
od;
QUIT;
