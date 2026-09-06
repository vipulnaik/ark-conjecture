#!/usr/bin/env python3
"""
ceiling_rederive3.py -- re-derive three-uniform-note.md section 5's beta_3
ceiling table by SCANNING REAL CONFIGURATIONS, not by the congruence argument
that produced it.

This is the k = 3 counterpart of `ceiling_rederive.py`, and it exists because
the k = 2 one has no analogue here: without a generic-family filter, a sup over
any range measures section 6's ESCAPES rather than the ceiling.  Measured on
`b3_census_2000.csv` unfiltered, the class sup exceeds the tabulated ceiling in
11 of 12 residue classes -- by 18x at class 0 -- and **7 of the 12 sups are
attained by a fused S2 shape with no foreign block at all** (`3x128`, `2x997`,
`2x983`).  Those are section 6.3's full-density blocks and the fused engine, not
counterexamples; they are what the filter is for.

    beta_3 := m*_3(n) / n^2,   m*_3 = min over classes of F * orb_3(c, d, m)

(only intra terms bind at k = 3 -- section 4.1's degree count, proved -- so the
score has ONE term type and no cross comparison, unlike k = 2.)

THE FILTER, and each cut names what it removes:

  * **c a prime >= 5.**  Removes the 2-power and 3-power blocks, which is where
    the ell = 2 and ell = 3 local obstructions on the foreign prime evaporate --
    the same evasion `ceiling_rederive.py` cuts at k = 2 -- and with them the
    full-density blocks c in {8, 32} of section 6.3, whose orb_3 = C(c,3) is an
    escape by Kantor's classification rather than a ceiling.
  * **the foreign twist a prime power at q >= 5.**  Removes rung B-prime
    (q = 2) and the r = 2^v * 3^e + 1 family.
  * **a foreign block must be present.**  NOT part of the filter: this one is
    STRUCTURAL and stays on under `--no-filter` too, because section 5's table
    is a statement about the two-part additive family and a fused-only shape is
    a different question (section 6.3).  It is listed here because it is the cut
    that matters most and has no k = 2 counterpart: at k = 3 the fused shape S2
    alone scores F * orb_3(c, c-1, m) ~ n*c/kappa, which at c ~ n/2 is
    Theta(n^2) with a large constant, so S2 dominates every class sup -- 7 of
    the 12 unfiltered sups on `b3_census_2000.csv` are fused shapes with no
    foreign block.  A reader comparing `--no-filter` here against
    `ceiling_rederive.py --no-filter` should know the two are not scanning the
    same shape set.

KAPPA_C IS A SPLIT, NOT A NUISANCE, and this is the k = 3-specific part.  For a
prime block c >= 5 at full twist, kappa_c = tau * theta * gamma = theta, which is
**3 when 3 | c - 1 and 2 otherwise**.  Section 5's table therefore has TWO
columns, and a scan that pools them compares against neither.  Results are
reported per (class, kappa_c) cell against the matching column.

USAGE
    python3 ceiling_rederive3.py                  # generic family
    python3 ceiling_rederive3.py --nmax 60000     # wider, slower
    python3 ceiling_rederive3.py --no-filter      # the escapes, deliberately

Exits nonzero if a tabulated cell is exceeded in filtered mode.
"""
import argparse
import sys
from math import comb, sqrt


# three-uniform-note.md section 5, keyed mod 12, in its two kappa_c columns.
CEIL = {
    (0, 2): 0.125, (4, 2): 0.125, (6, 2): 0.125, (10, 2): 0.125,
    (2, 2): 1 / (sqrt(2) + sqrt(6)) ** 2, (8, 2): 1 / (sqrt(2) + sqrt(6)) ** 2,
    (1, 2): 3 - 2 * sqrt(2), (9, 2): 3 - 2 * sqrt(2),
    (3, 2): 0.0625, (7, 2): 0.0625,
    (5, 2): (5 - 2 * sqrt(6)), (11, 2): 4 - 2 * sqrt(3),
}
# the kappa_c = 3 column, as the note prints it
CEIL3 = {0: 0.10102, 4: 0.10102, 6: 0.10102, 10: 0.10102,
         2: 0.05719, 8: 0.05719, 1: 0.06699, 9: 0.06699,
         3: 0.05051, 7: 0.05051, 5: 0.04167, 11: 0.02860}
