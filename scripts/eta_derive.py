#!/usr/bin/env python3
"""
eta_derive.py -- derives the guaranteed foreign efficiency eta per (residue class
mod 24, fusion count F) from congruences alone, and checks it against a direct
measurement over sampled n.  Supports section 4 of fusion-count-ceilings.md.

THE DERIVATION.  n odd, c a prime power = 3 (mod 4) so the matching term stays
F*x^2, r = n - F*c an odd prime, F even (forced at odd n).  eta = 2t/(r-1) with
t the largest prime-power divisor of r-1 whose prime avoids F.

  2-adic.  c = 3 (mod 4) => c = 3 or 7 (mod 8), so F*c is determined mod 8:
           6, 4, 2 for F = 2, 4, 6.  Hence r = n - F*c (mod 8) is fixed by the
           class.  Even F puts 2 in the cyclic layer, so t is odd, and the best
           case r-1 = 2^v * q^e gives eta_2 = 2^(1-v) with v = v_2(r-1):
               r = 3, 7 (mod 8) -> v = 1 ;  r = 5 -> v = 2 ;  r = 1 -> v >= 3.
           At r = 1 (mod 8) the mod-8 analysis is NOT enough -- see below.

  3-adic.  If 3 | r-1 is forced then the odd part carries a 3, and for it to be
           a single prime power it must be a power of 3: the density-zero family
           r = 2^v * 3^e + 1.  Generically the odd part is 3*(prime power), so
           eta is cut by 3.  Whether 3 | r-1 is forced depends on F mod 3:
             F not= 0 (mod 3): c mod 3 is free (c prime != 3), so r can be
                 steered to 2 (mod 3) unless that forces c = 0 (mod 3), which
                 happens exactly at n = 2 (mod 3).
             F = 0 (mod 3): r = n (mod 3) is forced.  The cut applies at
                 n = 1 (mod 3); at n = 0 (mod 3), 3 | r so the shape is
                 unavailable for prime r > 3.

  eta = eta_2 / (3 if cut else 1).

THE SUBTLETY AT r = 1 (mod 8).  There v >= 3 only, and the exact value needs
mod 16, where 4c = 12 (mod 16) is again forced -- so r = n - 12 (mod 16) and
n mod 16 is NOT determined by n mod 24.  The class then splits.  This is why
the 2-adic factor is computed here by exact enumeration mod 2^K rather than
from a mod-8 lookup.

Usage: python3 eta_derive.py      Exits nonzero on any disagreement.
"""
import sys
from sympy import factorint, primerange

K = 7
M = 1 << K


def _v2(x):
    if x % M == 0:
        return K - 1
    v = 0
    while x % 2 == 0 and v < K - 1:
        x //= 2
        v += 1
    return v


def eta_2adic(a, F):
    """min over n = a (mod 24) of max over c = 3 (mod 4) of 2^(1-v_2(r-1)).

    The min is the guarantee (what the class always reaches); the max is the
    best available at a given n.  Enumerating n mod 2^K captures the deeper
    dependence at r = 1 (mod 8) that a mod-8 lookup would miss."""
    worst = None
    for n in range(a, a + 24 * M, 24):
        if n % 8 != a % 8:
            continue
        best = max(2.0 ** (1 - _v2((n - 1 - F * c) % M)) for c in range(3, M, 4))
        worst = best if worst is None else min(worst, best)
    return worst


def eta_derived(a, F):
    """Guaranteed eta at residue class a (mod 24) and fusion count F, or None if
    the shape is unavailable at that class."""
    n3 = a % 3
    if F % 3 == 0:
        if n3 == 0:
            return None                      # 3 | r, impossible for prime r > 3
        cut = (n3 == 1)
    else:
        cut = (n3 == 2)
    return min(1.0, eta_2adic(a, F)) / (3 if cut else 1)


def eta_measured(a, F, lo=60000, hi=90000, step=53, primes=None):
    """Direct measurement: min over sampled n of the best eta an actual
    decomposition achieves.  Independent of the derivation above."""
    def qbest(m):
        b = 1
        for q, e in factorint(m).items():
            if F % q == 0:
                continue
            b = max(b, q ** e)
        return b
    worst = None
    for n in range(lo, hi + 1):
        if n % 24 != a or n % step:
            continue
        best = 0.0
        for c in range(3, n // F, 2):
            if c % 4 != 3 or c not in primes:
                continue
            r = n - F * c
            if r < 3 or r not in primes:
                continue
            t = qbest(r - 1)
            if t == 1:
                continue
            best = max(best, min(1.0, 2 * t / (r - 1)))
        worst = best if worst is None else min(worst, best)
    return worst or 0.0


if __name__ == "__main__":
    primes = set(primerange(3, 200000))
    ok = True
    print(" class |   F=2 der/meas    |   F=4 der/meas    |   F=6 der/meas    | agree")
    for a in range(1, 24, 2):
        cells, good = [], True
        for F in (2, 4, 6):
            d = eta_derived(a, F)
            m = eta_measured(a, F, primes=primes)
            agree = abs((0.0 if d is None else d) - m) < 1e-9
            good &= agree
            cells.append("%7s/%-7s" % ("--" if d is None else "%.4f" % d, "%.4f" % m))
        ok &= good
        print(" %-5d | %s | %s | %s | %s"
              % (a, cells[0], cells[1], cells[2], "OK" if good else "MISMATCH"))
    print("\nall 36 cells agree:", ok)

    # Where does the mod-24 keying actually hold?
    print("\ncells whose 2-adic factor is not constant across the mod-24 class:")
    split = []
    for a in range(1, 24, 2):
        for F in (2, 4, 6):
            vals = set()
            for n in range(a, a + 24 * M, 24):
                if n % 8 != a % 8:
                    continue
                vals.add(max(2.0 ** (1 - _v2((n - 1 - F * c) % M)) for c in range(3, M, 4)))
            if len(vals) > 1:
                split.append((a, F, sorted(vals)))
                print("   class %-3d F=%d : %s   %s" % (a, F, sorted(vals),
                      "CEILING-SETTING" if (a in (7, 11, 15, 23) and F == 4) else "(not the optimum)"))
    binding = [x for x in split if x[0] in (7, 11, 15, 23) and x[1] == 4]
    print("   -> of these, %d are ceiling-setting cells" % len(binding))
    ok &= not binding
    sys.exit(0 if ok else 1)
