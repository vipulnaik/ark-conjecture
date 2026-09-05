#!/usr/bin/env python3
"""
mu_ladder_exact.py -- B(n) EXACTLY, at ladder cost, wherever B(n) > C(n,2)/25.

THE IDEA.  `mu_exact.py` enumerates the whole shape space at every n because it
has to be an upper bound: it does not know in advance which shapes can win.  Two
theorems now say which can, above one explicit density:

  * Theorem E.5 (`enumeration-proof.md` Part E-prime-prime-prime): above
    delta = 1/25 the SAFE optimum is fallback-free, so every matching class is
    worth its flat F*C(c,2) and no twist strip is in play.
  * Proposition 1 (`ladder-completeness.md`): above delta = 1/25 a B-optimal
    configuration is one of
        S2   one fused class, n = F*c
        S3   c + r*
        S4 / S5 / S7 at F = 2   the three readings of 2c + r*
        S7   F*c + r*, 3 <= F <= 16
        S6   r1* + r2*           (two foreign primes, common top prime q)
        S11  F*c + r1* + r2*     (one matching class + two foreign, common q)
    and nothing else -- in particular not S12 (two matching classes of distinct
    size), which the merged fused class dominates, and not three foreign primes.

So B(n) above 1/25 is the maximum of the SAFE scores of exactly those shapes,
and each is enumerable in O(n / log n): the menu shapes scan one prime power c
per configuration, and S6/S11 need both foreign primes EFFICIENT -- r - 1 =
k*q^e with small k -- which groups them by q into lists of bounded length.

WHAT IS CERTIFIED, AND WHAT IS NOT.  If the maximum found exceeds C(n,2)/25 the
result is B(n) exactly, by the two theorems, with a witness -- no conjecture is
consulted.  If it does not, EVERY pruning step above was unjustified: the
fallback skip (E.5), the share > 1/5 cuts, F <= 16, the efficient-prime cut and
the S12 / three-foreign exclusions all assume delta > 1/25.  The value is still
a valid lower bound -- each scored configuration is admissible -- but it may sit
strictly below B(n), and the true optimum may be a FALLBACK configuration, which
is the one regime where B_safe and B_refined can differ and Corollary E.6 does
not apply.  Such an n would also be the first counterexample to the 1/25 floor
conjecture.  So the script does not merely flag it:

  * per-n output marks the row `certified = 0` and writes `LOWER-BOUND-ONLY` in
    the witness column ahead of the best menu witness;
  * with `--on-uncertified exact` (the default when `mu_exact.py` is importable
    from the same directory) it hands the n to `mu_exact.best_for_n`, reports
    both values, and says whether mu_exact's optimum is a fallback
    configuration -- in which case `fallback_cert.py` is the next step, since
    mu(n) = B(n) is then not established at that n by any theorem;
  * `--check` counts uncertified rows separately and lists every one, whatever
    the comparison says, because a clean value comparison at such a row is a
    coincidence and not a certification.

On the current table no n is uncertified (the floor is 0.04621 at n = 2759).
Two small-n caveats, both inside the certified table: Theorem E.5 has fifteen
listed exceptions at n <= 63, so the `certified` flag there rests on the table
rather than on the theorem; and the S11 fusion count is bounded by FMAX like
S7's, which the same cap argument justifies.

MEASURED.  Against `mu_table_exact.csv` (32,861 rows to n = 36,848): equal at
every row, 0 low, 0 high, 0 uncertified, 2.3 ms per n.  At n ~ 10^5: 10 ms per
n; at n ~ 10^6: 89 ms per n, against roughly three hours per value for
`mu_exact.py` extrapolated to that size.  So this is exact B(n) at ladder cost,
and it is what makes B(n) -- hence mu(n) by Corollary E.6 -- computable to 10^6
and beyond without a conjecture.

WHAT THIS IS NOT.  Not `mu_fast.py` (2026-07), which was a family menu written
before the shape space was understood and is superseded; and not a replacement
for `mu_exact.py`, whose exhaustive search is the independent route that proves
the theorems this file leans on were applied correctly.  The two must agree
wherever both are run; `--check TABLE` does that comparison.

SCORING.  SAFE throughout, identical to mu_exact.py's: a matching class F*C(c,2);
within-class cross (F/2)*c^2 at even F, F*c^2 at odd F; a foreign block
orb(r, q-part of r-1) = r*t or r*t/2 as t is odd or even, capped at C(r,2);
between-part cross s_i*s_j.  q is chosen freely per configuration: for the
menu shapes the best q for the single foreign block, for S6/S11 the best q
COMMON to both foreign blocks.  A configuration with r | c-1 is skipped (it is
a fallback and cannot be optimal above 1/25); a foreign prime equal to p is
skipped (r != p).

USAGE
    python3 mu_ladder_exact.py 5000 8000            # print B(n) for n in range
    python3 mu_ladder_exact.py --check mu_table_exact.csv
    python3 mu_ladder_exact.py --check mu_table_exact.csv --time
"""
import argparse
import csv
import sys
import time
from bisect import bisect_left, bisect_right
from collections import defaultdict
from math import comb, isqrt

