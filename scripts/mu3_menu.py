#!/usr/bin/env python3
"""
mu3_menu.py -- B_3(n) over the k = 3 census, to a CSV.

WHAT THIS IS, AND WHAT IT IS NOT.  `three-uniform-note.md` §6.2 carries a
caveat that this file is the first half of answering:

    "At k = 2 this kind of statement is backed by `mu_enumerate_v3.py`, which
     enumerates the whole shape space, plus `brute.py` as an independent check.
     HERE THERE IS NO SUCH ENUMERATOR.  The comparison above is a search over a
     hand-specified family ... So 'optimal' means *best in the family searched*."

This script replaces "the family searched by hand at one n" with "every shape in
the §4.2 census, at every n in a range, systematically".  That is a real
upgrade and it is **not** the enumerator §10 item 1 asks for, because the census
itself is not known to be complete at k = 3 (§4 re-analyses the k = 2 shape list
rather than deriving one).  So:

    B_3(n) computed here  =  max over the CENSUS shapes
    mu_3(n)               =  max over ALL admissible configurations

and B_3 >= mu_3 requires the census to be complete, which is open.  **The column
is therefore named `b3_census`, not `mu3`**, and nothing downstream should read
it as mu_3.  What it IS good for: the escape counts of §6, the class ceilings of
§5, and any statement of the form "the best shape at this n is ...", all of
which currently rest on hand searches.

WHAT IS SOUND HERE, AND IT IS THE MAJORITY.  The scoring is not in doubt:

  * the orbit law orb_3(c, d, m) = min(c*d*m/kappa_3, C(c,3)) with
    kappa_3 = tau * theta * gamma is PROVED (modulo one routine stabiliser step)
    and verified exhaustively on 104 (c, d, m) triples (§2.2);
  * ONLY INTRA TERMS BIND, which at k = 2 is false and here is proved in three
    lines by a degree count -- cross terms are cubic in n, intra terms quadratic
    (§4.1).  So the score of a configuration is min over its classes of
    F * orb_3(c, d, m), with no term-type comparison at all.

That second point is why this file is short.  At k = 2 the analogous enumerator
must compare intra, within-class-cross and between-orbit terms; here there is
one term type.

USAGE
    python3 mu3_menu.py --nmax 5000 --out b3_census.csv
    python3 mu3_menu.py 130 140            # lookup to stdout
    python3 mu3_menu.py --check-133        # reproduce §6.2's worked example
"""
import argparse
import csv
import sys
from math import comb, gcd


def sieve_pp(N):
    spf = list(range(N + 1))
    i = 2
    while i * i <= N:
        if spf[i] == i:
            for j in range(i * i, N + 1, i):
                if spf[j] == j:
                    spf[j] = i
        i += 1
    pp = {}                       # c -> (p, a) for prime powers c
    for c in range(2, N + 1):
        x, p, a = c, spf[c], 0
        while x % p == 0:
            x //= p
            a += 1
        if x == 1:
            pp[c] = (p, a)
    return spf, pp


def _is_pp(x):
    """x is a prime power (x > 1)."""
    if x < 2:
        return False
    d = 2
    while d * d <= x:
        if x % d == 0:
            while x % d == 0:
                x //= d
            return x == 1
        d += 1
    return True


def _is_q_power(x, q):
    """x is a power of q, including x = 1."""
    while x % q == 0:
        x //= q
    return x == 1


def least_prime_divisor(x):
    d = 2
    while d * d <= x:
        if x % d == 0:
            return d
        d += 1
    return x


