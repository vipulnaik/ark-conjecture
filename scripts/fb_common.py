#!/usr/bin/env python3
"""
fb_common.py -- shared machinery for the two fallback-collapse certificates.

`fallback_cert.py` runs against the true B(n) from the computed table;
`wide_cert.py` runs against a proven lower bound B_lo(n) and so reaches much
further.  Both ask the same question and enforce the same necessary conditions,
so those live here once.

THE QUESTION.  A "fallback configuration" contains a p-characteristic part
(F, c) and a foreign prime r of the same configuration with r | c-1, so that
Lemma C strictly reduces the c-twist and SAFE scoring assigns F*C(c,2) where
the Part E construction reaches only F*orb(c, d).  If such a configuration
attains B_safe(n), the sandwich B_refined <= mu <= B_safe fails to collapse at
that n.  Certifying that none can attain it proves mu(n) = B(n).

WHICH QUANTITY IS BEING BOUNDED, AND WHY IT DECIDES WHAT COUNTS AS NECESSARY.
The collapse needs B_refined(n) = B_safe(n), which reduces to: no share-carrying
configuration has its SAFE SCORE >= B_safe(n).  SAFE values a p-characteristic
part at the flat F*C(c,2) -- that is what mu_enumerate_v3.py's value() computes
and what the mu_bound column holds.  So a condition is necessary for this
certificate's purpose exactly when SAFE(W) >= B implies it.

That rules out capping the p-part by F*orb(c, dmax) with the foreign prime
stripped.  orb(c, dmax) <= C(c,2), so such a cap tests a SMALLER number than
SAFE assigns and can reject a configuration whose SAFE score does reach B --
anti-permissive, the one direction this file cannot detect from its own output.
The strip bounds a different quantity: the minimum intra-orbital of an actual
GROUP of that shape, which is what the leftover twist cap of Part E-prime is
about, and which is anyway only bounded by orb(c, dmax) for a GammaL(1)-type
stabiliser (Part B's extraspecial counterexample).  Bounding that quantity
proves mu(n) = B_refined(n), not B_refined(n) = B_safe(n).

So condition (4) below is the FLAT cap F*C(c,2) >= B.  It is weaker, hence
permissive, hence sound; the strip is retained only as an optional diagnostic
(set_strip_diagnostic), never as a gate.  Measured consequence: with the flat
cap and no theorems at all, the candidate list is still EMPTY at every row of
the computed table -- so the collapse in range rests on neither Corollary C'
nor J0a.

SOUNDNESS RULE, obeyed everywhere below: every test is a NECESSARY condition on
such a configuration, and every over-approximation errs permissive.  A candidate
that survives may be spurious; a real one is never discarded.  In particular the
certificate is sound against any B <= B_safe(n), which is what lets wide_cert.py
substitute a lower bound.

WHAT "ONLY THE EIGHT NECESSARY CONDITIONS" DOES AND DOES NOT MEAN.  Both
certificates advertise that a --no-theorems run rests only on the conditions
below.  That is true of the Part E-prime THEOREMS, and it is what the switch
buys, but two further dependencies sit underneath the conditions themselves and
should be named wherever the slogan is quoted:

  * UNFUSED FOREIGN PARTS.  Condition (3) scores a foreign part as a single
    block, orb(r, t) >= B, and the leftover tests admit foreign parts only at
    F = 1.  For a FUSED foreign class of F' blocks the intra term is
    F'*orb(r, t), so (3) is not necessary for it.  What excludes fused-foreign
    configurations is Lemma D2's domination (m* <= n*min(F',r)/2), whose
    range-scoped half is checked by `a18_verify.py` and which beyond the table
    needs only delta >> n^-1/2.  So the trusted base is: these conditions, PLUS
    D2/D2-prime over the range, PLUS Part 0's shape space.  Rerun a18_verify.py
    on every extension -- `pending-checks.md` R1 schedules it.
  * NOTHING ELSE.  In particular the conditions below no longer include a
    twist strip, and so no longer inherit Corollary C' or J0a -- see WHICH
    QUANTITY IS BEING BOUNDED.
"""
from math import comb, isqrt, gcd

