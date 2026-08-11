#!/usr/bin/env python3
"""
count_check.py -- test the singular-series prediction by COUNTING solutions,
not merely by finding one.

The density results of `arithmetic-of-density.md` rest on a Hardy-Littlewood
system having a solution near the balance point.  Existence is what the tables
verify.  This script tests the much stronger claim that the NUMBER of solutions
matches the singular series -- which is what the heuristic actually predicts,
and what would be evidence that the system behaves as modelled rather than
merely being non-empty.

THE SYSTEM.  For the three-part family n = 2c + r of section 3.2:

    c prime,   r = n - 2c prime,   r == 1 (mod q)

with c/n restricted to a window around the balance point x*.  BEWARE THE DEFAULT:
--centre defaults to the EQUAL SPLIT 1/(k+1) -- 1/3 for the three-part family --
which is the balance point only at eta = 1.  At the obstructed residues the two
diverge sharply: at (rung C, eta = 1/6) the equal split sits 0.109 from the true
x* = 0.22474, more than twice the standard window half-width, so a run left on
the default counts over a region that CANNOT reach the class ceiling and says
nothing about attainment (aod sections 3.3.6 and 3.8).  Always pass --centre
explicitly, taking the value from the x* column of aod section 3.3.5 for the
residue being tested; every figure in aod section 3.8's table was taken that way.
The third
condition is the one that carries the efficiency: a foreign block of size r
admits a twist of order q, so eta >= (roughly) q/(r-1), and it is also the
condition that makes this system strictly harder than binary Goldbach --
section 3.5.  Dropping it (--no-q) recovers the two-condition system, which is
useful as a calibration since its singular series is textbook.

THE PREDICTION.  Counting c in a window of width W*n lying in a fixed residue
class mod q, with ω(p) = #{c mod p : c(n-2c) = 0} = 1 if p | n else 2,

    predicted = S_q * (W*n/q) / (log c_mid * log r_mid),
    S_q       = 2 * prod_{2<p, p!=q} (1 - ω(p)/p) (1 - 1/p)^-2 * (q/(q-1))^2,

the (q/(q-1))^2 restoring the two factors that the residue restriction removes:
neither c nor r can be divisible by q once c is pinned mod q.  With --no-q this
collapses to the familiar 2*C2*prod_{p|n,p>2}(p-1)/(p-2).

SAMPLING.  Full enumeration is O(n/log n) per value, so a sweep to 10^6 is
cheap and a sweep to 10^8 is not.  --sample takes a random subset of the
qualifying n, which is what makes the high end reachable: the claim being
tested is distributional, so a sample confirms it as well as a census does.

Usage:
    # every n = 11 mod 12 up to a million
    python3 count_check.py --nmin 1000 --nmax 1000000 --residue 11 --modulus 12

    # a 10% sample of those in [10^6, 10^7]
    python3 count_check.py --nmin 1000000 --nmax 10000000 \
                           --residue 11 --modulus 12 --sample 0.1 --seed 7

    # calibration against the two-condition system
    python3 count_check.py --nmin 100000 --nmax 1000000 --residue 1 --modulus 2 --no-q
"""
import argparse, bisect, math, random, sys

ap = argparse.ArgumentParser()
ap.add_argument("--nmin", type=int, default=10_000)
ap.add_argument("--nmax", type=int, default=200_000)
ap.add_argument("--residue", type=int, default=11, help="n = residue (mod modulus)")
ap.add_argument("--modulus", type=int, default=12)
ap.add_argument("--sample", type=float, default=1.0,
                help="fraction of qualifying n to test, in (0,1]; <1 draws a random subset")
ap.add_argument("--seed", type=int, default=0)
ap.add_argument("--maxn", type=int, default=400, help="cap on how many n are tested")
ap.add_argument("--window", type=float, default=0.05,
                help="half-width of the c/n window around the balance point")
ap.add_argument("--centre", type=float, default=None,
                help="balance point x* = c/n, from the x* column of aod section "
                     "3.3.5 for the residue being tested.  If omitted it is "
                     "DERIVED from --dq (x* = sqrt(eta)/(1 + k*sqrt(eta)) at "
                     "eta = 2/D), which is the right value; without --dq it "
                     "falls back to the equal split 1/(k+1), which is the right "
                     "value only at eta = 1 -- see the module docstring.")
