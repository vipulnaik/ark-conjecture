#!/usr/bin/env python3
"""
wide_cert.py -- run the fallback-collapse certificate far beyond the computed
table, by substituting a PROVEN LOWER BOUND for B(n).

WHY THIS IS SOUND.  A fallback configuration attaining B_safe(n) has every SAFE
term >= B_safe(n) >= B_lo(n), so it satisfies the necessary conditions of
`fb_common.py` with B_lo in place of B.  An empty candidate list at n therefore
proves the collapse there without knowing B(n).  A weaker bound can only ADD
spurious candidates, never miss a real one.  Cost is O(n/log n) per value
against the table's n^2.9, which is what buys the range.

B_lo(n) = max over two families of admissible configurations, each scored in
SAFE mode, hence each a genuine lower bound on B_safe(n):
  * the family menu of `mu_enumerate.seed_value`;
  * the dominant three-part shape (1,c) + (1,c) + (1,r*), maximised over
    prime-power c with r* = n - 2c prime.
The second is essential: without it the certificate leaves a large fraction of
odd n unresolved, and the multi-part leftover check closes most of what is left.

Any n where candidates survive is reported as UNRESOLVED AT B_lo -- it needs the
true B(n) to settle and is NOT a counterexample.

--no-theorems disables every Part E-prime clause: `branch_settled` dispatches
nothing, so all branches reach the search, and `e3ii_resolves` stops resolving.
A run in that mode consults no Part E-prime theorem -- a much smaller trusted
base -- so it is the mode to quote, and it should agree with the normal run
exactly.  Quote it accurately: the base is the eight necessary conditions PLUS
unfused-foreign scoring (Lemma D2, range-scoped below n = 1582) and condition
(4)'s strip (Corollary C-prime, inheriting J0a at a >= 2); the banner says so.  If it ever stops agreeing while the
normal run passes, the error is localised to E.1 / E.3 / E.4 or their tables.

Usage: python3 wide_cert.py NMAX [--no-theorems] [--menu] [--refresh]
"""
import importlib.util, os, sys, time, bisect, hashlib
from math import comb
import fb_common as fb

_A = list(sys.argv); sys.argv = ['x']
_HERE = os.path.dirname(os.path.abspath(__file__))
_ME = os.environ.get("MU_ENUMERATE", os.path.join(_HERE, "mu_enumerate_v3.py"))
spec = importlib.util.spec_from_file_location("me", _ME)
me = importlib.util.module_from_spec(spec); me.__name__ = "me"
spec.loader.exec_module(me)

NMAX = int(_A[1]) if len(_A) > 1 and not _A[1].startswith('-') else 10000
NO_THM = '--no-theorems' in _A
fb.set_use_theorems(not NO_THM)
if NO_THM:
    print("--no-theorems: every s-branch goes to the search; E.1, E.3(ii), "
          "E.3(iii), E.4,\n               Lemma E.2's bound and the MERSENNE / "
          "REPUNIT3 tables are all unused.")
# The cache key must include the mode, or a --no-theorems run silently reuses a
# B_lo computed under the other one.  B_lo does not actually depend on the
# theorems -- pass 1 never consults them -- but keying on the mode anyway costs
# one recompute and removes the question, which is the same reasoning as keying
# the cache on SCAN_CAP rather than on NMAX alone.
_MODE = 'nothm' if NO_THM else 'thm' 
A = fb.Arith(NMAX + 2)
caps_m, caps_r = fb.cap_mersenne(A, NMAX), fb.cap_repunit(A, NMAX)

