#!/usr/bin/env python3
"""global_chi_min.py -- G*(n), the least s(P) over monotone graph properties P
on n vertices with chi(Delta_P) = 1 (`threshold-beyond-mu.md` section 9).

This is m*_N = m*_chi of the trivial group, the one Oliver group with a single
type.  A property with s(P) <= s is a family of isomorphism classes of graphs
with at most s edges (no isolated vertices, at most n vertices), closed under
deleting an edge, and
    chi = sum over classes H in P of (-1)^(e(H)-1) * (number of copies of H in K_n).
Feasibility of chi = 1 is decided by CP-SAT, the equation being imposed modulo
enough primes that their product exceeds twice the sum of all the counts.

Usage: python3 global_chi_min.py SMAX n [n ...]     (needs pynauty, ortools)
Prints, for each n, the least s <= SMAX with a solution, the generators of one
solution, and whether each smaller s was proved infeasible.
"""
import sys, itertools
from math import factorial
import pynauty
from ortools.sat.python import cp_model

SMAX = int(sys.argv[1]); NS = [int(x) for x in sys.argv[2:]]
TL = 300.0


def canon(edges):
    vs = sorted({x for e in edges for x in e}); ix = {v: i for i, v in enumerate(vs)}
    adj = {i: [] for i in range(len(vs))}
    for a, b in edges:
        adj[ix[a]].append(ix[b]); adj[ix[b]].append(ix[a])
    g = pynauty.Graph(len(vs), adjacency_dict=adj)
    lab = pynauty.canon_label(g); pos = {v: i for i, v in enumerate(lab)}
    return tuple(sorted(tuple(sorted((pos[ix[a]], pos[ix[b]]))) for a, b in edges)), len(vs)


def autsize(edges, v):
    adj = {i: [] for i in range(v)}
    for a, b in edges:
        adj[a].append(b); adj[b].append(a)
    _, m1, m2, _, _ = pynauty.autgrp(pynauty.Graph(v, adjacency_dict=adj))
    return round(m1 * 10 ** m2)


levels = [{((0, 1),): 2}]                      # canonical edge tuple -> vertex count
for e in range(2, SMAX + 1):
    nxt = {}
    for H, v in levels[-1].items():
        have = set(H)
        cand = [(a, b) for a in range(v) for b in range(a + 1, v) if (a, b) not in have]
        cand += [(a, v) for a in range(v)] + [(v, v + 1)]
        for c in cand:
            k, w = canon(H + (c,))
            nxt[k] = w
    levels.append(nxt)
cls = [(H, v) for lv in levels for H, v in lv.items()]
idx = {H: i for i, (H, v) in enumerate(cls)}
aut = [autsize(H, v) for H, v in cls]
below = [sorted({idx[canon(tuple(x for x in H if x != d))[0]] for d in H}) if len(H) > 1 else [] for H, v in cls]
print("classes by edges:", [len(lv) for lv in levels], flush=True)
PRIMES = [2147483647, 2147483629, 2147483587, 2147483579, 2147483563, 2147483549, 2147483543]


def solve(n, s):
    use = [i for i, (H, v) in enumerate(cls) if len(H) <= s and v <= n]
    cnt = {i: factorial(n) // factorial(n - cls[i][1]) // aut[i] for i in use}
    sgn = {i: 1 if len(cls[i][0]) % 2 else -1 for i in use}
    tot = sum(cnt.values())
    M = cp_model.CpModel(); X = {i: M.NewBoolVar(str(i)) for i in use}
    for i in use:
        for j in below[i]:
            M.AddImplication(X[i], X[j])
    M.Add(X[idx[((0, 1),)]] == 1)
    if tot < 2 ** 60:
        M.Add(sum(sgn[i] * cnt[i] * X[i] for i in use) == 1)
    else:
        prod = 1
        for p in PRIMES:
            z = M.NewIntVar(-len(use) - 1, len(use) + 1, f"z{p}")
            M.Add(sum((sgn[i] * cnt[i] % p) * X[i] for i in use) == 1 + p * z)
            prod *= p
            if prod > 2 * tot + 2:
                break
        assert prod > 2 * tot + 2
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = TL; S.parameters.num_workers = 8
    r = S.Solve(M)
    if r in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        P = [i for i in use if S.Value(X[i])]
        assert sum(sgn[i] * cnt[i] for i in P) == 1
        gens = [i for i in P if not any(i in below[j] for j in P)]
        return "yes", [(len(cls[i][0]), cls[i][0]) for i in gens]
    return ("no" if r == cp_model.INFEASIBLE else "unknown"), None


for n in NS:
    hist = []
    for s in range(1, SMAX + 1):
        r, gens = solve(n, s); hist.append(r)
        if r == "yes":
            print(f"n = {n}: G* = {s}" + ("" if all(h == "no" for h in hist[:-1]) else "  (an upper bound: " + ",".join(hist[:-1]) + ")"),
                  " generators (edges, graph):", gens, flush=True)
            break
    else:
        print(f"n = {n}: no solution with s <= {SMAX}: {hist}", flush=True)