ap.add_argument("--q", type=int, default=3, help="the twist prime for the r = 1 mod q condition")
ap.add_argument("--no-q", action="store_true", help="drop the congruence: two-condition calibration")
ap.add_argument("--parts", type=int, default=3, choices=(2, 3),
                help="3 = the odd family n = 2c + r of section 3.2 (default); "
                     "2 = the even family n = c + r of section 3.1.  Sets the "
                     "default balance point to 1/3 or 1/2 respectively.")
ap.add_argument("--dq", type=int, default=0, metavar="D",
                help="test SECTION 3.3's own system at efficiency eta = 2/D: "
                     "q prime, r = D*q + 1 prime, c = (n - r)/2 prime.  D must be even. "
                     "D = 2 is the safe-prime endpoint eta = 1; D = 4, 6, 12 give "
                     "eta = 1/2, 1/3, 1/6, which are the caps for the obstructed "
                     "classes.  D = 12 is the one that matters for n = 11 (mod 12).")
ap.add_argument("--quiet", action="store_true")
A = ap.parse_args()
K = A.parts - 1                      # c = (n - 1 - D*q) / K
# The x* column of aod section 3.3.5, keyed by n mod 24.  Deliberately a TABLE
# and not a formula: x* is the balance point of the RUNG that attains the class
# ceiling, and at odd n that is the fused rung B (x* = sqrt(eta)/(sqrt2+2sqrt eta))
# at nine residues and the unfused rung C (x* = sqrt(eta)/(1+2sqrt eta)) at 7, 15
# and 23.  Deriving x* from eta alone silently picks one rung for all of them and
# is wrong at seven residues, so the values are transcribed instead.
XSTAR_BY_RESIDUE = {0: 0.50000, 4: 0.50000, 6: 0.50000, 10: 0.50000,
                    12: 0.50000, 16: 0.50000, 18: 0.50000, 22: 0.50000,
                    2: 0.36603, 8: 0.36603, 14: 0.36603, 20: 0.36603,
                    1: 0.29289, 9: 0.29289, 13: 0.29289, 21: 0.29289,
                    3: 0.25000, 19: 0.25000,
                    5: 0.22474, 17: 0.22474,
                    7: 0.29289, 15: 0.29289,
                    11: 0.18301,
                    23: 0.22474}

if A.centre is None:
    # The equal split 1/(K+1) is the balance point ONLY at eta = 1.  Where the
    # run is keyed to a single residue mod 24 the right centre is known, so use
    # it; otherwise fall back to the equal split and say loudly that it is one.
    if A.modulus == 24 and (A.residue % 24) in XSTAR_BY_RESIDUE:
        A.centre = XSTAR_BY_RESIDUE[A.residue % 24]
        if not A.quiet:
            print(f"note: --centre taken from aod section 3.3.5 for "
                  f"n = {A.residue % 24} (mod 24): x* = {A.centre:.5f}")
    else:
        A.centre = 1 / (K + 1.0)
        if not A.quiet:
            print(f"WARNING: --centre defaulted to the equal split {A.centre:.5f}, "
                  f"which is the balance point only at eta = 1.  At an obstructed "
                  f"residue a window centred here CANNOT reach the class ceiling "
                  f"and the count says nothing about attainment (aod 3.3.6, 3.8). "
                  f"Pass --centre explicitly, or run with --modulus 24.")

LO, HI = A.centre - A.window, A.centre + A.window
if LO <= 0 or HI >= 1:
    sys.exit("window runs outside (0,1)")

# ---- sieve to nmax
N = A.nmax
sieve = bytearray([1]) * (N + 1)
sieve[0] = sieve[1] = 0
for i in range(2, int(N ** 0.5) + 1):
    if sieve[i]:
        sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
primes = [i for i in range(2, N + 1) if sieve[i]]
PRIMESET = set(primes)
print(f"sieved to {N:,}: {len(primes):,} primes", file=sys.stderr)

