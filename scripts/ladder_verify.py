#!/usr/bin/env python3
"""
ladder_verify.py -- verify the density ladder directly, per n, over ALL residue
classes, and compute the global floor of arithmetic-of-density.md section 5.

WHAT THIS REPLACED, AND WHY.  An earlier version asked a single binary question
-- "does a full-efficiency representation exist near the balance point?" -- and
skipped every class where full efficiency is locally obstructed.  That silently
left half of all n unverified: classes 2, 3, 5, 7, 8 and 11 mod 12 were never
examined, and those are exactly the hard ones.  It also used one fixed window
around x = 1/3, which does not contain the balance point of the low-efficiency
classes, so scanning there and finding nothing looks like a failure but is an
artefact of the window.

This version computes, for each n, the best density any of the three families of
section 2 can achieve, scanning the block size over a window wide enough to hold
EVERY class's balance point.  That is strictly more informative: representability
is the special case "achieved density > 0", and the number obtained is a proven
lower bound on delta(n) = mu(n)/C(n,2).

THE FAMILIES (all scored in SAFE mode, so each is a genuine lower bound)
  fused        n = F*c,      F a q-power, c a prime power        -> ~1/F
  two parts    n = c + r,    c a prime power, r prime            -> <= 1/4
  three parts  n = 2c + r,   two equal c-blocks plus a foreign   -> <= 1/9
  S7 (2026-08) n = F*c + r,  F >= 3 blocks fused in the CYCLIC layer
                             plus a foreign prime                -> <= 0.13397

THE S7 FAMILY, AND WHY IT WAS MISSING.  Until 2026-08 the enumeration required
the block-permuting group to sit in the top q-group, so F had to be a q-power.
It may instead sit in the cyclic layer, where the only requirement is that
Gamma_1/Gamma_2 stay cyclic -- so F may be any integer coprime to the
twists and the foreign primes -- prime power or not, odd or even.  See enumeration-proof.md Part 0.  Adding it here
can only RAISE the reported floor, since this script takes a max over families
and every family is a genuine construction.

BALANCE POINTS, and hence the window.  With x = c/n and eta the foreign block's
efficiency, delta(x) = min(x^2, 2x(1-kx), eta(1-kx)^2) for k = 1 (two parts) or
k = 2 (three parts).  The optima run from x = 0.2247 (three parts at e = 1/6,
class 11) up to x = 0.5 (two parts at e = 1).  The window [0.10, 0.55] holds all
of them with room to spare; [0.20, 0.55] does NOT -- it clips n = 9179, whose
optimum sits at x = 0.1973, and reports a spurious shortfall there.

CLASS CAPS (section 3.3), used to report each n as a fraction of what its class
permits:
    even n                          cap 0.25000 or 0.13397  (unchanged)
    n mod 24 in {1,9,13,21}         cap 0.17157   rung B
    n mod 24 in {3,19}              cap 0.12500   rung B
    n mod 24 in {5,17}              cap 0.10102   rung B
    n mod 24 in {7,15}              cap 0.08579   rung C -- no fused rung
    n mod 24 == 11                  cap 0.06699   rung B
    n mod 24 == 23                  cap 0.05051   rung C -- the extremal residue

Usage:
    python3 ladder_verify.py 100000
    python3 ladder_verify.py 100000 --floor 0.02
"""
import sys, time, bisect, math
from math import comb

_A = sys.argv
N = int(_A[1]) if len(_A) > 1 and not _A[1].startswith("-") else 100000
FLOOR = 0.02
for i, x in enumerate(_A):
    if x == "--floor":
        FLOOR = float(_A[i + 1])

# The asymptotic global lower bound of arithmetic-of-density.md section 5: the
# class-11 cap 5/2 - sqrt(6), smallest of the six class caps.  Values falling
# below it here are NOT counterexamples -- this script scans three families over
# a window and so computes a LOWER BOUND on delta(n).  They are the values where
# that bound is too weak to reach the asymptotic constant, i.e. the worklist for
# a future mu_enumerate.py run.
ASYMPTOTIC = 2.5 - 6 ** 0.5

# The worklist is EVIDENCE for figures quoted in arithmetic-of-density.md sections
# 3.7 and 5.2, and comparing two runs is the point of rerunning -- so do not write
# an unversioned file that the next run silently overwrites.  Override with
# LADDER_OUT=... to name a run explicitly.
import os as _os
OUTFILE = _os.environ.get("LADDER_OUT", "ladder_weak.txt")

