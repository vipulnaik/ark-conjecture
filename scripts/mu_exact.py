#!/usr/bin/env python3
"""
mu_exact.py -- B(n) by direct arithmetic over the shape space, ~10^3 x faster
than `mu_enumerate_v3.py` and computing THE SAME NUMBER.

WHY THIS EXISTS.  `mu_enumerate_v3.py` is a generic search: it loops over every
(bottom prime p, top prime q) pair -- ~n^2/log^2 n of them -- and for each runs a
recursion over multisets of parts drawn from a pool it rebuilds per pair.  That
is n^2.9 in practice and puts n = 10^4 out of reach.  This file enumerates the
SAME configurations by arithmetic instead: p is read off each part, r is
determined by subtraction, and the multi-part cases are bounded by inequalities
on the score rather than searched.

THE TRUSTED BASE IS IDENTICAL, AND THAT IS THE POINT.  Every restriction here is
either (a) a consequence of the SAFE score -- "this configuration cannot beat the
running best" -- or (b) a re-indexing of the same loop.  None is a new theorem
about groups.  Specifically, this file assumes exactly what v3 assumes:

    Part 0's shape space   matching classes of prime-power blocks sharing one
                           characteristic p, at any block count F; foreign parts
                           are single blocks of PRIME size (Lemma B'), unfused
                           (Lemma D2 domination, range-scoped below n = 1582);
                           distinct foreign primes; foreign twists are powers of
                           one common top prime q; r != p; no fixed points.
    the SAFE score         a matching class is worth F*C(c,2) -- flat, no twist
                           strip, bounding ANY point stabiliser; a foreign part
                           orb(r, q-part of r-1); within-class cross F*c^2 or
                           (F/2)*c^2 by the parity of F; between-class s_i*s_j.
    Proposition F.1        for the k bound, SELF-CERTIFIED as in v3's mu_bound:
                           the answer at cap K is accepted only if 1/sqrt(delta)
                           <= K, so the bound is checked against the value found
                           rather than assumed.  Notably this does NOT import the
                           ladder's delta_lo, which would add a dependency on
                           Part E's realisability that v3 does not have.

WHAT IS RE-INDEXED RATHER THAN ASSUMED.
  * No (p, q) loop.  p is the base of a matching part.  q is FREE in SAFE mode
    for every purpose except the foreign twist -- F = Fmid*Ftop with Fmid any
    integer means every F is reachable at every q, and the matching cap F*C(c,2)
    does not mention q at all.  So q is chosen per foreign part (one foreign
    part) or per foreign pair (two), by maximising, not looped globally.
  * Foreign twist by maximisation.  With one foreign part the best q is the one
    maximising orb(r, q-part of r-1).  CARE: this is NOT "the largest
    prime-power divisor of r-1", because orb halves when the twist is even --
    orb(r, 2^a) = r*2^(a-1) while orb(r, Q) = r*Q for odd Q.  We take the max
    over all prime-power divisors explicitly.
  * Parts are large.  Every pair of parts contributes s_i*s_j >= B, so each part
    has size >= B/n; and a foreign part needs orb(r, Q) >= B with orb <= C(r,2),
    so r >= sqrt(2B).  At the densities in range that puts every part above
    ~0.15n, which is what makes the multi-part cases cheap rather than
    quadratic.

PRUNES THAT ARE SCORE INEQUALITIES, NOT THEOREMS.
  * Two matching classes of the SAME block size c are dominated by the single
    fused class of F1+F2 blocks: min(F1,F2)*C(c,2) < (F1+F2)*C(c,2), and the
    cross term c^2*F1*F2 exceeds neither.  Skipping them cannot change B(n).
  * Two matching classes of DIFFERENT sizes have c2 <= c1/p, so the smaller
    class caps at F2*C(c1/p, 2); the configuration is bounded by that.  Applied
    as "cap < best -> skip", exactly like v3's `pt.cap >= floor`.
  * A part pool is filtered by cap >= running best, non-strictly, so a
    configuration that ties still records a witness (as in v3).

WHAT THIS IS NOT.  Not a lower-bound engine: it makes no realisability claim, so
it is not a replacement for `ladder_verify.py` and it does not apply Lemma C's
foreign strip (SAFE deliberately does not).  Use --refined for v3's refined
score if you want the strip; the default and the only mode the documents quote
is SAFE.

COST.  Measured: 4.6 s to n = 2,000; 46 s to 5,000; 158 s to 8,000 -- the whole
run scales as ~n^2.5, so a single-threaded pass to 10^5 is ~20 h.  Use --chunks:
the heaviest of 8 equal-work chunks took 281 s at nmax = 20,000, which puts an
8-way parallel run to 10^5 at ~4.5 h wall.  Chunks are independent (each
rebuilds the sieve to nmax), so this is `xargs -P8` and a `cat`, not a rewrite.

Usage:
    # 8-way parallel to 10^5, ~4.5 h wall
    seq 1 8 | xargs -P8 -I{} python3 mu_exact.py --nmax 100000 --chunks {}/8
    cat mu_table_exact.csv.part{1..8} > mu_table_exact_1e5.csv

    python3 mu_exact.py --nmax 10000                   # single-threaded
    python3 mu_exact.py --validate mu_table_safe_v5_code_v3.csv
    python3 mu_exact.py --cross 3000 12000 40          # spot-check vs v3
"""
import argparse
import csv
import sys
from math import comb, isqrt


