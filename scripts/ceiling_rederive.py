#!/usr/bin/env python3
"""
ceiling_rederive.py -- re-derive arithmetic-of-density.md section 3.3.5's ceiling
table WITHOUT using the congruence argument that produced it.

The table is derived in the documents from congruences: which r mod 8 is
reachable at each (class, F), what v_2(r-1) that forces, hence which eta.  Any
re-derivation by the same route agrees with itself and confirms nothing.  This
script instead SCANS REAL CONFIGURATIONS n = F*c + r under the current scoring
and takes the empirical sup of density per residue class, then compares.

    delta(n) = m* / C(n,2),   m* = min( F*orb(c,c-1), (F/2)c^2, orb(r,t), F*c*r )

WHAT THE FILTER IS FOR, AND WHY A NAIVE SUP IS THE WRONG STATISTIC.

Section 3.3.8 lists four routes that exceed a class ceiling on a sparse set of n
(O(n/log n) or O(log n) supply).  A sup over any range picks the luckiest n in
it, so it MEASURES THE ESCAPES rather than the ceiling.  Run unfiltered, classes
3, 5, 7 and 11 exceed their closed forms -- by 1.74x at class 11 -- every time
via c being a pure power of 2 or of 3, which is what makes the ell = 2 or
ell = 3 local obstruction on the foreign prime evaporate.  Those are not
counterexamples; they are section 3.3.8 working as documented, and their
disappearance when the filter goes on is itself a check on that section's
account of them.

READ THE WITNESS COLUMN, not just the ratios.  Every c reported in unfiltered
mode must be a PRIME POWER: a composite c there means the candidate list is
admitting block sizes no Oliver group has, and the escapes it reports are then
partly phantom.  (That was once a live defect -- the list tested prime-power-ness
on the odd part alone, admitting 6, 12, 20, 24, ...)

The generic family is therefore: c a prime >= 5 (excluding the ell=2 and ell=3
evasions at c a power of 2 or 3), the foreign twist a prime power at q >= 5
(excluding rung B-prime at q = 2, and the r = 2^v * 3^e + 1 family), and F even.

USAGE
    python3 ceiling_rederive.py                 # generic family, n in [N/2, N]
    python3 ceiling_rederive.py --nmax 90000    # wider range, slower
    python3 ceiling_rederive.py --no-filter     # the escapes, deliberately
    python3 ceiling_rederive.py --mod12         # check every pair {a, a+12}

Exits nonzero if a tabulated class is exceeded (filtered mode) or if any
mod-12 pair disagrees.
"""
import argparse
import bisect
import sys
from math import comb, sqrt

# section 3.3.5, keyed mod 12.  Six constants.
CEILING = {
    1: 3 - 2 * sqrt(2),   9: 3 - 2 * sqrt(2),
    3: 0.125,             7: 0.125,
    5: 5 - 2 * sqrt(6),
    11: 7 - 4 * sqrt(3),
}
# expected (F, eta) attaining each, for reporting
ATTAINER = {1: (2, 1.0), 9: (2, 1.0), 3: (2, 0.5), 7: (2, 0.5),
            5: (2, 1 / 3), 11: (4, 1 / 3)}


def sieve_upto(n):
    s = bytearray([1]) * (n + 1)
    s[0] = s[1] = 0
    for i in range(2, int(n ** .5) + 1):
        if s[i]:
            s[i * i::i] = bytearray(len(s[i * i::i]))
    return s


def factor_odd_part(m):
    """prime factorisation of the odd part of m, as {p: e}"""
    while m % 2 == 0:
        m //= 2
    f, d = {}, 3
    while d * d <= m:
        while m % d == 0:
            f[d] = f.get(d, 0) + 1
            m //= d
        d += 2
    if m > 1:
        f[m] = f.get(m, 0) + 1
    return f


def twist(m, generic):
    """largest admissible prime-power divisor of m used as the foreign twist.

    generic=True: q >= 5 only, and the pure-3-power odd part is rejected --
    that is the r = 2^v*3^e+1 escape, which reaches eta the congruences forbid.
    generic=False: any prime power, including q = 2 (rung B-prime).
    """
    f = factor_odd_part(m)
    if generic:
        if not f or set(f) == {3}:
            return 1
        return max((q ** e for q, e in f.items() if q >= 5), default=1)
    best = max((q ** e for q, e in f.items()), default=1)
    two = 1
    x = m
    while x % 2 == 0:
        x //= 2
        two *= 2
    return max(best, two)