KMAX_EFF = 40      # r-1 = k*q^e with k <= KMAX_EFF; k < 32 suffices (see note)
CERT_DELTA = 1 / 25   # certification threshold; --cert-threshold RAISES it for testing the
                      # uncertified path (raising is safe: the pruning assumes 1/25 regardless)
FMAX = 16          # cap_F(1) = 1/(1+sqrt F)^2 < 1/25 for F >= 17


def sieve_spf(N):
    spf = list(range(N + 1))
    for i in range(2, isqrt(N) + 1):
        if spf[i] == i:
            for j in range(i * i, N + 1, i):
                if spf[j] == j:
                    spf[j] = i
    return spf


class Arith:
    def __init__(self, N):
        self.N = N
        self.spf = sieve_spf(N + 1)
        self.pp = [None] * (N + 2)        # c -> (p, a) or None
        for c in range(2, N + 2):
            if c > N:
                break
            x, p = c, self.spf[c]
            a = 0
            while x % p == 0:
                x //= p; a += 1
            self.pp[c] = (p, a) if x == 1 else None
        self.primes = [x for x in range(2, N + 1) if self.spf[x] == x]
        # best single-q foreign value, and the q attaining it
        self.best_orb = [0] * (N + 1)
        self.best_q = [0] * (N + 1)
        # efficient primes by q: q -> sorted list of (r, t)
        self.eff = defaultdict(list)
        for r in self.primes:
            if r == 2:
                continue
            m = r - 1
            bo, bq = 0, 0
            x = m
            while x > 1:
                q = self.spf[x]
                t = 1
                while x % q == 0:
                    x //= q; t *= q
                v = orb(r, t)
                if v > bo:
                    bo, bq = v, q
                if m // t <= KMAX_EFF:
                    self.eff[q].append((r, t))
            self.best_orb[r], self.best_q[r] = bo, bq

    def is_prime(self, x):
        return 1 < x <= self.N and self.spf[x] == x


