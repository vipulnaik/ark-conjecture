#!/usr/bin/env python3
"""room_check.py -- the hypotheses of Theorem G + Lemmas F, R (threshold-beyond-mu.md §6.5) for the regular
prime blocks of the pp+pp gap rows (Gamma_Y = Z_P, k = (P - 1)/2 classes of P edges each), with the budget.

Cap: c = floor(T / P) classes per face.  For k = p^a q_1 ... q_s (q_i exactly dividing k):
  (G0) a complex Y on Z_{k/p} within cap floor(c/p) with chi(Y) = 1 (mod p^a)  [skipped when a = 0];
       searched among layered complexes (full skeleta below s plus chosen orbits of s-sets; chi values exact);
  (G1) for each q_i: c >= 2 q_i, and Z_{k/q_i} has at least q_i - 1 + E free edge orbits, where E bounds the free
       edge orbits already in Delta'^{C_q} (Delta' = pull-back of Y; E = free edge orbits of Y^{C_q} pulled back,
       bounded here by all of them when Y has edges) -- the room of Lemma G with edge moves;
  (R)  c >= 3 (Lemma R; its window is about +-k^2/6 around a chi of size O(k)).
usage: python3 room_check.py  -> ../outputs/room_check.txt"""
import csv, itertools
from math import comb
from sympy import factorint, isprime
L = {int(r['n']): int(r['L_new']) for r in csv.DictReader(open('../outputs/mu_cyc_bounds_4000.csv'))}
rows = [int(l.split()[0]) for l in open('../outputs/fpf_upper_scan.txt') if l[0].isdigit()]
OPEN_ROWS = [368, 442, 455, 609, 650, 714, 973, 1808, 1845, 1880, 1890, 1902, 1908, 1928, 1943, 1953, 1965, 1971,
             1991, 2085, 2175, 2205, 2255, 2778, 3348, 3464, 3632, 3655, 3715]
pp = lambda x: len(factorint(x)) == 1
from ws_budget_scan import orbit_counts
def y_residue(m, cap, pa, smax=6):
    """smallest s (number of points in the largest faces) of a layered complex on Z_m within cap with chi = 1 mod pa:
    chi = base + (-1)^(s-1) t, t a sum of C_m-orbit sizes of s-sets (each orbit at most once); None if none"""
    for s in range(1, min(cap, m - 1, smax) + 1):
        base = sum((-1) ** (r - 1) * comb(m, r) for r in range(1, s)); sg = (-1) ** (s - 1)
        reach = {0}
        for d, cnt in orbit_counts(m, s):
            for _ in range(min(cnt, pa)):
                new = {(x + d) % pa for x in reach}
                if new <= reach: break
                reach |= new
        if any((base + sg * t - 1) % pa == 0 for t in reach): return s
    return None
res = []
for n in OPEN_ROWS:
    T = L[n]
    for a in range(2, n // 2 + 1):
        b = n - a
        if b <= a or not (pp(a) and pp(b)) or (isprime(a) and isprime(b)) or min(comb(a, 2), comb(b, 2)) <= T: continue
        for P in (a, b):
            if not isprime(P): continue
            k = (P - 1) // 2; c = T // P; f = factorint(k)
            rep = [p for p, e in f.items() if e >= 2]; qs = [q for q, e in f.items() if e == 1]
            ok = True; notes = []
            if len(rep) > 1: ok = False; notes.append('two repeated primes')
            Yedges = False
            if rep:
                p = rep[0]; pa = p ** f[p]; m = k // p
                sY = y_residue(m, c // p, pa)
                if sY is None: ok = False; notes.append(f'G0: no layered Y on Z_{m} (cap {c // p}) with chi = 1 mod {pa}')
                else:
                    Yedges = sY >= 2; notes.append(f'G0: Y on Z_{m} with faces of at most {sY} points')
            for q in qs:
                mq = k // q; free_edges = (mq - 1) // 2
                E = free_edges if Yedges else 0
                if c < 2 * q: ok = False; notes.append(f'G1: cap {c} < 2*{q}')
                if free_edges - E < q - 1 and not (Yedges and free_edges >= q - 1):
                    ok = False; notes.append(f'G1: Z_{mq} has {free_edges} free edge orbits, need {q - 1} beyond {E}')
            if c < 3: ok = False; notes.append('R: cap < 3')
            res.append((n, T, P, k, c, dict(f), ok, notes))
with open('../outputs/room_check.txt', 'w') as fh:
    fh.write(f"regular prime blocks of the 29 formerly-open pp+pp rows: {len(res)}; hypotheses met: {sum(r[6] for r in res)}\n")
    for r in res: fh.write(f"{r}\n")
print(open('../outputs/room_check.txt').read()[:4000])
