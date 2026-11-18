#!/usr/bin/env python3
"""gluing_check.py -- do unions of pull-backs reach every residue of chi mod k?

For C_k on Z_k with faces of at most c points:
  ALL(k, c)  = { chi(Delta) mod k : Delta any invariant complex within the cap }       (CP-SAT, one call per residue)
  PB(k, c)   = { chi(L) mod k : L = union over primes r | k of pi_r^{-1}(X_r) }, X_r any invariant complex on
               Z_{k/r} with faces of at most floor(c/r) points (or empty); pi_r^{-1}(X) = {S : S mod (k/r) in X}.
By Lemma F only the residue matters (given room), so PB = ALL means gluing by pull-back unions suffices.
chi(L) is computed by listing L's faces (k <= 12).  usage: python3 gluing_check.py KMIN KMAX"""
import sys, itertools
from functools import lru_cache
from sympy import primefactors
from ortools.sat.python import cp_model
sys.path.insert(0, '.')
from lemma_c_data import orbits, model
def all_residues(k, c):
    out = set()
    for r in range(k):
        M, psi = model(k, c); z = M.NewIntVar(-10**6, 10**6, 'z'); M.Add(psi[1] - r == k * z)
        S = cp_model.CpSolver(); S.parameters.num_workers = 2; S.parameters.max_time_in_seconds = 60
        st = S.Solve(M)
        if st in (cp_model.OPTIMAL, cp_model.FEASIBLE): out.add(r)
        elif st != cp_model.INFEASIBLE: out.add(('?', r))
    return out
@lru_cache(maxsize=None)
def all_complexes(m, c):
    """every C_m-invariant complex on Z_m with faces of at most c points, as frozensets of faces"""
    c = min(c, m - 1)
    if c <= 0: return [frozenset()]
    orbs = [[tuple(sorted((x + i) % m for x in f)) for i in range(m)] for (r, f, sz, st) in orbits(m, c)]
    orbs = [sorted(set(o)) for o in orbs]
    res = []
    def rec(i, faces):
        if i == len(orbs): res.append(frozenset(faces)); return
        rec(i + 1, faces)
        f = orbs[i][0]
        if len(f) == 1 or all(g in faces for g in itertools.combinations(f, len(f) - 1)):
            rec(i + 1, faces | set(orbs[i]))
    rec(0, frozenset())
    return res
def pullback(X, k, m):
    """faces S of Z_k with S mod m in X"""
    out = set()
    for F in X:
        fib = [x for x in range(k) if x % m in F]
        for r in range(1, len(fib) + 1):
            for S in itertools.combinations(fib, r):
                if frozenset(y % m for y in S) == frozenset(F): out.add(S)
    return out
def pb_residues(k, c):
    out = set(); ps = primefactors(k)
    choices = [all_complexes(k // r, c // r) for r in ps]
    for combo in itertools.product(*choices):
        faces = set()
        for r, X in zip(ps, combo): faces |= pullback(X, k, k // r)
        if any(len(S) > c for S in faces): continue
        out.add(sum((-1) ** (len(S) - 1) for S in faces) % k)
    return out
if __name__ == "__main__":
    for k in range(int(sys.argv[1]), int(sys.argv[2]) + 1):
        if len(primefactors(k)) == 1 and k > 1 and all(k % p == 0 for p in primefactors(k)) and False: pass
        for c in range(2, k):
            A = all_residues(k, c); P = pb_residues(k, c)
            line = f"k={k} c={c} all={sorted(x for x in A if not isinstance(x, tuple))} pullback-unions={sorted(P)} missing={sorted(set(x for x in A if not isinstance(x, tuple)) - P)}"
            print(line, flush=True)
            with open('../outputs/gluing_check.txt', 'a') as fh: fh.write(line + '\n')
