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

with c/n restricted to a window around the balance point x* = 1/3.  The third
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
ap.add_argument("--centre", type=float, default=1/3.0,
                help="balance point x* = c/n; 1/3 for the three-part family, 1/2 for two-part")
ap.add_argument("--q", type=int, default=3, help="the twist prime for the r = 1 mod q condition")
ap.add_argument("--no-q", action="store_true", help="drop the congruence: two-condition calibration")
ap.add_argument("--quiet", action="store_true")
A = ap.parse_args()

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
    if degenerate(n, q):
        degen.append((n, count(n, q)))
        continue
    a = count(n, q)
    W = HI - LO
    denom = math.log(A.centre * n) * math.log((1 - 2 * A.centre) * n) if A.centre < 0.5 else 1
    pred = singular(n, q) * (W * n / (q if q else 1)) / max(denom, 1e-9)
    if a == 0: zero += 1
    rows.append((n, a, pred, a / pred if pred > 0 else 0.0))

if degen:
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
