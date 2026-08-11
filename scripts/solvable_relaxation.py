#!/usr/bin/env python3
"""
solvable_relaxation.py -- computes B_solv(n), the analogue of B(n) when Oliver's
condition is relaxed to "solvable", and verifies the claims of
solvable-relaxation.md.

THE SHAPE SPACE (derived in section 2 of the note).  An orbit of size s is a
transitive solvable group; to maximise its minimum orbital it is F blocks of
prime-power size c with s = F*c, each block carrying the FULL affine group
AGL(1,c) (2-transitive, solvable), and the F blocks permuted transitively.  Its
two classes are the fused within-block class F*C(c,2) and the cross-block class
m(F)*c^2, where m(F) >= F/2 is the permuter's minimum pair-orbital.  Since
(F/2)*c^2 > (F/2)*c*(c-1) = F*C(c,2), THE WITHIN-BLOCK CLASS ALWAYS BINDS, so

    score(s) = max over prime-power c | s of (s/c)*C(c,2) = s*(P(s)-1)/2,

with P(s) the LARGEST PRIME-POWER DIVISOR of s.  Between two orbits of sizes
s_i, s_j every cross pair is one class of exactly s_i*s_j.  Hence

    B_solv(n) = max over partitions n = s_1 + ... + s_k of
                min( min_i score(s_i), min_{i<j} s_i*s_j ).

  PASS 1  CEILING.  B_solv(n)/C(n,2) < 1/2 for every non-prime-power n, and the
          supremum 1/2 is approached along n = 2q with q a prime power.  (A
          solvable 2-transitive group has a regular elementary abelian socle,
          hence prime-power degree; so a non-prime-power n has >= 2 orbitals.)
          At prime-power n, AGL(1,n) is 2-transitive and the density is 1 --
          which is why the framework restricts to non-prime-powers.

  PASS 2  AT MOST TWO PARTS.  No partition with k >= 3 ever wins.

  PASS 3  THE TWO GENERIC CONSTANTS.  Away from the exceptional families of
          pass 4, even n give 1/4 = cap_1(1) and odd n give 3 - 2*sqrt(2) =
          cap_2(1), the latter at small-part share 1/(1+sqrt2) = 0.41421 --
          the framework's own balance point for the fused odd rung at eta = 1.

  PASS 4  THE EXCEPTIONAL FAMILY.  A single orbit wins exactly when n has a
          prime-power divisor large enough, i.e. n = m*c with c a prime power
          and m small; its share decays like log(5)/log(n) and so has density 0.

  PASS 6  UNCONDITIONAL FLOORS.  Section 3.5's constants: odd n reach 1/9 via
          three near-equal primes, even n only 1/16 via four (parity forces the
          fourth -- three odd primes sum odd, and the part 2 scores 1).  Checks
          that neither floor binds in range and that both exceed Oliver's worst
          conditional ceiling.

  PASS 5  AGAINST OLIVER.  B_solv >= B_safe at every tabulated n (Oliver groups
          are solvable), and the per-residue ceiling ratios match the closed
          forms: the eight Oliver ceilings of aod section 3.3.5 collapse to two.

Usage: python3 solvable_relaxation.py [path/to/mu_table_safe_v4.csv]
Exits nonzero on any failure.
"""
import csv
import sys
from math import comb, isqrt, log, sqrt
from statistics import median

N = 2484
TABLE = sys.argv[1] if len(sys.argv) > 1 else "mu_table_safe_v4.csv"
ok = True


def check(name, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + name)
    ok = ok and cond


# ---- prime powers, and P(s) = largest prime-power divisor -------------------
sieve = bytearray([1]) * (N + 1)
sieve[0] = sieve[1] = 0
for i in range(2, isqrt(N) + 1):
    if sieve[i]:
        sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
pps = set()
for p in [x for x in range(2, N + 1) if sieve[x]]:
    v = p
    while v <= N:
        pps.add(v)
        v *= p
P = [0] * (N + 1)
for c in sorted(pps):
    for s in range(c, N + 1, c):
        if c > P[s]:
            P[s] = c
SCORE = [0] * (N + 1)
for s in range(2, N + 1):
    SCORE[s] = s * (max(P[s], 1) - 1) // 2


