"""Independent re-derivation of aod section 3.3.5's ceiling table.

Deliberately NOT a congruence argument: it scans real configurations of the
additive family n = F*c + r under the CORRECTED scoring (full twist at any
fusion count) and reports the empirical sup of density per residue class mod 24.
If the closed forms are right, the sup should approach them from below.
"""
import sys
from sympy import isprime
from math import comb, sqrt

NMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 60000

# prime powers and prime sieve
sieve = bytearray([1]) * (NMAX + 1); sieve[0] = sieve[1] = 0
for i in range(2, int(NMAX**.5) + 1):
    if sieve[i]: sieve[i*i::i] = bytearray(len(sieve[i*i::i]))
primes = [i for i in range(2, NMAX + 1) if sieve[i]]
ppow = []            # odd prime powers >= 3
for p in primes:
    if p == 2: continue
    v = p
    while v <= NMAX: ppow.append(v); v *= p
ppow.sort()

def best_twist(m):
    """largest prime-power divisor of m (the foreign twist t = q^e)"""
    best, mm, d = 1, m, 2
    while d * d <= mm:
        if mm % d == 0:
            pk = 1
            while mm % d == 0: mm //= d; pk *= d
            if pk > best: best = pk
        d += 1
    if mm > 1 and mm > best: best = mm
    return best

def score(n, F, c, r):
    """corrected m* for F fused c-blocks + one foreign r"""
    intra = F * (c * (c - 1) // 2)          # full twist: F*orb(c,c-1) = F*C(c,2)
    cross = (F // 2) * c * c if F % 2 == 0 else F * c * c
    t = best_twist(r - 1)
    foreign = r * t if t % 2 else r * t // 2   # odd t cannot contain -1
    inter = (F * c) * r
    return min(intra, cross, foreign, inter)

import bisect
best_by_class = {}
# sample n: all n in [NMAX//2, NMAX]
for n in range(NMAX // 2 | 1, NMAX + 1, 2):
    cls = n % 24
    bd = 0.0
    for F in (2, 4, 6, 8):
        lim = n // F
        hi = bisect.bisect_right(ppow, lim)
        for c in ppow[:hi]:
            r = n - F * c
            if r < 3 or not sieve[r]: continue
            d = score(n, F, c, r) / comb(n, 2)
            if d > bd: bd = d; bF, bc, br = F, c, r
    if bd > 0:
        cur = best_by_class.get(cls)
        if cur is None or bd > cur[0]:
            best_by_class[cls] = (bd, n, bF, bc, br)

CLOSED = {1:('3-2sqrt2',3-2*sqrt(2)), 9:('3-2sqrt2',3-2*sqrt(2)), 13:('3-2sqrt2',3-2*sqrt(2)),
          21:('3-2sqrt2',3-2*sqrt(2)), 3:('1/8',0.125), 19:('1/8',0.125),
          5:('5-2sqrt6',5-2*sqrt(6)), 17:('5-2sqrt6',5-2*sqrt(6)),
          7:('?',0.125), 15:('?',0.125), 11:('7-4sqrt3',7-4*sqrt(3)), 23:('7-4sqrt3',7-4*sqrt(3))}
print(f"n in [{NMAX//2}, {NMAX}]   (odd classes only)\n")
print(f"{'cls':>4} {'emp sup':>9} {'closed':>9} {'name':>11} {'ratio':>7}  witness")
for cls in sorted(k for k in best_by_class if k % 2):
    bd, n, F, c, r = best_by_class[cls]
    nm, cf = CLOSED.get(cls, ('-', 0))
    print(f"{cls:>4} {bd:9.5f} {cf:9.5f} {nm:>11} {bd/cf:7.4f}  n={n} F={F} c={c} r={r}"
          f" (c%8={c%8}, r%8={r%8}, t={best_twist(r-1)}, eta={2*best_twist(r-1)/(r-1):.4f})")
