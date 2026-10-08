# bip_union_scan.g -- the largest-invariant-bipartite-graph conjecture (pending-checks A38 item 2) on every
# transitive group of degree n = 2 (mod 4), n <= 46 (the whole library at those degrees), from the TransGrp library.
# For each group: the orbitals on 2-sets, which of them are bipartite graphs, and whether their union is bipartite.
# If the union is bipartite, the fixed complex of bipartiteness is a full simplex (chi = 1, every condition met).
# Output per degree: groups scanned, solvable, with a bipartite orbital, and FAILURES (union not bipartite),
# each failure printed as T<k> with its order, solvability and orbital sizes.
# USAGE  gap -q bip_union_scan.g          (edit DEGREES to change)

DEGREES := [6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46];   # about a minute

IsBip := function(n, edges)
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
                    elif col[v] = col[u] then return false; fi;
                od;
            od;
        fi;
    od;
    return true;
end;

for n in DEGREES do
    pairs := Combinations([1..n], 2);
    tot := 0; solv := 0; withbip := 0; fails := 0;
    for k in [1..NrTransitiveGroups(n)] do
        G := TransitiveGroup(n, k); tot := tot + 1;
        if IsSolvableGroup(G) then solv := solv + 1; fi;
        orbs := Orbits(G, pairs, OnSets);
        bip := Filtered(orbs, o -> IsBip(n, o));
        if bip <> [] then
            withbip := withbip + 1;
            if not IsBip(n, Concatenation(bip)) then
                fails := fails + 1;
                Print("FAIL n=", n, " T", k, " order ", Size(G), " solvable ", IsSolvableGroup(G),
                      " orbitals ", List(orbs, Length), " bipartite ", List(bip, Length), "\n");
            fi;
        fi;
    od;
    Print("n=", n, ": ", tot, " transitive, ", solv, " solvable, ", withbip, " with a bipartite orbital, ",
          fails, " with non-bipartite union\n");
od;
QUIT;
