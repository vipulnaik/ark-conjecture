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

SOUNDNESS RULE, obeyed everywhere below: every test is a NECESSARY condition on
such a configuration, and every over-approximation errs permissive.  A candidate
that survives may be spurious; a real one is never discarded.  In particular the
certificate is sound against any B <= B_safe(n), which is what lets wide_cert.py
substitute a lower bound.
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
    at C(c,2).  The cap matters: it is what makes a 2-block worth 1, not 2."""
    return min(c * t // 2 if t % 2 == 0 else c * t, comb(c, 2))

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
    r^2 > delta*n(n-1) and c <= n - r (Part E-prime).  Returns floor."""
    d = B / comb(n, 2)
    return max(1, int(1 / d ** 0.5 - 1 + 1e-12))

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
            # The p-characteristic cap is NOT F * C(c2, 2).  The part's twist has
            # order dividing c2 - 1 and coprime to p, so it embeds in
            # (cyclic layer) x (top q-group); the cyclic layer already carries
            # the foreign block's translations C_r (Lemma B-prime puts them
            # there), and a cyclic group forces pairwise-coprime orders.  Hence
            # the cyclic part of the twist is coprime to r, and only the q-part
            # may hide in the top layer.  The largest admissible twist is
            # therefore qpart(c2-1, q) * (largest divisor of the rest coprime to
            # r) -- the same dmax logic as SAFE, applied to the leftover.
            #
            # This is what resolves the leftover L = c at c = 2r + 1: there
            # c2 - 1 = 2r, the r is stripped by coprimality and (for odd q not
            # dividing 2r) the q-part is 1, so dmax = 2 and the intra caps at
            # orb(c2, 2) = c2, far below B.  Without this cap the full C(c2, 2)
            # keeps the branch alive and the two n = 5r + 2 values below 10^5
            # (50817, 89697) stay unresolved.
            #
            # Soundness: coprimality-to-r is a proven necessary condition (the
            # cyclic layer is one cyclic group); exempting the whole q-part is
            # permissive; ignoring OTHER leftover parts' contents is permissive.
            # The '*' branch has no fixed q, so it keeps the full C(c2, 2) --
            # permissive, and that branch is gated on r >= B anyway.
            if q == '*':
                cap_i = F * comb(c2, 2)
            else:
                dq2 = qpart(c2 - 1, q)
                rest = (c2 - 1) // dq2
                while rest % r == 0:
                    rest //= r
                cap_i = F * orb(c2, dq2 * rest)
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
        if q == '*':
            capc = comb(cj, 2)
        else:
            dqj = qpart(cj - 1, q)
            restj = (cj - 1) // dqj
            while restj % r == 0:
                restj //= r
            capc = orb(cj, dqj * restj)
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
            # SAFE cap specialised to this branch: the twist's q-part may sit in
            # the top layer, and everything else sits in the cyclic layer, which
            # already carries the foreign translations C_r and the block
            # rotation C_Fmid -- one cyclic group, so pairwise-coprime orders.
            # Both strips are proven necessary conditions, so the cap is a true
            # upper bound on any admissible twist in this branch and the
            # tightening is sound.  It is also what resolves the F = 2 reading
            # of n = 5r + 2 at c = 2r + 1: there c - 1 = 2r, r is stripped by
            # the foreign coprimality and 2 by F_mid = 2, so dmax = qpart and
            # the intra collapses to O(c) at odd q.
            if q == '*':
                intra_cap = F * comb(c, 2)
            else:
                dqc = qpart(c - 1, q)
                restc = (c - 1) // dqc
                while restc % r == 0:
                    restc //= r
                fmid = F // qpart(F, q)
                g = gcd(restc, fmid)
                while g > 1:
                    restc //= g
                    g = gcd(restc, fmid)
                intra_cap = F * orb(c, dqc * restc)
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
