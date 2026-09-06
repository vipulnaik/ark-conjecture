#!/usr/bin/env python3
"""
k3_galois.py -- the Galois admissibility predicate for k = 3, implemented once
so that the eventual k = 3 enumerator imports it instead of re-deriving it.
Registered among the companion files of pending-checks.md.

THE PREDICATE (three-uniform-note.md section 2.2.2).  A matching block c = 2^a
with twist d gains the Galois factor iff

    p = 2,  m = a,  gcd(a, 6) = 1,  gcd(d, 6) = 1,  d > 1,  d | 2^a - 1,

and -- this is the Oliver-condition clause, and the one that is easy to get
wrong -- the Galois group C_a admits a LAYER SPLIT:

    exists a' | a  with  (i)  d | 2^{a/a'} - 1     [C_{a'} centralises C_d]
                         (ii) gcd(d, a') = 1       [C_d x C_{a'} cyclic]
                         (iii) a/a' a prime power  [Gamma/Gamma_1 is a q-group]

The tempting simplification "a is a prime power" is the a' = 1 branch ALONE and
admits strictly fewer blocks.  Note also that gcd(a, 6) = 1 is NOT implied by
the existence of a split and has to be tested separately: at a = 10, d = 31 a
perfectly good split exists (a' = 2, top 5, and 31 | 2^5 - 1), yet the F_4
escape of the theorem supplies a Galois-stable minimal orbit, so there is no
gain at all.  A predicate testing only "p = 2, gcd(d, 6) = 1, split exists"
OVER-credits, which is the safe direction here but still wrong.  Getting this wrong is dangerous in the unusual
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

    check("a=10, d=31 is REJECTED though a split exists (gcd(a,6)=2, so the "
          "F_4 escape applies and there is no gain)",
          galois_admissible(10, 31) is None
          and 31 % 1 == 0 and (2 ** 5 - 1) % 31 == 0)
    def _split_exists(a, d):
        """Conditions (i)-(iii) alone, with the gcd(a,6) clause omitted -- the
        wrong predicate, defined here only to show what it would admit."""
        m = _ord2(d)
        return any((a // ap) % m == 0 and gcd(d, ap) == 1
                   and _is_prime_power(a // ap) for ap in divisors(a))

    check("and the rejection is the gcd(a,6) clause alone: the split "
          "conditions (i)-(iii) on their own DO admit a=10, d=31",
          _split_exists(10, 31))

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

    # WHERE THE CORRECTION BITES, and the claim is RANGE-SCOPED -- it names its
    # range because the obvious reading of it is false.  Below 70 every
    # composite a coprime to 6 has lpf 5 (35, 55, 65), which invites "the gain
    # is always 5 at composite a"; a = 77 = 7*11 has gain 7 and a = 143 = 11*13
    # has gain 11.  The scope discipline the main documents follow (every
    # measured figure names the range it was taken over) applies to a self-test
    # message just as much as to prose.
    LIM = 70
    comp = [a for a in range(2, LIM)
            if gcd(a, 6) == 1 and not _is_prime_power(a) and a > 1]
    check("the affected block sizes below %d are a in %s, all with gain "
          "lpf(a) = 5 -- an accident of the range, not a law (a = 77 gains 7)"
          % (LIM, comp),
          comp == [35, 55, 65]
          and all(primefactors(a)[0] == 5 for a in comp)
          and primefactors(77)[0] == 7
          and galois_admissible(77, 127)["gain"] == 7)

    # THE TWO QUANTITIES THE DOCSTRING SEPARATES, pinned by a test rather than
    # left to the prose.  At a = 35 the gain is lpf(a) = 5 at both admissible
    # twists while the top prime is 5 or 7 according to d, so a scoring that
    # reads q off the gain (or the reverse) is wrong at the first composite a
    # in range -- and section 4.3 couples q to every foreign block, so the
    # error would propagate out of the block.
    gq = [(a, d, r["gain"], r["q"])
          for a in range(2, 46) if gcd(a, 6) == 1
          for d in divisors(2 ** a - 1)
          for r in [galois_admissible(a, d)] if r]
    check("gain and top prime are separately reported, and differ somewhere "
          "(%d admissible pairs, %d with gain != q)"
          % (len(gq), sum(1 for _, _, g, q in gq if g != q)),
          any(g != q for _, _, g, q in gq))

    # THE PREDICATE IS EXACT IN BOTH DIRECTIONS ON ITS OWN CLAUSES, which the
    # superset test above does not establish: it shows the split accepts what
    # the naive reading does, not that each clause is load-bearing.  Dropping
    # any one of the four must change the verdict somewhere in range.
    def _drop(clause, a, d):
        if a <= 1 or d <= 1 or (2 ** a - 1) % d != 0:
            return False
        if clause != "a6" and gcd(a, 6) != 1:
            return False
        if clause != "d6" and gcd(d, 6) != 1:
            return False
        m = _ord2(d)
        return any((a // ap) % m == 0
                   and (clause == "cyc" or gcd(d, ap) == 1)
                   and (clause == "pp" or _is_prime_power(a // ap))
                   for ap in divisors(a))

    # Two of the four are load-bearing at small a; the other two are not, and
    # the reasons differ -- which is worth a test each rather than one blanket
    # assertion, since they call for different treatment.
    live = {}
    for clause in ("a6", "d6", "cyc", "pp"):
        live[clause] = sum(
            1 for a in range(2, 40) for d in divisors(2 ** a - 1)
            if _drop(clause, a, d) != bool(galois_admissible(a, d)))
    check("gcd(a,6) = 1 and the prime-power top are load-bearing below a = 40 "
          "(%d and %d verdicts change when dropped)" % (live["a6"], live["pp"]),
          live["a6"] > 0 and live["pp"] > 0)

    # gcd(d, 6) = 1 IS REDUNDANT, provably: d | 2^a - 1 is odd, and for odd a
    # (which gcd(a,6) = 1 forces) 3 never divides 2^a - 1, since ord_3(2) = 2.
    # So the clause can never fire once the others hold.  Kept in the predicate
    # as a guard for callers who reach it by another route, but a self-test
    # asserting it bites would fail forever.
    check("gcd(d,6) = 1 is redundant given gcd(a,6) = 1 and d | 2^a - 1 "
          "(0 verdicts change; 3 divides 2^a - 1 only at even a)",
          live["d6"] == 0
          and not any((2 ** a - 1) % 3 == 0 for a in range(1, 40, 2))),

    # THE CYCLICITY CLAUSE IS LOAD-BEARING, but its first witness is a = 155 --
    # far outside the a < 40 the other clauses are exercised at, which is why an
    # earlier form of this test read it as redundant.  A clause whose smallest
    # counterexample sits outside the test range is indistinguishable from a
    # dead one, and the fix is to name the witness, not to widen the sweep:
    # a = 155, d = 31, a' = 31, top = 5.  Here 31 | gcd(d, a'), so C_d x C_{a'}
    # is not cyclic and the split is inadmissible -- yet conditions (i) and
    # (iii) both hold, so dropping the clause would admit it.
    def _nocyc(a, d):
        m = _ord2(d)
        return any((a // ap) % m == 0 and _is_prime_power(a // ap)
                   for ap in divisors(a))

    check("the cyclicity clause gcd(d, a') = 1 is load-bearing, first at "
          "a = 155, d = 31 (admitted without it, rejected with it)",
          galois_admissible(155, 31) is None and _nocyc(155, 31)
          and galois_admissible(253, 23) is None and _nocyc(253, 23))

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