def pdivs(x):
    o, d = [], 2
    while d * d <= x:
        if x % d == 0:
            o.append(d)
            while x % d == 0: x //= d
        d += 1 if d == 2 else 2
    if x > 1: o.append(x)
    return o

PMAX = 200_003
SPRIMES = [p for p in primes if p <= PMAX] if primes[-1] >= PMAX else primes

def degenerate(n, q):
    """The congruence r = 1 (mod q) pins c to a single class mod q, namely
    c0 = (n-1)/2.  If that class is 0 the system is DEGENERATE: c would have to
    be divisible by q, so the only candidate is c = q itself and the count is
    O(1) rather than of order n/log^3 n.  This is a local obstruction, not a
    failure of the heuristic, and the prediction must be 0 there -- an earlier
    draft omitted the check and reported a spurious shortfall at q = 5, where
    it fires for one n in q.  At q = 3 with n = 11 (mod 12) it never fires,
    which is why the omission went unnoticed."""
    if not q: return False
    return ((n - 1) * pow(2, -1, q)) % q == 0

def singular(n, q):
    """S_q as in the docstring.  The tail beyond PMAX contributes 1 + O(1/PMAX)
    because the factors are 1 + O(1/p^2) once p does not divide n."""
    nd = set(pdivs(n))
    s = 2.0
    for p in SPRIMES:
        if p == 2: continue
        if q and p == q: continue
        w = 1 if p in nd else 2
        s *= (1 - w / p) / (1 - 1 / p) ** 2
    if q:
        s *= (q / (q - 1)) ** 2
    return s

# ---------------------------------------------------------------------------
# Section 3.3's own system, at a chosen efficiency.
#
# A foreign block r carries a twist of order t, a prime power dividing r-1, and
# its efficiency is eta = 2t/(r-1) for odd t.  So eta = 2/D exactly when
# r - 1 = D*t.  Taking t = q prime, the three forms are
#
#     f1 = q,   f2 = D*q + 1  (= r),   f3 = (n - 1 - D*q)/K  (= c)
#
# with K = 1 for the even two-part family n = c + r of section 3.1 and K = 2
# for the odd three-part family n = 2c + r of section 3.2.  K = 2 was the only
# case the script covered until 2026-08.
#
# and a solution is a q making all three prime.  D = 2 is the safe-prime
# endpoint, eta = 1.  The obstructed classes cap out lower and need larger D:
#
#     D  =   2      4      6     12
#     eta=   1    1/2    1/3    1/6
#     cap  1/9  0.08579  0.0718  0.05051     <- the UNFUSED rung C at each eta
#
# Those are section 3.3's class ceilings only at the residues stuck on rung C
# (7, 15 and 23 mod 24).  At the nine rung-B residues the fused rung reaches
# higher -- 0.17157, 0.125, 0.10102, 0.06699 at eta = 1, 1/2, 1/3, 1/6 -- and
# section 3.3.5's table, not this row, is the reference for what a class caps at.
#
# Testing a class at the WRONG D tests a system with nothing to do with its
# ceiling.  n = 11 (mod 12) caps at 1/6 and so needs D = 12; at D = 2 its
# singular series vanishes identically, which is the obstruction, not a bug.