# ---------------------------------------------------------------- arithmetic
def sieve_spf(N):
    spf = list(range(N + 1))
    i = 2
    while i * i <= N:
        if spf[i] == i:
            for j in range(i * i, N + 1, i):
                if spf[j] == j:
                    spf[j] = i
        i += 1
    return spf


def factor(x, spf):
    f = {}
    while x > 1:
        p = spf[x]
        e = 0
        while x % p == 0:
            x //= p
            e += 1
        f[p] = e
    return f


def prime_power(x, spf):
    """(p, a) if x = p^a with a >= 1, else None."""
    if x < 2:
        return None
    f = factor(x, spf)
    if len(f) != 1:
        return None
    p = next(iter(f))
    return (p, f[p])


def is_prime(x, spf):
    return x > 1 and spf[x] == x


def orb(c, t, char2):
    """Intra-block orbital size -- byte-identical semantics to v3's orb()."""
    raw = c * t // 2 if (char2 or t % 2 == 0) else c * t
    return min(raw, comb(c, 2))


def qpart(x, q):
    t = 1
    while x % (t * q) == 0:
        t *= q
    return t


# ---------------------------------------------------------------- foreign table
class Foreign:
    """Per-prime data for foreign parts, precomputed once for the whole range.

    `best_orb[r]` is max over prime-power divisors Q of r-1 of orb(r, Q, False),
    i.e. the value a foreign part of size r can reach when q is free (one foreign
    part in the configuration).  `primes_by_q[q]` lists the primes r with q | r-1
    together with orb(r, q-part), for the case of two or more foreign parts,
    which must share q.

    The maximisation is over prime-power divisors and not simply the largest,
    because orb halves for even twists: at r = 41, r-1 = 40, the largest
    prime-power divisor is 8 giving orb = 164, while Q = 5 gives orb = 205.
    """

    def __init__(self, N, spf):
        self.N = N
        self.spf = spf
        self.best_orb = [0] * (N + 1)
        self.best_q = [0] * (N + 1)
        self.by_q = {}
        for r in range(2, N + 1):
            if spf[r] != r:
                continue
            f = factor(r - 1, spf)
            bo, bq = 0, 0
            for q, e in f.items():
                Q = q ** e
                v = orb(r, Q, False)
                self.by_q.setdefault(q, []).append((r, v))
                if v > bo:
                    bo, bq = v, q
            if not f:                      # r = 2, r-1 = 1: trivial twist
                bo, bq = orb(r, 1, False), 0
            self.best_orb[r] = bo
            self.best_q[r] = bq
        for q in self.by_q:
            self.by_q[q].sort()

    def shared(self, r1, r2):
        """max over common top primes q of min(orb(r1,.), orb(r2,.)); 0 if none."""
        f1 = factor(r1 - 1, self.spf)
        f2 = factor(r2 - 1, self.spf)
        best = 0
        for q in set(f1) & set(f2):
            v = min(orb(r1, q ** f1[q], False), orb(r2, q ** f2[q], False))
            if v > best:
                best = v
        return best

    def shared3(self, rs):
        fs = [factor(r - 1, self.spf) for r in rs]
        common = set(fs[0])
        for f in fs[1:]:
            common &= set(f)
        best = 0
        for q in common:
            v = min(orb(r, f[q] and q ** f[q], False) for r, f in zip(rs, fs))
            if v > best:
                best = v
        return best


