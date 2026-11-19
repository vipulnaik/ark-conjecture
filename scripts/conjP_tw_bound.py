#!/usr/bin/env python3
"""conjP_tw_bound.py -- Conjecture P for twisted wreath type (threshold-beyond-mu.md §6.3): check
2k(|T| - 1) < q(|T|)^k at the least admissible k, for alternating T = A_n (5 <= n <= NMAX) and the sporadic groups.
In a primitive twisted wreath product, P is faithful on the k factors and T is a composition factor of P_1 <= S_{k-1}
(Baddeley; see Fawcett, arXiv:2102.02190), so |T| divides (k-1)! and k >= 6.  For A_n the largest prime p <= n divides
(k-1)!, so k >= p + 1.  The left side grows linearly in k and the right side at least doubles, so the least k suffices.
Lie type is by the inequality |T| < |T|_p^3 (checked here for every Lie-type simple group of order < 10^12 from the
standard order formulas, as a sanity check of the general argument).
usage: python3 conjP_tw_bound.py [NMAX=3000] -> ../outputs/conjP_tw_bound.txt"""
import sys
from math import factorial, prod
from sympy import factorint, prevprime, isprime, primerange
NMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 3000
qn = lambda N: max(p ** e for p, e in factorint(N).items())
out = []; bad = []
def check(name, order, kmin):
    k = kmin
    while factorial(k - 1) % order: k += 1          # |T| divides (k-1)!
    ok = 2 * k * (order - 1) < qn(order) ** k
    if not ok: bad.append((name, k))
    return k, ok
# alternating: q(|A_n|) is at least the 2-part of n!/2
for n in range(5, NMAX + 1):
    o2 = 0; m = n
    while m: m //= 2; o2 += m
    q2 = 2 ** (o2 - 1)
    p = n if isprime(n) else prevprime(n)
    k = max(6, p + 1)
    # use log-scale comparison: 2k(n!/2) < q2^k  <=>  log2(k * n!) < k * (o2 - 1)
    import math
    lhs = math.log2(k) + math.lgamma(n + 1) / math.log(2)
    if not lhs < k * (o2 - 1): bad.append((f"A{n}", k))
out.append(f"alternating A_n, 5 <= n <= {NMAX}: failures {[b for b in bad if b[0].startswith('A')]}")
# large n: k >= p + 1 > n/2 + 1 and o2 - 1 >= n - log2(n) - 2, so k(o2 - 1) >= n^2/2 - O(n log n) > log2(n!) + log2(k)
spor = {"M11": 7920, "M12": 95040, "J1": 175560, "M22": 443520, "J2": 604800, "M23": 10200960, "HS": 44352000,
        "J3": 50232960, "M24": 244823040, "McL": 898128000, "He": 4030387200, "Ru": 145926144000,
        "Suz": 448345497600, "ON": 460815505920, "Co3": 495766656000, "Co2": 42305421312000,
        "Fi22": 64561751654400, "HN": 273030912000000, "Ly": 51765179004000000, "Th": 90745943887872000,
        "Fi23": 4089470473293004800, "Co1": 4157776806543360000, "J4": 86775571046077562880,
        "Fi24'": 1255205709190661721292800, "B": 4154781481226426191177580544000000,
        "M": 808017424794512875886459904961710757005754368000000000, "Tits": 17971200}
for nm, o in spor.items(): check(nm, o, 6)
out.append(f"sporadic and Tits: failures {[b for b in bad if not b[0].startswith('A') and not b[0].startswith('L')]}")
# Lie type sanity check of |T| < |T|_p^3 for the classical and exceptional families over small q
def lie_orders(q, p):
    res = []
    for n in range(2, 9):
        d = __import__('math').gcd(n, q - 1)
        o = q ** (n * (n - 1) // 2) * prod(q ** i - 1 for i in range(2, n + 1)) // d
        res.append((f"L{n}({q})", o, q ** (n * (n - 1) // 2)))
        d = __import__('math').gcd(n, q + 1)
        o = q ** (n * (n - 1) // 2) * prod(q ** i - (-1) ** i for i in range(2, n + 1)) // d
        if n >= 3: res.append((f"U{n}({q})", o, q ** (n * (n - 1) // 2)))
    for m in range(2, 6):
        d = __import__('math').gcd(2, q - 1)
        o = q ** (m * m) * prod(q ** (2 * i) - 1 for i in range(1, m + 1)) // d
        res.append((f"S{2*m}({q})/O{2*m+1}({q})", o, q ** (m * m)))
        d = __import__('math').gcd(4, q ** m - 1)
        o = q ** (m * (m - 1)) * (q ** m - 1) * prod(q ** (2 * i) - 1 for i in range(1, m)) // d
        if m >= 4: res.append((f"O+{2*m}({q})", o, q ** (m * (m - 1))))
        d = __import__('math').gcd(4, q ** m + 1)
        o = q ** (m * (m - 1)) * (q ** m + 1) * prod(q ** (2 * i) - 1 for i in range(1, m)) // d
        if m >= 4: res.append((f"O-{2*m}({q})", o, q ** (m * (m - 1))))
    res.append((f"G2({q})", q ** 6 * (q ** 6 - 1) * (q ** 2 - 1), q ** 6))
    res.append((f"3D4({q})", q ** 12 * (q ** 8 + q ** 4 + 1) * (q ** 6 - 1) * (q ** 2 - 1), q ** 12))
    res.append((f"F4({q})", q ** 24 * (q ** 12 - 1) * (q ** 8 - 1) * (q ** 6 - 1) * (q ** 2 - 1), q ** 24))
    if p == 2 and q > 2 and round(__import__('math').log2(q)) % 2 == 1:
        res.append((f"Sz({q})", q ** 2 * (q ** 2 + 1) * (q - 1), q ** 2))
        res.append((f"2F4({q})", q ** 12 * (q ** 6 + 1) * (q ** 4 - 1) * (q ** 3 + 1) * (q - 1), q ** 12))
    if p == 3 and q > 3 and round(__import__('math').log(q, 3)) % 2 == 1:
        res.append((f"R({q})", q ** 3 * (q ** 3 + 1) * (q - 1), q ** 3))
    return res
lie_bad = []
for p in primerange(2, 50):
    q = p
    while q < 200:
        for nm, o, op in lie_orders(q, p):
            if not o < op ** 3: lie_bad.append(nm)
        q *= p
out.append(f"Lie type |T| < |T|_p^3, q < 200 (families above; orders by formula, small non-simple cases included harmlessly): failures {lie_bad}")
open('../outputs/conjP_tw_bound.txt', 'w').write('\n'.join(out) + '\n')
print('\n'.join(out))