# ---------------------------------------------------------------- theorem switch
#
# The Part E-prime theorems (E.1, E.3(ii), E.3(iii), E.4, Lemma E.2's bound on
# L(a), and the hardcoded MERSENNE / REPUNIT3 tables) are an OPTIMISATION, not
# part of the proof: a branch they dispatch is never searched, so an error in one
# of them -- or in its implementation -- would silently remove a real candidate.
# Setting USE_THEOREMS = False makes every branch go to the search and drops the
# E.3(ii) resolution, so a run in that mode rests only on the eight necessary
# conditions below being necessary.  That is a much smaller trusted base than the
# module's structure suggests, and it is worth re-establishing on every extension
# rather than living in a log: if the two modes ever disagree while the normal
# run passes, the error is localised to E.1 / E.3 / E.4 or their tables at once.
USE_THEOREMS = True

# Diagnostic hook.  A strip that fires where it is not licensed produces exactly
# the same (empty) candidate list as a correct run, so the failure is invisible
# in the output.  Set this to a list to record every strip DECISION as
# (p, a, r, B, bound, licensed) -- both the fires and the declines, since the
# interesting quantity is how often the gate changes the answer, and that cannot
# be read off the candidate list at all.
_STRIP_TRACE = None


def set_strip_trace(lst):
    global _STRIP_TRACE
    _STRIP_TRACE = lst


def _record_strip_diagnostic(A, c, r, p, B):
    """Records what the OLD strip-based cap would have decided at this (c, r).

    Purely observational: nothing in the certificate reads it.  It exists so
    that the weaker group-level statement (mu = B_refined, via Part E-prime's
    leftover twist cap) can still be measured, and so that a run can report how
    often the two questions would have parted company.  Entries are
    (p, a, r, B, sharing_bound, licensed)."""
    pp = A.prime_power(c)
    if not pp or (c - 1) % r:
        return
    bd = sharing_bound(p, pp[1], r)
    _STRIP_TRACE.append((p, pp[1], r, B, bd, bd < B))


def set_use_theorems(flag):
    """Callers should go through this rather than assigning the global, so that
    `from fb_common import USE_THEOREMS` in a caller cannot silently bind a stale
    copy of the value."""
    global USE_THEOREMS
    USE_THEOREMS = bool(flag)

# ---------------------------------------------------------------- arithmetic

def sieve_spf(N):
    spf = list(range(N + 2))
    i = 2
    while i * i <= N + 1:
        if spf[i] == i:
            for j in range(i * i, N + 2, i):
                if spf[j] == j:
                    spf[j] = i
        i += 1
    return spf

class Arith:
    """Smallest-prime-factor arithmetic, shared by both certificates."""
    def __init__(self, N):
        self.N = N
        self.spf = sieve_spf(N)

    def is_prime(self, x):
        return x > 1 and self.spf[x] == x

    def prime_power(self, x):
        """(p, e) if x = p^e with e >= 1, else None."""
        if x < 2:
            return None
        p = self.spf[x]; e = 0
        while x % p == 0:
            x //= p; e += 1
        return (p, e) if x == 1 else None

    def prime_divisors(self, x):
        """Distinct prime divisors.  Uses the sieve when x is in range, and
        falls back to trial division otherwise (the theorem caps below factor
        numbers larger than the sieve, but only for pairs that fit in range,
        so the fallback is never called on anything unfactorable in practice)."""
        if x <= self.N:
            out = []
            while x > 1:
                p = self.spf[x]; out.append(p)
                while x % p == 0:
                    x //= p
            return out
        out, d = [], 2
        while d * d <= x:
            if x % d == 0:
                out.append(d)
                while x % d == 0:
                    x //= d
            d += 1 if d == 2 else 2
        if x > 1:
            out.append(x)
        return out

    def largest_pp_divisor(self, x):
        best = 1
        for p in self.prime_divisors(x):
            e = 1
            while x % (p ** (e + 1)) == 0:
                e += 1
            best = max(best, p ** e)
        return best

def qpart(x, q):
    t = 1
    while x % (t * q) == 0:
        t *= q
    return t