# ---------------------------------------------------------------- the search
def coeff(F):
    return F if F % 2 else F // 2


class Cfg:
    """A configuration under construction: matching classes all of char p."""
    __slots__ = ("p", "parts", "used")

    def __init__(self, p):
        self.p = p
        self.parts = []          # (F, c, size, cap, cb)
        self.used = 0


def score(match_parts, foreign_sizes, foreign_val):
    """SAFE score of a complete configuration.

    match_parts: (F, c, size, cap, cb) with cap = F*C(c,2), cb the within-class
    cross term or None.  foreign_val: the min over foreign parts of their
    orbital, already maximised over the admissible q.  Mirrors v3's `value`.
    """
    terms = []
    sizes = []
    for F, c, size, cap, cb in match_parts:
        terms.append(cap)
        if cb is not None:
            terms.append(cb)
        sizes.append(size)
    if foreign_sizes:
        terms.append(foreign_val)
        sizes.extend(foreign_sizes)
    for i in range(len(sizes)):
        for j in range(i + 1, len(sizes)):
            terms.append(sizes[i] * sizes[j])
    return min(terms)


def best_for_n(n, spf, FT, kmax=6):
    """max SAFE score over the shape space at n; returns (value, witness, k)."""
    N2 = comb(n, 2)
    best, wit, bestk = 0, "", 0

    pp_n = prime_power(n, spf)
    if pp_n:
        return N2, f"p={pp_n[0]} q=2: 1x{n}", 1

    # ---- matching-part pool, keyed by characteristic p ----------------
    # A matching part is (F, c) with c = p^a; cap = F*C(c,2) (flat, SAFE).
    pools = {}
    for c in range(2, n + 1):
        pc = prime_power(c, spf)
        if not pc:
            continue
        p = pc[0]
        Cc2 = comb(c, 2)
        for F in range(1, n // c + 1):
            size = F * c
            if size > n - 2 and size != n:
                break
            cap = F * Cc2
            cb = coeff(F) * c * c if F > 1 else None
            pools.setdefault(p, []).append((F, c, size, cap, cb))
    for p in pools:
        pools[p].sort(key=lambda t: -t[2])

    def consider(mparts, fsizes, fval, tag):
        nonlocal best, wit, bestk
        v = score(mparts, fsizes, fval)
        if v > best:
            best = v
            wit = tag
            bestk = len(mparts) + len(fsizes)

    # ---- k = 1: one matching class filling n ---------------------------
    for p, pool in pools.items():
        for F, c, size, cap, cb in pool:
            if size != n:
                continue
            consider([(F, c, size, cap, cb)], [], 0,
                     f"p={p} q=2: {F}x{c}")

    # ---- recursive fill with matching classes, then foreign completion --
    def fill(p, pool, idx, chosen, rem, capmin):
        """Add matching classes from pool[idx:], then complete with foreigns."""
        nonlocal best
        # completion with 0..3 foreign parts
        if chosen:
            complete(p, chosen, rem)
        if len(chosen) >= kmax:
            return
        for i in range(idx, len(pool)):
            F, c, size, cap, cb = pool[i]
            if size > rem:
                continue
            # score inequality: this class caps the whole configuration
            if cap <= best:
                continue
            if cb is not None and cb <= best:
                continue
            # same block size as an existing class is dominated by fusing them
            if any(c == cc for _, cc, _, _, _ in chosen):
                continue
            # every pair of parts contributes size_i*size_j
            if chosen and min(s for _, _, s, _, _ in chosen) * size <= best:
                continue
            chosen.append(pool[i])
            fill(p, pool, i + 1, chosen, rem - size, min(capmin, cap))
            chosen.pop()

    def complete(p, chosen, rem):
        msizes = [s for _, _, s, _, _ in chosen]
        mmin = min(msizes)
        if rem == 0:
            consider(list(chosen), [], 0, tag_of(p, chosen, []))
            return
        # one foreign part
        if is_prime(rem, spf) and rem != p:
            v = FT.best_orb[rem]
            if v > best and mmin * rem > best:
                consider(list(chosen), [rem], v, tag_of(p, chosen, [rem]))
        # two or three foreign parts: each needs orb >= best, so r >= sqrt(2*best)
        if rem >= 6 and best > 0:
            rmin = isqrt(2 * best) + 1
            if 2 * rmin <= rem:
                for r1 in range(rmin, rem // 2 + 1):
                    if not is_prime(r1, spf) or r1 == p:
                        continue
                    if FT.best_orb[r1] <= best or mmin * r1 <= best:
                        continue
                    r2 = rem - r1
                    if r2 == r1 or not is_prime(r2, spf) or r2 == p:
                        continue
                    if FT.best_orb[r2] <= best or r1 * r2 <= best:
                        continue
                    v = FT.shared(r1, r2)
                    if v > best:
                        consider(list(chosen), [r1, r2], v,
                                 tag_of(p, chosen, [r1, r2]))

    def tag_of(p, chosen, fs):
        bits = [f"{F}x{c}" for F, c, _, _, _ in chosen]
        bits += [f"1x{r}*" for r in fs]
        q = FT.best_q[fs[0]] if len(fs) == 1 else (
            _shared_q(fs, spf) if len(fs) > 1 else 2)
        return f"p={p} q={q}: " + " + ".join(bits) + (
            "   (* foreign)" if fs else "")

    def _shared_q(fs, spf):
        fsets = [set(factor(r - 1, spf)) for r in fs]
        common = set.intersection(*fsets)
        return min(common) if common else 2

    for p, pool in pools.items():
        fill(p, pool, 0, [], n, 1 << 62)

    # ---- all-foreign configurations (no matching class) -----------------
    if best > 0:
        rmin = isqrt(2 * best) + 1
        for r1 in range(rmin, n // 2 + 1):
            if not is_prime(r1, spf) or FT.best_orb[r1] <= best:
                continue
            r2 = n - r1
            if r2 == r1 or r2 > n or not is_prime(r2, spf):
                continue
            if FT.best_orb[r2] <= best or r1 * r2 <= best:
                continue
            v = FT.shared(r1, r2)
            if v > best:
                consider([], [r1, r2], v,
                         f"p=0 q={_shared_q([r1, r2], spf)}: 1x{r1}* + 1x{r2}*"
                         "   (* foreign)")
    return best, wit, bestk


def mu_bound(n, spf, FT):
    """B(n) with F.1 self-certification, as in v3's mu_bound."""
    v, wit, k = best_for_n(n, spf, FT)
    N2 = comb(n, 2)
    delta = v / N2 if N2 else 0
    certified = bool(delta > 0 and 1 / delta ** 0.5 >= k)
    return v, wit, k, certified


# ---------------------------------------------------------------- driver
HEADER = ["n", "C(n2)", "mu_bound", "density", "parts", "certified_K",
          "partcap", "certified", "fallback", "witness"]


def run(nmax, out, start=2, header=True):
    """Rows for n in [start, nmax].

    The sieve and the Foreign table are built to nmax regardless of start, so a
    chunk is independent of every other chunk and chunks can be run in parallel
    and concatenated.  That matters: the per-n cost grows as ~n^1.5 (the whole
    run is ~n^2.5), so a single-threaded pass to 10^5 is ~20 h while eight
    EQUAL-WORK chunks are ~2.5 h.  Equal work is not equal width -- the last
    decade costs far more than the first -- so split on cumulative n^1.5, not on
    n.  `--chunks i/N` does that for you.
    """
    spf = sieve_spf(nmax + 2)
    FT = Foreign(nmax + 1, spf)
    mode = "w" if header else "a"
    with open(out, mode, newline="") as fh:
        w = csv.writer(fh)
        if header:
            w.writerow(HEADER)
        for n in range(start, nmax + 1):
            if prime_power(n, spf):
                continue
            v, wit, k, cert = mu_bound(n, spf, FT)
            N2 = comb(n, 2)
            w.writerow([n, N2, v, f"{v / N2:.6f}", k, k, k,
                        int(cert), 0, wit])
    return out


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--nmax", type=int, default=1000)
    ap.add_argument("--out", default="mu_table_exact.csv")
    ap.add_argument("--chunks", metavar="i/N",
                    help="run only chunk i of N, split for EQUAL WORK (on "
                         "cumulative n^1.5, not equal width).  Writes "
                         "<out>.part<i>; concatenate in order afterwards, "
                         "keeping only the first header.  Chunks are "
                         "independent -- each rebuilds the sieve to nmax.")
    ap.add_argument("--validate", metavar="CSV",
                    help="compare every row against a v3-produced table")
    ap.add_argument("--cross", nargs=3, type=int, metavar=("LO", "HI", "K"),
                    help="cross-check K random n in [LO,HI) against "
                         "mu_enumerate_v3.mu_bound directly")
    a = ap.parse_args()

    if a.validate:
        rows = list(csv.DictReader(open(a.validate)))
        nmax = max(int(r["n"]) for r in rows)
        spf = sieve_spf(nmax + 2)
        FT = Foreign(nmax + 1, spf)
        bad = low = high = 0
        for r in rows:
            n = int(r["n"])
            ref = int(r["mu_bound"])
            v, wit, k, cert = mu_bound(n, spf, FT)
            if v != ref:
                bad += 1
                if v < ref:
                    low += 1
                else:
                    high += 1
                if bad <= 12:
                    print(f"  n={n}: fast {v} vs v3 {ref}  "
                          f"[{wit}] vs [{r['witness']}]")
        print(f"{len(rows)} rows: {bad} mismatches "
              f"({low} low = MISSING SHAPE, {high} high = OVER-SCORE)")
        return 1 if bad else 0

    if a.cross:
        import random
        import mu_enumerate_v3 as v3
        lo, hi, K = a.cross
        spf = sieve_spf(hi + 2)
        FT = Foreign(hi + 1, spf)
        ns = [n for n in range(lo, hi) if not prime_power(n, spf)]
        random.seed(0)
        random.shuffle(ns)
        bad = 0
        for n in ns[:K]:
            v, wit, k, _ = mu_bound(n, spf, FT)
            ref, rwit, rk, rc = v3.mu_bound(n, spf)
            flag = "OK " if v == ref else "MISMATCH"
            if v != ref:
                bad += 1
            print(f"  n={n:6d}  fast {v:12d}  v3 {ref:12d}  {flag}  [{wit}]")
        print(f"{K} cross-checks, {bad} mismatches")
        return 1 if bad else 0

    if a.chunks:
        i, N = (int(x) for x in a.chunks.split("/"))
        if not 1 <= i <= N:
            print("--chunks i/N needs 1 <= i <= N")
            return 2
        # equal work, not equal width: cost per n grows ~n^1.5, so split the
        # range at equal increments of the integral, i.e. at nmax*(j/N)^(2/5).
        edge = lambda j: max(2, int(a.nmax * (j / N) ** 0.4))
        lo = edge(i - 1) + 1 if i > 1 else 2
        hi = edge(i) if i < N else a.nmax
        out = f"{a.out}.part{i}"
        run(hi, out, start=lo, header=(i == 1))
        print(f"wrote {out}  (n in [{lo}, {hi}])")
        return 0

    run(a.nmax, a.out)
    print(f"wrote {a.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