def orb(c, d, char2=False):
    """min intra-orbital: c*d/2 when -1 in T (always in char 2), else c*d"""
    v = c * d // 2 if (char2 or d % 2 == 0) else c * d
    return min(v, comb(c, 2))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--nmax", type=int, default=30000)
    ap.add_argument("--no-filter", action="store_true",
                    help="include section 3.3.8's escapes (expect exceedances)")
    ap.add_argument("--mod12", action="store_true",
                    help="also check that each pair {a, a+12} agrees")
    args = ap.parse_args()
    generic = not args.no_filter
    N = args.nmax
    sieve = sieve_upto(N)
    primes = [i for i in range(2, N + 1) if sieve[i]]
    # c must be a PRIME POWER in either mode.  Testing the odd part for
    # prime-power-ness instead admits 6, 12, 20, 24, 40, ... -- block sizes no
    # Oliver group has -- so an unfiltered run would report phantom
    # configurations among the escapes it is meant to display.
    def prime_power(x):
        m, e2 = x, 0
        while m % 2 == 0:
            m //= 2; e2 += 1
        f = factor_odd_part(x)
        if e2 and f:
            return False                     # two distinct primes
        if e2:
            return True                      # a power of 2
        return len(f) == 1
    cand = [p for p in primes if p >= 5] if generic else \
           [q for q in range(3, N + 1) if prime_power(q)]

    best24 = {}
    for n in range(N // 2 | 1, N + 1, 2):
        bd, bw = 0.0, None
        for F in (2, 4, 6, 8):
            hi = bisect.bisect_right(cand, n // F)
            for c in cand[:hi]:
                r = n - F * c
                if r < 5 or not sieve[r]:
                    continue
                t = twist(r - 1, generic)
                if t == 1:
                    continue
                m = min(F * comb(c, 2), (F // 2) * c * c, orb(r, t), F * c * r)
                d = m / comb(n, 2)
                if d > bd:
                    bd, bw = d, (F, c, r, t)
        if bd > 0:
            k = n % 24
            if k not in best24 or bd > best24[k][0]:
                best24[k] = (bd,) + bw + (n,)

    mode = "generic family" if generic else "UNFILTERED (escapes included)"
    print(f"ceiling_rederive.py -- {mode}, n in [{N//2}, {N}]\n")
    print(f"{'cls12':>6} {'emp sup':>9} {'tabled':>9} {'ratio':>7} "
          f"{'F':>2} {'eta':>7}  witness")
    rc = 0
    for a in sorted(k for k in CEILING):
        halves = [best24[x] for x in (a, a + 12) if x in best24]
        if not halves:
            continue
        bd, F, c, r, t, n = max(halves)
        cf = CEILING[a]
        eta = 2 * t / (r - 1)
        flag = ""
        if bd > cf * (1 + 1e-4):
            flag = "  <-- EXCEEDS"
            if generic:
                rc = 1
        print(f"{a:>6} {bd:9.5f} {cf:9.5f} {bd/cf:7.4f} {F:>2} {eta:7.4f}  "
              f"n={n} c={c} r={r}{flag}")

    if args.mod12:
        print("\nmod-12 keying: each pair {a, a+12} must agree in cap, F and eta")
        for a in range(1, 12, 2):
            x, y = best24.get(a), best24.get(a + 12)
            if not (x and y):
                continue
            fx = (x[1], round(2 * x[4] / (x[3] - 1), 4))
            fy = (y[1], round(2 * y[4] / (y[3] - 1), 4))
            ok = abs(x[0] - y[0]) < 3e-4 and fx == fy
            if not ok:
                rc = 1
            print(f"  {a:>2} vs {a+12:>2}: {x[0]:.5f} / {y[0]:.5f}  "
                  f"F,eta {fx} / {fy}   {'agree' if ok else 'DISAGREE'}")

    if not generic:
        print("\nExceedances here are section 3.3.8's escapes, not counterexamples:"
              "\nre-run without --no-filter and they disappear.")
    return rc


if __name__ == "__main__":
    sys.exit(main())
