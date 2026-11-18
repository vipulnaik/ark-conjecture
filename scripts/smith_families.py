#!/usr/bin/env python3
"""smith_families.py -- the least face size j for the Smith bound of k blocks of a prime p
(threshold-beyond-mu.md §6.2, Propositions B and B'), computed on FAMILIES of faces.

smith_blocks.py lists the faces of the class complex (k blocks of h = (p - 1)/2 classes,
group C_h wr S_k) and so is limited to small kh.  Here a family (an orbit of faces) is a
multiset of parts, one per block it meets, each part a nonempty subset of C_h up to
translation.  With r parts, multiplicities m_c and part stabilisers s_i, its size is
    k (k - 1) ... (k - r + 1) / prod m_c!  *  prod (h / s_i),
a polynomial in k, and the list of families with at most J classes is the same for every
k >= J.  So for each J, feasibility (some invariant complex with faces of at most J classes
and chi = 1 mod p) depends only on k mod p once k >= J: one period of k decides every k.

Below budget p^2 no face holds a cross orbital, so s_Q = p * j; if no j < p works,
s_Q >= p^2 (reported as 'p^2+').

usage: python3 smith_families.py [PMAX=31] [JMAX=8] [--compare]
  for every prime 5 <= p <= PMAX and every k in 2 .. JMAX + p (p not dividing k): least j.
"""
import sys, itertools
from math import factorial, prod
from collections import Counter
from ortools.sat.python import cp_model

args = [a for a in sys.argv[1:] if not a.startswith('--')]
PMAX = int(args[0]) if args else 31
JMAX = int(args[1]) if len(args) > 1 else 8


def primes(a, b):
    return [p for p in range(a, b + 1) if all(p % d for d in range(2, int(p ** .5) + 1))]


def canon(S, h):
    return min(tuple(sorted((x + i) % h for x in S)) for i in range(h))


def stab(S, h):
    return sum(1 for i in range(h) if tuple(sorted((x + i) % h for x in S)) == S)


def families(h, J):
    parts = sorted({canon(S, h) for t in range(1, J + 1) for S in itertools.combinations(range(h), t)},
                   key=lambda S: (len(S), S))
    fams = []
    def rec(start, cur, tot):
        if cur: fams.append(tuple(cur))
        for i in range(start, len(parts)):
            if tot + len(parts[i]) <= J:
                cur.append(parts[i]); rec(i, cur, tot + len(parts[i])); cur.pop()
    rec(0, [], 0)
    return fams


def subfams(F, h):
    out = set()
    for i, P in enumerate(F):
        for x in P:
            Q = tuple(y for y in P if y != x)
            rest = list(F[:i]) + list(F[i + 1:])
            if Q: rest.append(canon(Q, h))
            if rest: out.add(tuple(sorted(rest, key=lambda S: (len(S), S))))
    return out


def size(F, k, h):
    r = len(F)
    if r > k: return 0
    fall = prod(range(k - r + 1, k + 1))
    return fall // prod(factorial(m) for m in Counter(F).values()) * prod(h // stab(P, h) for P in F)


def feasible(fams, sub, k, p, h):
    use = [F for F in fams if len(F) <= k]
    M = cp_model.CpModel(); X = {F: M.NewBoolVar('') for F in use}
    for F in use:
        for G in sub[F]:
            M.AddImplication(X[F], X[G])
    z = M.NewIntVar(-10 ** 9, 10 ** 9, '')
    M.Add(sum((1 if sum(map(len, F)) % 2 else -1) * (size(F, k, h) % p) * X[F] for F in use) == 1 + p * z)
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 120; S.parameters.num_workers = 2
    r = S.Solve(M)
    return {cp_model.OPTIMAL: True, cp_model.FEASIBLE: True, cp_model.INFEASIBLE: False}.get(r)


def least_j(k, p, cache={}):
    h = (p - 1) // 2
    for J in range(1, min(JMAX, p - 1) + 1):
        if (p, J) not in cache:
            fams = families(h, J)
            cache[(p, J)] = (fams, {F: subfams(F, h) for F in fams})
        fams, sub = cache[(p, J)]
        r = feasible(fams, sub, k, p, h)
        if r is None: return 'unknown'
        if r: return J
    return f'>{min(JMAX, p - 1)}' if JMAX < p - 1 else 'p^2+'


if __name__ == '__main__':
    if '--compare' in sys.argv:
        sys.argv = ['x']; import smith_blocks
        for k, p in [(2, 5), (2, 7), (3, 7), (4, 7), (3, 11), (4, 11), (2, 13), (5, 13), (6, 7), (8, 5)]:
            a = least_j(k, p); b = smith_blocks.least_j(k, p, min(p - 1, 6))
            print(f"compare k = {k}, p = {p}: families {a}, faces {b}", flush=True)
        sys.exit()
    print(f"least j (s_Q = p j) for k blocks of p; k = 2 .. JMAX + p covers a full period for every J <= JMAX = {JMAX}")
    for p in primes(5, PMAX):
        row = {k: least_j(k, p) for k in range(2, JMAX + p + 1) if k % p}
        vals = Counter(row.values())
        print(f"p = {p}: max j = {max((v for v in row.values() if isinstance(v, int)), default=None)}; "
              f"distribution {dict(vals)}", flush=True)
        print("   " + ", ".join(f"{k}:{v}" for k, v in row.items()), flush=True)