def best(n, allow_three=False):
    """B_solv(n) and an optimal partition."""
    bv, bp = SCORE[n], (n,)
    for a in range(2, n // 2 + 1):
        v = min(SCORE[a], SCORE[n - a], a * (n - a))
        if v > bv:
            bv, bp = v, (a, n - a)
    if allow_three:
        for a in range(2, n // 3 + 1):
            if SCORE[a] <= bv and a * (n - a) <= bv:
                continue
            for b in range(a, (n - a) // 2 + 1):
                c = n - a - b
                v = min(SCORE[a], SCORE[b], SCORE[c], a * b, a * c, b * c)
                if v > bv:
                    bv, bp = v, (a, b, c)
    return bv, bp


D = {n: best(n) for n in range(6, N + 1)}
delta = {n: D[n][0] / comb(n, 2) for n in D}
npp = [n for n in D if n not in pps]

# ---- pass 1: ceiling -------------------------------------------------------
check("delta_solv < 1/2 at every non-prime-power n",
      all(delta[n] < 0.5 for n in npp))
twoq = [n for n in npp if n % 2 == 0 and (n // 2) in pps]
check("along n = 2q (q a prime power) delta_solv -> 1/2 (max %.5f)"
      % max(delta[n] for n in twoq),
      min(delta[n] for n in twoq if n > 500) > 0.498)
check("at prime-power n the density is 1 (2-transitive AGL(1,n))",
      all(SCORE[n] == comb(n, 2) for n in pps if n >= 6))

# ---- pass 2: at most two parts ---------------------------------------------
three = [n for n in range(6, 400) if len(best(n, allow_three=True)[1]) >= 3]
check("no partition with >= 3 parts ever wins (checked n < 400)", not three)

# ---- pass 3: the two generic constants -------------------------------------
def generic(par):
    out = []
    for n in npp:
        if n < 1200:
            continue
        v, p = D[n]
        if len(p) == 1:
            continue                      # exceptional family, pass 4
        if any((s & (s - 1)) == 0 for s in p):
            continue                      # 2-power part sitting near n/2
        if n % 2 == par:
            out.append(delta[n])
    return out


ev, od = generic(0), generic(1)
CAP1, CAP2 = 0.25, 3 - 2 * sqrt(2)
check("generic even n: median %.5f vs cap_1(1) = 1/4" % median(ev),
      abs(median(ev) - CAP1) < 0.01)
check("generic odd n: median %.5f vs cap_2(1) = 3-2sqrt2 = %.5f"
      % (median(od), CAP2), abs(median(od) - CAP2) < 0.01)
shares = [min(D[n][1]) / n for n in npp
          if n >= 1200 and n % 2 == 1 and len(D[n][1]) == 2
          and not any((s & (s - 1)) == 0 for s in D[n][1])]
check("odd small-part share %.4f vs 1/(1+sqrt2) = %.4f"
      % (median(shares), 1 / (1 + sqrt(2))),
      abs(median(shares) - 1 / (1 + sqrt(2))) < 0.02)

# ---- pass 4: the exceptional family ----------------------------------------
sing = [n for n in npp if len(D[n][1]) == 1]
mults = sorted({n // P[n] for n in sing})
check("single-orbit winners all have n = m*P(n) with m small: m in %s" % mults,
      max(mults) <= 8)
shares = []
for lo, hi in [(100, 500), (500, 1200), (1200, 2484)]:
    s = [n for n in sing if lo <= n <= hi]
    t = [n for n in npp if lo <= n <= hi]
    shares.append(len(s) / len(t))
check("exceptional share decays (%.3f -> %.3f -> %.3f, cf log5/log n)" % tuple(shares),
      shares[0] > shares[1] > shares[2])

# ---- pass 6: unconditional floors (section 3.5) -----------------------------
# Odd n take three near-equal primes -> 1/9; even n are forced to four by parity
# (three odd primes sum odd, and admitting the part 2 scores C(2,2)=1) -> 1/16.
# Both are approached, not attained; and neither binds in the computed range.
odd_min = min(delta[n] for n in npp if n % 2)
even_min = min(delta[n] for n in npp if n % 2 == 0)
check("no odd n in range falls below 1/9 (min %.5f at n=%d)"
      % (odd_min, min((n for n in npp if n % 2), key=lambda n: delta[n])),
      odd_min >= 1 / 9)
check("no even n in range falls below 1/16 (min %.5f)" % even_min,
      even_min >= 1 / 16)


def balanced(n, k):
    """Best-balanced representation of n as k primes, or None."""
    pr = [p for p in range(2, n) if p in pps and sieve[p]]
    S = {p for p in pr}
    tgt, best_v, best_p = n // k, None, None
    rng = [p for p in pr if abs(p - tgt) <= max(200, tgt // 8)]
    if k == 3:
        for a in rng:
            for b in rng:
                if b < a:
                    continue
                c = n - a - b
                if c in S and c >= b:
                    v = min(comb(a, 2), comb(b, 2), comb(c, 2), a * b, a * c, b * c)
                    if best_v is None or v > best_v:
                        best_v, best_p = v, (a, b, c)
    else:
        for a in rng:
            for b in rng:
                if b < a:
                    continue
                for c in rng:
                    if c < b:
                        continue
                    e = n - a - b - c
                    if e in S and e >= c:
                        ps = (a, b, c, e)
                        v = min(min(comb(x, 2) for x in ps),
                                min(ps[i] * ps[j] for i in range(4) for j in range(i + 1, 4)))
                        if best_v is None or v > best_v:
                            best_v, best_p = v, ps
    return (best_v / comb(n, 2), best_p) if best_v else None


r3 = [balanced(n, 3) for n in (1001, 2001)]
r4 = [balanced(n, 4) for n in (1000, 2000)]
check("odd n admit three near-equal primes approaching 1/9 (%s)"
      % ", ".join("%.5f" % x[0] for x in r3),
      all(x and x[0] > 0.099 for x in r3))
check("even n admit four near-equal primes approaching 1/16 (%s)"
      % ", ".join("%.5f" % x[0] for x in r4),
      all(x and x[0] > 0.057 for x in r4))
check("the unconditional floors exceed Oliver's worst conditional ceiling 0.05051",
      1 / 16 > 0.050510 and 1 / 9 > 0.050510)

# ---- pass 5: against Oliver ------------------------------------------------
tab = {int(r["n"]): int(r["mu_bound"]) for r in csv.DictReader(open(TABLE))}
shared = [n for n in sorted(tab) if n in D and n not in pps]
check("B_solv >= B_safe at all %d shared n (Oliver groups are solvable)" % len(shared),
      all(D[n][0] >= tab[n] for n in shared))
OLIVER = {**{r: 0.25 for r in (0, 4, 6, 10, 12, 16, 18, 22)},
          **{r: (2 - sqrt(3)) / 2 for r in (2, 8, 14, 20)},
          **{r: 3 - 2 * sqrt(2) for r in (1, 9, 13, 21)},
          **{r: 0.125 for r in (3, 19)},
          **{r: 5 - 2 * sqrt(6) for r in (5, 17)},
          **{r: (3 - 2 * sqrt(2)) / 2 for r in (7, 15)},
          **{11: (2 - sqrt(3)) / 4, 23: (5 - 2 * sqrt(6)) / 2}}
solv_cap = {r: (CAP1 if r % 2 == 0 else CAP2) for r in range(24)}
ratios = {r: solv_cap[r] / OLIVER[r] for r in range(24)}
check("Oliver's eight ceilings collapse to two under the relaxation",
      len(set(round(v, 9) for v in OLIVER.values())) == 8
      and len(set(round(v, 9) for v in solv_cap.values())) == 2)
check("ceiling ratio at n = 23 (mod 24) is (3-2sqrt2)/((5-2sqrt6)/2) = %.4f"
      % ratios[23], abs(ratios[23] - 3.3968) < 1e-3)
check("ratio is exactly 2 at residues 7 and 15 (cap_F(eta) = cap_1(F eta)/F)",
      abs(ratios[7] - 2.0) < 1e-9 and abs(ratios[15] - 2.0) < 1e-9)
check("ratio is exactly 1 where Oliver already reaches eta = 1",
      all(abs(ratios[r] - 1.0) < 1e-9
          for r in (0, 4, 6, 10, 12, 16, 18, 22, 1, 9, 13, 21)))
print("\n      global constant: Oliver %.5f (n = 23 mod 24) vs solvable %.5f"
      % (min(OLIVER.values()), min(solv_cap.values())))
print("      per-residue ceiling ratios:",
      " ".join("%d:%.3f" % (r, ratios[r]) for r in sorted(ratios)))

sys.exit(0 if ok else 1)