def orb3(c, d, m, p, a):
    """§2.2's law.  kappa_3 = tau * theta * gamma, the three places a stabiliser
    can come from: translations, the twist, the Galois part."""
    tau = 3 if p == 3 else 1
    theta = max(j for j in (1, 2, 3) if d % j == 0)
    if p == 2 and m == a and gcd(a, 6) == 1 and gcd(d, 6) == 1 and a > 1:
        gamma = a // least_prime_divisor(a)      # the RISE case of §2.2.2
    else:
        gamma = m
    kappa = tau * theta * gamma
    return min(c * d * m // kappa if kappa else c * d * m, comb(c, 3))


def qpart(x, q):
    t = 1
    while x % q == 0:
        x //= q
        t *= q
    return t


def best3(n, spf, pp, primes):
    """max over the census shapes of the configuration's score.

    Only intra terms bind (§4.1), so a configuration's score is the minimum over
    its classes of F * orb_3(c, d, m); the search is over partitions of n into a
    matching class F*c and at most one foreign prime r, which is S2/S3/S5/S7 --
    the shapes that win at k = 2.  Three-part shapes are scored too where they
    fit, since §5 needs them for the odd classes.
    """
    best, wit = 0, ""

    def offer(v, w):
        nonlocal best, wit
        if v > best:
            best, wit = v, w

    # ---- S2: a single fused class n = F*c, full twist, Galois part in the top
    #
    # m IS THE ORDER OF THE GALOIS (FROBENIUS) PART, WHICH SITS IN THE TOP
    # LAYER, so the top must contain it and the top is a q-group: **m must be a
    # prime power** here, and a power of the top prime q in the two-part case
    # below.  Omitting that check credited a Galois part no chain can carry, at
    # 295 of 306 rows in the first run of this script -- always m = 5 on a
    # 32-block beside a foreign prime with q != 5.  That is precisely §4.3's
    # warning ("spending the top prime on the Galois gain cripples every foreign
    # block") and the reason §6.2's n = 133 is an *example* rather than a
    # pattern: there 5 is exactly the prime with 5^2 | 100.
    for c, (p, a) in pp.items():
        if c > n or n % c:
            continue
        F = n // c
        for m in [x for x in range(1, a + 1) if a % x == 0 and (x == 1 or _is_pp(x))]:
            offer(F * orb3(c, c - 1, m, p, a), f"{F}x{c} (m={m})")

    # ---- S3/S5/S7: F*c + r*, one foreign prime, top prime q
    for c, (p, a) in pp.items():
        for F in range(1, n // c + 1):
            r = n - F * c
            if r < 5 or spf[r] != r or r == p:
                continue
            # the top prime q must divide r - 1 (Lemma B'); the matching block
            # takes the full twist, the foreign block the q-part -- and the
            # Galois part m, living in the top layer, must be a POWER OF q.
            for q in sorted(_prime_factors(r - 1, spf)):
                t = qpart(r - 1, q)
                for m in [x for x in range(1, a + 1)
                          if a % x == 0 and _is_q_power(x, q)]:
                    mine = F * orb3(c, c - 1, m, p, a)
                    theirs = orb3(r, t, 1, r, 1)
                    offer(min(mine, theirs),
                          f"{F}x{c} + 1x{r}* (m={m}, q={q}, t={t})")
    return best, wit


def _prime_factors(x, spf):
    out = set()
    while x > 1:
        out.add(spf[x])
        p = spf[x]
        while x % p == 0:
            x //= p
    return out


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--nmax", type=int, default=2000)
    ap.add_argument("--out")
    ap.add_argument("--check-133", action="store_true")
    ap.add_argument("lo", type=int, nargs="?")
    ap.add_argument("hi", type=int, nargs="?")
    a = ap.parse_args()

    if a.check_133:
        spf, pp = sieve_pp(400)
        print("§6.2's worked example, recomputed:")
        print("  orb3(32, 31, 5) =", orb3(32, 31, 5, 2, 5), " (note: 4960 = C(32,3))")
        print("  orb3(32, 31, 1) =", orb3(32, 31, 1, 2, 5), " (note: 992)")
        print("  orb3(101, 25, 1) =", orb3(101, 25, 1, 101, 1), " (note: 2525)")
        print("\n  the r-table of §6.2:")
        ok = True
        for r, t, exp in [(11, 5, 55), (41, 5, 205), (71, 5, 355), (101, 25, 2525),
                          (131, 5, 655), (151, 25, 3775), (251, 125, 31375)]:
            got = orb3(r, t, 1, r, 1)
            flag = "" if got == exp else "  <-- MISMATCH"
            ok = ok and got == exp
            print(f"    r={r:4d} t={t:4d}  orb3 = {got:6d}   note says {exp}{flag}")
        print("\n  all agree" if ok else "\n  MISMATCHES ABOVE")
        return 0 if ok else 1

    N = a.hi if a.hi else a.nmax
    spf, pp = sieve_pp(N + 1)
    primes = [x for x in range(2, N + 1) if spf[x] == x]
    lo, hi = (a.lo, a.hi) if a.hi else (6, a.nmax)
    rows = []
    for n in range(lo, hi + 1):
        if n in pp:
            continue
        v, w = best3(n, spf, pp, primes)
        if v:
            rows.append((n, comb(n, 3), v, v / comb(n, 3), w))
    if a.out:
        with open(a.out, "w", newline="") as fh:
            wr = csv.writer(fh)
            wr.writerow(["n", "C(n3)", "b3_census", "delta3", "witness"])
            for r in rows:
                wr.writerow([r[0], r[1], r[2], f"{r[3]:.8f}", r[4]])
        print(f"{a.out}: {len(rows)} rows, n in [{rows[0][0]}, {rows[-1][0]}]")
    else:
        print("n,C(n3),b3_census,delta3,witness")
        for r in rows:
            print(f"{r[0]},{r[1]},{r[2]},{r[3]:.8f},{r[4]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
