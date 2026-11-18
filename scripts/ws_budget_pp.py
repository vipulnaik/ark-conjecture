#!/usr/bin/env python3
"""ws_budget_pp.py -- the pp+pp gap configurations (GammaL(1) twists) with the budget, where few classes fit.

Class weights: in a block of size a = p^e, a class of Gamma_X is a set D of nonzero difference vectors (closed
under +-), and has a |D| / 2 edges.  Classes heavier than T = mu*_cyc(n) can be in no face.  When the usable
classes of a configuration number at most MAXU, decide exactly, with NO symmetry imposed (every complex is
allowed; a separation found this way is sound, a complex found may not be N*-invariant), whether some complex
with every face of weight <= T meets Gamma's readings.
usage: python3 ws_budget_pp.py [MAXU]  -> ../outputs/ws_budget_pp.txt"""
import sys, itertools
from math import comb, gcd
from functools import reduce
from ortools.sat.python import cp_model
MAXU = int(sys.argv[1]) if len(sys.argv) > 1 else 14
src = open('ws_gapclose_pp.py').read(); exec(src[:src.index("open_cfg = []")])
def weights(a, cfg):
    """class weights of the configuration (c, t, d) on block a"""
    if isprime(a):
        k = cfg[3]; return [comb(a, 2) // k] * k
    (p, e), = fac(a).items(); N = a - 1; c, t, d = cfg[:3]; pt = pow(p, t); half = N // 2 if p != 2 else None
    par = list(range(c))
    def find(x):
        while par[x] != x: par[x] = par[par[x]]; x = par[x]
        return x
    for x in range(c):
        for y in (((pt * x + d) % c) if t < e else x, ((x + half) % c) if half else x):
            rx, ry = find(x), find(y)
            if rx != ry: par[rx] = ry
    cnt = {}
    for x in range(c): cnt[find(x)] = cnt.get(find(x), 0) + 1
    return [a * r * (N // c) // 2 for r in cnt.values()]
def decide(W, T, exact, qs):
    U = [w for w in W if w <= T]; m = len(U)
    faces = [S for r in range(1, m + 1) for S in itertools.combinations(range(m), r) if sum(U[i] for i in S) <= T]
    idx = {S: i for i, S in enumerate(faces)}
    M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in faces]
    for i, S in enumerate(faces):
        if len(S) > 1:
            for j in range(len(S)): M.AddImplication(X[i], X[idx[S[:j] + S[j + 1:]]])
    chi = sum((-1) ** (len(S) - 1) * X[i] for i, S in enumerate(faces))
    if exact: M.Add(chi == 1)
    else:
        Q = reduce(lambda u, v: u * v, qs, 1); z = M.NewIntVar(-10**6, 10**6, 'z'); M.Add(chi - 1 == Q * z)
    S_ = cp_model.CpSolver(); S_.parameters.max_time_in_seconds = 60; S_.parameters.num_workers = 2
    st = S_.Solve(M)
    return {cp_model.OPTIMAL: 'complex', cp_model.FEASIBLE: 'complex', cp_model.INFEASIBLE: 'NONE'}.get(st, 'unknown')
if __name__ == "__main__":
    counts = {}; res = []
    for n, a, b in sorted(pairs):
        T = L[n]
        for ca in CF[a]:
            for cb in CF[b]:
                if ca[3] == 1 and cb[3] == 1: continue
                exact, qs = readings(a, ca, b, cb)
                if not exact and not qs: continue
                W = weights(a, ca) + weights(b, cb)
                u = sum(1 for w in W if w <= T)
                if u > MAXU: counts['roomy'] = counts.get('roomy', 0) + 1; continue
                r = decide(W, T, exact, qs) if u else ('complex' if False else 'NONE')
                counts[r] = counts.get(r, 0) + 1
                if r != 'complex':
                    res.append((r, n, T, a, ca, b, cb, exact, sorted(qs), sorted(W))); print(res[-1], flush=True)
    with open('../outputs/ws_budget_pp.txt', 'w') as f:
        f.write(f"pp+pp configurations (GammaL(1)): {counts}  (roomy = more than {MAXU} usable classes, not decided here)\n")
        for r in res: f.write(f"{r}\n")
    print(counts)
