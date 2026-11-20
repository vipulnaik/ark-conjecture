#!/usr/bin/env python3
"""fixed_points_scan.py -- do groups with fixed points ever beat the fixed-point-free maximum?  (threshold-beyond-mu.md
§6.1, the link mu*_N^fpf <= mu*_N.)

Let Gamma be an Oliver group on n points fixing a >= 1 points and moving b = n - a.
  - Gamma' = Gamma on the moved points is the same abstract group (same Oliver readings), fixed-point-free on b points,
    and N*(Gamma) restricted to the moved points lies in N*(Gamma'); so m*_N(Gamma) <= m*_N(Gamma') <= mu*_N^fpf(b).
  - The pairs inside the fixed set form types of at most C(a, 2) pairs (a >= 2); the pairs between the fixed set and
    the moved part form types of at most a*b pairs.
So m*_N(Gamma) <= min(C(a, 2) [a >= 2], a*b, mu*_N^fpf(b)).  With T = mu*_cyc(n) <= mu*_N^fpf(n), groups with a fixed
points cannot exceed mu*_N^fpf(n) unless C(a, 2) > T, a*b > T and mu*_N^fpf(b) > T.  For the last, the orbit-data bound
(fpf_upper_scan.py's credits: an orbit class (c, m), m orbits of size c merged, worth m*tau(c), tau(c) = c(q(c)-1)/2,
C(c, 2) at prime powers; Conjecture P, conjecture-p-proof.md) says mu*_N^fpf(b) <= T unless b splits into orbit classes
with distinct sizes, each worth more than T.  That is a subset-sum, done here exactly with bitsets (any number of
classes).  The trivial group (a = n) is the separate term G*(n), not treated here.
usage: python3 fixed_points_scan.py [NMAX=4000] -> ../outputs/fixed_points_scan.txt"""
import sys, csv
from math import comb
from sympy import factorint
NMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 4000
L = {int(r['n']): int(r['L_new']) for r in csv.DictReader(open('../outputs/mu_cyc_bounds_4000.csv'))}
fac = {c: factorint(c) for c in range(2, NMAX + 1)}
tau = {c: comb(c, 2) if len(fac[c]) == 1 else c * (max(p ** e for p, e in fac[c].items()) - 1) // 2 for c in range(2, NMAX + 1)}
bad = []; checked = 0
for n in sorted(L):
    if n > NMAX: break
    T = L[n]; checked += 1
    reach = 1                                   # bit s: some shape of total s with every class > T
    mask = (1 << n) - 1                         # sums < n (b <= n - 1)
    for c in range(2, n):
        ms = [m for m in range(1, (n - 1) // c + 1) if m * tau[c] > T]
        if not ms: continue
        add = 0
        for m in ms: add |= reach << (m * c)
        reach = (reach | add) & mask
    for a in range(1, n):
        b = n - a
        if b < 2: continue
        if (a >= 2 and comb(a, 2) <= T) or a * b <= T: continue
        if (reach >> b) & 1: bad.append((n, T, a, b))
with open('../outputs/fixed_points_scan.txt', 'w') as fh:
    fh.write(f"rows checked: {checked}; rows where some fixed-point configuration is not excluded: {len({x[0] for x in bad})}\n")
    for x in bad[:200]: fh.write(f"{x}\n")
print(open('../outputs/fixed_points_scan.txt').read()[:1500])