# CEILINGS, REKEYED MOD 24 (2026-08).  The old table was keyed mod 12 and used
# the UNFUSED rung throughout.  For odd n the shapes form a ladder
#
#   A  one c-block + foreign      cap  eta/(1+sqrt e)^2      needs c = 2^a
#   B  two c-blocks FUSED + fgn   cap 2eta/(sqrt2+2sqrt e)^2 needs c = 3 mod 4
#   C  two c-classes UNFUSED      cap  eta/(1+2sqrt e)^2     always available
#
# with A > B > C.  Rung B needs an odd twist on the c-blocks, i.e. c = 3 mod 4,
# and whether that is compatible with the residue's own eta is a condition mod 8
# on n -- which is why the split is mod 24 rather than mod 12.  The certifying
# congruence DIFFERS BY ETA and must not be quoted as one condition: with
# c = 3 mod 4 one has 2c = 6 mod 8 and hence r = n-6 mod 8, so
#     eta = 1/2 or 1/6  (D = 4 or 12)  needs r = 5 mod 8, hence n = 3 mod 8;
#     eta = 1 or 1/3    (D = 2 or 6)   needs r = 3 or 7 mod 8, i.e. n = 1 or 5.
# The nine rung-B residues are spread across all three of those cases -- they are
# 1, 3 and 5 mod 8, NOT all 3 mod 8.  See aod section 3.9.1.4, whose table is the
# reference; an earlier version of this comment asserted n = 3 mod 8 throughout,
# which is false for six of the nine.  Half of each obstructed class reaches B
# and half is stuck on C.
# Measured 100%/0% with no boundary cases.  Nine of the twelve odd residues rise
# by 33-54%; residues 7, 15 and 23 do not.  The global minimum is unchanged at
# 0.050510, now attained at n = 23 (mod 24) alone.
CAP = {0: 0.250000, 1: 0.171573, 2: 0.133975, 3: 0.125000,
       4: 0.250000, 5: 0.101021, 6: 0.250000, 7: 0.085786,
       8: 0.133975, 9: 0.171573, 10: 0.250000, 11: 0.066987,
       12: 0.250000, 13: 0.171573, 14: 0.133975, 15: 0.085786,
       16: 0.250000, 17: 0.101021, 18: 0.250000, 19: 0.125000,
       20: 0.133975, 21: 0.171573, 22: 0.250000, 23: 0.050510}
MOD = 24

t = time.time()
sieve = bytearray([1]) * (N + 1)
sieve[0] = sieve[1] = 0
for i in range(2, int(N ** 0.5) + 1):
    if sieve[i]:
        sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
ispp = bytearray(N + 1)
base = [0] * (N + 1)
for p in range(2, N + 1):
    if sieve[p]:
        q = p
        while q <= N:
            ispp[q] = 1
            base[q] = p
            q *= p

# Efficiency of a foreign prime r: e = max over top primes q of orb(r, q-part)/C(r,2).
# With r-1 = 2^a * u, u odd, L the largest prime power dividing u, this is
# max(2^a/(r-1), 2L/(r-1)) -- section 3.3.
EFF = [0.0] * (N + 1)
for r in range(3, N + 1, 2):
    if not sieve[r]:
        continue
    m = r - 1
    a, x = 0, m
    while x % 2 == 0:
        x //= 2
        a += 1
    best, y, d = 1, x, 3
    while d * d <= y:
        if y % d == 0:
            e = 1
            while y % d == 0:
                y //= d
                e += 1
            best = max(best, d ** (e - 1))
        d += 2
    if y > 1:
        best = max(best, y)
    EFF[r] = max((2 ** a) / m, 2 * best / m)

# S7 needs the foreign efficiency maximised over top primes q OTHER than the
# fusion prime, since the two cannot coincide.  Using the unrestricted EFF would
# overstate whenever the best q is the fusion prime, which would break the
# lower-bound guarantee -- so these are computed separately.
# Keyed by the frozenset of primes the fusion count occupies in the cyclic
# layer.  A fused class of F blocks puts EVERY prime divisor of F into that
# layer, so the foreign twist's top prime must avoid all of them -- not just one.
# Computed on demand and memoised, since only a handful of exclusion sets occur.
_EFF_EX_CACHE = {}


