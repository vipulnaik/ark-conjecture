#!/usr/bin/env python3
"""merged_rows_scan.py -- the 496 gap rows whose witnesses include a merged class or a non-prime-power orbit
(threshold-beyond-mu.md §6.4), first pass.

For every such row and every witness with a prime orbit r that is too large to fit (C(r,2) > T), and every twist
d | r - 1 on that orbit (k = (r-1)/c classes of r c/2 edges, c = d or 2d), test whether chi = 1 is realisable on the
r-orbit's classes within the cap floor(T / w) (roomy_close.chi1_ok: pure pieces, digits, Lemma S, then Lemma R).
chi = 1 meets every reading, and the complex uses only that orbit's classes, so the configuration closes whatever the
rest of the group is (N* acting on a prime orbit's classes as C_k, as throughout section 6).
What remains: witnesses without such an orbit, and twists where chi = 1 fails (k a prime power, k = 1 above all).
usage: python3 merged_rows_scan.py -> ../outputs/merged_rows_scan.txt"""
import csv, sys, io, contextlib
from math import comb
from collections import Counter
from sympy import factorint, isprime, divisors
sys.argv = ['x']
with contextlib.redirect_stdout(io.StringIO()):
    from roomy_close import chi1_ok
L = {int(r['n']): int(r['L_new']) for r in csv.DictReader(open('../outputs/mu_cyc_bounds_4000.csv'))}
pp = lambda a: len(factorint(a)) == 1
qn = lambda a: max(p ** e for p, e in factorint(a).items())
tau = lambda a: comb(a, 2) if pp(a) else a * (qn(a) - 1) // 2
def witnesses(n, T):
    wit = []
    cand = [(a, m) for a in range(2, n) for m in range(1, n // a + 1) if m * tau(a) > T and m * a <= n]
    by = {}
    for a, m in cand: by.setdefault(m * a, []).append((a, m))
    for a, m in cand:
        if m * a == n and m >= 2: wit.append(((a, m),))
    for a, m in cand:
        for b, k in by.get(n - m * a, []):
            if b > a: wit.append(((a, m), (b, k)))
    for a, m in cand:
        for b, k in cand:
            if b <= a or m * a + k * b >= n: continue
            for c, l in by.get(n - m * a - k * b, []):
                if c > b: wit.append(((a, m), (b, k), (c, l)))
    return wit
simple = lambda w: len(w) == 2 and all(m == 1 and pp(a) for a, m in w)
cache = {}
def ok(k, cap):
    if (k, cap) not in cache: cache[(k, cap)] = chi1_ok(k, cap)[0] if k > 1 else False
    return cache[(k, cap)]
res = Counter(); residual = []
for n in sorted(L):
    T = L[n]; W = witnesses(n, T)
    if not W or all(simple(w) for w in W): continue
    for w in W:
        if simple(w): continue
        rs = [a for a, m in w if m == 1 and isprime(a) and comb(a, 2) > T]
        if not rs: res['no large prime orbit'] += 1; residual.append((n, T, w, 'no large prime orbit')); continue
        r = max(rs); bad = []
        for d in divisors(r - 1):
            c = d if d % 2 == 0 else 2 * d
            k = (r - 1) // c; wgt = r * c // 2
            if not ok(k, min(T // wgt, k - 1)): bad.append((d, k))
        if not bad: res['closed: chi = 1 on the prime orbit, every twist'] += 1
        else:
            res['twists left'] += 1; residual.append((n, T, w, r, bad))
with open('../outputs/merged_rows_scan.txt', 'w') as fh:
    fh.write(f"{dict(res)}\n")
    for x in residual: fh.write(f"{x}\n")
print(dict(res)); print(residual[:8])
