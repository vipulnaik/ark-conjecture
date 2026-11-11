#!/usr/bin/env python3
"""biclique_boost_scan.py -- the biclique location with qualifying foreign
blocks admitted (`threshold-beyond-mu.md` section 6), against the structured
s(n) of `biclique_table.py`.

s(n) keeps only groups whose minimal blocks are all 2-homogeneous.  Here a
foreign block of prime size r is also admitted when its k = C(r,2)/orb(r,t)
cyclotomic pair-orbitals form a good type for the top prime q: k = 1, or
k <= 7 with q outside the exceptional set of `cyclic_chi_values.py`, or
k in {8,...,11,13} with q > 2^k (the same rule as `threshold_scan.py`).

Shapes enumerated for the new groups: n = F*c + r only, c a prime power with
full twist, r a prime different from c's prime, gcd(F*(c-1), r) = 1 as in
`biclique_table.py`.  The value is max(s(n), largest min(c, r)), so it is a
LOWER bound for the quantity s*_N(n) of the note; nothing here bounds it above.

Usage: python3 biclique_boost_scan.py [N]     (default 10000; about a minute)
Run from scripts/; reads ../outputs/biclique_table_10000.csv.
"""
import sys, csv, statistics
from math import comb, gcd
from collections import Counter
from sympy import primerange, factorint, divisors

N = int(sys.argv[1]) if len(sys.argv) > 1 else 10000
BAD = {1: set(), 2: set(), 3: {2}, 4: {3}, 5: {2, 3}, 6: {2, 5, 7}, 7: {2, 3, 5, 13}}


def good(k, q):                       # q = None: trivial top
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


ok = {}                               # r -> (k, q), smallest qualifying k
for r in primerange(3, N):
    best = None
    for q, t in [(None, 1)] + [(q, q ** e) for q, e in factorint(r - 1).items()]:
        k = comb(r, 2) // orb(r, t)
        if good(k, q) and (best is None or k < best[0]):
            best = (k, q)
    if best:
        ok[r] = best
pp = {}
for p in primerange(2, N):
    x = p
    while x < N:
        pp[x] = p
        x *= p
old = {int(r['n']): int(r['s'])
       for r in csv.DictReader(open('../outputs/biclique_table_10000.csv'))
       if int(r['n']) <= N}
new = {}
for n in old:
    b = (old[n], None)
    for r in ok:
        m = n - r
        if m < 2:
            break
        if r <= b[0]:
            continue
        for F in divisors(m):
            c = m // F
            if c <= b[0] or c not in pp or pp[c] == r or gcd(F * (c - 1), r) != 1:
                continue
            b = (min(c, r), (F, c, r) + ok[r])
    new[n] = b

imp = [n for n in old if new[n][0] > old[n]]
print("rows improved:", len(imp), "of", len(old))
print("k of the admitted block at improved rows:", dict(sorted(Counter(new[n][1][3] for n in imp).items())))
for lo, hi in ((6, 1000), (1000, N), (N // 2, N)):
    o = min((old[n] / n, n) for n in old if lo <= n <= hi)
    w = min((new[n][0] / n, n, new[n][1]) for n in old if lo <= n <= hi)
    print("[%d, %d]  min s/n: %.4f at n = %d   boosted: %.4f at n = %d %s" % (lo, hi, o[0], o[1], w[0], w[1], w[2]))
print("upper half, by class mod 12 (median old, median boosted, min old, min boosted):")
for cl in range(12):
    ns = [n for n in old if n % 12 == cl and n >= N // 2]
    print("  %2d  %.3f  %.3f  %.3f  %.3f" % (cl, statistics.median(old[n] / n for n in ns),
          statistics.median(new[n][0] / n for n in ns), min(old[n] / n for n in ns), min(new[n][0] / n for n in ns)))
for n in (2759,):
    if n in new:
        print(n, old[n], new[n])