def eff_excluding(excl):
    """Best foreign efficiency over top primes q NOT in `excl`, per r."""
    key = frozenset(excl)
    if key in _EFF_EX_CACHE:
        return _EFF_EX_CACHE[key]
    arr = [0.0] * (N + 1)
    for r in range(3, N + 1, 2):
        if not sieve[r]:
            continue
        m = r - 1
        best_e = 0.0
        a_, x_ = 0, m
        while x_ % 2 == 0:
            x_ //= 2; a_ += 1
        if 2 not in key:
            best_e = max(best_e, (2 ** a_) / m)          # q = 2 branch
        y, d = x_, 3
        while d * d <= y:
            if y % d == 0:
                e2 = 1
                while y % d == 0:
                    y //= d; e2 += 1
                if d not in key:
                    best_e = max(best_e, 2 * (d ** (e2 - 1)) / m)
            d += 2
        if y > 1 and y not in key:
            best_e = max(best_e, 2 * y / m)
        arr[r] = best_e
    _EFF_EX_CACHE[key] = arr
    return arr


EFF_EX = {q0: eff_excluding({q0}) for q0 in (3, 5, 7)}


def prime_divisors_of(m):
    """The set of primes dividing m -- exactly the primes a fused class of m
    blocks occupies in the cyclic layer."""
    out, d, x = set(), 2, m
    while d * d <= x:
        if x % d == 0:
            out.add(d)
            while x % d == 0:
                x //= d
        d += 1 if d == 2 else 2
    if x > 1:
        out.add(x)
    return out


# Fusion counts scanned by the S7 family.  F = 1 is the unfused case and F = 2 is
# the odd-n rung, both handled elsewhere; everything from 3 up is in scope here.
# The ceiling is set by Part G.4's F <= 1/delta: at the floors this ladder is
# used to establish (delta around 1/25) F cannot exceed 25, and in practice the
# intra term Fp*orb(c, dmax) falls off fast enough that large F never wins.
FSET = tuple(range(3, 13)) + (16, 25)

# Best foreign efficiency over ODD top primes only -- what rung B may use, since
# its cyclic-layer C_2 rules out q = 2 sharing the layer with an even twist.
EFF_ODD = [0.0] * (N + 1)
for r in range(3, N + 1, 2):
    if not sieve[r]:
        continue
    m = r - 1
    y, d, best_e = m, 3, 0.0
    while y % 2 == 0:
        y //= 2
    while d * d <= y:
        if y % d == 0:
            e2 = 1
            while y % d == 0:
                y //= d; e2 += 1
            best_e = max(best_e, 2 * (d ** (e2 - 1)) / m)
        d += 2
    if y > 1:
        best_e = max(best_e, 2 * y / m)
    EFF_ODD[r] = best_e

# Rung B' (top-layer F = 2) forces q = 2, so the foreign twist is the 2-part of
# r - 1 and the efficiency is 1/u with u the odd part.  Kept separate from EFF,
# which maximises over all q and would overstate this rung.
EFF2 = [0.0] * (N + 1)
for r in range(3, N + 1, 2):
    if sieve[r]:
        m = r - 1
        a2 = 1
        while m % (2 * a2) == 0:
            a2 *= 2
        EFF2[r] = a2 / m          # = 2-part of r-1 over r-1 = 1/u


def orb_ld(c, t, char2):
    """Minimum intra-orbital of a c-block with cyclic twist of order t, capped
    at C(c,2).  Same rule as mu_enumerate's orb()."""
    raw = c * t // 2 if (char2 or t % 2 == 0) else c * t
    return min(raw, comb(c, 2))


PPs = [c for c in range(2, N + 1) if ispp[c]]
print(f"sieve and efficiencies to {N:,} in {time.time()-t:.1f}s")

LO_X, HI_X = 0.10, 0.55        # contains every class's balance point

