#!/usr/bin/env python3
"""lean_model_max.py -- the Lean model's B_safe(n), computed directly, against the ladder table.

The Lean theorems (`PartEMu.e6_mu`, `Bsafe_le_mu`) are about B_safe(n): the maximum of SAFE over
`E6.Config`s satisfying `GAdm`.  Above C(n,2)/25 that maximum is attained by a configuration with
no D2 part, at most one p-characteristic class and at most two foreign parts (`E6.d2_case`,
`Prop1Final.prop1`), each part of size at least (n + 3)/5 (`Prop1.part_share`).  This script
maximises SAFE over exactly that family, with the Lean scoring (`E6.CPart.safeTerms`, `crossN`),
and compares with `mu_bound` in the ladder table.

What a pass shows: the table's value at n is the Lean model's B_safe(n) -- so `e6_mu` is a
statement about the table's numbers, not about a model that happens to share their name.
`lean_score_crosscheck.py` compares the two scorers term by term on random configurations; this
compares the two *maxima* row by row.

  python3 lean_model_max.py ../outputs/mu_table_ladder.csv --nmax 3000
  python3 lean_model_max.py ../outputs/mu_table_ladder.csv --window 100000 100200

Rows at or below the 1/25 line (none exist in the table) are reported and skipped, since there
the family is not known to contain the maximum.
"""
import argparse, csv, sys
from functools import lru_cache


def pairs(n):
    return n * (n - 1) // 2


def orb(c, t):
    v = c * t // 2 if t % 2 == 0 else c * t
    return min(v, pairs(c))


def K0(F):
    return F if F % 2 else F // 2


def sieve(N):
    s = bytearray([1]) * (N + 1)
    s[0:2] = b"\x00\x00"
    for i in range(2, int(N ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = bytearray(len(s[i * i::i]))
    return s


@lru_cache(maxsize=None)
def prime_factors(m):
    out, d = [], 2
    while d * d <= m:
        if m % d == 0:
            out.append(d)
            while m % d == 0:
                m //= d
        d += 1
    if m > 1:
        out.append(m)
    return tuple(out)


def qpart(m, q):
    t = 1
    while m % q == 0:
        m //= q
        t *= q
    return t


@lru_cache(maxsize=None)
def class_options(s):
    """(score, p) for every class F x p^b of total size s, b >= 1, F >= 1: the class's own terms."""
    out = []
    for c in range(2, s + 1):
        if s % c:
            continue
        pf = prime_factors(c)
        if len(pf) != 1:
            continue
        F = s // c
        sc = F * pairs(c)
        if F >= 2:
            sc = min(sc, K0(F) * c * c)
        out.append((sc, pf[0]))
    out.sort(reverse=True)
    return tuple(out)


def best(n, isp, target):
    """max SAFE over the family at n.  `target` only orders the search; the result is exact."""
    lo = (n + 3 + 4) // 5          # every part has size >= (n+3)/5
    best_val, best_cfg = 0, None
    # one class alone
    for sc, p in class_options(n):
        if sc > best_val:
            best_val, best_cfg = sc, f"p={p}: class {n}"
        break
    primes = [r for r in range(max(2, lo), n + 1) if isp[r]]

    def fr_score(r, q):
        return orb(r, qpart(r - 1, q))

    def qs(*rs):
        cand = {2}
        for r in rs:
            cand.update(prime_factors(r - 1) if r > 2 else ())
        return cand

    # foreign parts beside (or instead of) a class
    for i, r1 in enumerate(primes):
        if pairs(r1) <= best_val:
            continue
        # [class] + r1
        s = n - r1
        if s == 0:
            pass
        elif s >= lo:
            for sc, p in class_options(s):
                if min(sc, s * r1, pairs(r1)) <= best_val:
                    break
                if p == r1:
                    continue
                for q in qs(r1):
                    v = min(sc, s * r1, fr_score(r1, q))
                    if v > best_val:
                        best_val, best_cfg = v, f"p={p} q={q}: class {s} + {r1}*"
        for r2 in primes[i + 1:]:
            if r1 + r2 > n:
                break
            if min(pairs(r1), r1 * r2) <= best_val:
                continue
            s = n - r1 - r2
            if s == 0:
                for q in qs(r1, r2):
                    v = min(fr_score(r1, q), fr_score(r2, q), r1 * r2)
                    if v > best_val:
                        best_val, best_cfg = v, f"q={q}: {r1}* + {r2}*"
            elif s >= lo:
                for sc, p in class_options(s):
                    if min(sc, s * r1, r1 * r2) <= best_val:
                        break
                    if p in (r1, r2):
                        continue
                    for q in qs(r1, r2):
                        v = min(sc, s * r1, s * r2, r1 * r2, fr_score(r1, q), fr_score(r2, q))
                        if v > best_val:
                            best_val, best_cfg = v, f"p={p} q={q}: class {s} + {r1}* + {r2}*"
    return best_val, best_cfg


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("table")
    ap.add_argument("--nmax", type=int, default=3000)
    ap.add_argument("--window", type=int, nargs=2)
    a = ap.parse_args()
    lo, hi = (a.window if a.window else (6, a.nmax))
    isp = sieve(hi + 1)
    rows = {}
    with open(a.table) as f:
        for r in csv.DictReader(f):
            n = int(r["n"])
            if lo <= n <= hi:
                rows[n] = int(r["mu_bound"])
            elif n > hi:
                break
    checked = agree = below = 0
    bad = []
    for n, B in sorted(rows.items()):
        if 25 * B <= pairs(n):
            below += 1
            continue
        v, cfg = best(n, isp, B)
        checked += 1
        if v == B:
            agree += 1
        else:
            bad.append((n, B, v, cfg))
    print(f"coverage: {checked} table rows in [{lo}, {hi}] above the 1/25 line "
          f"({len(rows)} rows in range, {below} at or below the line, skipped)")
    print(f"agree: {agree}   differ: {len(bad)}")
    for n, B, v, cfg in bad[:20]:
        print(f"  n={n}: table {B}, Lean model {v} ({cfg})")
    sys.exit(1 if bad or checked == 0 else 0)


if __name__ == "__main__":
    main()
