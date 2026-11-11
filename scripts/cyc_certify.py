#!/usr/bin/env python3
"""cyc_certify.py -- an upper bound for mu*_cyc(n), against the lower bound of
`threshold_scan.py` (`threshold-beyond-mu.md` section 5).

mu*_cyc(n) is the largest M of the Proposition over Oliver groups on [n] and at
most one orbit R of prime size r: M = min(C(r,2), least orbital outside R's own
pairs), or the group's smallest orbital if no orbit is used.

UPPER BOUND.  The orbitals inside the complement of R are those of the image
group there, an Oliver group on m = n - r points, so the least of them is at
most mu*(m); a cross orbital is at most r*m (r, if m = 1).  Hence

    mu*_cyc(n) <= U(n) = max( mu*(n), max_r min(C(r,2), r*m, mu*(m)) ).

U takes every prime r.  U_for restricts to r that can qualify as a FOREIGN
block (r not the group's prime p): there the induced group is Z/r : C_t with t
a power of the top prime q, or trivial, and k = C(r,2)/orb(r,t) must be good.
U_for bounds the foreign reading only; a block of the group's own prime with a
partial twist is bounded by U alone.

Usage: python3 cyc_certify.py        (run from scripts/, after
       python3 threshold_scan.py 4000 ../outputs/threshold_scan_4000.csv)
"""
import csv
from math import comb
from sympy import primerange, factorint

BAD = {1: set(), 2: set(), 3: {2}, 4: {3}, 5: {2, 3}, 6: {2, 5, 7}, 7: {2, 3, 5, 13}}


def good(k, q):
    if k == 1:
        return True
    if k in BAD:
        return q is None or q not in BAD[k]
    if k in (8, 9, 10, 11, 13):
        return q is None or q > 2 ** k
    return False


def orb(r, t):
    raw = r * t // 2 if t % 2 == 0 else r * t
    return min(raw, comb(r, 2))


rows = list(csv.DictReader(open('../outputs/threshold_scan_4000.csv')))
N = max(int(r['n']) for r in rows)
L = {int(r['n']): int(r['cyc_lower']) for r in rows}
T = {int(r['n']): int(r['mu_bound'])
     for r in csv.DictReader(open('../outputs/mu_table_ladder.csv')) if int(r['n']) <= N}
assert all(int(r['mu']) == T[int(r['n'])] for r in rows)


def mu(m):                        # m >= 2; absent from the table = prime power
    return T[m] if m in T else comb(m, 2)


def foreign_ok(r):
    c = [(None, 1)] + [(q, q ** j) for q, e in factorint(r - 1).items() for j in range(1, e + 1)]
    return any(comb(r, 2) // orb(r, t) > 1 and good(comb(r, 2) // orb(r, t), q) for q, t in c)


FOK = {r: foreign_ok(r) for r in primerange(3, N)}
U, UF = {}, {}
for n in L:
    u = uf = T[n]
    for r in FOK:
        m = n - r
        if m < 1:
            break
        v = min(comb(r, 2), r * m, mu(m) if m >= 2 else r)
        u = max(u, v)
        if FOK[r]:
            uf = max(uf, v)
    U[n], UF[n] = u, uf
assert all(L[n] <= UF[n] <= U[n] for n in L)
ex = [n for n in L if L[n] == U[n]]
exf = [n for n in L if L[n] == UF[n]]
imp = [n for n in L if L[n] > T[n]]
print("rows:", len(L), " improved over mu*:", len(imp), " first:", imp[:10])
print("exact, every reading (L = U):", len(ex), "  of the improved rows:", sum(n in set(ex) for n in imp))
print("exact, foreign reading (L = U_for):", len(exf), "  not:", [(n, L[n], UF[n]) for n in L if L[n] < UF[n]])
print("no gain possible (U = mu*):", sum(U[n] == T[n] for n in L),
      "; every n <= 55:", all(U[n] == T[n] for n in L if n <= 55))
print("first rows with L < U:", [(n, L[n], U[n]) for n in L if L[n] < U[n]][:8])
