#!/usr/bin/env python3
"""cyc_floor_scan.py -- the floor of mu*_cyc(n)/C(n,2) on a long range
(`threshold-beyond-mu.md` section 5).

`threshold_scan.py` scores every shape at every n and is quadratic.  A floor
needs less: a row whose mu* is already THR*C(n,2) or more cannot lower a floor
below THR, so only rows with mu*(n) < THR*C(n,2) are examined, and for each the
shapes n = F*c + r with F in FS, vectorised over the prime powers c.

What is computed is a LOWER bound for mu*_cyc(n) at each examined row:
  - shapes n = F*c + r only (one foreign prime r, rescored at C(r,2) when its
    index is good), F in FS, gcd(F*(c-1), r) = 1;
  - c is taken in the window  n*sqrt(D0/F) <= c <= n*(1 - sqrt(D0))/F,  outside
    which the shape is worth less than D0*n^2/2 (`aod` section 6.1); D0 = 0.078,
    so the result is the best of the family whenever it is at least that.
The entangled shape of section 5 is not scored.

Usage: python3 cyc_floor_scan.py [N=100000] [THR=0.12] [out.csv]
       (run from scripts/; 15 s at 10^5 with THR 0.12, about 5 min at 10^6 with
        THR 0.11; reads ../outputs/mu_table_ladder.csv)
If ../outputs/threshold_scan_4000.csv is present the rows it shares are compared.
A decade's minimum is printed as exact (for this lower bound) when it is below
THR, and as ">= THR" otherwise.
"""
import csv, os, sys, time
from math import comb
import numpy as np
from sympy import primerange, factorint

N = int(sys.argv[1]) if len(sys.argv) > 1 else 100000
THR = float(sys.argv[2]) if len(sys.argv) > 2 else 0.12
OUT = sys.argv[3] if len(sys.argv) > 3 else None
FS = (1, 2, 3, 4, 5, 6, 8)
D0 = 0.078
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


t0 = time.time()
cap = np.zeros(N + 1, dtype=np.int64)  # capacity of a foreign prime r, rescored where its index is good
for r in primerange(3, N):
    best = orb(r, 1)
    if good(comb(r, 2) // best, None):
        best = comb(r, 2)
    for q, e in factorint(r - 1).items():
        o = orb(r, q ** e)
        best = max(best, comb(r, 2) if good(comb(r, 2) // o, q) else o)
    cap[r] = best
pp, pch = [], []
for p in primerange(2, N):
    x = p
    while x < N:
        pp.append(x); pch.append(p); x *= p
o = np.argsort(pp); pp = np.array(pp, dtype=np.int64)[o]; pch = np.array(pch, dtype=np.int64)[o]
rows = [(int(r['n']), int(r['mu_bound'])) for r in csv.DictReader(open('../outputs/mu_table_ladder.csv'))
        if int(r['n']) <= N]
res = {}
for n, T in rows:
    C = n * (n - 1) // 2
    if T >= THR * C:
        continue
    best, w = T, None
    for F in FS:
        lo = np.searchsorted(pp, int(n * (D0 / F) ** 0.5))
        hi = np.searchsorted(pp, min((n - 3) // F, int(n * (1 - D0 ** 0.5) / F) + 1), side='right')
        cs = pp[lo:hi]
        if not len(cs):
            continue
        r = n - F * cs
        m = (r > 2) & (cap[np.maximum(r, 0)] > 0) & (pch[lo:hi] != r) & (np.gcd(F * (cs - 1), np.maximum(r, 1)) == 1)
        if not m.any():
            continue
        c, rr = cs[m], r[m]
        v = np.minimum(np.minimum(F * c * (c - 1) // 2, F * c * rr), cap[rr])
        if F > 1:
            v = np.minimum(v, (F if F % 2 else F // 2) * c * c)
        i = int(v.argmax())
        if int(v[i]) > best:
            best, w = int(v[i]), (F, int(c[i]), int(rr[i]))
    res[n] = (T, best, w)
print(f"N = {N}, THR = {THR}: {len(res)} of {len(rows)} rows examined (mu* below THR*C(n,2)); "
      f"{sum(1 for x in res.values() if x[2])} lifted; {round(time.time() - t0)} s")
dens = lambda n, v: v / (n * (n - 1) // 2)
low = sorted(res, key=lambda n: dens(n, res[n][1]))
print("lowest rows (n, mu*/C, lower bound for mu*_cyc/C, shape F c r):")
for n in low[:8]:
    T, b, w = res[n]
    print(f"   {n:>7}  {dens(n, T):.5f}  {dens(n, b):.5f}  {w if w else 'not lifted'}")
allT = dict(rows)
print("by decade:  range | min mu*/C at n | min of the lower bound for mu*_cyc/C at n")
lo = 6
while lo < N:
    hi = min(lo * 10 if lo > 6 else 100, N + 1)
    inT = [n for n in allT if lo <= n < hi]
    if inT:
        a = min(inT, key=lambda n: dens(n, allT[n]))
        ex = [n for n in res if lo <= n < hi]
        b = min(ex, key=lambda n: dens(n, res[n][1])) if ex else None
        if b is not None and dens(b, res[b][1]) < THR:
            cyc = f"{dens(b, res[b][1]):.5f} at {b}"
        else:
            cyc = f">= {THR}"
        print(f"   [{lo}, {hi - 1}]  {dens(a, allT[a]):.5f} at {a}  |  {cyc}")
    lo = hi
ref = '../outputs/threshold_scan_4000.csv'
if os.path.exists(ref):
    eq = lower = higher = 0
    for r in csv.DictReader(open(ref)):
        n = int(r['n'])
        if n in res:
            d = res[n][1] - int(r['cyc_lower'])
            eq += d == 0; lower += d < 0; higher += d > 0
    print(f"against threshold_scan_4000.csv on the shared rows: equal {eq}, lower here {lower} "
          f"(shapes not scored here), higher here {higher} (must be 0)")
    assert higher == 0
if OUT:
    with open(OUT, 'w') as fh:
        fh.write("n,mu,cyc_lower,F,c,r\n")
        for n in sorted(res):
            T, b, w = res[n]
            fh.write(f"{n},{T},{b},{'%d,%d,%d' % w if w else ',,'}\n")
