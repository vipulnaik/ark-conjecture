#!/usr/bin/env python3
"""
brute.py -- an independent naive re-implementation of the configuration score.

Written from `enumeration-proof.md` Part 0 alone: no pruning, no seed value, no
precomputed part pool, no early exit.  Its whole purpose is to be a DIFFERENT
program from `mu_enumerate.py`, so that agreement is evidence about that
program's pruning rather than a re-run of it.  Where there was a choice of
implementation the opposite one is taken on purpose -- the coprimality test
below is pairwise gcd rather than a shared set of prime factors, and the
fusion counts are enumerated by trial division rather than by a q-power ladder.

WHAT A CONFIGURATION IS (Part 0, corrected shape space)

  Fix a home prime p (or the sentinel p = 0, meaning a trivial bottom layer)
  and a top prime q.  A configuration is a multiset of classes summing to n.
  Each class is F blocks of size c with

      c        a prime power.  MATCHING if its base is p, OUTSIDE otherwise,
               and an outside block must be prime, not a proper prime power.
      F        = Fmid * Ftop.  Ftop is a power of q, supplied by the top layer.
               Fmid is any integer, supplied by the cyclic layer.  Nothing from
               the bottom layer: Lemma D1 absorbs it for matching blocks and
               Lemma D2 forbids it for outside blocks.
      outside  classes are never fused at all, so F = 1 there (Lemma D2).

  GLOBAL admissibility: outside primes are pairwise distinct.  A fused class's
  Fmid is NOT required coprime to them or to any twist -- the block rotation is
  a quotient of the cyclic layer (entangled generator), not a subgroup of it.

SCORING (SAFE mode, so a matching block always gets the unconditional F*C(c,2))

      matching class      F * C(c,2), the flat cap, at every Fmid
      outside class       orb(c, q-part of c-1)
      within-class cross  (F or F/2) * c^2, by the parity of F, when F > 1
      between classes     size_i * size_j

  and the score is the minimum of all of them.

Cost is roughly (number of admissible classes)^kmax per (p, q), so n <= 120 is
seconds, n <= 260 an overnight run.  Driver: `brute_compare.py`.
"""
from math import comb, gcd
from sympy import factorint, isprime


def prime_power(x):
    """(base, exponent) if x is a prime power, else None."""
    if x < 2:
        return None
    f = factorint(x)
    if len(f) != 1:
        return None
    (b, e), = f.items()
    return b, e


def qpart(x, q):
    t = 1
    while x % q == 0:
        x //= q
        t *= q
    return t


def orb(c, t, char2):
    """Minimum intra-orbital of a c-block under a cyclic twist of order t,
    capped at C(c,2).  The cap is what makes a 2-block worth 1 rather than 2."""
    raw = c * t // 2 if (char2 or t % 2 == 0) else c * t
    return min(raw, comb(c, 2))


def coprime_part(m, F):
    """Largest divisor of m coprime to F.  Deliberately by repeated trial
    division rather than by a shared factor set, to stay a different program
    from `mu_enumerate_v2.py`."""
    if F <= 1:
        return m
    for b in factorint(F):
        while m % b == 0:
            m //= b
    return m


def pairwise_coprime(vals):
    """Deliberately the naive O(k^2) gcd test rather than a factor-set sieve."""
    vs = [v for v in vals if v > 1]
    for i in range(len(vs)):
        for j in range(i + 1, len(vs)):
            if gcd(vs[i], vs[j]) > 1:
                return False
    return True


def score(n, p, q, classes):
    """classes: list of (Fmid, Ftop, c, is_outside).  None if inadmissible."""
    outside = [c for _, _, c, o in classes if o]
    if len(outside) != len(set(outside)):
        return None                       # C_r x C_r is not cyclic
    # No coprimality between a fused class's Fmid and anything else: the block
    # rotation is a QUOTIENT of the cyclic layer, carried by an entangled
    # generator, so the layer stays cyclic at any Fmid (Theorem 3.1's gotcha;
    # groups built at n = 33, 78, 105).

    terms = []
    for fm, ft, c, o in classes:
        F = fm * ft
        if o:
            terms.append(orb(c, qpart(c - 1, q), False))
        else:
            # SAFE: the flat cap F*C(c,2).  The entangled generator realises
            # the full twist at any Fmid, so nothing is stripped.
            terms.append(F * comb(c, 2))
        if F > 1:
            terms.append((F if F % 2 else F // 2) * c * c)
    sizes = [fm * ft * c for fm, ft, c, _ in classes]
    for i in range(len(sizes)):
        for j in range(i + 1, len(sizes)):
            terms.append(sizes[i] * sizes[j])
    return min(terms)


def classes_for(n, p, q):
    """Every admissible class of size at most n, built by trial division."""
    out = []
    for c in range(2, n + 1):
        pp = prime_power(c)
        if not pp:
            continue
        outside = pp[0] != p
        if outside:
            if pp[1] > 1:                 # Lemma B': outside blocks are prime
                continue
            out.append((1, 1, c, True))   # Lemma D2: never fused
            continue
        # For a given block count F the score depends only on F, but the
        # ADMISSIBILITY depends on Fmid, which must be coprime to everything
        # else in the cyclic layer.  So among all splittings F = Fmid*Ftop the
        # one with the smallest Fmid is weakly the most permissive and the
        # others can never win.  Taking Ftop to be the full q-part of F leaves
        # exactly one entry per (F, c), which is both correct and the reason
        # this enumeration is affordable at all.
        for F in range(1, n // c + 1):
            ft = qpart(F, q)
            out.append((F // ft, ft, c, False))
    return out


def B(n, kmax=4):
    """max score over all (p, q) and all multisets of at most kmax classes."""
    primes = [x for x in range(2, n + 1) if isprime(x)]
    best = 0
    for p in [0] + primes:                # 0 = trivial bottom layer
        for q in primes:
            pool = classes_for(n, p, q)
            pool = sorted((t for t in pool if t[0] * t[1] * t[2] <= n),
                          key=lambda t: t[0] * t[1] * t[2])
            sizes = [t[0] * t[1] * t[2] for t in pool]

            def rec(start, rem, chosen):
                nonlocal best
                if rem == 0:
                    if chosen:
                        v = score(n, p, q, chosen)
                        if v is not None and v > best:
                            best = v
                    return
                if len(chosen) >= kmax:
                    return
                for k in range(start, len(pool)):
                    sz = sizes[k]
                    if sz > rem:
                        break            # pool is sorted by size ascending
                    rec(k, rem - sz, chosen + [pool[k]])

            rec(0, n, [])
    return best