def achieved(n, stop_at=None):
    """Best density over the three families.  With stop_at set, returns as soon
    as that is exceeded; most n clear it at once, which is what makes the scan
    affordable.

    NOTE on stop_at: when it fires, the value returned is NOT the family maximum
    -- it is merely some value above stop_at.  Callers pass 0.9*CAP[class], so
    any reported figure at or just below 0.9*CAP is a truncation artefact rather
    than a real minimum.  This is why the per-block 'floor' lines in a long run
    keep reporting 0.04546 = 0.9 * 0.05051.  Everything the script asserts is a
    lower bound, so the truncation is safe; it just must not be read as a max."""
    C = n * (n - 1) / 2
    best = 0.0
    F = 2
    while F * F <= n:                              # fused
        if n % F == 0:
            for FF in (F, n // F):
                c = n // FF
                if ispp[FF] and ispp[c]:
                    q = base[FF]
                    v = min(FF * comb(c, 2), (FF if q % 2 else FF // 2) * c * c)
                    if v > best * C:
                        best = v / C
        F += 1
    if stop_at and best > stop_at:
        return best
    lo = bisect.bisect_left(PPs, int(LO_X * n))
    hi = bisect.bisect_right(PPs, int(HI_X * n))
    for k in range(lo, hi):
        c = PPs[k]
        bp = base[c]
        r = n - c                                  # two parts
        # Lemma C: the p-block's twist must be coprime to every foreign prime,
        # so the full twist c-1 (and hence the full capacity C(c,2)) is only
        # available when r does not divide c-1.  In this window that can only
        # happen at c = r+1, i.e. n = 2r+1 with r Mersenne-like, but without the
        # guard the score would not be a lower bound on delta(n) there.
        if 3 <= r <= N and sieve[r] and bp != r and (c - 1) % r:
            v = min(comb(c, 2), EFF[r] * comb(r, 2), c * r)
            if v > best * C:
                best = v / C
                if stop_at and best > stop_at:
                    return best
        r = n - 2 * c                              # three parts, two equal blocks
        if 3 <= r <= N and sieve[r] and bp != r and (c - 1) % r:   # Lemma C, as above
            # rung C: the two c-blocks left UNFUSED (census S4)
            v = min(comb(c, 2), EFF[r] * comb(r, 2), c * c, c * r)
            if v > best * C:
                best = v / C
                if stop_at and best > stop_at:
                    return best
            # rung B: the two c-blocks fused in the CYCLIC layer (census S7 at
            # F = 2).  Fmid = 2 shares the cyclic layer with the twist, so the
            # twist is cut to the ODD PART of c-1; the top prime is free, but
            # must differ from 2, hence EFF_EX[3]-style exclusion is wrong here
            # -- what is excluded is q = 2, so use the best odd-q efficiency.
            dodd = c - 1
            while dodd % 2 == 0:
                dodd //= 2
            eB = EFF_ODD[r]
            if eB > 0:
                # Within-class cross carries F/2 = 1 because F = 2 is EVEN --
                # the coefficient is keyed on the parity of the BLOCK COUNT,
                # not on the top prime.  Writing 2*c*c here would not change any
                # reported figure, since 2*orb(c,d) <= c(c-1) < c^2 means the
                # term never binds -- but this is a lower-bound script, where an
                # over-credit is the dangerous direction, so it must be right for
                # a reason rather than by accident.  Rung B' below is the same
                # rule at F = 2.
                v = min(2 * orb_ld(c, dodd, bp == 2), eB * comb(r, 2),
                        c * c, 2 * c * r)
                if v > best * C:
                    best = v / C
                    if stop_at and best > stop_at:
                        return best
            # rung B': the two c-blocks fused in the TOP layer (census S5).
            # F_top = 2 forces q = 2, so the twist is untouched (full c-1) and
            # the foreign efficiency is the 2-part of r-1, i.e. 1/u.  The
            # within-class cross carries F/2 because F is even.
            if EFF2[r] > 0:
                v = min(2 * comb(c, 2), EFF2[r] * comb(r, 2), c * c, 2 * c * r)
                if v > best * C:
                    best = v / C
                    if stop_at and best > stop_at:
                        return best
    # S7 (added 2026-08): F blocks of c fused in the CYCLIC layer, plus a
    # foreign prime.  This is the family enumeration-proof.md G.2 wrongly ruled
    # out -- the block-permuting group need not sit in the top q-group, so F need
    # not be a q-power, only coprime to everything else the cyclic layer carries
    # (the twist c-1 and the foreign prime r).  The foreign twist's prime must
    # also differ from F's prime, which is why EFF_EX rather than EFF is used.
    #
    # Ordering note.  `achieved` early-returns once stop_at is cleared, so with a
    # naive stop_at a family placed FIRST can truncate the scan at its own value
    # and report less than the three-family version did -- still a valid lower
    # bound, but non-monotone.  The caller now passes
    # stop_at = max(0.9*cap, ASYMPTOTIC), which removes the truncation exactly on
    # the values that form the worklist, so order no longer changes the result.
    # S7 is kept last anyway: it is the most expensive family and the one most
    # often irrelevant.
    # F = 2 is deliberately absent from this loop and handled in the three-part
    # branch above instead: at F = 2 the shape is not an escape but the odd-n
    # fused RUNG (rungs B and B'), which belongs with the family it competes
    # against.  See aod section 3.2.
    #
    # EVERY OTHER F IS IN SCOPE, including even ones.  A fused class of F blocks
    # puts every prime divisor of F into the cyclic layer, so what the family
    # requires is only that the twist and the foreign top prime avoid those
    # primes -- and the twist is CUT to the largest divisor of c-1 coprime to F,
    # not abandoned.  Skipping such c instead (as the guard `(c-1) % qF == 0`
    # used to do) keeps the bound valid but discards the family outright at every
    # even F, since c - 1 is even for every odd c.  That is not a small loss:
    # F = 4 and F = 6 are the winning shapes at the arithmetically weakest n,
    # where no multiplicative escape exists, and omitting them understates those
    # values by more than a factor of two.
    for Fp in FSET:
        exclF = prime_divisors_of(Fp)
        EFFx = eff_excluding(exclF)
        # The within-class cross term takes the coefficient F for odd F and F/2
        # for even F -- the minimum pair-orbital of a transitive group of degree
        # F.  Using F for even F would OVERSTATE the family and break the
        # lower-bound guarantee, so the parity is load-bearing here.
        cross_coeff = Fp if Fp % 2 else Fp // 2
        for c in PPs:
            m = Fp * c
            if m >= n:
                break
            r = n - m
            if r < 3 or r > N or not sieve[r]:
                continue
            if base[c] == r or r in exclF:
                continue
            e = EFFx[r]
            if e <= 0:
                continue
            # The fused class sits in the cyclic layer alongside the twist, and
            # a cyclic group has a unique subgroup of each order, so the twist
            # must be coprime to F.  Scoring the intra term at Fp*C(c,2)
            # regardless would credit a twist the configuration cannot have and
            # make this an UPPER bound on the family rather than a lower one.
            # The correct cap is Fp * orb(c, dmax) with dmax the largest divisor
            # of c-1 coprime to F.
            dmax = c - 1
            for qq in exclF:
                while dmax % qq == 0:
                    dmax //= qq
            intra = Fp * orb_ld(c, dmax, base[c] == 2)
            v = min(intra, cross_coeff * c * c, m * r, e * comb(r, 2))
            if v > best * C:
                best = v / C
                if stop_at and best > stop_at:
                    return best
    return best

TICK, SUMMARY = 10_000, 100_000

def stamp():
    return time.strftime("%H:%M:%S")

t0 = time.time()
per = {a: [1e9, None, 0] for a in range(MOD)}
gmin = (1e9, None)
below = []
weak = []
blk_min = (1e9, None)              # minimum within the current SUMMARY block
last = t0
print(f"{stamp()}  scanning to {N:,}; checkpoint every {TICK:,}, "
      f"summary every {SUMMARY:,}")
# Untruncated trend measurement.  Sampling UNIFORMLY is worthless here: the
# quantity wanted is a MINIMUM, and the n attaining it are rare and structured
# (the doubly-obstructed residues with no multiplicative escape), so a uniform
# sample reports a value two to three times too high.  Sample inside the two
# lowest-cap residue classes instead -- 23 and 11 mod 24 -- which is where every
# observed minimum has sat.  One in TREND_EVERY members of those classes is
# rescanned without stop_at, so the added cost is about 2/(24*TREND_EVERY) of a
# full untruncated run.  Set TREND_EVERY = 0 to disable.
TREND_EVERY = 4
TREND_CLASSES = (23, 11)
blk_true = (9.9, None)
gtrue = (9.9, None)
trend_seen = 0

for n in range(6, N + 1):
    if not ispp[n]:
        a = n % MOD
        # Never early-return while the value is still below the asymptotic
        # bound: those n are exactly the worklist, and truncating them there
        # both lengthens the list and makes the family order matter.  Only
        # class 11 is affected -- every other class has 0.9*cap > ASYMPTOTIC
        # already -- so the extra work is negligible.
        d = achieved(n, stop_at=max(0.9 * CAP[a], ASYMPTOTIC))
        # The reported d is CLAMPED: once it clears stop_at the scan returns
        # early, so every n above the asymptotic bound reports "just above" it
        # rather than its family maximum.  That is safe for every claim here
        # (all are lower bounds) but it makes the per-block floor line unable to
        # show any trend once the true floor rises past ASYMPTOTIC -- the line
        # simply pins at that value.  To keep the trend visible at negligible
        # cost, recompute UNTRUNCATED on a sparse sample and report that
        # separately.  TREND_EVERY = 0 disables it.
        if TREND_EVERY and a in TREND_CLASSES and (n // MOD) % TREND_EVERY == 0:
            du = achieved(n)
            if du < blk_true[0]:
                blk_true = (du, n)
            if du < gtrue[0]:
                gtrue = (du, n)
            trend_seen += 1
        ratio = d / CAP[a]
        if ratio < per[a][0]:
            per[a][0], per[a][1] = ratio, n
        if d < gmin[0]:
            gmin = (d, n)
        if d < blk_min[0]:
            blk_min = (d, n)
        if d < FLOOR:
            per[a][2] += 1
            below.append((n, round(d, 5)))
        if d < ASYMPTOTIC:
            weak.append((n, round(d, 5)))
    if n % TICK == 0:
        now = time.time()
        rate = TICK / max(now - last, 1e-9)
        # Per-n cost is proportional to the number of prime powers in the scan
        # window, i.e. to n/log n, so elapsed time grows like N^2/log N.  Scale
        # the elapsed time by that ratio rather than extrapolating linearly.
        f = lambda x: x * x / math.log(max(x, 3))
        eta = (now - t0) * (f(N) / f(n) - 1)
        print(f"{stamp()}  n = {n:>9,}  ({now-t0:>6.0f}s, {rate:>7.0f} n/s)  "
              f"floor so far {gmin[0]:.5f} at n = {gmin[1]}"
              f"{'  <' + str(len(below)) + ' below ' + str(FLOOR) + '>' if below else ''}"
              f"   eta ~{eta/60:.1f}m")
        last = now
    if n % SUMMARY == 0:
        b = f"{blk_min[0]:.5f} at n = {blk_min[1]}" if blk_min[1] else "n/a"
        # Flag the clamp explicitly.  A block floor sitting at ASYMPTOTIC is
        # almost always the stop_at truncation rather than a real minimum, and
        # reading it as a trend is the mistake this label exists to prevent.
        if blk_min[1] and blk_min[0] < ASYMPTOTIC * 1.0001:
            b += "  [at or below the asymptotic bound: a real minimum]"
        else:
            b = f">= {ASYMPTOTIC:.5f}  [CLAMPED by stop_at, not a minimum]"
        tr = (f"; untruncated floor over classes {TREND_CLASSES} "
              f"{blk_true[0]:.5f} at n = {blk_true[1]}"
              f" (1 in {TREND_EVERY} of them, {trend_seen} scanned)") if blk_true[1] else ""
        print(f"{stamp()}  --- through {n:,}: block floor {b}; "
              f"global floor {gmin[0]:.5f} at n = {gmin[1]} "
              f"(mod 24 = {gmin[1] % MOD}); {len(below)} below {FLOOR}{tr} ---")
        blk_true = (9.9, None)
        trend_seen = 0
        blk_min = (1e9, None)
print(f"{stamp()}  scan complete in {time.time()-t0:.0f}s")
print()
print(f"{'n mod 24':>9} {'cap':>9} {'min delta/cap':>14} {'at n':>8} "
      f"{'# below ' + str(FLOOR):>14}")
for a in range(MOD):
    r, n, cnt = per[a]
    if n is None:
        continue
    print(f"{a:>9} {CAP[a]:>9.5f} {r:>14.3f} {n:>8} {cnt:>14}")
print()
print(f"GLOBAL FLOOR over composite non-prime-power n <= {N:,}: "
      f"delta >= {gmin[0]:.5f}, attained at n = {gmin[1]} "
      f"(n mod 24 = {gmin[1] % MOD})")
print(f"values with delta < {FLOOR}: {len(below)}"
      + (f" -> {below[:10]}" if below
         else "  -- the section 5 conjecture holds throughout this range"))
print()
print(f"values below the asymptotic bound {ASYMPTOTIC:.6f} = 5/2 - sqrt(6): {len(weak)}")
if weak:
    print("  NOT counterexamples.  This script searches four families over a window,")
    print("  so it computes a LOWER BOUND on delta(n).  It is a worklist: computing")
    print("  B(n) at these n would tighten the global floor of section 5 of")
    print(f"  arithmetic-of-density.md.  Written to {OUTFILE}.")
    print("  These are LOWER bounds, so an entry below a threshold does NOT mean")
    print("  delta(n) is below it -- B(n) may be larger.  Read the list as the set")
    print("  of n worth computing B(n) at, ranked by how little the four families")
    print("  find there.")
    with open(OUTFILE, "w") as fh:
        for n, d in weak:
            fh.write(f"{n} {d}\n")
    print("  first 15: " + ", ".join(f"{n}({d})" for n, d in weak[:15]))