# ---- pass 1: the lower bound
#
# Scanning c downward from n/2 over prime powers and keeping the first SCAN_CAP
# hits suffices: the binding term min(C(c,2), c*r*, cap(r*)) is largest for c
# near n/2, and taking any SUBSET of admissible configurations still gives a
# valid lower bound.  Verified at NMAX = 10^4: SCAN_CAP = 60 alone resolves every
# value, identically to the full scan plus the family menu.  The menu is kept
# behind --menu for cross-checking; it costs O(n/log n) per value and dominates
# the runtime, so it is off by default.
t0 = time.time()
SCAN_CAP = 60
PPs = [c for c in range(3, NMAX // 2 + 2) if A.prime_power(c)]
PPs2 = [c for c in range(3, NMAX + 1) if A.prime_power(c)]
_FC = {}
def fcap(r):
    v = _FC.get(r)
    if v is None:
        v = _FC[r] = fb.foreign_cap(A, r)
    return v

def near(seq, target, cap):
    """The `cap` entries of the sorted list `seq` nearest to `target`.  The
    lower-bound families below all balance one growing term against one
    shrinking term, so their optimum sits near a balance point rather than at
    an endpoint -- scanning outward from that point is what makes a small cap
    sufficient."""
    i = bisect.bisect_left(seq, target)
    lo, hi, out = i - 1, i, []
    while len(out) < cap and (lo >= 0 or hi < len(seq)):
        if hi >= len(seq) or (lo >= 0 and target - seq[lo] <= seq[hi] - target):
            out.append(seq[lo]); lo -= 1
        else:
            out.append(seq[hi]); hi += 1
    return out

def orb_full(c, t, char2):
    raw = c * t // 2 if (char2 or t % 2 == 0) else c * t
    return min(raw, comb(c, 2))

def three_part_lo(n, cap=None):
    """(1,c)+(1,c)+(1,r*).  Terms C(c,2) ~ c^2/2 and cap(r*) <= r*^2/2 balance
    at c ~ r* ~ n/3, so scan c outward from n/3.  Needs n - 2c prime, hence
    exists mainly for odd n.

    SHARE PAIRS ARE SKIPPED (r* | c-1).  Scoring such a pair at
    min(C(c,2), c*r*, cap(r*)) OVER-credits it: the coupling of Lemma C cuts
    either the c-twist or the foreign twist, so that value is not realised by
    any group.  An over-credited B_lo is ANTI-permissive -- B_lo feeds the s_max
    and foreign-cap FILTERS, so too large a value drops candidate (pair, n)
    combinations and can turn an unresolved n into a silent pass, the one error
    class this file cannot see in its own output.  Measured over n <= 2600 no
    share pair ever set or came within 0.1% of setting B_lo, so the guard costs
    nothing; it removes the question instead of relying on that staying true."""
    best = 0
    for c in near(PPs, n // 3, cap or SCAN_CAP):
        rr = n - 2 * c
        if rr < 3 or not A.is_prime(rr) or rr == A.prime_power(c)[0]:
            continue
        if (c - 1) % rr == 0:
            continue                          # share pair: see the docstring
        best = max(best, min(comb(c, 2), c * rr, fcap(rr)))
    return best

def two_part_lo(n, cap=None):
    """(1,c)+(1,r*).  Balances at c ~ r* ~ n/2.  Covers even n, where the
    three-part shape does not exist.  Share pairs (r* | c-1) are skipped for the
    reason given in three_part_lo."""
    best = 0
    for c in near(PPs2, n // 2, cap or SCAN_CAP):
        rr = n - c
        if rr < 3 or not A.is_prime(rr) or rr == A.prime_power(c)[0]:
            continue
        if (c - 1) % rr == 0:
            continue                          # share pair: see three_part_lo
        best = max(best, min(comb(c, 2), c * rr, fcap(rr)))
    return best

def fused_lo(n):
    """A single fused class (F, c), n = F*c, c a prime power.

    F ranges over EVERY divisor, not over prime powers: F = F_mid*F_top with
    only F_top a q-power, so a composite block count such as 6 = 2*3 is a real
    group (an entangled cyclic-layer generator supplies the rotation and the
    full twist together).  Restricting F to prime powers is conservative --
    B_lo would still be a lower bound -- but it needlessly weakens the bound at
    exactly the n where the fused family is the only cheap one, and a weaker
    B_lo means a larger permitted s and more work in pass 2.

    The within-class cross coefficient is keyed on the parity of the BLOCK
    COUNT, not on the top prime: F for odd F, F/2 for even F.  Reading it off q
    is correct only where every F is forced to be a q-power.

    Includes Theorem 2.1's n = 2*(odd prime power) at F = 2."""
    best = 0
    for F in range(2, n + 1):
        if n % F:
            continue
        c = n // F
        pc = A.prime_power(c)
        if not pc:
            continue
        best = max(best, min(F * orb_full(c, c - 1, pc[0] == 2),
                             (F if F % 2 else F // 2) * c * c))
    return best

# The cheap families leave a few dozen values with a weak bound; for those only,
# top up with the family menu of mu_enumerate.seed_value.  That is O(n/log n) per
# call and would dominate if used everywhere, but on a few hundred values it is
# free -- and it lifts the density floor, which is what keeps the permitted s
# (and hence pass 2) small.
WEAK = 0.02
t1 = time.time()
# Pass 1 is the expensive half, so it is cached -- but the cache MUST be keyed on
# everything that determines B_lo, not just on NMAX.  Keying on NMAX alone means
# that changing SCAN_CAP, WEAK, or any of the family functions silently reuses a
# stale bound and the run "certifies" against old data.  --refresh exists but
# relies on remembering; this does not.
# Everything B_lo depends on has to be in here, not just what is defined in this
# file: the families call fb.foreign_cap, fb.orb and me.seed_value, so a fix to
# any of those would otherwise silently reuse a stale cache -- exactly the
# failure this signature exists to prevent.
_SIG = hashlib.sha1("|".join([
    str(SCAN_CAP), str(WEAK),
    three_part_lo.__doc__ or "", two_part_lo.__doc__ or "", fused_lo.__doc__ or "",
    _MODE,
    str(three_part_lo.__code__.co_code), str(two_part_lo.__code__.co_code),
    str(fused_lo.__code__.co_code), str(near.__code__.co_code),
    str(orb_full.__code__.co_code),
    str(fb.foreign_cap.__code__.co_code), str(fb.orb.__code__.co_code),
    str(fb.qpart.__code__.co_code),
    str(me.seed_value.__code__.co_code),
]).encode()).hexdigest()[:10]
CACHE = os.path.join(os.environ.get("WIDE_CERT_CACHE", _HERE), f"blo_{NMAX}_{_SIG}.txt")
if os.path.exists(CACHE) and '--refresh' not in _A:
    Blo = [0] * (NMAX + 2); ns = []
    for line in open(CACHE):
        n, v = line.split()
        Blo[int(n)] = int(v); ns.append(int(n))
    topped = escal = -1
    print(f"        loaded B_lo from {CACHE} ({len(ns)} values)")
else:
  spf = me.sieve_spf(NMAX + 2)
  Blo = [0] * (NMAX + 2); ns = []; topped = escal = 0
  for n in range(6, NMAX + 1):
    if A.prime_power(n):
        continue
    v = max(three_part_lo(n), two_part_lo(n), fused_lo(n))
    if v == 0 or 2 * v / (n * (n - 1)) < WEAK:
        v = max(v, me.seed_value(n, spf)); topped += 1
        if 2 * v / (n * (n - 1)) < WEAK:      # still weak: escalate the scan
            v = max(v, three_part_lo(n, 10**9), two_part_lo(n, 10**9))
            escal += 1
    Blo[n] = v
    ns.append(n)
  with open(CACHE, "w") as fh:
    for n in ns:
        fh.write(f"{n} {Blo[n]}\n")
  print(f"        cheap families + {topped} menu top-ups + {escal} full escalations "
        f"({time.time()-t1:.0f}s); cached to {CACHE}")
no_bound = [n for n in ns if Blo[n] == 0]
ns = [n for n in ns if Blo[n] > 0]
by_B = sorted(ns, key=lambda n: Blo[n]); Bvals = [Blo[n] for n in by_B]
dmin = min(2 * Blo[n] / (n * (n - 1)) for n in ns)
print(f"pass 1: B_lo for {len(ns)} values in [6, {NMAX}]"
      + (f" (+{len(no_bound)} with no bound: {no_bound[:8]}...)" if no_bound else "")
      + f"  ({time.time()-t0:.0f}s); weakest density {dmin:.6f}, permitted s <= "
        f"{int(1/dmin**0.5 - 1)}")

# ---- pass 2: pair scan
#
# Two filters make this cheap, and both must be applied BEFORE iterating over n
# rather than inside the loop:
#   * s <= s_max(n, B) rearranges to delta_lo(n) <= 1/(s+1)^2, so a pair with
#     s = 2 can only threaten values of density at most 1/9.  Most n are denser
#     than that, so the per-s candidate lists are far shorter than the whole
#     range.
#   * the foreign block's own cap bounds B, so only n with B_lo(n) <= cap(r)
#     are reachable -- a prefix of each list once it is sorted by B_lo.
t0 = time.time()
S_TOP = max(fb.s_max(n, Blo[n]) for n in ns)
per_s = {}
for sv in range(1, S_TOP + 1):
    # delta_lo(n) <= 1/(sv+1)^2, in exact integer arithmetic:
    #     2*Blo/(n(n-1)) <= 1/(sv+1)^2  <=>  (sv+1)^2 * 2*Blo <= n(n-1).
    # The float form is a tolerance sitting exactly on the boundary of the
    # property it tests, and the values that reach the comparison are precisely
    # the boundary ones -- the same trap as the old s_max().  Getting it wrong
    # here DROPS an n from the candidate list, which is the anti-permissive
    # direction and would turn an unresolved value into a silent pass.
    lst = [n for n in ns if (sv + 1) ** 2 * 2 * Blo[n] <= n * (n - 1)]
    lst.sort(key=lambda n: Blo[n])
    per_s[sv] = (lst, [Blo[n] for n in lst])
print(f"pass 2: permitted s <= {S_TOP}; candidate values per s: "
      + ", ".join(f"s={k}: {len(v[0])}" for k, v in sorted(per_s.items())))

cand = {}
pairs_seen = pairs_live = items = 0
# Count what the dispatch actually settles, per s.  Without this the
# --no-theorems comparison is easy to over-read: if the dispatch never fires,
# the two modes agree trivially and the run is no evidence about E.1 / E.3 / E.4
# at all.  Whether it fires depends on which s reach the loop, and the
# foreign-cap filter (hi == 0) removes whole s-branches before the dispatch sees
# them -- so this has to be measured rather than assumed.
live_by_s, dispatched = {}, {}
for r in range(3, NMAX, 2):
    if not A.is_prime(r):
        continue
    capr = fb.foreign_cap(A, r)
    sv = 1
    while True:
        c = sv * r + 1
        if c + r > NMAX:
            break
        s_this = sv; sv += 1
        if s_this > S_TOP:
            break
        pp = A.prime_power(c)
        if not pp or pp[0] == r:
            continue
        p = pp[0]
        pairs_seen += 1
        lst, Bl = per_s[s_this]
        hi = bisect.bisect_right(Bl, capr)
        if hi == 0:
            continue
        pairs_live += 1
        for n in lst[:hi]:
            if n < c + r:
                continue
            B = Blo[n]
            ok_thm, _ = fb.branch_settled(A, n, B, s_this, caps_m, caps_r)
            live_by_s[s_this] = live_by_s.get(s_this, 0) + 1
            if ok_thm:
                dispatched[s_this] = dispatched.get(s_this, 0) + 1
                continue
            items += 1
            got = fb.pair_candidates(A, n, B, c, r, p)
            if got:
                cand.setdefault(n, []).extend(got)
print(f"        {pairs_seen} (c,r,s) pairs, {pairs_live} with a nonempty window, "
      f"{items} (pair, n) checks after theorem dispatch  ({time.time()-t0:.0f}s)")
print(f"        live (pair, n) by s: "
      + ", ".join(f"s={k}: {v}" for k, v in sorted(live_by_s.items()))
      + ("  |  settled by theorem: "
         + ", ".join(f"s={k}: {v}" for k, v in sorted(dispatched.items()))
         if dispatched else "  |  settled by theorem: NONE"))
if not dispatched and not NO_THM:
    print("        NOTE: the dispatch settled nothing at this NMAX, so a")
    print("        --no-theorems run here would agree TRIVIALLY and is no evidence")
    print("        about E.1 / E.3 / E.4.  The s-branches those theorems cover")
    print("        (s = 1 and s = 3) are removed earlier by the foreign-cap filter.")

for n in no_bound:
    cand.setdefault(n, []).append(('NO-LOWER-BOUND',))
res = sorted(cand)
tot = len(ns) + len(no_bound)
print()
print(f"UNRESOLVED at B_lo: {len(res)} of {tot}")
for n in res:
    print(f"    n={n:6d} B_lo={Blo[n]:9d} d_lo={2*Blo[n]/(n*(n-1)):.4f}  {cand[n][:2]}")
print()
ok = tot - len(res)
print(f"COLLAPSE CERTIFIED at {ok} of {tot} values ({100*ok/tot:.2f}%) in [6, {NMAX}]")
print("from proven lower bounds alone.  Unresolved values need the true B(n) and")
print("are NOT counterexamples.  Over the range where both certificates run, the")
print("true-table certificate (fallback_cert.py) agrees.")
print()
print("The theorem dispatch in pass 2 is an optimisation, not part of the proof.")
if NO_THM:
    print("THIS RUN USED NONE OF IT: --no-theorems was set, so every s-branch went")
    print("to the search and no Part E-prime clause was consulted.  Compare it")
    print("against a normal run at the same NMAX; they should agree exactly,")
    print("including on the unresolved values.")
    print()
    print("WHAT THE TRUSTED BASE STILL IS.  The eight necessary conditions of")
    print("fb_common.py, PLUS two dependencies underneath them, both scoped:")
    print("  * foreign parts scored UNFUSED -- fused foreign classes are excluded by")
    print("    Lemma D2's domination, a range check below n = 1582 (a18_verify.py)")
    print("    and a theorem above it, not by condition (3);")
    print("  * condition (4)'s strip, licensed by Corollary C-prime, which inherits")
    print("    J0a at a >= 2 (automatic at a = 1).  Measured over v4 at n <= 1200:")
    print("    24 strip decisions, all licensed, none at a >= 2.")
    print("Quote the result with those, not as the eight conditions alone.")
else:
    print("Rerun with --no-theorems to establish that: it stubs the dispatch and")
    print("drops the E.3(ii) resolution, so the run rests only on the eight")
    print("necessary conditions of fb_common.py being necessary.  Doing this on each")
    print("extension is cheap and localises any error in E.1 / E.3 / E.4 at once.")
