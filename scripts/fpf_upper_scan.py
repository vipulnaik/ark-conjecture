#!/usr/bin/env python3
"""fpf_upper_scan.py -- fpf_upper.py's orbit-data bound over the whole mu*_cyc table, n <= 4000,
with tau(a) = a(q(a) - 1)/2 at every non-prime-power degree a.  That value is fact 8's bound
on m*_typ for soluble transitive groups, i.e. Conjecture P (threshold-beyond-mu.md §6.4),
checked by computation at every non-prime-power degree <= 46 but 40.  So the conclusions
here are conditional on Conjecture P.

For each n it decides whether some orbit shape has every class above T = mu*_cyc(n):
a class is (a, m), m orbits of size a merged, worth m * tau(a).  Such a shape (or the
transitive tau(n) > T) is a GAP ROW: there U_fpf > mu*_cyc and orbit data alone cannot rule
out a separation.  Elsewhere mu*_N^fpf = nu*_fpf = mu*_cyc, given Conjecture P.

With a second argument PMAX, Conjecture P is used only at degrees a <= PMAX (where it is proved, §6.3: Step 5 to
degree 1000 and the induction through Step 4), and the trivial tau(a) = C(a, 2) stands in above PMAX.

usage: python3 fpf_upper_scan.py [NMAX=4000] [PMAX]     (run from scripts/)
writes ../outputs/fpf_upper_scan.txt, or ../outputs/fpf_upper_scan_P<PMAX>.txt with PMAX
"""
import sys, csv
from math import comb
from sympy import factorint

NMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 4000
PMAX = int(sys.argv[2]) if len(sys.argv) > 2 else None
L = {int(r['n']): int(r['L_new']) for r in csv.DictReader(open('../outputs/mu_cyc_bounds_4000.csv'))}
fac = {a: factorint(a) for a in range(2, NMAX + 1)}
pp = lambda a: len(fac[a]) == 1
qn = lambda a: max(p ** e for p, e in fac[a].items())
tau = {a: comb(a, 2) if pp(a) or (PMAX is not None and a > PMAX) else a * (qn(a) - 1) // 2 for a in range(2, NMAX + 1)}

out = open('../outputs/fpf_upper_scan.txt' if PMAX is None else f'../outputs/fpf_upper_scan_P{PMAX}.txt', 'w')
gaps = 0; rows = 0
for n in sorted(L):
    if n > NMAX: break
    T = L[n]; rows += 1; wit = []
    if tau[n] > T: wit.append(('transitive', tau[n]))
    cand = [(a, m) for a in range(2, n) for m in range(1, n // a + 1) if m * tau[a] > T and m * a <= n]
    # each a appears once (all its orbits merged); shapes with >= 2 orbits in total
    by = {}
    for a, m in cand: by.setdefault(m * a, []).append((a, m))
    for a, m in cand:                      # one class
        if m * a == n and m >= 2: wit.append(((a, m),))
    for i, (a, m) in enumerate(cand):      # two classes
        for b, k in by.get(n - m * a, []):
            if b > a: wit.append(((a, m), (b, k)))
    for i, (a, m) in enumerate(cand):      # three classes
        for j, (b, k) in enumerate(cand):
            if b <= a or m * a + k * b >= n: continue
            for c, l in by.get(n - m * a - k * b, []):
                if c > b: wit.append(((a, m), (b, k), (c, l)))
    if wit:
        gaps += 1
        best = max(wit, key=lambda w: w[1] if w[0] == 'transitive' else min(m * tau[a] for a, m in w))
        out.write(f"{n} T={T} witnesses={len(wit)} e.g. {best}\n")
out.write(f"# {gaps} gap rows of {rows}\n"); out.close()
print(f"{gaps} gap rows of {rows}")