def roots_mod(n, l, D):
    """#{q mod l : f1 f2 f3 = 0 mod l}, or l itself if f3 vanishes identically."""
    h = ((n - 1) // K) % l                      # c = h - (D/K) q
    g = (D // K) % l
    rs = {0}                                    # f1 = q
    if D % l:                                   # f2 = Dq+1
        rs.add((-pow(D % l, -1, l)) % l)
    if g:                                       # f3 = h - (D/K) q
        rs.add((h * pow(g, -1, l)) % l)
    elif h % l == 0:
        return l                                # f3 == 0 identically: no solutions
    return len(rs)

def singular_dq(n, D):
    if (n - 1) % K:            # three-part family needs n odd; two-part does not
        return 0.0
    s = 1.0
    for p in SPRIMES:
        w = roots_mod(n, p, D)
        if w >= p:
            return 0.0
        s *= (1 - w / p) / (1 - 1 / p) ** 3
    return s

def _density_integral(n, D, steps=64):
    """sum over q in the window of 1/(log q * log r * log c), by Simpson."""
    h = (n - 1) // K
    qlo = (h - int(HI * n)) / (D / float(K))
    qhi = (h - int(LO * n)) / (D / float(K))
    if qhi <= qlo or qlo < 2:
        return 0.0
    tot, dq = 0.0, (qhi - qlo) / steps
    for i in range(steps + 1):
        qv = qlo + i * dq
        r = D * qv + 1.0
        c = h - (D / float(K)) * qv
        if qv < 2 or r < 2 or c < 2:
            continue
        w = 1 if i in (0, steps) else (4 if i % 2 else 2)
        tot += w / (math.log(qv) * math.log(r) * math.log(c))
    return tot * dq / 3.0


def count_dq(n, D):
    """q in the window (measured on c) with q, D*q+1 and (n-1)/2-(D/2)q all prime."""
    lo, hi = int(LO * n), int(HI * n)
    k = 0
    for c in primes:
        if c < lo: continue
        if c > hi: break
        num = n - 1 - K * c
        if num <= 0 or num % D: continue
        q = num // D
        if q < 2 or q not in PRIMESET: continue
        r = D * q + 1
        if r > N or r not in PRIMESET: continue
        k += 1
    return k


def count(n, q):
    """solutions with c/n in the window."""
    lo, hi = int(LO * n), int(HI * n)
    i = bisect.bisect_left(primes, max(lo, 3))
    k = 0
    while i < len(primes) and primes[i] <= hi:
        c = primes[i]; i += 1
        r = n - 2 * c
        if r < 3 or r > N or not sieve[r]: continue
        if q and r % q != 1: continue
        k += 1
    return k

# ---- pick the n to test
cands = [n for n in range(max(A.nmin, 6), A.nmax + 1)
         if n % A.modulus == A.residue % A.modulus]
rng = random.Random(A.seed)
total = len(cands)
sampled = A.sample < 1.0
if sampled:
    cands = [n for n in cands if rng.random() < A.sample]
truncated = len(cands) > A.maxn
if truncated:
    cands = sorted(rng.sample(cands, A.maxn))
q = None if A.no_q else A.q

if A.dq:
    fam = "n = c + r  (section 3.1, even)" if K == 1 else "n = 2c + r  (section 3.2, odd)"
    print(f"system: q prime, r = {A.dq}q+1 prime, c = (n-r)/{K} prime   "
          f"[{fam}, eta = 2/{A.dq} = {2/A.dq:.4g}]")
else:
    print(f"system: c prime, r = n - 2c prime"
          + ("" if q is None else f", r = 1 (mod {q})"))
print(f"window: c/n in [{LO:.4f}, {HI:.4f}]  (centre {A.centre:.4f}, half-width {A.window})")
how = []
if sampled:
    how.append(f"--sample {A.sample:.3g}")
if truncated:
    how.append(f"--maxn {A.maxn} (RANDOM SUBSET of the {total:,} qualifying n)")
print(f"testing {len(cands)} values of n = {A.residue % A.modulus} (mod {A.modulus}) "
      f"in [{A.nmin:,}, {A.nmax:,}]: "
      + ("; ".join(how) if how else f"exhaustive, all {total:,}"))
if truncated:
    print("   NOTE: --maxn subsamples silently unless you look here.  The mean is a")
    print("   good estimate at this size but the sd is noisy; quote the sd only from")
    print("   an exhaustive run, or raise --maxn until it stabilises.")
print()

rows, zero, degen = [], 0, []
for n in cands:
    if A.dq:
        D = A.dq
        if (n - 1) % K: continue
        a = count_dq(n, D)
        # Integrate the density across the window rather than evaluating it at
        # the midpoint.  The window is a CONSTANT relative width, so q sweeps a
        # factor of (h - LO*n)/(h - HI*n) across it -- 1.86 at the default
        # settings -- and 1/log q is convex, so the midpoint value is not the
        # mean.  The error is D-dependent: log q ~ log(n/(3D)), so the same
        # relative sweep in q is a larger fractional swing in 1/log q the larger
        # D is.  At D = 2 it is under a percent; at D = 12 it is several.
        pred = singular_dq(n, D) * _density_integral(n, D)
        if pred <= 0:
            degen.append((n, a)); continue
        if a == 0: zero += 1
        rows.append((n, a, pred, a / pred if pred > 0 else 0.0))
        continue
    if degenerate(n, q):
        degen.append((n, count(n, q)))
        continue
    a = count(n, q)
    W = HI - LO
    if A.centre >= 0.5:
        # The non-dq path is the three-part family n = 2c + r, so a centre at or
        # above 1/2 leaves no room for the foreign block and the two log factors
        # below are not defined.  Falling back to denom = 1 would drop BOTH log
        # factors and return a prediction too large by log^2 n with nothing in
        # the output saying so, so fail loudly instead.
        sys.exit("--centre >= 0.5 is meaningless for the three-part system; "
                 "use --parts 2 (which defaults to centre 1/2) or --dq")
    denom = math.log(A.centre * n) * math.log((1 - 2 * A.centre) * n)
    pred = singular(n, q) * (W * n / (q if q else 1)) / max(denom, 1e-9)
    if a == 0: zero += 1
    rows.append((n, a, pred, a / pred if pred > 0 else 0.0))

if degen and A.dq:
    print(f"{len(degen)} of {len(cands)} values have a VANISHING singular series: the")
    print(f"   full-efficiency system is locally obstructed there, which for this system")
    print(f"   happens exactly at n = 2 (mod 3) -- section 3.3's omega(3) = 3 case.")
    print(f"   Observed counts there: max {max(a for _, a in degen)}"
          + (", as predicted." if max(a for _, a in degen) == 0 else " -- INVESTIGATE"))
    print()
    if not rows:
        sys.exit("every tested n is locally obstructed for this system; try another "
                 "residue class -- 1 or 9 mod 12 are the unobstructed odd ones")
elif degen:
    bad = [n for n, a in degen if a > 1]
    print(f"{len(degen)} of {len(cands)} values are DEGENERATE at q = {q}: the congruence")
    print(f"   forces q | c, so no solution with c > q can exist.  Excluded from the")
    print(f"   statistics below.  Observed counts there: max {max(a for _, a in degen)}"
          + (f", and {len(bad)} exceeding 1 -- INVESTIGATE" if bad else ", as predicted."))
    print()
    if not rows:
        sys.exit("every tested n was degenerate; pick another q or residue class")

if not A.quiet:
    print(f"{'n':>10} {'actual':>8} {'predicted':>10} {'ratio':>7}")
    step = max(1, len(rows) // 25)
    for n, a, pred, rt in rows[::step]:
        print(f"{n:>10,} {a:>8} {pred:>10.1f} {rt:>7.3f}")
    print()

rt = sorted(r[3] for r in rows)
mean = sum(rt) / len(rt)
med = rt[len(rt) // 2]
var = sum((x - mean) ** 2 for x in rt) / len(rt)
print(f"ratio actual/predicted over {len(rt)} values:")
print(f"   mean {mean:.4f}   median {med:.4f}   sd {var**0.5:.4f}")
print(f"   min  {rt[0]:.4f}   10th {rt[len(rt)//10]:.4f}   90th {rt[9*len(rt)//10]:.4f}   max {rt[-1]:.4f}")
print(f"   values with NO solution in the window: {zero}")
print()
if zero:
    print("   A zero is not a counterexample by itself -- the window is narrow and the")
    print("   prediction is an average -- but a zero where the prediction exceeds ~5 is")
    print("   worth looking at individually.")
big0 = [r for r in rows if r[1] == 0 and r[2] > 5]
if big0:
    print(f"   {len(big0)} zero(s) against a prediction above 5: {[r[0] for r in big0][:10]}")
print("A mean near 1 with sd falling as n grows is the signal; a systematic drift")
print("away from 1 would say the singular series is being computed for the wrong system.")
