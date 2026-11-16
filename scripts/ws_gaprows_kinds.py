#!/usr/bin/env python3
"""ws_gaprows_kinds.py -- sorts the 977 gap rows of fpf_upper_scan.py (n <= 4000, given Conjecture P)
by the kinds of witness shape they have: transitive; two classes, both single prime orbits
(prime+prime); both single prime-power orbits, not both prime (pp+pp); two classes with a merged
class (m >= 2 orbits of one size); two classes with a non-prime-power orbit; three classes.
A row is settled at level 1 by ws_gapclose.py only if every witness is prime+prime.
usage: python3 ws_gaprows_kinds.py   (run from scripts/)  -> ../outputs/ws_gaprows_kinds.txt"""
import csv
from math import comb
from collections import Counter
from sympy import factorint, isprime
NMAX = 4000
L = {int(r['n']): int(r['L_new']) for r in csv.DictReader(open('../outputs/mu_cyc_bounds_4000.csv'))}
fac = {a: factorint(a) for a in range(2, NMAX + 1)}
pp = lambda a: len(fac[a]) == 1
qn = lambda a: max(p ** e for p, e in fac[a].items())
tau = {a: comb(a, 2) if pp(a) else a * (qn(a) - 1) // 2 for a in range(2, NMAX + 1)}
def kind(w):
    if w == 'transitive': return 'transitive'
    if len(w) != 2: return f'{len(w)}-class'
    if any(m > 1 for a, m in w): return '2-class merged'
    if all(isprime(a) for a, m in w): return 'prime+prime'
    if all(pp(a) for a, m in w): return 'pp+pp'
    return '2-class nonpp'
rowkind = Counter(); ex = {}; settled = []
for n in sorted(L):
    T = L[n]; wit = []
    if tau[n] > T: wit.append('transitive')
    cand = [(a, m) for a in range(2, n) for m in range(1, n // a + 1) if m * tau[a] > T and m * a <= n]
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
    if not wit: continue
    ks = frozenset(kind(w) for w in wit)
    rowkind[ks] += 1; ex.setdefault(ks, n)
    if ks == {'prime+prime'}: settled.append(n)
with open('../outputs/ws_gaprows_kinds.txt', 'w') as f:
    f.write(f"gap rows {sum(rowkind.values())}\n")
    for k, v in rowkind.most_common(): f.write(f"{v:4d}  {' / '.join(sorted(k))}   first n = {ex[k]}\n")
    f.write(f"prime+prime only ({len(settled)} rows): {settled}\n")
print(open('../outputs/ws_gaprows_kinds.txt').read()[:900])
