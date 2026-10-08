# bip_halves_sign_check.g -- certificate behind the largest-invariant-bipartite-graph conjecture
# (pending-checks A38 item 2; oen 7.4).  For every transitive group of degree n = 2 (mod 4) with a bipartite
# orbital, let W be the union of its bipartite orbitals (bipartite, by bip_union_scan.g), D the W-component of
# point 1 and L its setwise stabiliser.  For each bipartite orbital U, eps_U(g) is the sign of g acting on the
# halves (colour classes of components) of U inside D.  Checked: eps_U equals W's colour-swap character on every
# generator of L, for every U -- i.e. one character of L restricts to the half-swap of every U at once.
# USAGE  gap -q bip_halves_sign_check.g
DEGREES := [6, 10, 14, 18, 22, 26, 30, 34, 38, 42, 46];   # about 10 minutes in all
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
# For every bipartite orbital U, eps_U(g) = sign of g on the halves of U inside the W-component D.
# Test: eps_U equals the W colour-swap character on generators of L, for every U.
for n in DEGREES do
  pairs := Combinations([1..n], 2); tested := 0; bad := 0;
  for k in [1..NrTransitiveGroups(n)] do
    G := TransitiveGroup(n, k);
    orbs := Orbits(G, pairs, OnSets);
    bip := Filtered(orbs, o -> IsBipCol(n, o) <> fail);
    if bip = [] then continue; fi;
    tested := tested + 1;
    rW := IsBipCol(n, Concatenation(bip)); colW := rW[2];
    D := Comps(rW[1], [1])[1]; L := Stabilizer(G, D, OnSets);
    gens := GeneratorsOfGroup(L);
    for U in bip do
      rU := IsBipCol(n, Filtered(U, e -> e[1] in D));
      halves := [];
      for C in Comps(rU[1], D) do
        Add(halves, Set(Filtered(C, y -> rU[2][y] = 1))); Add(halves, Set(Filtered(C, y -> rU[2][y] = 2)));
      od;
      for g in gens do
        epsU := SignPerm(PermList(List(halves, h -> Position(halves, Set(OnTuples(h, g))))));
        # W swap: does g send a point of colour c to colour c?  (D is one W-component, so this is a character)
        sw := (colW[D[1]] = colW[D[1]^g]);
        if (epsU = 1) <> sw then bad := bad + 1; fi;
      od;
    od;
  od;
  Print("n=", n, " groups ", tested, " generator mismatches eps_U vs W-swap: ", bad, "\n");
od;
QUIT;