# and the kappa_c = 2 column, likewise
CEIL2 = {0: 0.125, 4: 0.125, 6: 0.125, 10: 0.125,
         2: 0.06699, 8: 0.06699, 1: 0.08579, 9: 0.08579,
         3: 0.0625, 7: 0.0625, 5: 0.05051, 11: 0.03590}


def sieve_upto(n):
    s = bytearray([1]) * (n + 1)
    s[0] = s[1] = 0
    for i in range(2, int(n ** .5) + 1):
        if s[i]:
            s[i * i::i] = bytearray(len(s[i * i::i]))
    return s


def prime_power_parts(m):
    """{p: p^e} for the odd part of m, plus the 2-part."""
    out = {}
    two = 1
    while m % 2 == 0:
        m //= 2
        two *= 2
    if two > 1:
        out[2] = two
    d = 3
    while d * d <= m:
        if m % d == 0:
            pe = 1
            while m % d == 0:
                m //= d
                pe *= d
            out[d] = pe
        d += 2
    if m > 1:
        out[m] = m
    return out


def orb3_prime(c, d):
    """orb_3 for a PRIME block at twist d: tau = 1, gamma = 1, theta = kappa."""
    theta = 3 if d % 3 == 0 else (2 if d % 2 == 0 else 1)
    return min(c * d // theta, comb(c, 3)), theta


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--nmax", type=int, default=20000)
    ap.add_argument("--no-filter", action="store_true",
                    help="include section 6's escapes (expect exceedances)")
    a = ap.parse_args()
    generic = not a.no_filter
    N = a.nmax
    sieve = sieve_upto(N)
    primes = [i for i in range(2, N + 1) if sieve[i]]
    cand = [p for p in primes if p >= 5] if generic else \
           [q for q in range(3, N + 1) if sieve[q]]

    best = {}          # (n % 12, kappa_c) -> (beta3, F, c, r, t, n)
    for n in range(N // 2 | 1, N + 1):
        for F in range(1, 9):
            for c in cand:
                if F * c >= n:
                    break
                r = n - F * c
                if r < 5 or not sieve[r]:
                    continue
                pp = prime_power_parts(r - 1)
                for q, t in pp.items():
                    if generic and q < 5:
                        continue
                    kr = 3 if t % 3 == 0 else (2 if t % 2 == 0 else 1)
                    mine, kc = orb3_prime(c, c - 1)
                    theirs = min(r * t // kr, comb(r, 3))
                    m3 = min(F * mine, theirs)
                    b3 = m3 / (n * n)
                    k = (n % 12, kc)
                    if k not in best or b3 > best[k][0]:
                        best[k] = (b3, F, c, r, t, n)

    mode = "generic family" if generic else "UNFILTERED (escapes included)"
    print(f"ceiling_rederive3.py -- {mode}, n in [{N//2}, {N}]\n")
    print(f"{'cls':>4} {'kc':>3} {'emp sup':>9} {'tabled':>9} {'ratio':>7} "
          f"{'F':>2}  witness")
    rc = 0
    for cls in range(12):
        for kc, table in ((2, CEIL2), (3, CEIL3)):
            if (cls, kc) not in best:
                continue
            b3, F, c, r, t, n = best[(cls, kc)]
            cf = table[cls]
            flag = ""
            if b3 > cf * (1 + 2e-3):
                flag = "  <-- EXCEEDS"
                if generic:
                    rc = 1
            print(f"{cls:>4} {kc:>3} {b3:9.5f} {cf:9.5f} {b3/cf:7.4f} {F:>2}  "
                  f"n={n} {F}x{c} + {r}* (t={t}){flag}")
    if not generic:
        print("\nExceedances here are section 6's escapes, not counterexamples:"
              "\nrerun without --no-filter and they should disappear.")
    return rc


if __name__ == "__main__":
    sys.exit(main())
