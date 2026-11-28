#!/usr/bin/env python3
"""s9_k3_check.py -- is shape S9 (a fused class of F >= 2 foreign r-blocks) dominated at k = 3?

`three-uniform-note.md` §4.2 lists S9 as unchecked at k = 3.  A fused foreign class
carries diagonal translations and a common multiplier (Lemma D2's proof, which is
k-independent), so in block coordinates the group acts as (i, x) -> (s(i), a x + t).
Its least 3-set orbit is therefore at most
    F >= 3, F < r :  min(C(F,3) * r,  F * orb3(r, t))     (same-position triples)
    otherwise      :  F * orb3(r, t)                       (intra, foreign block law)
with t the twist, a q-power dividing r - 1.  A foreign class needs a matching part beside it (else
the chain prime is r and the blocks are matching), so the configuration also has
parts on the remaining m = n - F*r >= 2 points, and its score is at most U(m), the
largest single-class term available on m points (any prime power c <= m, any F,
full twist, best Galois part), capped by C(m, 3).  The configuration scores at most
min(cap, U(m)).  This script compares the largest cap available at n
(F*r <= n, best q) with b3_census(n) from mu3_menu.py and lists every n where the
cap is not strictly below it.
"""
import sys
from math import comb
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from mu3_menu import sieve_pp, best3, orb3, qpart, _prime_factors

def U(m, pp):
    if m < 3:
        return 0
    u = 0
    for c, (p, a) in pp.items():
        if c > m:
            continue
        for g in [x for x in range(1, a + 1) if a % x == 0]:
            u = max(u, (m // c) * orb3(c, c - 1, g, p, a))
    return min(u, comb(m, 3))

def s9_cap(n, spf, pp):
    best, wit = 0, ""
    for r in range(5, n // 2 + 1):
        if spf[r] != r:
            continue
        tmax = max(qpart(r - 1, q) for q in _prime_factors(r - 1, spf))
        intra1 = orb3(r, tmax, 1, r, 1)
        for F in range(2, n // r + 1):
            cap = F * intra1
            if 3 <= F < r:
                cap = min(cap, comb(F, 3) * r)
            m = n - F * r
            if m < 2:
                continue
            cap = min(cap, U(m, pp))
            if cap > best:
                best, wit = cap, f"{F}x{r}* (t={tmax})"
    return best, wit

def main():
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 2000
    spf, pp = sieve_pp(N + 1)
    primes = [x for x in range(2, N + 1) if spf[x] == x]
    bad = []
    for n in range(10, N + 1):
        if n in pp:
            continue
        b3, w3 = best3(n, spf, pp, primes)
        cap, wc = s9_cap(n, spf, pp)
        if cap >= b3:
            bad.append((n, cap, wc, b3, w3))
    print(f"n in [10, {N}], non-prime-powers: S9 cap >= b3_census at {len(bad)} n")
    for row in bad[:40]:
        print("  n=%d  S9 cap %d (%s)  vs b3_census %d (%s)" % row)
    return 0

if __name__ == "__main__":
    sys.exit(main())
