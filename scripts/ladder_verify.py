#!/usr/bin/env python3
#
# 2026-08-16: Lemma C guard added to the S7 (F >= 3) loop -- the two- and
# three-part branches guard with (c-1) % r, the S7 loop did not, so at n with
# r | c-1 it could credit a twist sharing the foreign prime.  Audited to 10^6
# (audit_s7.py): 495,176 candidates with r | c-1, 25,937 with a strictly larger
# invalid score, 0 of which exceeded the guarded maximum -- so no reported
# figure to 10^6 was affected; the guard prevents it biting on any extension.
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

CLASS CAPS (section 3.3), keyed MOD 12, used to report each n as a fraction of
what its class permits:
    n mod 12 in {0, 4, 6, 10}       cap 0.25000   k = 1, eta = 1
    n mod 12 in {2, 8}              cap 0.13397   k = 1, eta = 1/3
    n mod 12 in {1, 9}              cap 0.17157   F = 2, eta = 1
    n mod 12 in {3, 7}              cap 0.12500   F = 2, eta = 1/2
    n mod 12 == 5                   cap 0.10102   F = 2, eta = 1/3
    n mod 12 == 11                  cap 0.07180   F = 4, eta = 1/3  (= 7-4sqrt3)
The ceiling is the JOINT optimum over (F, eta), not eta at a fixed rung: at odd
n the fusion count must be even, and F = 4 wins at 11 because 4c = 4 rather than
6 (mod 8) pins r and removes the 2-adic cut on the foreign efficiency.  Six
constants; nothing finer than mod 12 survives into the table.

Usage:
    python3 ladder_verify.py 100000
    python3 ladder_verify.py 100000 --floor 0.04