def orb(c, t):
    """Minimum intra-orbital of a c-block with cyclic twist of order t, capped
    at C(c,2).  The cap matters: it is what makes a 2-block worth 1, not 2.

    NOTE, and do NOT "fix" it: this deliberately omits the characteristic-2
    halving that `mu_enumerate`'s orb() applies (at p = 2 one has -1 = 1, so
    +/-T = T and the orbital is c*t/2 even at odd t).  Omitting it OVER-states
    the intra term by at most a factor 2 at even c.  Every use of orb() in this
    file is an upper-bound cap inside a NECESSARY condition, where over-stating
    keeps a candidate alive -- the permissive, sound direction.  Adding the
    halving here would make those conditions anti-permissive and could discard a
    real candidate silently, which is the one error class this file cannot
    detect from its own output."""
    return min(c * t // 2 if t % 2 == 0 else c * t, comb(c, 2))

def ord_mod(p, r):
    """Multiplicative order of p mod r, for r prime not dividing p."""
    o, v = 1, p % r
    while v != 1:
        v = v * p % r
        o += 1
    return o


def sharing_bound(p, a, r):
    """Corollary C' (enumeration-proof.md Part D): if the cyclic-layer twist of a
    p-characteristic part with blocks of size c = p^a shares the prime r with an
    outside part of prime size r, then every multiplier induced on that outside
    part lies in <p mod r>, so its twist order t divides ord_r(p), which divides
    a.  The outside part therefore carries an intra class of at most

        orb(r, t)  <=  min(r * ord_r(p), C(r, 2)).

    A configuration containing a share thus has some class no larger than this,
    so it cannot attain B whenever the bound is BELOW B -- which is what makes
    stripping r from the twist a NECESSARY condition rather than merely a true
    one.  The bound is local to (p, a, r): no n, no density floor, no threshold
    on the table.  It is finite and small in practice because ord_r(p) <= a and
    a <= log_p(n).

    Note the strip only ever acts when r | p^a - 1, i.e. when ord_r(p) | a; on
    every other (p, a, r) there is nothing in the twist to strip and the gate is
    vacuous either way."""
    return min(r * ord_mod(p, r), comb(r, 2))


def foreign_cap(A, r):
    """Max over top primes q of orb(r, q-part of r-1), including the q | r-1
    failing case where the twist is trivial and the block is worth r."""
    if r <= 2:
        return 1
    return max([r] + [orb(r, qpart(r - 1, q)) for q in set(A.prime_divisors(r - 1))])

# ------------------------------------------------- theorems of Part E-prime

MERSENNE = [2, 3, 5, 7, 13, 17, 19, 31, 61, 89, 107, 127, 521, 607]
REPUNIT3 = [3, 7, 13, 71, 103, 541]          # a with (3^a-1)/2 prime

def cap_mersenne(A, nmax=None):
    """Theorem E.1, p = 2 branch: s = 1 forces c = 2^a, r = 2^a - 1 Mersenne,
    and SAFE <= (2^a - 1) * max(2, L(a)) with L(a) the largest prime-power
    divisor of 2^(a-1) - 1.  Lemma E.2 bounds L(a) <= 2^((a-1)/2) + 1."""
    out = {}
    nmax = nmax if nmax is not None else A.N
    for a in MERSENNE:
        if 2 ** (a + 1) - 1 > nmax:      # pair cannot fit at any n <= nmax
            break
        M = 2 ** (a - 1) - 1
        out[a] = (2 ** a - 1) * max(2, A.largest_pp_divisor(M) if M > 1 else 1)
    return out

def cap_repunit(A, nmax=None):
    """Theorem E.3(iii), s = 2 with a >= 2: forces p = 3 and r = (3^a - 1)/2 a
    base-3 repunit prime, with the foreign block's SAFE score capped by
    Cap'(a) = max over q of orb(r, q-part of r-1) = O(r^{3/2})."""
    out = {}
    nmax = nmax if nmax is not None else A.N
    for a in REPUNIT3:
        c = 3 ** a
        r = (c - 1) // 2
        if c + r > nmax:                 # pair cannot fit at any n <= nmax
            break
        out[a] = (c, r, max([orb(r, qpart(r - 1, q))
                             for q in set(A.prime_divisors(r - 1))] + [r]))
    return out

E4_PAIR = (16, 5)        # Theorem E.4: the entire s = 3 branch
E4_CAP = 10              # its absolute SAFE ceiling, orb(5, 4)

def s_max(n, B):
    """Largest s = (c-1)/r a fallback configuration can have at this n, from
    r^2 > delta*n(n-1) and c <= n - r (Part E-prime): s <= 1/sqrt(delta) - 1.

    Computed in EXACT INTEGER ARITHMETIC.  The float form
    `int(1/d**0.5 - 1 + eps)` needs a fudge term precisely because the inputs
    that reach the comparison are the ones sitting on the boundary
    delta = 1/(s+1)^2, and floating point settles those by accident of
    representation.  The rule is general and worth carrying to every threshold
    test here: a tolerance equal to the exact boundary of the property it tests
    fails on exactly the cases it exists to decide.  Move the comparison into
    arithmetic with no boundary error instead of tuning the boundary.

    s <= 1/sqrt(delta) - 1  <=>  (s+1)^2 * delta <= 1  <=>  (s+1)^2 * B <= C(n,2).
    """
    C = comb(n, 2)
    s = 1
    while (s + 2) ** 2 * B <= C:
        s += 1
    return s

def branch_settled(A, n, B, s, caps_m, caps_r):
    """Is the s-branch at this n settled by theorem alone?  Returns
    (True, reason) or (False, reason).

    Under --no-theorems this answers False for every branch, so nothing is
    dispatched and every branch reaches the search."""
    if not USE_THEOREMS:
        return False, "theorems disabled (--no-theorems)"
    if s == 1:
        for a, cap in caps_m.items():
            if 2 ** (a + 1) - 1 <= n and cap >= B:
                return False, f"E.1 Mersenne a={a}: Cap={cap} >= B"
        return True, "E.1 (r=2 branch worth 1; Mersenne caps all below B)"
    if s == 2:
        # a >= 2 repunit branch: capped
        for a, (c, r, cap) in caps_r.items():
            if c + r <= n and cap >= B:
                return False, f"E.3(iii) repunit a={a}: Cap'={cap} >= B"
        # a = 1 safe-prime branch: pairwise domination only, not global
        return False, "E.3(ii) is pairwise only; global promotion open"
    if s == 3:
        c, r = E4_PAIR
        if c + r <= n and E4_CAP >= B:
            return False, f"E.4 pair {E4_PAIR}: cap {E4_CAP} >= B"
        return True, "E.4 (branch is the single pair (16,5), cap 10)"
    return False, f"s={s} has no theorem"

def theorem_report(A, n, B, caps_m, caps_r):
    """Per-n theorem coverage: (fully_settled, s_max, {s: (ok, reason)})."""
    sm = s_max(n, B)
    per = {s: branch_settled(A, n, B, s, caps_m, caps_r) for s in range(1, sm + 1)}
    return all(ok for ok, _ in per.values()), sm, per

# --------------------------------------------- necessary conditions (1)-(8)
#
# NECESSITY, CONDITION BY CONDITION.  What makes an empty candidate list a proof
# is that each condition below is NECESSARY for a fallback configuration to
# attain B(n) -- not merely true of the ones we know about.  A condition that is
# not in fact necessary silently discards a real candidate, which is the one
# error class this file cannot detect from its own output.  So:
#
#   (1) r | c-1, r prime != p             definitional for the branch (Lemma C's
#                                         trigger).
#   (2) q | r-1, or the '*' branch        necessary: Lemma B' forces the foreign
#                                         twist into the top layer, so it is a
#                                         q-power dividing r-1; a trivial twist
#                                         leaves the block worth only r, which is
#                                         the '*' branch, gated on r >= B.
#   (3) orb(r, qpart(r-1,q)) >= B         necessary: the twist divides the q-part
#                                         and orb is monotone in it.
#   (4) F * C(c,2) >= B                   necessary: SAFE scores the part at
#       exactly F*C(c,2), so a configuration attaining B_safe(n) satisfies this.
#       It is the FLAT cap and no twist strip is applied -- see WHICH QUANTITY
#       IS BEING BOUNDED in the header.  A strip of the foreign prime (Lemma C's
#       coupling, licensed by Corollary C') would give the smaller
#       F*orb(c, dmax) and is ANTI-permissive against B_safe, so it is available
#       here only as a diagnostic.  Stripping the block count is unsound on top
#       of that (the rotation's image is a quotient of the cyclic layer, not a
#       subgroup) and is done nowhere.
#   (5) F * c * r >= B                    necessary by counting: the cross class
#                                         holds F*c*r pairs in total.
#   (6) coeff(F) * c^2 >= B               NOT independently necessary -- see below.
#   (7) leftover floors                   necessary by counting on each leftover
#                                         part's cross classes and its own intra.
#   (8) leftover composability            necessary per part by (3)/(4)-type
#                                         arguments; the subset-sum reachability
#                                         over-approximates, hence permissive.
#
# ON (6).  The within-class cross coefficient is exact for the Part E
# construction (block-permuting group the regular C_F) and is NOT an upper bound
# over all admissible block-permuters: F = Fmid*Ftop need not be a prime power, so
# the permuter may be 2-transitive on the blocks -- AGL(1,5) on 5 of them -- and
# then the single cross orbital is 10c^2 rather than 5c^2.  So (6) is kept as a
# TRIPWIRE rather than relied on as a necessity, and it cannot wrongly exclude
# anything, because coeff*c^2 >= F*C(c,2) >= F*orb(c,dmax) means (4) binds first
# in every case.  Do not promote it to an independent condition.

def intra_floor(B):
    """Smallest part size that can carry an intra-orbital of size B at all,
    i.e. least s with C(s,2) >= B.  Closed form via isqrt -- the obvious
    increment-by-one loop costs O(sqrt(B)) and this runs in the inner loop of
    both certificates, where B can be 10^8."""
    if B <= 0:
        return 1
    s = (1 + isqrt(1 + 8 * B)) // 2
    while s * (s - 1) // 2 < B:
        s += 1
    while s > 1 and (s - 1) * (s - 2) // 2 >= B:
        s -= 1
    return s

def single_part_ok(A, L, B, p, q, r):
    """Can the leftover L be ONE admissible part whose own intra term reaches B?
    q may be '*' for the generic branch, over-approximated permissively.

    Note the block count F ranges over ALL divisors of L, not over q-powers.
    Under the corrected shape space F = F_mid * F_top with only F_top a q-power,
    so a q-power-only list would be a restriction in the ANTI-permissive
    direction -- it could discard a real leftover and turn an inconclusive n
    into a spurious proof."""
    Fs = [f for f in range(1, L + 1) if L % f == 0]
    for F in Fs:
        if L % F:
            continue
        c2 = L // F
        pp = A.prime_power(c2)
        if not pp:
            continue
        if pp[0] == p:
            # The leftover p-characteristic cap is the FLAT F * C(c2, 2), for
            # the same reason as condition (4): the question is whether a
            # configuration's SAFE score can reach B, and SAFE credits this part
            # every pair in every block regardless of twist.  An earlier form
            # capped it by the twist stripped of the foreign prime, which is a
            # bound on what a GROUP of this shape realises rather than on what
            # SAFE assigns, and is therefore anti-permissive here.
            #
            # What that costs is sharpness at one shape and nothing else: the
            # leftover L = c with c = 2r + 1, where the strip left d | 2 and
            # closed the branch immediately.  Under the flat cap that shape is
            # closed by the search instead, which is where it belongs.
            cap_i = F * comb(c2, 2)
            if cap_i >= B:
                return True
        elif pp[1] == 1 and c2 != r:
            capf = foreign_cap(A, c2) if q == '*' else orb(c2, qpart(c2 - 1, q))
            if F == 1 and capf >= B:
                return True
    return False

def multi_part_ok(A, L, B, p, q, r, limit=60):
    """Can L split into two or more admissible parts, each meeting the necessary
    floors?  Exact-sum reachability over: foreign primes r_j != r whose own cap
    reaches B (distinct, so subset sums), and p-characteristic sizes F'*p^j with
    F'*C(p^j,2) >= B (repeats allowed, so unbounded sums).  Necessary conditions
    only, hence permissive.  Returns True/False, or None if the candidate set is
    too large to enumerate (treated as surviving by callers)."""
    fcands = []
    for rj in range(3, L + 1, 2):
        if not A.is_prime(rj) or rj == r:
            continue
        capj = foreign_cap(A, rj) if q == '*' else orb(rj, qpart(rj - 1, q))
        if capj >= B:
            fcands.append(rj)
    pcands = []
    cj = p
    while cj <= L:
        # F over every integer, not over q-powers: F = F_mid * F_top and only
        # F_top is a q-power, so restricting here would drop real parts.  The
        # `q == '*'` branch previously stopped at F = 1, which was the same
        # restriction in its sharpest form.
        # Same twist cap as in single_part_ok: for a fixed prime q the part's
        # twist is qpart(cj-1, q) times the r-coprime remainder, since the
        # cyclic layer already holds C_r and is one cyclic group.  C(cj, 2) is
        # kept only in the '*' branch, which is gated on r >= B.
        # FLAT, as in condition (4) and single_part_ok: SAFE credits a
        # p-characteristic part F'*C(c_j,2) whatever its twist, so that is what
        # a configuration attaining B_safe(n) must clear.  The twist-stripped
        # form is a bound on a group's realised orbital, not on the SAFE score,
        # and using it here would be anti-permissive.
        capc = comb(cj, 2)
        for F in range(1, L // cj + 1):
            if F * capc >= B:
                pcands.append(F * cj)
        cj *= p
    if len(fcands) + len(pcands) > limit:
        return None
    reach = {0}
    for x in fcands:
        reach |= {v + x for v in reach if v + x <= L}
    for x in pcands:
        growing = True
        while growing:
            add = {v + x for v in reach if v + x <= L} - reach
            reach |= add
            growing = bool(add)
    return L in reach

def leftover_ok(A, L, B, p, q, r, Fc):
    """Conditions (7)-(8) on the leftover L = n - F*c - r.  True if L could be
    made of admissible parts, False if provably not, None if inconclusive."""
    if L == 0:
        return True
    need = max(-(-B // min(Fc, r)), intra_floor(B))
    if L < need:
        return False
    if L < 2 * need:
        return single_part_ok(A, L, B, p, q, r)
    if single_part_ok(A, L, B, p, q, r):
        return True
    return multi_part_ok(A, L, B, p, q, r)

def e3ii_resolves(A, n, c, r, F, L):
    """Theorem E.3(ii), applied as a RESOLUTION rather than a mere domination.

    When the whole configuration is the bare pair -- F = 1 and leftover L = 0,
    so n = c + r with c = 2r + 1 a safe prime -- the (p, q) = (r, r) re-reading
    of the same n is a different admissible configuration, namely the r-block
    p-characteristic at full twist plus the c-block foreign.  Three facts make
    that a proof of collapse at this n rather than a heuristic:

      * it IS an admissible configuration: the chain is F_r <| F_r : (C_{r-1} x
        F_c) <| Gamma, whose middle layer is cyclic because gcd(r-1, c) = 1.
        That gcd is not immediate -- gcd(r-1, 2r+1) = gcd(r-1, 3), so what has
        to be ruled out is 3 | r-1 -- and it holds because r == 1 (mod 3) would
        force 3 | 2r+1 = c, killing the primality of c unless c = 3.  Stating
        the conclusion without this step is the gap worth naming: "gcd(r-1, c)
        = 1" does not follow from anything about safe primes on its own;
      * it scores min(C(c,2), C(r,2), cr), and the fallback reading scores
        min(C(c,2), orb(r,t), cr) with orb(r,t) <= C(r,2), so the re-reading
        scores at least as much;
      * it is itself FALLBACK-FREE -- the only foreign prime is c, the p-part is
        r, and c = 2r + 1 > r - 1 cannot divide r - 1 -- so its SAFE and REFINED
        scores coincide;
      * hence if the fallback reading attained B_safe(n), so does the re-reading,
        giving B_refined(n) >= B_safe(n) and therefore equality.

    This does NOT extend to L > 0.  With a leftover the re-reading must also
    re-type the leftover parts, and the commonest case L = c fails outright: two
    blocks of the same prime c would be two equal foreign parts, which Part E
    forbids (they would place C_c x C_c in the cyclic layer), and fusing them is
    forbidden too.  Those cases stay open -- Part J item 2.

    Under --no-theorems this returns False, so the pair is kept as a candidate
    rather than resolved.  That is the anti-permissive direction on purpose: the
    point of the mode is that a surviving-candidate list computed without any
    Part E-prime clause should still be empty."""
    if not USE_THEOREMS:
        return False
    return F == 1 and L == 0 and c == 2 * r + 1 and A.is_prime(c)

def pair_candidates(A, n, B, c, r, p, skip_settled=None):
    """All (p, q, F, c, r) meeting conditions (1)-(8) for this (c, r) at this n.
    `skip_settled` is an optional set of s values already settled by theorem."""
    out = []
    if (c - 1) % r or c + r > n:
        return out
    s = (c - 1) // r
    if skip_settled and s in skip_settled:
        return out
    qopts = list(set(A.prime_divisors(r - 1)))
    if r >= B:
        qopts.append('*')                  # trivial-twist generic branch
    Fmax = (n - r) // c
    for q in qopts:
        t = 1 if q == '*' else qpart(r - 1, q)
        if orb(r, t) < B:
            continue
        # F over every integer up to Fmax.  A q-power ladder here is the
        # pre-correction shape space: F = F_mid * F_top with F_mid drawn from the
        # cyclic layer, so F need only be coprime to what that layer already
        # carries.  Enumerating all F is permissive -- some are inadmissible on
        # the coprimality budget -- which is the required direction.
        for F in range(1, Fmax + 1):
            # Within-class cross: the coefficient is F for ODD F and F/2 for
            # EVEN F, keyed on the parity of the block count and not on the top
            # prime.  Reading it off q is correct only where F is forced to be a
            # q-power, since even F then means q = 2; under the corrected shape
            # space the two come apart.  Here the q-keyed form is the LARGER of
            # the two at odd q with even F, so it made `ok` true more often --
            # permissive, hence sound, but wrong, and it would silently become
            # anti-permissive if this expression were ever reused with the
            # inequality the other way round.
            # The intra cap is F * orb(c, dmax), NOT F * C(c, 2).  dmax is the
            # twist's q-part (which may sit in the top layer) times the rest of
            # c - 1 with the FOREIGN PRIME stripped where Corollary C' licenses
            # it -- and nothing else stripped; see the note at the strip below
            # for why the block count must not join it.  The foreign strip alone
            # is what resolves the F = 2 reading of n = 5r + 2 at c = 2r + 1:
            # there c - 1 = 2r, r goes, and what is left is d | 2, so the intra
            # collapses to O(c) at odd q.
            # Condition (4), FLAT.  SAFE scores a p-characteristic class at
            # F*C(c,2) whatever its twist, so that is what a configuration
            # attaining B_safe(n) must clear, and it is the only cap here that
            # is necessary for the question this file asks.  Capping by
            # F*orb(c, dmax) instead -- the twist stripped of the foreign prime
            # -- tests a smaller number and can reject a configuration whose
            # SAFE score does reach B: anti-permissive, and invisible in the
            # output, which is the one error class this file cannot detect.
            #
            # The strip is not wrong, it answers a different question: it bounds
            # the minimum intra-orbital of an actual GROUP of this shape (Part
            # E-prime's leftover twist cap), which yields mu = B_refined rather
            # than B_refined = B_safe, and which is itself only valid for a
            # GammaL(1)-type stabiliser.  Reported by strip_diagnostic() for
            # anyone who wants that weaker statement; never used as a gate.
            intra_cap = F * comb(c, 2)
            if _STRIP_TRACE is not None and q != '*':
                _record_strip_diagnostic(A, c, r, p, B)
            ok = (intra_cap >= B and F * c * r >= B and
                  (F == 1 or (F if F % 2 else F // 2) * c * c >= B))
            if ok:
                lo = leftover_ok(A, n - F * c - r, B, p, q, r, F * c)
                if lo is False:
                    ok = False
                elif lo is None:
                    out.append((p, q, F, c, r, s, 'INCONCLUSIVE-LEFTOVER'))
                    break
            if ok:
                L = n - F * c - r
                if e3ii_resolves(A, n, c, r, F, L):
                    break                       # dominated by the (r,r) re-reading
                out.append((p, q, F, c, r, s, L))
                break
    return out
