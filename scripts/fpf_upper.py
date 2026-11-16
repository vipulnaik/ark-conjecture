#!/usr/bin/env python3
"""fpf_upper.py -- an upper bound U_fpf(n) for nu*_fpf(n), hence for mu*_N^fpf(n), from orbit
data alone (threshold-beyond-mu.md section 7, "Small n: no separation").

For a fixed-point-free Oliver group Gamma and an orbit O of size a, the types of Gamma inside O
are refined by the orbits of N*(Gamma^O) on pairs of O, because N*(Gamma)_O restricted to O
carries Gamma^O's orbitals to orbitals.  Gamma^O is soluble and transitive, so some type has
at most F * tau(a) pairs, F the number of orbits in O's N*-class and
    tau(a) = C(a,2)                                     if a is a prime power,
           = the largest m*_typ over soluble transitive groups of degree a  otherwise
(outputs/nstar_transitive_check.txt).  Merging the equal-size orbits into one class is the
best case, so
    nu*_fpf(n) <= U_fpf(n) = max( tau(n), max over orbit shapes with >= 2 orbits, all of
                                  size >= 2, of min over sizes a of mult(a) * tau(a) ).
Compared with mu*_cyc(n) (outputs/mu_cyc_bounds_4000.csv), which is a lower bound for
mu*_N^fpf(n): equality U_fpf = mu*_cyc decides mu*_N^fpf(n).

usage: python3 fpf_upper.py [NMAX=30]
"""
import sys, csv, re, os
from math import comb
from collections import Counter
from sympy import factorint

D = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'outputs')
NMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 30
tau = {}
for l in open(os.path.join(D, 'nstar_transitive_check.txt')):
    m = re.match(r"n=(\d+): .*max m\*_typ = (\d+)", l)
    if m: tau[int(m.group(1))] = int(m.group(2))
pp = lambda a: len(factorint(a)) == 1
T = lambda a: comb(a, 2) if pp(a) else tau.get(a)
L = {int(r['n']): int(r['L_new']) for r in csv.DictReader(open(os.path.join(D, 'mu_cyc_bounds_4000.csv')))}


def shapes(n, mx):
    if n == 0: yield []; return
    for a in range(min(n, mx), 1, -1):
        for r in shapes(n - a, a): yield [a] + r


for n in range(6, NMAX + 1):
    if pp(n): continue
    best, arg, missing = T(n), ('transitive',), set()
    if best is None: missing.add(n); best = 0
    for S in shapes(n, n - 1):
        c = Counter(S); vals = []
        for a, m in c.items():
            t = T(a)
            if t is None: missing.add(a); t = comb(a, 2)    # unknown: use the trivial bound
            vals.append(m * t)
        if min(vals) > best: best, arg = min(vals), tuple(S)
    # a missing tau(a), a < n, was replaced by the trivial bound C(a, 2), still an upper bound;
    # only a missing tau(n) (the transitive groups) leaves n undecided
    if best > L[n]: verdict = 'open'
    elif n in missing: verdict = f'undecided: tau({n}) not computed'
    else: verdict = 'mu*_N^fpf = nu*_fpf = mu*_cyc'
    print(f"n = {n}: mu*_cyc = {L[n]}, U_fpf = {best} (from {arg}); {verdict}")
