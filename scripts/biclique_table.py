#!/usr/bin/env python3
"""
biclique_table.py -- the largest s(n) such that some Oliver group on [n] has a
complete bipartite K_{a,b} inside EVERY orbital for all a + b <= s(n).

WHY ONE NUMBER.  `orbital-evasiveness-notes.md` (the biclique box) proves, modulo
Part 0, that for a group whose minimal blocks are all 2-homogeneous the set of
(a, b) with K_{a,b} in every orbital is exactly the triangle a + b <= beta, beta
the smallest minimal block; cross orbitals are complete bipartite between blocks
and never bind; and a group with a non-2-homogeneous prime block admits no linear
biclique at all.  So the region at n is a + b <= s(n) with

    s(n) = max beta(Gamma) over Oliver groups on [n] with all minimal blocks
           2-homogeneous ("structured"),

and this script computes s(n) by enumerating structured configurations.  It is a
DIFFERENT optimisation from mu(n): it maximises the smallest block and ignores
orbital sizes entirely.

STRUCTURED CONFIGURATIONS ENUMERATED (block sizes in brackets)
  S1   n a prime power                     [n]            AGL(1,n)
  S2   n = F*c, c a prime power, F >= 2    [c]            fused class, full twist
  S3/7 n = F*c + r, one foreign prime r    [c, r]         F >= 1
  S6   n = r1 + r2, two foreign primes     [r1, r2]
  S11  n = F*c + r1 + r2                   [c, r1, r2]

A FOREIGN block must have eta = 1 to be 2-homogeneous: r - 1 = 2^e (Fermat, top
prime q = 2) or r - 1 = 2*q^e with q an odd prime.  Several foreign blocks must
share one top prime q.  A matching class takes full twist via an entangled
generator of order F*(c - 1), which sits in the cyclic layer beside the foreign
translations, so the cyclic layer is cyclic only if gcd(F*(c-1), r) = 1 for every
foreign r -- the condition enforced below.  The foreign primes must differ from
the matching prime and from each other.

NOT ENUMERATED, deliberately: two matching classes of the same prime in different
block sizes (S12), fused foreign blocks (S9), and matching blocks with partial
twist (not 2-homogeneous, so no linear biclique).  S12 can in principle be
structured; if it ever mattered it would show as n where this script's s(n) is
beaten by a hand construction.

USAGE
    python3 biclique_table.py --nmax 1000 --out biclique_table_1000.csv
Cost is roughly quadratic in nmax (a loop over (c, F, r) per n); fine to 10^4,
slow beyond.  Columns: n, s, s_over_n, shape, config.
"""
import argparse
import csv
import sys
from math import gcd


def sieve(N):
    s = bytearray([1]) * (N + 1)
    s[0] = s[1] = 0
    for i in range(2, int(N ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = bytearray(len(s[i * i::i]))
    return s


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--nmax", type=int, default=1000)
    ap.add_argument("--out", default="biclique_table.csv")
    a = ap.parse_args()
    N = a.nmax
    isp = sieve(N)

    # prime powers c >= 2, with their prime
    pp = {}
    for p in range(2, N + 1):
        if isp[p]:
            c = p
            while c <= N:
                pp[c] = p
                c *= p

    # eta = 1 foreign primes, keyed by their top prime q
    def eta1_q(r):
        m = r - 1
        if m & (m - 1) == 0:          # r - 1 a power of 2: Fermat, q = 2
            return 2
        if m % 2 or m % 4 == 0:
            return None
        h = m // 2                    # need h = q^e, q an odd prime
        for q in range(3, h + 1, 2):
            if h % q == 0:
                while h % q == 0:
                    h //= q
                return q if h == 1 else None
        return None
    eta1 = {r: eta1_q(r) for r in range(3, N + 1) if isp[r] and eta1_q(r)}
    by_q = {}
    for r, q in eta1.items():
        by_q.setdefault(q, []).append(r)

    rows = []
    for n in range(6, N + 1):
        best = (0, "none", "")

        def offer(beta, shape, cfg):
            nonlocal best
            if beta > best[0]:
                best = (beta, shape, cfg)

        if n in pp:
            offer(n, "S1", f"AGL(1,{n})")
        for c, p in pp.items():
            if c >= n:
                continue
            # S2
            if n % c == 0 and n // c >= 2:
                offer(c, "S2", f"{n//c}x{c}")
            # S3/S7: F*c + r
            F = 1
            while F * c < n:
                r = n - F * c
                if r in eta1 and r % p and gcd(F * (c - 1), r) == 1:
                    offer(min(c, r), "S3" if F == 1 else f"S7f{F}",
                          f"{F}x{c} + {r}* (q={eta1[r]})")
                F += 1
        # S6: r1 + r2, same q
        for q, rs in by_q.items():
            s_rs = set(rs)
            for r1 in rs:
                r2 = n - r1
                if r2 > r1 and r2 in s_rs:
                    offer(min(r1, r2), "S6", f"{r1}* + {r2}* (q={q})")
        # S11: F*c + r1 + r2, same q.  Only worth checking if it can beat best.
        for q, rs in by_q.items():
            for i, r1 in enumerate(rs):
                if r1 <= best[0]:
                    continue
                for r2 in rs[i + 1:]:
                    rest = n - r1 - r2
                    if rest < 2 or r2 <= best[0]:
                        continue
                    for c, p in pp.items():
                        if c > rest or c <= best[0]:
                            continue
                        if rest % c:
                            continue
                        F = rest // c
                        if r1 % p and r2 % p and gcd(F * (c - 1), r1 * r2) == 1:
                            offer(min(c, r1, r2), "S11",
                                  f"{F}x{c} + {r1}* + {r2}* (q={q})")
        rows.append((n, best[0], best[0] / n, best[1], best[2]))

    with open(a.out, "w", newline="") as fh:
        w = csv.writer(fh)
        w.writerow(["n", "s", "s_over_n", "shape", "config"])
        for r in rows:
            w.writerow([r[0], r[1], f"{r[2]:.6f}", r[3], r[4]])
    print(f"{a.out}: {len(rows)} rows, n in [6, {N}]", file=sys.stderr)


if __name__ == "__main__":
    main()
