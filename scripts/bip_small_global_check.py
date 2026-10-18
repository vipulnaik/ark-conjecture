"""bip_small_global_check.py -- oen section 7.4 / pending-checks A38.3: bipartiteness at the small-global rung.
chi(Delta_bip) = 1 - B(n), B with e.g.f. sqrt(2e^x - 1).  B(n) mod p has period p - 1 (n >= 1), so
B(n) mod p = B(r) mod p with r = (n-1) mod (p-1) + 1 < p.  For every n in a range, find a prime p <= n with
p not dividing B(n) (a failing congruence, hence evasiveness by the small-global rung).  Only B up to PMAX is needed.
Usage: python3 bip_small_global_check.py NMAX [PMAX=3000] [--class240]   (--class240: only n = 2 mod 240)"""
import sys
from math import comb
from sympy import primerange
NMAX = int(sys.argv[1]); PMAX = int(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[2].isdigit() else 3000
only240 = '--class240' in sys.argv
B = [1]
for n in range(1, PMAX + 1):
    s = sum(comb(n, k) * B[k] * B[n - k] for k in range(1, n)); B.append((2 - s) // 2)
P = list(primerange(3, PMAX + 1))   # odd primes only: the period-(p-1) shortcut is FALSE at p = 2 (period 3 there)
res = {p: [B[r] % p for r in range(p)] for p in P}
ns = range(242, NMAX + 1, 240) if only240 else range(3, NMAX + 1)
fail = []; worst = 0
for n in ns:
    w = next((p for p in P if p <= n and res[p][(n - 1) % (p - 1) + 1] != 0), None)
    if w is None: fail.append(n)
    else: worst = max(worst, w)
print(f"n in {'2 mod 240, ' if only240 else ''}[3 or 242, {NMAX}]: {len(ns)} values; no witnessing prime <= {PMAX}: {len(fail)} {fail[:10]}; largest smallest-witness used: {worst}")
