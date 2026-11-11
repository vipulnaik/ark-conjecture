#!/usr/bin/env python3
"""global_chi_forced.py -- a graph property on n vertices with chi = 1 that
contains a prescribed large graph (`threshold-beyond-mu.md` section 9).

P = (all subgraphs of H0)  +  D,   D a family of classes with at most E edges
that are not subgraphs of H0, the whole closed under deleting an edge.  H0 is
the graph some p-subgroup forces into every property with chi = 1:
   2km : H0 = 2K_m, n = 2m   (forced by Z_p on two p-cycles; e_max(P) = m(m-1))
   star: H0 = K_{1,n-1}      (forced by Z_{n-1} when n - 1 is prime; e_max(P) = n-1)
   2km+star: both
   tri, tri+star: H0 = (n/3)K_3   (forced at n = 18 by the translations of two blocks of 9)
D is found by CP-SAT with
    chi = sum over classes H in P of (-1)^(e(H)-1) n!/((n-v(H))! |Aut H|) = 1,
imposed modulo enough primes.  e_max(P) = max(e(H0), largest member of D).

Usage: python3 global_chi_forced.py 2km|star|2km+star|tri|tri+star n E [check]
  check: recompute chi by brute force over all graphs (n = 6 only).
Writes D to ../outputs/global_chi_<mode>_<n>.json; `verify_global_chi.py` rechecks it.
"""
import sys, itertools
from math import factorial
import pynauty
from ortools.sat.python import cp_model

MODE, n, E = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]); m = n // 2
CHECK = len(sys.argv) > 4


def canon(edges):
    vs = sorted({x for e in edges for x in e}); ix = {v: i for i, v in enumerate(vs)}
    adj = {i: [] for i in range(len(vs))}
    for a, b in edges:
        adj[ix[a]].append(ix[b]); adj[ix[b]].append(ix[a])
    g = pynauty.Graph(len(vs), adjacency_dict=adj)
    lab = pynauty.canon_label(g); pos = {v: i for i, v in enumerate(lab)}
    _, m1, m2, _, _ = pynauty.autgrp(g)
    return tuple(sorted(tuple(sorted((pos[ix[a]], pos[ix[b]]))) for a, b in edges)), len(vs), round(m1 * 10 ** m2)


def in_2km(H, v):
    """components can be split into two groups of at most m vertices each"""
    comp = list(range(v))
    def f(x):
        while comp[x] != x:
            comp[x] = comp[comp[x]]; x = comp[x]
        return x
    for a, b in H:
        comp[f(a)] = f(b)
    sizes = {}
    for x in range(v):
        sizes[f(x)] = sizes.get(f(x), 0) + 1
    sizes = list(sizes.values())
    if max(sizes) > m:
        return False
    reach = {0}
    for s in sizes:
        reach |= {r + s for r in reach if r + s <= m}
    return any(v - r <= m for r in reach)


# free universe: classes with at most E edges, at most n vertices
info = {}                                   # canonical -> (v, aut)
level = {((0, 1),): 2}; info[((0, 1),)] = (2, 2)
for e in range(2, E + 1):
    nxt = {}
    for H, v in level.items():
        have = set(H)
        cand = [(a, b) for a in range(v) for b in range(a + 1, v) if (a, b) not in have]
        if v + 1 <= n:
            cand += [(a, v) for a in range(v)]
        if v + 2 <= n:
            cand += [(v, v + 1)]
        for c in cand:
            k, w, a = canon(H + (c,))
            if k not in info:
                info[k] = (w, a)
            nxt[k] = w
    level = nxt
    print(f"  {e} edges: {len(nxt)} classes", flush=True)
# forced: every subgraph of H0
forced = set()
if MODE.startswith("2km"):
    blk = list(itertools.combinations(range(m), 2))
    one = {}                                # graphs on one block up to isomorphism
    for r in range(len(blk) + 1):
        for S in itertools.combinations(blk, r):
            adj = {i: [] for i in range(m)}
            for a, b in S:
                adj[a].append(b); adj[b].append(a)
            one.setdefault(pynauty.certificate(pynauty.Graph(m, adjacency_dict=adj)), S)
    reps = list(one.values())
    for i, A in enumerate(reps):
        for Bq in reps[i:]:
            H = tuple(A) + tuple((a + m, b + m) for a, b in Bq)
            if H:
                k, w, a = canon(H); info.setdefault(k, (w, a)); forced.add(k)
    S0 = m * (m - 1); NAME = f"2K_{m}"
    assert all(in_2km(H, info[H][0]) == (H in forced) for H in info if len(H) <= E)
