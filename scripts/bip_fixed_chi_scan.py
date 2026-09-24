#!/usr/bin/env python3
"""
bip_fixed_chi_scan.py -- bipartiteness against every Oliver group in an oliver_tom.g export (six-field format).

For each group, chi of the fixed complex of bipartiteness (the sets of orbitals whose union is
bipartite; the full set excluded), by depth-first search over that down-set with an
incremental 2-colouring.  Verdict: susceptible if the group's condition fails (chi != 1 for an
"exact" group; chi != 1 mod q for some top prime q otherwise).  For resistant groups it also
reports whether the complex is a CONE (some orbital addable to every face -- contractible, so
blind at every rung) and, if not, its reduced F_2 Betti numbers.

USAGE   python3 bip_fixed_chi_scan.py N tomN.txt [face_budget]
"""
import sys, json
import numpy as np
from collections import Counter


def parse(path):
    G = []
    for line in open(path):
        order, trans, exact, qs, ntq, orbs = line.rstrip("\n").split("|")
        tag = "exact" if exact == "true" else json.loads(qs)
        orbs = [[(e[0] - 1, e[1] - 1) for e in o] for o in json.loads(orbs)]
        G.append(dict(order=int(order), trans=(trans == "true"), tag=tag, orbs=orbs))
    return G


def bip_add(state, edges):
    p, r = state
    p = p[:]; r = r[:]

    def find(x):
        par = 0
        while p[x] != x:
            par ^= r[x]; x = p[x]
        return x, par
    for u, v in edges:
        (a, pa), (b, pb) = find(u), find(v)
        if a == b:
            if pa == pb:
                return None
        else:
            p[a] = b; r[a] = pa ^ pb ^ 1
    return (p, r)


def faces(orbs, n, budget):
    t = len(orbs); F = []
    stack = [(0, (list(range(n)), [0] * n), ())]
    while stack:
        i, st, S = stack.pop()
        if i == t:
            if 0 < len(S) < t:
                F.append(frozenset(S))
                if len(F) > budget:
                    return None
            continue
        stack.append((i + 1, st, S))
        ns = bip_add(st, orbs[i])
        if ns is not None:
            stack.append((i + 1, ns, S + (i,)))
    return F


def reduced_betti_f2(F):
    by = {}
    for f in F:
        by.setdefault(len(f) - 1, []).append(tuple(sorted(f)))
    if not by:
        return []
    D = max(by); idx = {d: {s: i for i, s in enumerate(by[d])} for d in by}; rk = {}

    def rank2(M):
        M = M.copy() % 2; r = 0
        for c in range(M.shape[1]):
            piv = next((i for i in range(r, M.shape[0]) if M[i, c]), None)
            if piv is None:
                continue
            M[[r, piv]] = M[[piv, r]]
            for i in range(M.shape[0]):
                if i != r and M[i, c]:
                    M[i] ^= M[r]
            r += 1
        return r
    for d in range(1, D + 1):
        if d in by and d - 1 in by:
            M = np.zeros((len(by[d - 1]), len(by[d])), dtype=np.uint8)
            for j, s in enumerate(by[d]):
                for k in range(len(s)):
                    M[idx[d - 1][s[:k] + s[k + 1:]], j] = 1
            rk[d] = rank2(M)
    b = [len(by.get(d, [])) - rk.get(d, 0) - rk.get(d + 1, 0) for d in range(D + 1)]
    b[0] -= 1
    return b


def main():
    n = int(sys.argv[1]); G = parse(sys.argv[2])
    budget = int(sys.argv[3]) if len(sys.argv) > 3 else 300000
    C = Counter(); skipped = 0
    for g in G:
        F = faces(g["orbs"], n, budget)
        if F is None:
            skipped += 1; continue
        chi = sum((-1) ** (len(f) - 1) for f in F)
        ok = chi == 1 if g["tag"] == "exact" else all(chi % q == 1 % q for q in g["tag"])
        kind = "transitive" if g["trans"] else "intransitive"
        if not ok:
            C[(kind, "susceptible")] += 1; continue
        Fs = set(F); t = len(g["orbs"])
        cone = any(frozenset([o]) in Fs and all((f | {o}) in Fs for f in Fs) for o in range(t))
        if cone:
            C[(kind, "resistant, cone")] += 1
        elif len(F) > 20000:
            C[(kind, "resistant, homology not computed")] += 1
        else:
            b = reduced_betti_f2(F)
            C[(kind, "resistant, NOT F2-acyclic" if any(b) else "resistant, F2-acyclic")] += 1
    print(f"n={n}: {len(G)} Oliver classes, {skipped} skipped over the face budget ({budget:,})")
    for k, v in sorted(C.items()):
        print(f"  {k[0]:12s} {k[1]:36s} {v}")


if __name__ == "__main__":
    main()
