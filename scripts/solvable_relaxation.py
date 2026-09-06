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
          that neither floor binds in range, and compares each against Oliver's
          worst conditional ceiling 7-4sqrt3 = 0.07180 -- which the odd floor
          exceeds and the even floor does not.  The asymmetry is the section's
          headline and is asserted in that form.

  PASS 5  AGAINST OLIVER.  B_solv >= B_safe at every tabulated n (Oliver groups
          are solvable), and the per-residue ceiling ratios match the closed
          forms: the six Oliver ceilings of aod section 3.3.5, keyed mod 12,
          collapse to two.

          The keying is mod 12, not mod 24.  A fused rung is reachable at full
          twist at every odd n -- the block-permutation image is a QUOTIENT of
          the cyclic layer, not a subgroup, so one entangled generator supplies
          the block count and the full twist together -- so no mod-8 condition
          survives into the ceiling.  Residues 7 and 15 (mod 24) therefore sit
          at eta = 1/2 with the rest of class 3 mod 12, not at eta = 1.

Usage: python3 solvable_relaxation.py [path/to/current_mu_table.csv]
       QUIET=1 python3 solvable_relaxation.py table.csv     # no heartbeat
Exits nonzero on any failure.

PROGRESS.  Stage announcements and a heartbeat go to STDERR, so redirecting
stdout keeps the PASS/FAIL lines clean and still shows progress.  The heartbeat
reports **work done, not values done**: `best(n)` scans a window that grows with
n, so the cost is ~O(n) per value and ~O(N^2) overall, and a count-based ETA
drifts low for the whole run.  An up-front estimate is printed before the loop
starts, since that is the figure that decides whether to run this at all on a
larger table: **64 s at N = 76,752, hence ~3 h at N = 10^6.**
"""
import bisect
import csv
import os
import sys
import time
from math import comb, isqrt, log, sqrt
from statistics import median

# ---- progress reporting ----------------------------------------------------
#
# WHY THIS EXISTS.  The script used to print nothing until every pass had
# finished -- 79 s on an 85k-row table, and growing faster than linearly, so on
# a 921k-row one there was no way to tell whether to wait or to go and optimise.
# That is the decision the heartbeat exists to inform, so it reports a RATE and
# an ETA rather than a spinner, and it names the stage, because the stages have
# very different costs and "which stage is slow" is what an optimisation would
# need to know first.
#
# Progress goes to STDERR so that `solvable_relaxation.py table.csv > log`
# keeps the PASS/FAIL lines clean and still shows progress on a terminal.
# ON BY DEFAULT, and not conditioned on stderr being a tty: the run this
# exists for is the long one, which is the one most likely to be under nohup
# with stderr redirected to a file.  `QUIET=1` turns it off.
PROGRESS = os.environ.get("QUIET") is None
_t0 = time.time()
_stage_t = [time.time()]


def hms(sec):
    sec = int(max(sec, 0)); h, r = divmod(sec, 3600); m, s = divmod(r, 60)
    return f"{h}:{m:02d}:{s:02d}" if h else f"{m}:{s:02d}"


def stage(name):
    """Announce a stage and report how long the previous one took."""
    if not PROGRESS:
        return
    now = time.time()
    print(f"  [{hms(now - _t0)}] {name}"
          + (f"   (previous stage {now - _stage_t[0]:.1f}s)" if _stage_t[0] != _t0 else ""),
          file=sys.stderr, flush=True)
    _stage_t[0] = now


def ticker(lo, hi, every=20000, label=""):
    """Heartbeat for the B_solv loop, reporting progress by WORK rather than by
    count, and an ETA that is not systematically optimistic.

    `best(n)` scans the prime powers in a window that grows with n, so its cost
    is roughly linear in n and the total is quadratic in the range.  A
    count-based ETA therefore drifts low throughout: measured on a 76k-row
    table the instantaneous rate falls from 4,249/s to about 1,200/s, so an ETA
    computed from the running average promises a finish that keeps receding.
    Since the point of this heartbeat is to inform "wait, or go and optimise?",
    an ETA that is wrong in the reassuring direction is worse than none.

    So progress is measured as Sum(n) done against Sum(n) total, which is the
    O(n)-per-value model.  The printed rate stays in values/s because that is
    the intelligible unit; the percentage and the ETA are work.
    """
    total_work = (hi * (hi + 1) - lo * (lo - 1)) / 2.0
    state = {"n": 0, "work": 0.0, "last": time.time(), "t0": time.time()}

    def tick(n):
        if not PROGRESS:
            return
        state["n"] += 1
        state["work"] += float(n)
        now = time.time()
        if state["n"] % every and now - state["last"] < 5.0:
            return
        state["last"] = now
        el = now - state["t0"]
        frac = state["work"] / total_work if total_work else 1.0
        eta = el * (1 - frac) / frac if frac > 0 else 0.0
        print(f"    {label} n = {n:,}  {state['n']:,} values, "
              f"{100 * frac:.1f}% of work, {state['n'] / el if el else 0:,.0f} val/s, "
              f"elapsed {hms(el)}, eta {hms(eta)}", file=sys.stderr, flush=True)
    return tick


TABLE = sys.argv[1] if len(sys.argv) > 1 else "mu_table_ladder.csv"
# The frontier is read from the table rather than hardcoded, so this script does
# not silently compare a stale range against a freshly extended one.
with open(TABLE) as _f:
    N = max(int(_r.split(",")[0]) for _r in _f.read().splitlines()[1:] if _r.strip())
ok = True


def check(name, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + name)
    ok = ok and cond


# ---- prime powers, and P(s) = largest prime-power divisor -------------------
stage(f"sieving to N = {N:,}")
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


PPL = sorted(pps)


def best(n, allow_three=False):
    """B_solv(n) and an optimal partition.

    THE TWO-PART SCAN IS CANDIDATE-ENUMERATED, NOT A SWEEP, and the reason is
    arithmetic rather than engineering.  The old form looped a over 2..n/2, so
    the whole run was O(N^2): 126 s over a 50k-row table and ~20 min over a 144k
    one -- the same quadratic shape `validate_table_v3.py`'s gap scan had.

    A part only matters if SCORE[a] = a*(P(a)-1)/2 exceeds the running best, and
    writing a = m*P(a) that is a*a/m > 2*bv up to O(a).  With bv near its true
    value -- delta_solv >= 0.12 in range -- this forces m <= 2 or 3: **the
    admissible a are the prime powers and small multiples of them**, not an
    interval.  So we enumerate a = m*c over prime powers c, m ascending, and
    stop at the first m whose whole family is excluded by a*a <= 2*m*bv.  That
    is an exact restatement of "SCORE[a] > bv", not a heuristic: every a the
    sweep would have accepted is generated.

    Pass 1 takes m = 1 first precisely so bv is near-optimal before pass 2 sizes
    its own bound -- the same ordering lesson as `mu_ladder_exact.py`'s scan,
    where the prune is only as strong as the best-so-far.

    Measured 5x, and verified equal to the sweep at every n in [6, 4000) and on
    400 values near 50,000."""
    bv, bp = SCORE[n], (n,)

    def try_a(a):
        nonlocal bv, bp
        sa = SCORE[a]
        if sa <= bv:
            return
        sb = SCORE[n - a]
        if sb <= bv:
            return
        v = sa if sa < sb else sb
        p = a * (n - a)
        if p < v:
            v = p
        if v > bv:
            bv, bp = v, (a, n - a)

    if not allow_three:
        lo = 2
        while lo * (lo - 1) // 2 <= bv:      # SCORE[a] <= C(a,2) bounds a below
            lo += 1
        for i in range(bisect.bisect_left(PPL, lo),
                       bisect.bisect_right(PPL, n // 2)):
            try_a(PPL[i])
        m = 2
        while True:
            amax = n // 2
            if amax * amax <= 2 * m * bv:    # the whole m-family is excluded
                break
            amin = isqrt(2 * m * bv) + 1
            i0 = bisect.bisect_left(PPL, max(2, -(-amin // m)))
            i1 = bisect.bisect_right(PPL, amax // m)
            for i in range(i0, i1):
                try_a(m * PPL[i])
            m += 1
        return bv, bp
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


# The cost is ~quadratic in N, so an up-front estimate is worth printing: it is
# the number that decides whether to run this at all on a larger table.
if PROGRESS:
    print(f"  [0:00] B_solv is O(N^2) overall (~O(n) per value).  Reference point: "
          f"64 s of compute for N = 76,752, so N = 10^6 is about "
          f"{64 * (10 ** 6 / 76752.0) ** 2 / 60:.0f} min. "
          f"Here N = {N:,}, estimate {64 * (N / 76752.0) ** 2 / 60:.1f} min.",
          file=sys.stderr, flush=True)
stage(f"computing B_solv at every n in [6, {N:,}] -- the dominant cost")
_tick = ticker(6, N, label="B_solv")
D = {}
for _n in range(6, N + 1):
    D[_n] = best(_n)
    _tick(_n)
delta = {n: D[n][0] / comb(n, 2) for n in D}
npp = [n for n in D if n not in pps]

stage("pass 1: the 1/2 ceiling")
# ---- pass 1: ceiling -------------------------------------------------------
check("delta_solv < 1/2 at every non-prime-power n",
      all(delta[n] < 0.5 for n in npp))
twoq = [n for n in npp if n % 2 == 0 and (n // 2) in pps]
check("along n = 2q (q a prime power) delta_solv -> 1/2 (max %.5f)"
      % max(delta[n] for n in twoq),
      min(delta[n] for n in twoq if n > 500) > 0.498)
check("at prime-power n the density is 1 (2-transitive AGL(1,n))",
      all(SCORE[n] == comb(n, 2) for n in pps if n >= 6))

stage("pass 2: three-part partitions (n < 400)")
# ---- pass 2: at most two parts ---------------------------------------------
three = [n for n in range(6, 400) if len(best(n, allow_three=True)[1]) >= 3]
check("no partition with >= 3 parts ever wins (checked n < 400)", not three)

stage("pass 3: the two generic constants")
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

stage("pass 4: the exceptional single-orbit family")
# ---- pass 4: the exceptional family ----------------------------------------
sing = [n for n in npp if len(D[n][1]) == 1]
mults = sorted({n // P[n] for n in sing})
check("single-orbit winners over [6, %d] all have n = m*P(n) with m small: "
      "m in %s" % (N, mults), max(mults) <= 8)
# The multiplier set is a RANGE-SCOPED fact and the note quotes it, so it is
# printed with its range rather than asserted as a constant: the m = 7 entries
# were three named n at the 2,600 frontier and are a family at 10^5.
print("      multiplier census over [6, %d]: %s"
      % (N, {m: sum(1 for n in sing if n // P[n] == m) for m in mults}))
shares = []
for lo, hi in [(100, 500), (500, 1200), (1200, 2484)]:
    s = [n for n in sing if lo <= n <= hi]
    t = [n for n in npp if lo <= n <= hi]
    shares.append(len(s) / len(t))
check("exceptional share decays (%.3f -> %.3f -> %.3f, cf log5/log n)" % tuple(shares),
      shares[0] > shares[1] > shares[2])

stage("pass 6: unconditional floors, incl. the balanced-prime searches")
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
# The note's comparison is asymmetric and the asymmetry is the point: the ODD
# floor beats Oliver's worst conditional ceiling, the EVEN floor falls just
# below it.  Checking both against a smaller constant would hide that.
WORST = 7 - 4 * sqrt(3)                   # n = 11 mod 12, the global minimum
check("the odd unconditional floor 1/9 EXCEEDS Oliver's worst conditional "
      "ceiling %.5f -- a proved bound beating a conjectural one" % WORST,
      1 / 9 > WORST)
check("the even unconditional floor 1/16 falls just BELOW it (%.5f < %.5f), "
      "so the comparison runs the other way at even n" % (1 / 16, WORST),
      1 / 16 < WORST)

stage("pass 5: against the Oliver table")
# ---- pass 5: against Oliver ------------------------------------------------
tab = {int(r["n"]): int(r["mu_bound"]) for r in csv.DictReader(open(TABLE))}
shared = [n for n in sorted(tab) if n in D and n not in pps]
check("B_solv >= B_safe at all %d shared n (Oliver groups are solvable)" % len(shared),
      all(D[n][0] >= tab[n] for n in shared))
# The invariant is not merely an inequality: on a matching class the Oliver
# score F*C(c,2) = s*(c-1)/2 EQUALS this document's solvable score at c = P(s),
# so exact attainments are expected and their count is a free structural check
# on any rebuild -- a violation would mean the Oliver side is crediting a class
# no solvable group can carry.
att = [n for n in shared if D[n][0] == tab[n]]
print("      B_solv = B_safe at %d of %d shared n (%.1f%%, matching-class "
      "coincidence)" % (len(att), len(shared), 100 * len(att) / len(shared)))
# THE RATIO DISTRIBUTION, which solvable-relaxation.md section 4 quotes and which
# no earlier version of this script printed -- so requoting the note meant
# recomputing it by hand.  Printed with its range, per the same discipline the
# main documents follow.
rat = sorted((D[n][0] / tab[n], n) for n in shared)
rodd = [r for r, n in rat if n % 2]
rev = [r for r, n in rat if n % 2 == 0]
print("      ratio B_solv/B_safe over [6, %d]: median %.3f (%.3f even, %.3f odd), "
      "max %.3f at n = %d" % (N, median([r for r, _ in rat]), median(rev),
                              median(rodd), rat[-1][0], rat[-1][1]))
# The share of class-11 values exceeding their own class ceiling, which the
# note quotes and the rebuild moves.  Printed rather than asserted.
c11 = [n for n in shared if n % 12 == 11]
over = [n for n in c11 if tab[n] / comb(n, 2) > 7 - 4 * sqrt(3)]
print("      class 11 mod 12: %d of %d tabulated values exceed the class "
      "ceiling 7-4sqrt3" % (len(over), len(c11)))
# aod section 3.3.5, as the JOINT optimum over (F, eta).  The last two lines are
# the residues whose optimum takes F = 4 rather than F = 2.
OLIVER = {**{r: 0.25 for r in (0, 4, 6, 10)},
          **{r: (2 - sqrt(3)) / 2 for r in (2, 8)},
          **{r: 3 - 2 * sqrt(2) for r in (1, 9)},
          **{r: 0.125 for r in (3, 7)},
          **{r: 5 - 2 * sqrt(6) for r in (5,)},
          **{r: 7 - 4 * sqrt(3) for r in (11,)}}
check("the ceiling table is keyed mod 12 and covers every residue",
      sorted(OLIVER) == list(range(12)))
solv_cap = {r: (CAP1 if r % 2 == 0 else CAP2) for r in range(12)}
ratios = {r: solv_cap[r] / OLIVER[r] for r in range(12)}
check("Oliver's six ceilings collapse to two under the relaxation",
      len(set(round(v, 9) for v in OLIVER.values())) == 6
      and len(set(round(v, 9) for v in solv_cap.values())) == 2)
check("worst ceiling ratio is (3-2sqrt2)/(7-4sqrt3) = %.4f at n = 11 mod 12"
      % ratios[11], abs(ratios[11] - 2.3897) < 1e-3
      and ratios[11] == max(ratios.values()))
check("class 3 mod 12 (which absorbed 7, 15 mod 24) sits at eta = 1/2, "
      "ratio %.4f -- the twist losing the 2-part of r-1, not a fusion count"
      % ratios[3],
      abs(ratios[3] - (3 - 2 * sqrt(2)) * 8) < 1e-9
      and abs(ratios[3] - ratios[7]) < 1e-9)
check("ratio is exactly 1 where Oliver already reaches eta = 1",
      all(abs(ratios[r] - 1.0) < 1e-9 for r in (0, 4, 6, 10, 1, 9)))
check("the chain is free on six of the twelve residues",
      sum(1 for r in ratios if abs(ratios[r] - 1.0) < 1e-9) == 6)
print("\n      global constant: Oliver %.5f (n = 11 mod 12) vs solvable %.5f"
      % (min(OLIVER.values()), min(solv_cap.values())))
print("      per-residue ceiling ratios:",
      " ".join("%d:%.3f" % (r, ratios[r]) for r in sorted(ratios)))

stage("done")
if PROGRESS:
    print(f"  total {hms(time.time() - _t0)}", file=sys.stderr, flush=True)
sys.exit(0 if ok else 1)