if MODE.startswith("tri"):                 # H0 = (n/3) K_3, subgraphs listed by edge deletion
    H0 = tuple(e for i in range(n // 3) for e in ((3 * i, 3 * i + 1), (3 * i, 3 * i + 2), (3 * i + 1, 3 * i + 2)))
    k, w, a = canon(H0); info.setdefault(k, (w, a)); layer = {k}; forced.add(k)
    while layer:
        nxt = set()
        for H in layer:
            if len(H) > 1:
                for d in H:
                    k, w, a = canon(tuple(x for x in H if x != d))
                    if k not in forced:
                        info.setdefault(k, (w, a)); forced.add(k); nxt.add(k)
        layer = nxt
    S0 = n; NAME = f"{n // 3}K_3"
if MODE.endswith("star"):
    for j in range(1, n):
        k, w, a = canon(tuple((0, i) for i in range(1, j + 1))); info.setdefault(k, (w, a)); forced.add(k)
    S0, NAME = (n - 1, f"K_(1,{n-1})") if MODE == "star" else (max(S0, n - 1), NAME + f" and K_(1,{n-1})")
free = [H for H in info if H not in forced and len(H) <= E]
cnt = lambda H: factorial(n) // factorial(n - info[H][0]) // info[H][1]
sgn = lambda H: 1 if len(H) % 2 else -1
c0 = sum(sgn(H) * cnt(H) for H in forced)
print(f"n = {n}: {len(forced)} classes of subgraphs of {NAME} (chi of that property alone: {c0}); "
      f"{len(free)} free classes with at most {E} edges", flush=True)
idx = {H: i for i, H in enumerate(free)}
M = cp_model.CpModel(); X = [M.NewBoolVar(str(i)) for i in range(len(free))]
for H in free:
    if len(H) > 1:
        for d in H:
            k = canon(tuple(x for x in H if x != d))[0]
            if k in idx:
                M.AddImplication(X[idx[H]], X[idx[k]])
tot = sum(cnt(H) for H in free) + abs(c0)
prod = 1
for p in [2147483647, 2147483629, 2147483587, 2147483579, 2147483563]:
    z = M.NewIntVar(-len(free) - 2, len(free) + 2, f"z{p}")
    M.Add(sum((sgn(H) * cnt(H) % p) * X[idx[H]] for H in free) + (c0 % p) == 1 + p * z)
    prod *= p
    if prod > 2 * tot + 2:
        break
assert prod > 2 * tot + 2
S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 420; S.parameters.num_workers = 8
r = S.Solve(M)
if r not in (cp_model.OPTIMAL, cp_model.FEASIBLE):
    print("no family D found:", "infeasible" if r == cp_model.INFEASIBLE else "solver stopped without an answer")
    sys.exit(0)
D = [H for H in free if S.Value(X[idx[H]])]
chi = c0 + sum(sgn(H) * cnt(H) for H in D)
Dset = set(D)
gens = [H for H in D if not any(H != G and len(G) == len(H) + 1 and
                                any(canon(tuple(x for x in G if x != d))[0] == H for d in G) for G in D)]
print(f"FOUND: |D| = {len(D)} classes, {len(gens)} maximal, largest {max(len(H) for H in D)} edges; chi = {chi}; "
      f"e_max(P) = {max(S0, max(len(H) for H in D))}")
assert chi == 1
print("   generators of D by edge count:", sorted({len(H): sum(1 for G in gens if len(G) == len(H)) for H in gens}.items()))
import json
json.dump({"n": n, "mode": MODE, "E": E, "D": [list(map(list, H)) for H in sorted(D)]},
          open(f"../outputs/global_chi_{MODE.replace('+', '_')}_{n}.json", "w"))
print(f"   written to ../outputs/global_chi_{MODE.replace('+', '_')}_{n}.json")
if CHECK:
    P = forced | Dset
    PAIRS = list(itertools.combinations(range(n), 2)); x = 0
    for e in range(1, len(PAIRS) + 1):
        for T in itertools.combinations(PAIRS, e):
            if canon(T)[0] in P:
                x += (-1) ** (e - 1)
    print("brute-force chi over all graphs:", x); assert x == 1
