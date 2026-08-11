#!/usr/bin/env python3
"""
k3_galois.py -- the Galois admissibility predicate for k = 3, implemented once
so that the eventual k = 3 enumerator imports it instead of re-deriving it.
Resolves item A19 of pending-checks.md.

THE PREDICATE (three-uniform-note.md section 2.2.2).  A matching block c = 2^a
with twist d gains the Galois factor iff

    p = 2,  m = a,  gcd(a, 6) = 1,  gcd(d, 6) = 1,  d > 1,  d | 2^a - 1,

and -- this is the Oliver-condition clause, and the one that is easy to get
wrong -- the Galois group C_a admits a LAYER SPLIT:

    exists a' | a  with  (i)  d | 2^{a/a'} - 1     [C_{a'} centralises C_d]
                         (ii) gcd(d, a') = 1       [C_d x C_{a'} cyclic]
                         (iii) a/a' a prime power  [Gamma/Gamma_1 is a q-group]

The tempting simplification "a is a prime power" is the a' = 1 branch ALONE and
admits strictly fewer blocks.  Getting this wrong is dangerous in the unusual
direction: section 5.8 of that document records that a k = 3 scoring which
UNDER-credits the Galois part is not a loose upper bound but not an upper bound
at all, unlike k = 2 where the analogous looseness is safe.

TWO QUANTITIES THAT ARE NOT THE SAME, and conflating them is the next trap:

    gain factor  = lpf(a)        the factor by which min_3 rises (the theorem)
    top prime q  = lpf(a/a')     which prime Gamma/Gamma_1 is a group of

At a a prime power these coincide.  At composite a they need not, and since
section 4.3 couples the top prime to every foreign block in the configuration
(each needs q | r - 1), the choice of d -- which fixes a' and hence q -- is a
real degree of freedom that the naive predicate cannot express.

Usage:  from k3_galois import galois_admissible
        galois_admissible(a, d) -> None, or a dict with a_prime, q, gain.
Running the file executes the self-test.
"""
from math import gcd

from sympy import divisors, primefactors


def _ord2(d):
    """Multiplicative order of 2 mod d, for odd d > 1."""
    o, v = 1, 2 % d
    while v != 1:
        v = v * 2 % d
        o += 1
    return o


def _is_prime_power(x):
    return x > 1 and len(primefactors(x)) == 1


def galois_admissible(a, d):
    """The full criterion.  Returns None if the Galois part does not raise the
    minimum, else a dict describing the layer split.  Where several splits
    exist the one with the smallest top prime is returned, and all of them are
    listed under 'splits' -- the caller may want a different q because of the
    top-prime coupling to foreign blocks (section 4.3)."""
    if a <= 1 or d <= 1:
        return None
    if gcd(a, 6) != 1 or gcd(d, 6) != 1:
        return None
    if (2 ** a - 1) % d != 0:
        return None
    m = _ord2(d)
    splits = []
    for ap in divisors(a):
        if (a // ap) % m:
            continue                      # (i)  d | 2^{a/a'} - 1
        if gcd(d, ap) != 1:
            continue                      # (ii) C_d x C_{a'} cyclic
        top = a // ap
        if not _is_prime_power(top):
            continue                      # (iii) top layer is a q-group
        splits.append({"a_prime": ap, "top": top, "q": primefactors(top)[0]})
    if not splits:
        return None
    splits.sort(key=lambda s: s["q"])
    best = dict(splits[0])
    best["gain"] = primefactors(a)[0]     # lpf(a) -- NOT necessarily q
    best["splits"] = splits
    return best


def naive_admissible(a, d):
    """The superseded reading: a itself a prime power.  Kept only so the
    self-test can show the gap; never use it for scoring."""
    if a <= 1 or d <= 1 or gcd(a, 6) != 1 or gcd(d, 6) != 1:
        return False
    return _is_prime_power(a) and (2 ** a - 1) % d == 0


def _selftest():
    ok = True

    def check(name, cond):
        nonlocal ok
        print(("PASS  " if cond else "FAIL  ") + name)
        ok = ok and cond

    r = galois_admissible(35, 31)
    check("a=35, d=31 is admissible via a'=7 with top prime 5",
          r and r["a_prime"] == 7 and r["q"] == 5 and r["gain"] == 5)
    check("and the naive 'a is a prime power' reading rejects it",
          not naive_admissible(35, 31))
    r2 = galois_admissible(35, 127)
    check("a=35, d=127 is admissible via a'=5 with top prime 7, gain still 5",
          r2 and r2["a_prime"] == 5 and r2["q"] == 7 and r2["gain"] == 5)
    check("so at a=35 the twist choice selects the top prime (5 or 7) "
          "while the gain is lpf(a)=5 either way",
          r["q"] != r2["q"] and r["gain"] == r2["gain"] == 5)

    # the predicate must never REJECT something the naive reading accepts
    bad = []
    for a in range(2, 46):
        if gcd(a, 6) != 1:
            continue
        for d in divisors(2 ** a - 1):
            if naive_admissible(a, d) and not galois_admissible(a, d):
                bad.append((a, d))
    check("the split accepts everything the naive reading does (superset)", not bad)

    # and it is a STRICT superset, first at a = 35
    extra = []
    for a in range(2, 46):
        if gcd(a, 6) != 1:
            continue
        for d in divisors(2 ** a - 1):
            if galois_admissible(a, d) and not naive_admissible(a, d):
                extra.append((a, d))
    check("strictly larger, and the smallest witness is a = 35 (i.e. n = 2^35)",
          extra and min(a for a, _ in extra) == 35)

    # where the correction bites: composite a coprime to 6 (35, 55, 65, ...)
    comp = [a for a in range(2, 70)
            if gcd(a, 6) == 1 and not _is_prime_power(a) and a > 1]
    check("the affected block sizes are a in %s, all with gain lpf(a)=5" % comp,
          comp == [35, 55, 65]
          and all(primefactors(a)[0] == 5 for a in comp))

    print("\n      admissible (a, d) with a <= 45, by branch:")
    for a in range(2, 46):
        if gcd(a, 6) != 1:
            continue
        ds = [d for d in divisors(2 ** a - 1) if galois_admissible(a, d)]
        if ds:
            r = galois_admissible(a, ds[0])
            print("       a=%-3d gain=%-3d  %2d twists admissible  %s"
                  % (a, r["gain"], len(ds),
                     "prime power" if _is_prime_power(a) else "COMPOSITE -- naive misses this"))
    return ok


if __name__ == "__main__":
    import sys
    sys.exit(0 if _selftest() else 1)
