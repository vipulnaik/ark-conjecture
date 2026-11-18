#!/usr/bin/env python3
"""lemma_c_data.py -- Lemma C with full fixed-point data (Lefschetz / Burnside), small cyclic actions.

For a C_k-invariant complex Delta on Z_k with faces of at most c points, its data vector is
psi(f) = chi(Delta^{C_f}) for f | k (C_f the subgroup of order f; a C_f-invariant face F is a cell of
dimension |F|/f - 1; psi(k) = 0 since Z_k itself is not a face).
Necessary conditions ("predicted" data):
  (R) for each prime r | k, (psi(r e))_{e | k/r} is the data vector of a realised complex on k/r points, faces
      of at most floor(c/r) points (Delta^{C_r} on the cosets of C_r);
  (B) sum_{f | k} mu(f) psi(f) = 0 (mod k)  (the e = 1 Burnside congruence; e > 1 lives inside (R)).
Lemma C (data form): every predicted data vector with psi(1) inside the realised range is realised.
Realised data: CP-SAT feasibility of each predicted vector.  usage: python3 lemma_c_data.py KMIN KMAX"""
import sys, itertools
from functools import lru_cache
from sympy import primefactors, divisors, mobius
from ortools.sat.python import cp_model
@lru_cache(maxsize=None)
def orbits(k, c):
    seen = set(); out = []
    for r in range(1, c + 1):
        for f in itertools.combinations(range(k), r):
            if f in seen: continue
            o = {tuple(sorted((x + i) % k for x in f)) for i in range(k)}; seen |= o
            stab = k // len(o)
            out.append((r, f, len(o), stab))
    return out
def model(k, c):
    orbs = orbits(k, c); idx = {}
    for i, (r, f, sz, st) in enumerate(orbs):
        for g in {tuple(sorted((x + j) % k for x in f)) for j in range(k)}: idx[g] = i
    M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in orbs]
    for i, (r, f, sz, st) in enumerate(orbs):
        if r > 1:
            for g in itertools.combinations(f, r - 1): M.AddImplication(X[i], X[idx[g]])
    psi = {}
    for fdeg in divisors(k):
        psi[fdeg] = sum((-1) ** (r // fdeg - 1) * sz * X[i] for i, (r, f, sz, st) in enumerate(orbs) if st % fdeg == 0)
    return M, psi
def feasible(k, c, vec):
    M, psi = model(k, c)
    for fdeg, v in vec.items(): M.Add(psi[fdeg] == v)
    S = cp_model.CpSolver(); S.parameters.num_workers = 2; S.parameters.max_time_in_seconds = 60
    st = S.Solve(M)
    return {cp_model.OPTIMAL: True, cp_model.FEASIBLE: True, cp_model.INFEASIBLE: False}.get(st, None)
def chi_range(k, c):
    out = []
    for sense in (1, -1):
        M, psi = model(k, c); M.Minimize(sense * psi[1])
        S = cp_model.CpSolver(); S.parameters.num_workers = 2; S.Solve(M); out.append(sense * int(S.ObjectiveValue()))
    return out
@lru_cache(maxsize=None)
def D(k, c):
    """(realised data vectors, predicted-but-not-realised, undecided), vectors as tuples over divisors(k)"""
    c = min(c, k - 1); divs = divisors(k)
    if k == 1 or c <= 0: return (frozenset({tuple(0 for _ in divs)}), frozenset(), frozenset())
    lo, hi = chi_range(k, c)
    # combine the prime restrictions
    cands = [{k: 0}]
    for r in primefactors(k):
        sub = D(k // r, c // r)[0]; sdivs = divisors(k // r); new = []
        for cd in cands:
            for v in sub:
                m = {r * e: x for e, x in zip(sdivs, v)}
                if all(cd.get(f, x) == x for f, x in m.items()):
                    d = dict(cd); d.update(m); new.append(d)
        cands = new
    real, miss, und = set(), set(), set()
    for cd in cands:
        s = sum(mobius(f) * cd[f] for f in divs if f > 1)
        x0 = (-s) % k
        for x in range(lo + ((x0 - lo) % k), hi + 1, k):
            vec = dict(cd); vec[1] = x; t = tuple(vec[f] for f in divs)
            r_ = feasible(k, c, vec)
            (real if r_ else (miss if r_ is False else und)).add(t)
    return (frozenset(real), frozenset(miss), frozenset(und))
if __name__ == "__main__":
    KMIN, KMAX = int(sys.argv[1]), int(sys.argv[2])
    for k in range(KMIN, KMAX + 1):
        for c in range(1, k):
            real, miss, und = D(k, c)
            chis = sorted({t[0] for t in real}); mchis = sorted({t[0] for t in miss} - set(chis))
            line = (f"k={k} c={c} divisors={divisors(k)} realised vectors {len(real)}, predicted-not-realised {len(miss)}"
                    f" (chi values never realised: {mchis[:10]}{'...' if len(mchis) > 10 else ''}), undecided {len(und)}")
            if miss: line += f"  e.g. {sorted(miss)[:3]}"
            print(line, flush=True)
            with open('../outputs/lemma_c_data.txt', 'a') as fh: fh.write(line + '\n')