"""
import sys, time, bisect, math
from math import comb

_A = sys.argv
N = int(_A[1]) if len(_A) > 1 and not _A[1].startswith("-") else 100000
FLOOR = 0.04   # = 1/25, the section 5 conjecture; verified to 10^6 with the
               # floor at 0.04453 (n = 11183), i.e. 11% of margin
for i, x in enumerate(_A):
    if x == "--floor":
        FLOOR = float(_A[i + 1])

# The asymptotic global lower bound of arithmetic-of-density.md section 5:
# 7 - 4*sqrt(3), the cap at n = 11 (mod 12) and the smallest of the six
# class caps.  Values falling
# below it here are NOT counterexamples -- this script scans three families over
# a window and so computes a LOWER BOUND on delta(n).  They are the values where
# that bound is too weak to reach the asymptotic constant, i.e. the worklist for
# a future mu_enumerate.py run.
ASYMPTOTIC = 7 - 4 * 3 ** 0.5      # 7 - 4*sqrt(3) = 0.0717968, the global
                                   # class ceiling, at n = 11 (mod 12)

# The worklist is EVIDENCE for figures quoted in arithmetic-of-density.md sections
# 3.7 and 5.2, and comparing two runs is the point of rerunning -- so do not write
# an unversioned file that the next run silently overwrites.  Override with
# LADDER_OUT=... to name a run explicitly.
import os as _os
OUTFILE = _os.environ.get("LADDER_OUT", "ladder_weak.txt")

# CLASS CEILINGS, KEYED MOD 12.  For odd n the shapes form a ladder
#
#   A  one c-block + foreign        cap  eta/(1+sqrt eta)^2       needs c = 2^a
#   B  two c-blocks FUSED + fgn     cap 2eta/(sqrt2+2sqrt eta)^2  no condition on c
#   C  two c-classes UNFUSED        cap  eta/(1+2sqrt eta)^2      always available
#
# with A > B > C.  A cyclic-layer fusion costs NOTHING on the matching side --
# an entangled generator supplies the block rotation and the full twist from one
# cyclic subgroup -- so rung B imposes no congruence on c and is available at
# every odd n.  What c mod 4 does instead is STEER the foreign residue: at F = 2,
# 2c = 2 or 6 (mod 8), so r = n - 2c reaches two residues mod 8.  They differ by
# 4 and hence agree mod 4, so the choice can buy r = 5 (mod 8) (eta = 1/2) but
# can never produce r = 3 (mod 4).  At F = 4, 4c = 4 (mod 8) for every odd c, so
# r is pinned and c is inert.
#
# GOTCHA, and the reason this table is mod 12 rather than mod 24: every mod-8
# condition in the derivation is either absorbed (F = 2, where the two options
# agree mod 4) or constant on the mod-12 class (F = 4).  A CAP table that
# separates any residue a from a + 12 is therefore getting it from a condition
# that does not survive -- a defect, not a refinement.  In particular a grouping
# that puts 7, 15 in one row and 3, 19 in another cuts ACROSS mod-12 classes,
# since 15 = 3 and 7 = 19 (mod 12); all four share a row at cap 1/8.
#
# The ceilings are the JOINT optimum over (F, eta), cap_F(eta) =
# eta/(1 + sqrt(F*eta))^2, maximised over the (F, eta) pairs the residue admits.
# At odd n the fusion count must be EVEN (c odd and r an odd prime force F*c
# even), and cap_F(1) = 1/(1+sqrt F)^2 excludes F >= 8 outright.  F = 4 attains
# the ceiling only at n = 11 (mod 12), where the ell = 3 obstruction caps eta at
# 1/3 and 7 - 4*sqrt(3) results; elsewhere F = 2 wins.  Note 1/9 = cap_4(1) is
# the absolute ceiling of the F = 4 SLICE and is not any class's ceiling: a
# class that could take F = 4 at full efficiency reaches 1/8 through F = 2 at
# eta = 1/2 instead.
CAP = {0: 0.250000, 1: 0.171573, 2: 0.133975, 3: 0.125000,
       4: 0.250000, 5: 0.101021, 6: 0.250000, 7: 0.125000,
       8: 0.133975, 9: 0.171573, 10: 0.250000, 11: 0.071797}
MOD = 12

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

# Efficiency at a SPECIFIC top prime q, as against the max over an allowed set.
# Needed because a fused class splits as F = F_mid * F_top with F_top a power of
# q (`enumeration-proof.md` G.2): the cyclic layer carries only F_mid, so the
# foreign twist has to avoid the primes of F_mid but MAY use q itself, and when
# it does its efficiency is pinned to that q rather than maximised over primes.
# Built once per q, over the same sieve pass shape as EFF, so the cost is a few
# array builds and nothing inside the family loops.
_EFF_AT_CACHE = {}


def eff_at(q0):
    """Foreign efficiency when the top prime is exactly q0, per r."""
    if q0 in _EFF_AT_CACHE:
        return _EFF_AT_CACHE[q0]
    arr = [0.0] * (N + 1)
    for r in range(3, N + 1, 2):
        if not sieve[r]:
            continue
        m = r - 1
        tq, x = 1, m
        while x % q0 == 0:
            x //= q0
            tq *= q0
        if tq == 1:
            continue                       # q0 does not divide r-1: no twist
        pm = tq if tq % 2 == 0 else 2 * tq
        arr[r] = min(pm, m) / m
    _EFF_AT_CACHE[q0] = arr
    return arr


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


# The layer splits of each fusion count, precomputed.
#
# WHY THERE IS MORE THAN ONE READING PER F.  A fused class of F blocks does NOT
# put every prime of F into the cyclic layer: F = F_mid * F_top with F_top a
# power of the top prime q, and only F_mid competes with the twist and the
# foreign prime there (`enumeration-proof.md` G.2, and the n = 308 witness in
# its Part 0).  Taking exclF = primes(F) for every F is the pre-repair reading;
# it stays a valid lower bound, but it silently discards every configuration
# whose foreign twist needs a prime dividing F -- in practice q = 2 with F even,
# i.e. Fermat-prime foreign blocks.  That is what made this ladder report
# delta(935) >= 0.04898 where B(935) = 0.07534, on `6x113 + 1x257*` with
# F_top = 2 and F_mid = 3.
#
# So each F contributes one branch per admissible split: the all-cyclic reading
# (q avoiding every prime of F), plus one per prime q | F, where F_top is the
# q-part, F_mid is the rest, and the efficiency is pinned to that q.  Each
# branch is a genuine configuration, so taking the best over branches keeps the
# result a lower bound.
#
# COST.  The branch list is built once; the scan runs the same single pass over
# PPs per branch that it previously ran per F.  FSET's members have one or two
# distinct prime divisors, so this is bounded by a factor of three on the S7
# family alone and measures well below that, the extra branches being the ones
# whose efficiency array is mostly zero and so exit at `e <= 0` immediately.
PPs = [c for c in range(2, N + 1) if ispp[c]]

S7_BRANCHES = []
for _F in FSET:
    _pr = prime_divisors_of(_F)
    S7_BRANCHES.append((_F, _pr, eff_excluding(_pr)))
    for _q in sorted(_pr):
        _mid = _F
        while _mid % _q == 0:
            _mid //= _q
        _excl = prime_divisors_of(_mid) if _mid > 1 else set()
        S7_BRANCHES.append((_F, _excl, eff_at(_q)))

# The twist a branch leaves on a c-block depends only on its exclusion set, so
# strip once per set rather than once per (branch, c) inside the scan.  This is
# what pays for the extra branches: it removes a division loop from the inner
# body, and the branch list has only a handful of distinct exclusion sets.
_STRIP_CACHE = {}


def strip_map(excl):
    key = frozenset(excl)
    if key in _STRIP_CACHE:
        return _STRIP_CACHE[key]
    m = {}
    for c in PPs:
        d = c - 1
        for qq in key:
            while d % qq == 0:
                d //= qq
        m[c] = d
    _STRIP_CACHE[key] = m
    return m


S7_BRANCHES = [(F_, ex_, ef_, strip_map(ex_)) for F_, ex_, ef_ in S7_BRANCHES]
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
    keep reporting 0.9 * cap verbatim.  Everything the script asserts is a
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
            # F = 2).  The twist is FULL -- an entangled generator (a block
            # rotation whose step-multipliers have product a generator of F_c^*)
            # supplies the rotation and the whole of C_{c-1} from one cyclic
            # subgroup, so a cyclic-layer fusion costs nothing on the matching
            # side and imposes no congruence on c.  Cutting the twist to the odd
            # part of c-1 here would UNDERSTATE the rung at every c; since this
            # script takes a max over families, that shows up as a floor that is
            # too low rather than as an error, which is why it is worth stating.
            # The top prime is free but must differ from 2 (q = 2 is rung B'),
            # so the foreign efficiency is the best over ODD q.
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
                v = min(2 * comb(c, 2), eB * comb(r, 2),
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
    for Fp, exclF, EFFx, STRIP in S7_BRANCHES:
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
            # Lemma C guard (same as the two- and three-part branches): the
            # c-blocks' cyclic-layer twist must be coprime to the foreign prime
            # r.  STRIP removes the branch's F_mid primes but not r, so when
            # r | c-1 the r-part must be stripped as well or the intra term
            # credits a twist the cyclic layer cannot hold.
            d_tw = STRIP[c]
            while d_tw % r == 0:
                d_tw //= r
            # The fused class sits in the cyclic layer alongside the twist, and
            # a cyclic group has a unique subgroup of each order, so the twist
            # must be coprime to F.  Scoring the intra term at Fp*C(c,2)
            # regardless would credit a twist the configuration cannot have and
            # make this an UPPER bound on the family rather than a lower one.
            # The correct cap is Fp * orb(c, dmax) with dmax the largest divisor
            # of c-1 coprime to F.
            intra = Fp * orb_ld(c, d_tw, base[c] == 2)
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
# lowest-cap residue class instead -- 11 mod 12 -- which is where every
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
              f"(mod 12 = {gmin[1] % MOD}); {len(below)} below {FLOOR}{tr} ---")
        blk_true = (9.9, None)
        trend_seen = 0
        blk_min = (1e9, None)
print(f"{stamp()}  scan complete in {time.time()-t0:.0f}s")
print()
print(f"{'n mod 12':>9} {'cap':>9} {'min delta/cap':>14} {'at n':>8} "
      f"{'# below ' + str(FLOOR):>14}")
for a in range(MOD):
    r, n, cnt = per[a]
    if n is None:
        continue
    print(f"{a:>9} {CAP[a]:>9.5f} {r:>14.3f} {n:>8} {cnt:>14}")
print()
print(f"GLOBAL FLOOR over composite non-prime-power n <= {N:,}: "
      f"delta >= {gmin[0]:.5f}, attained at n = {gmin[1]} "
      f"(n mod 12 = {gmin[1] % MOD})")
print(f"values with delta < {FLOOR}: {len(below)}"
      + (f" -> {below[:10]}" if below
         else "  -- the section 5 conjecture holds throughout this range"))
print()
print(f"values below the asymptotic bound {ASYMPTOTIC:.6f} = 7 - 4*sqrt(3): {len(weak)}")
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
