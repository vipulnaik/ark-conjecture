#!/usr/bin/env python3
"""
s7_scan.py -- find the n where the S7 family beats the computed table.

S7 is the configuration class missing from `mu_enumerate.py` as of 2026-08: a
class of F blocks of size c fused by a group in the CYCLIC layer of the Oliver
chain rather than in the top q-group, together with one foreign prime r.  See
`enumeration-proof.md` Part 0.  Because the fusing group is not in the top
layer, F need not be a q-power -- only coprime to everything else the cyclic
layer carries, namely the twist c-1 and the foreign prime r.

    n = F*c + r,   c a prime power,   r prime,   F a prime power with base qF,
    qF not dividing c-1 and not equal to r,  and the foreign twist prime q != qF.

Score, in SAFE mode so it is a genuine lower bound on mu(n):

    min( F*C(c,2),  (F or F/2)*c^2,  F*c*r,  orb(r, qpart(r-1,q)) )

Output is a worklist for the repair: every n where this beats mu_bound is an n
whose table entry is known to be too low.

Usage:
    python3 s7_scan.py mu_table_safe_v2.csv --nmax 2400
    python3 s7_scan.py mu_table_safe_v2.csv --nmax 2400 --out s7_weak.txt
"""
import argparse, csv, sys
from math import comb

ap = argparse.ArgumentParser()
ap.add_argument("table")
ap.add_argument("--nmax", type=int, default=2400)
ap.add_argument("--fmax", type=int, default=25, help="largest fusion count F to try")
ap.add_argument("--out", default=None, help="write the worklist to this file")
A = ap.parse_args()

rows = {int(r["n"]): int(r["mu_bound"]) for r in csv.DictReader(open(A.table))}
N = min(A.nmax, max(rows))

spf = list(range(N + 2)); i = 2
while i * i <= N + 1:
    if spf[i] == i:
        for j in range(i * i, N + 2, i):
            if spf[j] == j: spf[j] = i
    i += 1
def pp(x):
    if x < 2: return None
    p = spf[x]; e = 0
    while x % p == 0: x //= p; e += 1
    return (p, e) if x == 1 else None
def isprime(x): return x > 1 and spf[x] == x
def pdivs(x):
    o = []
    while x > 1:
        p = spf[x]; o.append(p)
        while x % p == 0: x //= p
    return o
def qpart(x, q):
    t = 1
    while x % q == 0: x //= q; t *= q
    return t
def orb(c, t): return min(c * t // 2 if t % 2 == 0 else c * t, comb(c, 2))

PPs = [c for c in range(2, N + 1) if pp(c)]
Fs = [f for f in range(2, A.fmax + 1) if pp(f)]

worst, hits = [], 0
for n in sorted(rows):
    if n > N: break
    B = rows[n]
    best, arg = 0, None
    for F in Fs:
        qF = pp(F)[0]
        for c in PPs:
            m = F * c
            if m >= n: break
            r = n - m
            if not isprime(r): continue
            p = pp(c)[0]
            if p == r or (c - 1) % qF == 0 or r % qF == 0: continue
            for q in set(pdivs(r - 1)):
                if q == qF: continue
                v = min(F * comb(c, 2),
                        (F if qF % 2 else F // 2) * c * c,
                        m * r,
                        orb(r, qpart(r - 1, q)))
                if v > best: best, arg = v, (F, c, q, r)
    if best > B:
        hits += 1
        worst.append((n, best, B, best / B, arg))

print(f"{A.table}: scanned {len([x for x in rows if x <= N])} values to n = {N}")
print(f"S7 beats the table at {hits} of them")
if worst:
    worst.sort(key=lambda t: -t[3])
    print(f"  worst ratio {worst[0][3]:.3f} at n = {worst[0][0]}")
    print(f"  {'n':>7} {'S7':>10} {'table':>10} {'ratio':>7}   configuration")
    for n, v, B, rt, (F, c, q, r) in worst[:25]:
        print(f"  {n:>7} {v:>10} {B:>10} {rt:>7.3f}   {F} x {c} + {r}*  (twist prime {q})")
    if len(worst) > 25:
        print(f"  ... and {len(worst)-25} more")
    fus = sorted({w[4][0] for w in worst})
    odd = [w for w in worst if w[0] % 2]
    print(f"\n  fusion counts used: {fus}")
    print(f"  {len(odd)} of {len(worst)} are odd n; at odd n the parity of n = F*c + r")
    print(f"  forces c to be a power of 2, so the supply there is only O(log n).")
    if A.out:
        with open(A.out, "w") as fh:
            for n, v, B, rt, arg in sorted(worst):
                fh.write(f"{n} {v} {B} {arg[0]} {arg[1]} {arg[3]}\n")
        print(f"\n  worklist written to {A.out}")
sys.exit(1 if hits else 0)
