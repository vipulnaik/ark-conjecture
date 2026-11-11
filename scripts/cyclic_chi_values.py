#!/usr/bin/env python3
"""cyclic_chi_values.py -- Euler characteristics of cyclically symmetric complexes.

For the cyclic group C_k acting regularly on k points, list every value the
(unreduced) Euler characteristic takes on a C_k-invariant simplicial complex
that is not the full simplex -- the empty complex, with chi = 0, included.

Why: the k cyclotomic pair-orbitals of a foreign block are isomorphic graphs,
cycled by a multiplier, so the part of the fixed complex they span is such a
complex (`threshold-beyond-mu.md`).  If none of the listed values is 1 modulo
the top prime q, Oliver's congruence fails and the property is evasive.

  python3 cyclic_chi_values.py            exact value sets for k = 2..7
  python3 cyclic_chi_values.py --sat 13   also: is chi = 1 attainable, k = 8..13
                                          (CP-SAT; needs ortools)

Output of 2026-11-10: chi = 1 is attainable at k = 12 and at no other k <= 13.
"""
import sys

def orbits(k):
    seen = {}; orbs = []
    for m in range(1, 1 << k):
        if m in seen: continue
        O = set(); x = m
        for _ in range(k):
            x = ((x << 1) | (x >> (k - 1))) & ((1 << k) - 1); O.add(x)
        for y in O: seen[y] = len(orbs)
        orbs.append((min(O), len(O)))
    return seen, orbs

def sign(rep): return 1 if bin(rep).count("1") % 2 else -1

def chi_values(k):
    """All chi, by enumerating the invariant down-sets of the orbit poset."""
    seen, orbs = orbits(k); n = len(orbs); full = seen[(1 << k) - 1]
    below = [set() for _ in range(n)]
    for i, (rep, _) in enumerate(orbs):
        for b in range(k):
            if rep >> b & 1 and rep ^ (1 << b): below[i].add(seen[rep ^ (1 << b)])
    order = sorted(range(n), key=lambda i: bin(orbs[i][0]).count("1"))
    vals = set(); count = [0]
    def rec(j, inn, chi):
        if j == n:
            vals.add(chi); count[0] += 1; return
        i = order[j]; rec(j + 1, inn, chi)
        if i != full and below[i] <= inn:
            rec(j + 1, inn | {i}, chi + sign(orbs[i][0]) * orbs[i][1])
    rec(0, frozenset(), 0)
    return count[0], sorted(vals)

def attainable(k, target=1):
    from ortools.sat.python import cp_model
    seen, orbs = orbits(k)
    M = cp_model.CpModel(); X = [M.NewBoolVar(f"x{i}") for i in range(len(orbs))]
    M.Add(X[seen[(1 << k) - 1]] == 0)
    for i, (rep, _) in enumerate(orbs):
        for b in range(k):
            if rep >> b & 1 and rep ^ (1 << b): M.AddImplication(X[i], X[seen[rep ^ (1 << b)]])
    M.Add(sum(sign(rep) * sz * X[i] for i, (rep, sz) in enumerate(orbs)) == target)
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 300
    r = S.Solve(M)
    return True if r in (cp_model.OPTIMAL, cp_model.FEASIBLE) else (False if r == cp_model.INFEASIBLE else None)

def prime_factors(x):
    x = abs(x); out = set(); d = 2
    while d * d <= x:
        while x % d == 0: out.add(d); x //= d
        d += 1
    if x > 1: out.add(x)
    return out

if __name__ == "__main__":
    for k in range(2, 8):
        cnt, v = chi_values(k)
        bad = sorted(set().union(*[prime_factors(x - 1) for x in v if x != 1]))
        print(f"k = {k}: {cnt} invariant proper complexes; chi in {v}; "
              f"chi = 1 (mod q) possible only for q in {bad}")
    if "--sat" in sys.argv:
        K = int(sys.argv[sys.argv.index("--sat") + 1])
        for k in range(8, K + 1):
            print(f"k = {k}: chi = 1 attainable: {attainable(k)}")