def orb(r, t):
    return min(r * t if t % 2 else r * t // 2, comb(r, 2))


def coeff(F):
    return F if F % 2 else F // 2


def qpart(x, q):
    t = 1
    while x % (t * q) == 0:
        t *= q
    return t


def best_for_n(n, A):
    """(B, witness, certified).  certified iff B > C(n,2)/25."""
    C2 = comb(n, 2)
    pp = A.pp[n]
    if pp:
        return C2, f"p={pp[0]} q=2: 1x{n}", True
    best, wit = 0, ""

    def upd(v, w):
        nonlocal best, wit
        if v > best:
            best, wit = v, w

    PP = A.pp
    # ---- S2: one fused class, every F | n with n/F a prime power ----------
    for F in range(2, isqrt(n) + 1):
        if n % F:
            continue
        for FF in (F, n // F):
            c = n // FF
            if PP[c]:
                upd(min(FF * comb(c, 2), coeff(FF) * c * c), f"p={PP[c][0]} q=2: {FF}x{c}")
    # ---- S3, S7 (F = 1..16): F*c + r*, one foreign at its best q ------------
    lo_c = n // (5 * FMAX)             # every part has share > 1/5
    for c in range(max(2, lo_c), n):
        pc = PP[c]
        if not pc:
            continue
        p = pc[0]
        for F in range(1, FMAX + 1):
            r = n - F * c
            if r < 3:
                break
            if 5 * r <= n:              # foreign part must have share > 1/5
                continue
            if 5 * F * c <= n:          # so must the class
                continue
            if not A.is_prime(r) or r == p or (c - 1) % r == 0:
                continue
            fo = A.best_orb[r]
            if fo <= best:
                continue
            intra = F * comb(c, 2)
            v = min(intra, fo, F * c * r) if F == 1 else min(intra, coeff(F) * c * c, fo, F * c * r)
            if v > best:
                upd(v, f"p={p} q={A.best_q[r]}: {F}x{c} + 1x{r}*   (* foreign)")
    # ---- S6 and S11: two foreign primes at a common q ----------------------
    if best > 0:
        for q, lst in A.eff.items():
            # candidates in (n/5, n) -- both foreign parts have share > 1/5
            i0 = bisect_right(lst, (n // 5, 10**9))
            i1 = bisect_left(lst, (n, 0))
            cand = lst[i0:i1]
            for i in range(len(cand)):
                r1, t1 = cand[i]
                o1 = orb(r1, t1)
                if o1 <= best:
                    continue
                for j in range(i + 1, len(cand)):
                    r2, t2 = cand[j]
                    if r1 + r2 > n:
                        break
                    o2 = orb(r2, t2)
                    if o2 <= best or r1 * r2 <= best:
                        continue
                    rest = n - r1 - r2
                    if rest == 0:
                        upd(min(o1, o2, r1 * r2),
                            f"p=0 q={q}: 1x{r1}* + 1x{r2}*   (* foreign)")
                        continue
                    if 5 * rest <= n:
                        continue
                    # S11: the rest is one matching class F*c
                    for F in range(1, FMAX + 1):
                        if rest % F:
                            continue
                        c = rest // F
                        pc = PP[c]
                        if not pc or pc[0] in (r1, r2):
                            continue
                        if (c - 1) % r1 == 0 or (c - 1) % r2 == 0:
                            continue
                        intra = F * comb(c, 2)
                        v = min(intra, o1, o2, F * c * r1, F * c * r2, r1 * r2)
                        if F > 1:
                            v = min(v, coeff(F) * c * c)
                        if v > best:
                            upd(v, f"p={pc[0]} q={q}: {F}x{c} + 1x{r1}* + 1x{r2}*   (* foreign)")
    return best, wit, best > CERT_DELTA * C2


def load_mu_exact():
    """Import mu_exact.py from this file's directory, or return None."""
    import importlib.util, os
    here = os.path.dirname(os.path.abspath(__file__))
    for cand in (os.path.join(here, "mu_exact.py"), "mu_exact.py"):
        if os.path.exists(cand):
            spec = importlib.util.spec_from_file_location("mu_exact", cand)
            mod = importlib.util.module_from_spec(spec)
            spec.loader.exec_module(mod)
            return mod
    return None


_EXACT_CACHE = {}


def exhaustive(n, exact):
    """mu_exact's B(n) at this n: (value, witness, is_fallback).  Its Foreign
    table is built once per size class and cached."""
    N = 1 << (n.bit_length())
    if N not in _EXACT_CACHE:
        spf = exact.sieve_spf(N + 1)
        _EXACT_CACHE[N] = (spf, exact.Foreign(N + 1, spf))
    spf, FT = _EXACT_CACHE[N]
    v, wit, k, cert = exact.mu_bound(n, spf, FT)
    # a fallback configuration is one whose foreign prime divides c - 1 for a
    # matching class; read it off the witness
    import re
    parts = re.findall(r"(\d+)x(\d+)(\*?)", wit)
    cs = [int(c) for F, c, s in parts if not s]
    rs = [int(c) for F, c, s in parts if s]
    fb = any((c - 1) % r == 0 for c in cs for r in rs)
    return v, wit, fb


def report_uncertified(n, v, w, exact):
    C2 = comb(n, 2)
    thr = "1/25" if abs(CERT_DELTA - 1 / 25) < 1e-12 else f"the test threshold {CERT_DELTA}"
    print(f"# n={n}: menu+S6/S11 maximum {v} = {v/C2:.6f} C(n,2) does NOT clear {thr} -- "
          f"LOWER BOUND ONLY; the pruning theorems do not apply here", file=sys.stderr)
    if exact is None:
        print(f"#        run mu_exact.py at n={n} (and fallback_cert.py if its optimum is a "
              f"fallback configuration)", file=sys.stderr)
        return None
    ev, ew, fb = exhaustive(n, exact)
    tag = "FALLBACK configuration -- B_safe may exceed B_refined here; run fallback_cert.py" \
          if fb else "fallback-free -- mu(n) = B(n) still holds at this n by Part E"
    print(f"#        mu_exact.py: B({n}) = {ev} = {ev/C2:.6f} C(n,2)  [{ew.split('(')[0].strip()}]  "
          f"{'(menu value was exact)' if ev == v else f'(menu value short by {ev - v})'}; {tag}",
          file=sys.stderr)
    return ev, ew, fb


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("lo", type=int, nargs="?", default=6)
    ap.add_argument("hi", type=int, nargs="?", default=1000)
    ap.add_argument("--check", metavar="TABLE", help="compare against a mu_table CSV")
    ap.add_argument("--time", action="store_true")
    ap.add_argument("--on-uncertified", choices=["exact", "flag"], default=None,
                    help="at an n whose maximum does not clear C(n,2)/25: 'exact' hands "
                         "it to mu_exact.py's exhaustive search (default if importable), "
                         "'flag' only marks it")
    ap.add_argument("--cert-threshold", type=float, default=None,
                    help="TEST ONLY: certify only above this density instead of 1/25 -- exercises "
                         "the uncertified path on real rows (e.g. 0.05 makes n = 2759 uncertified). "
                         "Lowering it below 1/25 is refused, since the pruning assumes 1/25.")
    a = ap.parse_args()
    global CERT_DELTA
    if a.cert_threshold is not None:
        if a.cert_threshold < 1 / 25:
            sys.exit("--cert-threshold below 1/25 would certify what the theorems do not cover")
        CERT_DELTA = a.cert_threshold
    exact = load_mu_exact() if a.on_uncertified != "flag" else None
    if a.on_uncertified == "exact" and exact is None:
        sys.exit("--on-uncertified exact: mu_exact.py not importable from this directory")
    if a.check:
        rows = list(csv.DictReader(open(a.check)))
        N = max(int(r["n"]) for r in rows)
        t0 = time.perf_counter(); A = Arith(N + 1); t1 = time.perf_counter()
        eq = low = high = uncert = 0
        bad = []
        unc_rows = []
        for r in rows:
            n, B = int(r["n"]), int(r["mu_bound"])
            v, w, cert = best_for_n(n, A)
            if not cert:
                uncert += 1
                unc_rows.append((n, v, B))
            if v == B:
                eq += 1
            elif v < B:
                low += 1; bad.append((n, v, B, "LOW", w, r["witness"].split("(")[0].strip()))
            else:
                high += 1; bad.append((n, v, B, "HIGH", w, r["witness"].split("(")[0].strip()))
        t2 = time.perf_counter()
        print(f"{a.check}: {len(rows)} rows to n = {N}")
        print(f"equal {eq}, LOW {low}, HIGH {high}; uncertified (B <= C(n,2)/25) {uncert}")
        for b in bad[:12]:
            print("  ", b)
        if unc_rows:
            print(f"UNCERTIFIED rows (value comparison at these is NOT a certification):")
            for n, v, B in unc_rows[:20]:
                print(f"   n={n}: menu {v}, table {B}, table density {B/comb(n,2):.6f}")
                if exact is not None:
                    report_uncertified(n, v, "", exact)
        if a.time:
            print(f"sieve {t1-t0:.1f}s; per-n {1000*(t2-t1)/len(rows):.3f} ms average over the table")
        sys.exit(1 if bad else 0)
    A = Arith(a.hi + 1)
    print("n,C(n2),mu_bound,density,certified,witness")
    for n in range(a.lo, a.hi + 1):
        if A.pp[n]:
            continue
        v, w, cert = best_for_n(n, A)
        if not cert:
            res = report_uncertified(n, v, w, exact)
            if res is not None:
                ev, ew, fb = res
                print(f"{n},{comb(n,2)},{ev},{ev/comb(n,2):.6f},0,"
                      f"EXHAUSTIVE{'-FALLBACK' if fb else ''}: {ew}")
                continue
            print(f"{n},{comb(n,2)},{v},{v/comb(n,2):.6f},0,LOWER-BOUND-ONLY: {w}")
            continue
        print(f"{n},{comb(n,2)},{v},{v/comb(n,2):.6f},1,{w}")


if __name__ == "__main__":
    main()
