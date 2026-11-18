#!/usr/bin/env python3
"""lemma_c_check.py -- Lemma C (Smith completeness) tested on small cyclic actions.

V_c(k) = the set of chi(Delta) over C_k-invariant complexes Delta on Z_k (k points, C_k by translation) whose
faces have at most c points (c <= k - 1, so Delta is proper; the empty complex has chi 0).
Smith prediction N_c(k): the x with, for every prime r | k, x = y (mod r) for some y in V_{floor(c/r)}(k/r)
(Delta^{C_r} is a C_{k/r}-complex on the k/r cosets of C_r, its faces unions of at most c/r cosets; V_c(1) = {0}).
Lemma C asks whether V_c(k) = N_c(k) inside V_c(k)'s range [min, max].
Exact V_c(k) by CP-SAT: min and max of chi, then feasibility of every value in between.
usage: python3 lemma_c_check.py KMIN KMAX   -> appends to ../outputs/lemma_c_check.txt"""
import sys, itertools
from functools import lru_cache
from sympy import primefactors
from ortools.sat.python import cp_model
@lru_cache(maxsize=None)
def orbits(k, c):
    seen = set(); out = []
    for r in range(1, c + 1):
        for f in itertools.combinations(range(k), r):
            if f in seen: continue
            o = {tuple(sorted((x + i) % k for x in f)) for i in range(k)}; seen |= o; out.append((r, f, len(o)))
    return out
def model(k, c):
    orbs = orbits(k, c); idx = {}
    for i, (r, f, sz) in enumerate(orbs):
        for g in {tuple(sorted((x + j) % k for x in f)) for j in range(k)}: idx[g] = i
    M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in orbs]
    for i, (r, f, sz) in enumerate(orbs):
        if r > 1:
            for g in itertools.combinations(f, r - 1): M.AddImplication(X[i], X[idx[g]])
    chi = sum((-1) ** (r - 1) * sz * X[i] for i, (r, f, sz) in enumerate(orbs))
    return M, chi
def solve(M):
    S = cp_model.CpSolver(); S.parameters.num_workers = 2; S.parameters.max_time_in_seconds = 60
    st = S.Solve(M); return st, S
@lru_cache(maxsize=None)
def V(k, c):
    c = min(c, k - 1)
    if k == 1 or c <= 0: return frozenset({0})
    M, chi = model(k, c); M.Minimize(chi); st, S = solve(M); lo = int(S.ObjectiveValue())
    M, chi = model(k, c); M.Maximize(chi); st, S = solve(M); hi = int(S.ObjectiveValue())
    out = {lo, hi, 0}
    for v in range(lo, hi + 1):
        if v in out: continue
        M, chi = model(k, c); M.Add(chi == v); st, S = solve(M)
        if st in (cp_model.OPTIMAL, cp_model.FEASIBLE): out.add(v)
        elif st != cp_model.INFEASIBLE: out.add(('?', v))
    return frozenset(out)
def N(k, c, lo, hi):
    c = min(c, k - 1); out = set()
    for x in range(lo, hi + 1):
        if all(any((x - y) % r == 0 for y in V(k // r, c // r) if not isinstance(y, tuple)) for r in primefactors(k)):
            out.add(x)
    return out
if __name__ == "__main__":
    KMIN, KMAX = int(sys.argv[1]), int(sys.argv[2])
    for k in range(KMIN, KMAX + 1):
        for c in range(1, k):
            v = V(k, c); vals = {x for x in v if not isinstance(x, tuple)}; unk = [x for x in v if isinstance(x, tuple)]
            lo, hi = min(vals), max(vals); pred = N(k, c, lo, hi)
            miss = sorted(pred - vals); extra = sorted(vals - pred)
            line = (f"k={k} c={c} range=[{lo},{hi}] |V|={len(vals)} allowed-not-realised={miss[:12]}"
                    f"{'...' if len(miss) > 12 else ''} ({len(miss)}) realised-not-allowed={extra} unknown={unk}")
            print(line, flush=True)
            with open('../outputs/lemma_c_check.txt', 'a') as f: f.write(line + '\n')
