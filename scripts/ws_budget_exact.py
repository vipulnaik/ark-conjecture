#!/usr/bin/env python3
"""ws_budget_exact.py -- exact level-1 check, with the budget, for two-block configurations with few usable classes.

Points: the classes of block A (Z_kA, weight wA each) and of block B (Z_kB, weight wB); the cross orbital
(a b edges) never fits.  Group: C_kA x C_kB (each shifts its block's classes).  N* contains it, so an
N*-invariant complex is invariant under it: if NO C_kA x C_kB-invariant complex with every face of weight <= T
meets the condition, none is N*-invariant either, and m*_N(Gamma) > T -- a separation at n.
Faces: all subsets of weight <= T (each is proper).  CP-SAT over orbits: closure, and chi = 1 (exact reading)
or chi = 1 mod Q.  usage: python3 ws_budget_exact.py [maxsets]  -> ../outputs/ws_budget_exact.txt"""
import csv, sys, itertools
from math import comb, gcd
from functools import reduce
from sympy import isprime, divisors
from ortools.sat.python import cp_model
sys.path.insert(0, '.')
import ws_budget_scan as WB
L, rows, cls, readings = WB.L, WB.rows, WB.cls, WB.readings
MAXSETS = int(sys.argv[1]) if len(sys.argv) > 1 else 200000

def feasible_sets(kA, wA, kB, wB, T):
    cA, cB = min(T // wA, kA), min(T // wB, kB)
    out = []
    for i in range(0, cA + 1):
        for j in range(0, cB + 1):
            if i + j == 0 or i * wA + j * wB > T: continue
            if comb(kA, i) * comb(kB, j) > MAXSETS: return None
            for SA in itertools.combinations(range(kA), i):
                for SB in itertools.combinations(range(kB), j):
                    out.append((SA, SB))
            if len(out) > MAXSETS: return None
    return out
def decide(kA, wA, kB, wB, T, exact, R):
    sets = feasible_sets(kA, wA, kB, wB, T)
    if sets is None: return None
    key = lambda SA, SB: (tuple(sorted(SA)), tuple(sorted(SB)))
    orb = {}; reps = []
    for SA, SB in sets:
        if key(SA, SB) in orb: continue
        o = {key([(x + u) % kA for x in SA], [(y + v) % kB for y in SB]) for u in range(kA) for v in range(kB)}
        idx = len(reps); reps.append((SA, SB, len(o)))
        for f in o: orb[f] = idx
    M = cp_model.CpModel(); X = [M.NewBoolVar(f"x{i}") for i in range(len(reps))]
    for i, (SA, SB, sz) in enumerate(reps):
        F = [('a', x) for x in SA] + [('b', y) for y in SB]
        if len(F) > 1:
            for drop in range(len(F)):
                G = F[:drop] + F[drop + 1:]
                g = key([x for t, x in G if t == 'a'], [y for t, y in G if t == 'b'])
                M.AddImplication(X[i], X[orb[g]])
    chi = sum((-1) ** (len(SA) + len(SB) - 1) * sz * X[i] for i, (SA, SB, sz) in enumerate(reps))
    if exact: M.Add(chi == 1)
    else:
        Q = reduce(lambda u, v: u * v, R, 1); z = M.NewIntVar(-10**9, 10**9, 'z'); M.Add(chi - 1 == Q * z)
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 60; S.parameters.num_workers = 2
    st = S.Solve(M)
    return {cp_model.OPTIMAL: 'complex', cp_model.FEASIBLE: 'complex', cp_model.INFEASIBLE: 'NONE'}.get(st, 'unknown')
if __name__ == "__main__":
    res = []; counts = {}
    for n in rows:
        T = L[n]
        for a in range(3, n // 2 + 1):
            b = n - a
            if b <= a or not (isprime(a) and isprime(b)) or min(comb(a, 2), comb(b, 2)) <= T: continue
            for dA in divisors(a - 1):
                kA, wA = cls(a, dA)
                for dB in divisors(b - 1):
                    kB, wB = cls(b, dB)
                    if kA == 1 and kB == 1: continue
                    ex, R = readings(a, dA, b, dB)
                    if not ex and not R: continue
                    r = decide(kA, wA, kB, wB, T, ex, R)
                    counts[r] = counts.get(r, 0) + 1
                    if r in ('NONE', 'unknown'):
                        res.append((r, n, T, a, dA, kA, wA, b, dB, kB, wB, ex, sorted(R))); print(res[-1], flush=True)
    with open('../outputs/ws_budget_exact.txt', 'w') as f:
        f.write(f"prime+prime configurations by exact result (None = too many sets, not decided): {counts}\n")
        for r in res: f.write(f"{r}\n")
    print(counts)
