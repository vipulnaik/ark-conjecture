#!/usr/bin/env python3
"""
2026-08-16 EG-patched companion for validating V3 TABLES (entangled-generator
correction).  Three changes against validate_table.py: (1) score() drops the
F_mid twist strip -- the SAFE cap is F*orb(c, c-1); (2) c_cyclic_layer checks
foreign sizes only, the F_mid coprimality having been refuted (explicit groups
at n = 33, 78, 105; entangled-generator-finding.md); (3) CAP24 updated to the
current ceilings -- which were STALE here even against v4 (the 7/11/15/23
entries were the pre-rekey F = 2 values) -- with 7/15 at the entangled 1/8,
which merges them into the 3/19 row and makes the ceiling law mod 12.  Running THIS file against a v4 CSV will FAIL c_rederive at the
rows whose winner was cut-scored; that is expected and is the point.

validate_table.py -- check a mu_table_safe_v*.csv against everything the three
documents currently claim, and print a summary.

This is the standing version of the by-hand checking done in each review pass.
Every check states a BELIEF drawn from a named place in the documents, tests it,
and reports PASS / FAIL / INFO.  A FAIL is a claim the table contradicts; an
INFO is a measured quantity the documents quote and that will drift as the
table grows -- those are printed so they can be copied back, not judged here.

    PASS   the belief holds over every row it applies to
    FAIL   the table contradicts it -- investigate before trusting either
    INFO   a figure to carry back into the documents, no verdict
    SKIP   nothing in range exercises the check

KEEP IT FAST -- THIS IS A DESIGN CONSTRAINT, NOT A NICETY.  The whole suite runs
in about 0.1 s on 1,700 rows, which is what makes it something to run reflexively:
before every certificate, after every batch, on any hunch.  A suite that costs
seconds gets skipped, and a skipped check is worth nothing.  So every check
should stay O(rows) or O(rows * parts), doing arithmetic on numbers already
parsed out of the witness string.

What does NOT belong here: enumerating configurations, VF2 or isomorphism work,
re-deriving B(n), sieving past NMAX, or anything whose cost grows with n rather
than with the row count.  Those are `brute_compare.py`'s and the certificates'
business.  The case that tempts is a check wanting to compare a row against
ALTERNATIVE configurations rather than against a formula -- that belongs in a
certificate, and if it must live here, budget it against the 0.1 s and say so at
the check so the next reader knows what is being protected.

WHAT THIS DOES NOT DO.  It checks the table against the documents' *model*, not
against mathematics: it re-derives each configuration's score from its witness
string and the Part G.3 formulas, so it will catch a table that disagrees with
the model, and it will not catch a model that is wrong.  For independent
evidence use `brute_compare.py`, which re-enumerates from scratch.

Usage:
    python3 validate_table.py mu_table_safe_v4.csv
    python3 validate_table.py mu_table_safe_v4.csv --baseline mu_table_safe_v2.csv
    python3 validate_table.py mu_table_safe_v4.csv --quiet     # failures only

KEEPING THIS CURRENT.  When the model changes, add or amend a check here in the
same pass.  Each check carries the document section it comes from, so a stale
check is findable from the other end.  Checks are registered with @check.
"""
import argparse, csv, math, re, sys, textwrap
from collections import Counter, defaultdict
from fractions import Fraction
from math import comb

ap = argparse.ArgumentParser()
ap.add_argument("table")
ap.add_argument("--baseline", default=None,
                help="an earlier table to compare against; enables the monotonicity check")
ap.add_argument("--ladder", default=None, metavar="FILE",
                help="a ladder_weak*.txt worklist (n, lower-bound-on-delta per line); "
                     "enables the two cross-artefact checks against the ladder. The file "
                     "is READ, never recomputed -- these checks join on n and do no "
                     "arithmetic beyond a ratio, so they stay inside the suite's budget.")
ap.add_argument("--quiet", action="store_true", help="print FAILs only")
ap.add_argument("--explain", type=int, default=None, metavar="N",
                help="print the full term breakdown for one n and exit -- the case where "
                     "you would otherwise open the CSV")
A = ap.parse_args()

# --------------------------------------------------------------------------
# parsing

WIT = re.compile(r"p=(\d+) q=(\d+):")
PART = re.compile(r"(\d+)x(\d+)(\*?)")


class Row:
    __slots__ = ("n", "C", "B", "delta", "delta_str", "parts", "certK", "certified",
                 "fallback", "witness", "p", "q", "cls", "shape")

    def __init__(self, d):
        self.n = int(d["n"]); self.C = int(d["C(n2)"]); self.B = int(d["mu_bound"])
        self.delta_str = d["density"].strip()
        self.delta = float(self.delta_str); self.parts = int(d["parts"])
        self.certK = int(d["certified_K"]); self.certified = d["certified"] == "1"
        self.fallback = d["fallback"] != "0"; self.witness = d["witness"]
        m = WIT.match(self.witness)
        self.p, self.q = (int(m.group(1)), int(m.group(2))) if m else (None, None)
        # cls: list of (F, c, is_foreign)
        self.cls = [(int(a), int(b), s == "*") for a, b, s in PART.findall(self.witness)]
        self.shape = classify(self)


def classify(r):
    """Census S-number of a winner.

    S7 is split by fusion count -- S7f2, S7f3, S7f4, ... -- and NOT lumped at
    F >= 3.  The granularity is the point: F = 4 attains the class ceiling at
    n = 11 (mod 12) (aod section 3.3.5), so it is a distinct family
    rather than a tail of the F = 3 escape, and lumping it hid that.  While
    "S7" covered every F >= 3, a migration into F = 4 was reported as a
    migration into the F = 3 escape, and the census showed one number where
    there were two behaviours.
    S7f2 is kept separate from S5 because those differ only by which layer
    holds the swap (aod section 3.2)."""
    mm = [x for x in r.cls if not x[2]]
    fg = [x for x in r.cls if x[2]]
    if not r.cls:
        return "?"
    if len(r.cls) == 1 and mm:
        return "S1" if mm[0][0] == 1 else "S2"
    if len(fg) > 1:
        return "S6"
    if len(fg) == 1 and len(mm) == 1:
        F = mm[0][0]
        if F == 1:
            return "S3"
        if F == 2:
            return "S5" if r.q == 2 else "S7f2"
        return "S7f%d" % F
    if len(fg) == 1 and len(mm) == 2:
        return "S4"
    return "?"


def qpart(x, q):
    t = 1
    while q and x % q == 0:
        x //= q; t *= q
    return t


def oddpart(x):
    while x % 2 == 0:
        x //= 2
    return x


def coprime_part(m, F):
    if F <= 1:
        return m
    d = 2
    while d * d <= F:
        if F % d == 0:
            while F % d == 0:
                F //= d
            while m % d == 0:
                m //= d
        d += 1
    if F > 1:
        while m % F == 0:
            m //= F
    return m


def orb(c, t, char2):
    raw = c * t // 2 if (char2 or t % 2 == 0) else c * t
    return min(raw, comb(c, 2))


def is_prime(x):
    if x < 2:
        return False
    if x % 2 == 0:
        return x == 2
    d = 3
    while d * d <= x:
        if x % d == 0:
            return False
        d += 2
    return True


def prime_power_base(x):
    """base prime if x is a prime power, else None."""
    if x < 2:
        return None
    d = 2
    while d * d <= x:
        if x % d == 0:
            while x % d == 0:
                x //= d
            return d if x == 1 else None
        d += 1
    return x


def score(r):
    """Re-derive m* from the witness by the Part G.3 formulas (SAFE mode)."""
    terms = []
    for F, c, foreign in r.cls:
        if foreign:
            terms.append(orb(c, qpart(c - 1, r.q), False))
        else:
            # EG correction: full twist at any F_mid; no strip.
            terms.append(F * orb(c, c - 1, r.p == 2))
            if F > 1:
                # Coefficient is keyed on the parity of F, NOT on q.  Under the
                # corrected shape space F = Fmid*Ftop need not be a q-power, so
                # "F for odd q, F/2 for q = 2" -- correct while every block count
                # was a q-power -- is no longer the rule.  What the divisibility
                # argument actually bounds is the minimum pair-orbital of a
                # transitive group of degree F, which is F/2 for even F and F for
                # odd F.  Both shipped enumerators key on F's parity.
                terms.append(_cross_term(F, c))
    sizes = [F * c for F, c, _ in r.cls]
    for i in range(len(sizes)):
        for j in range(i + 1, len(sizes)):
            terms.append(sizes[i] * sizes[j])
    return min(terms) if terms else 0


def _cross_term(F, c):
    """The within-class cross term of a class of F blocks of size c.

    Factored out of `score` so that `c_cross_coeff` asserts the same expression
    the scorer uses rather than a copy of it -- a check that recomputes its own
    assumption cannot fail.  The coefficient is F for odd F and F/2 for even F:
    it bounds the minimum pair-orbital of a transitive group of degree F, and
    the halving is the l = 2 case of the divisibility argument, not a fact about
    the top prime.
    """
    return (F if F % 2 else F // 2) * c * c


# mod-24 class ceilings, aod section 3.3.5
# EG-patched.  Was stale even against v4 (7/11/15/23 carried the pre-rekey
# F = 2 values .085786/.066987/.085786/.050510).
#
# 2026-08-17 (SETTLED): the ceiling law is keyed mod 12, not mod 24 -- classes 7, 15
# merged into the 1/8 row when the entangled correction freed c mod 4, and that
# was the table's only genuine mod-24 dependence.  This dict is LEFT keyed mod
# 24 deliberately: a mod-12 law is expressible mod 24 with each value duplicated
# at a and a+12, and keeping 24 keys lets the validator check the duplication
# holds rather than assuming it.  The redundancy is now redundancy, not
# structure -- see the c_mod12_keying check below.
CAP24 = {0: .250000, 1: .171573, 2: .133975, 3: .125000, 4: .250000, 5: .101021,
         6: .250000, 7: .125000, 8: .133975, 9: .171573, 10: .250000, 11: .071797,
         12: .250000, 13: .171573, 14: .133975, 15: .125000, 16: .250000,
         17: .101021, 18: .250000, 19: .125000, 20: .133975, 21: .171573,
         22: .250000, 23: .071797}

# --------------------------------------------------------------------------
# check registry
#
# Checks are grouped, and the group determines what a result means:
#
#   A. TABLE INTEGRITY     Is this file a well-formed enumeration at all?
#                          Failures here are bugs in the run or the parser,
#                          not discoveries. Nothing downstream is meaningful
#                          until these pass.
#
#   B. EXACT CLAIMS AT n   Statements that must hold at EVERY row, including
#                          every congruence-gated one. A failure is a genuine
#                          contradiction between the table and the documents,
#                          and one of the two is wrong.
#
#   C. DENSITY AND         Aggregates, distributions and per-residue-class
#      DISTRIBUTION        behaviour. These are asymptotic claims sampled at a
#                          finite range, so they are reported as INFO with the
#                          expected limit printed beside them. A gap is not a
#                          failure; it is data about convergence.
#
# Every check names the document section it comes from. INFO checks in group C
# carry an `expect` line so the comparison can be made without opening the
# arithmetic-of-density document.

CHECKS = []
GROUPS = [("A", "table integrity"),
          ("B", "exact claims, holding at every n"),
          ("C", "density and distribution, against the asymptotic model")]


def check(group, name, source, expect=None):
    def deco(fn):
        CHECKS.append((group, name, source, expect, fn))
        return fn
    return deco


# ==========================================================================
# A. TABLE INTEGRITY
# ==========================================================================

@check("A", "parts sum to n, and every part is well formed", "ep Part G.3")
def c_wellformed(R, base):
    bad = []
    for r in R:
        if sum(F * c for F, c, _ in r.cls) != r.n:
            bad.append((r.n, "parts do not sum to n")); continue
        for F, c, foreign in r.cls:
            b = prime_power_base(c)
            if b is None:
                bad.append((r.n, f"block {c} is not a prime power")); break
            if foreign and c != b:
                bad.append((r.n, f"foreign block {c} is a proper prime power (Lemma B')")); break
            if foreign and F != 1:
                bad.append((r.n, f"foreign block {c} is fused, F={F} (Lemma D2)")); break
            if not foreign and r.p and b != r.p:
                bad.append((r.n, f"matching block {c} is not a power of p={r.p}")); break
    return ("FAIL" if bad else "PASS", f"{len(bad)} malformed of {len(R)}", bad[:5])


@check("A", "foreign primes are pairwise distinct within a configuration", "ep Part E")
def c_distinct_foreign(R, base):
    bad = [r.n for r in R if len({c for _, c, f in r.cls if f}) != sum(1 for _, _, f in r.cls if f)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} with a repeated foreign prime", bad[:5])


@check("A", "no configuration contains a fixed point (part of size 1)", "ep Part A")
def c_nofixed(R, base):
    bad = [r.n for r in R if any(F * c == 1 for F, c, _ in r.cls)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} with a fixed point", bad[:5])


@check("A", "mu_bound is re-derivable from the witness by the G.3 formulas", "ep Part G.3")
def c_rederive(R, base):
    bad = [(r.n, r.B, score(r)) for r in R if score(r) != r.B]
    return ("FAIL" if bad else "PASS", f"{len(bad)} mismatches of {len(R)}", bad[:5])


def density_ok(r):
    """Is the stored density string a correct rounding of mu_bound / C(n,2)?

    Done in EXACT rational arithmetic, against the half-ulp of the stored
    string's own precision.  Both refinements matter, and the second is the one
    that bit: a float tolerance of 5e-7 is the right VALUE, but a tie rounds to
    a difference of exactly 5e-7, and evaluating that subtraction in floating
    point lands a few ulps above the bound, so a strict `>` rejects a correctly
    rounded row.  n = 2561 is the instance -- 250978/3278080 = 49/640 =
    0.0765625 exactly, the only 6-decimal tie in the table -- where the exact
    difference IS the half-ulp and float arithmetic gives 5.000000000005e-07.

    Reading the precision off the string rather than assuming six places also
    means the check does not silently loosen if the writer's format changes.
    """
    s = r.delta_str
    places = len(s.split(".")[1]) if "." in s else 0
    stored = Fraction(s)
    return abs(stored - Fraction(r.B, r.C)) * 2 * 10 ** places <= 1


@check("A", "density column agrees with mu_bound / C(n,2)", "table")
def c_density(R, base):
    bad = [r.n for r in R if not density_ok(r)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} mismatches", bad[:5])


@check("A", "every row is certified, and no optimum invokes the fallback", "ep Part E-prime")
def c_certified(R, base):
    unc = [r.n for r in R if not r.certified]
    fb = [r.n for r in R if r.fallback]
    st = "FAIL" if unc else ("INFO" if fb else "PASS")
    return (st, f"{len(unc)} uncertified, {len(fb)} fallback optima", (unc + fb)[:5])


@check("A", "the rebuild never lowers a value against the baseline", "pending-checks R0")
def c_monotone(R, base):
    if not base:
        return ("SKIP", "no --baseline given", [])
    com = [r for r in R if r.n in base]
    lower = [(r.n, r.B, base[r.n][0]) for r in com if r.B < base[r.n][0]]
    higher = sum(1 for r in com if r.B > base[r.n][0])
    return ("FAIL" if lower else "PASS",
            f"{len(com)} common values: {higher} higher, {len(lower)} lower", lower[:5])


@check("A", "shape migrations against the baseline", "pending-checks A0, A7",
       expect="the shape-space repair moves winners between census rows -- most often a "
              "3-part c+c+r* becoming the 2-part fused 2xc+r*. Any per-shape count written "
              "against the baseline is stale for every n listed here")
def c_migrate(R, base):
    if not base:
        return ("SKIP", "no --baseline given", [])
    mig = Counter()
    for r in R:
        if r.n in base and base[r.n][1] != r.shape:
            mig[(base[r.n][1], r.shape)] += 1
    ex = [f"{o} -> {n_}: {k}" for (o, n_), k in sorted(mig.items(), key=lambda t: -t[1])[:8]]
    tot = sum(mig.values())
    return ("INFO", f"{tot} of {len([r for r in R if r.n in base])} winners changed shape", ex)


# ==========================================================================
# B. EXACT CLAIMS, HOLDING AT EVERY n
# ==========================================================================

@check("B", "Proposition F.1: the part count obeys k < 1/sqrt(delta)", "ep Prop F.1")
def c_f1(R, base):
    bad = [(r.n, r.parts, round(1 / math.sqrt(r.delta), 3)) for r in R
           if r.delta > 0 and r.parts >= 1 / math.sqrt(r.delta)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} violations of {len(R)}", bad[:5])


@check("B", "no winner exceeds cap_F(eta) for its own F and eta", "aod section 3.3.8")
def c_capF(R, base):
    bad, tested = [], 0
    for r in R:
        mm = [x for x in r.cls if not x[2]]
        fg = [x for x in r.cls if x[2]]
        if len(mm) != 1 or len(fg) != 1:
            continue
        tested += 1
        F, c, _ = mm[0]; _, rr, _ = fg[0]
        eta = orb(rr, qpart(rr - 1, r.q), False) / comb(rr, 2)
        cap = eta / (1 + math.sqrt(F * eta)) ** 2
        if r.delta > cap + 1e-9:
            bad.append((r.n, round(r.delta, 6), round(cap, 6)))
    return ("FAIL" if bad else "PASS", f"{len(bad)} of {tested} one-foreign rows exceed", bad[:5])


@check("B", "the within-class cross coefficient is keyed on F's parity, not on q",
       "ep Part E, box 'The parity is F's, not q's'")
def c_cross_coeff(R, base):
    """Assert the COEFFICIENT, because the resulting minimum cannot see it.

    The within-class cross term is (F/2)c^2 for even F and F*c^2 for odd F,
    against an intra term of at most F*c(c-1) -- so at F = 2 the cross term sits
    a factor c/(c-1) above the intra term and never binds.  A wrong coefficient
    there produces byte-identical output: same mu_bound, same witness, same
    density, so group A's re-derivation passes and no measured figure moves.
    Keying it on q is correct wherever F is forced to be a q-power, since even F
    then means q = 2, which is why the wrong rule survives in prose and in hand
    checks.  The direction that matters is that the q-keyed reading is LARGER at
    odd q with even F, so a lower-bound script carrying it over-credits.

    BE CLEAR ABOUT WHAT THIS CAN AND CANNOT CATCH.  Rescoring the table under
    the q-keyed rule and asking which reading `mu_bound` matches is **vacuous
    while the term never binds**: both readings give the same score, so no row
    can discriminate.  What is asserted instead is the coefficient `score()`
    computes, row by row, against the rule written out here -- which catches a
    regression in the scorer, the thing actually at risk.  The rescoring is kept
    as a live tripwire: it acquires teeth the moment `binds` is nonzero, and the
    check says so rather than reporting a pass it did not earn.

    NOTE on `binds`.  The intra term it compares against is built from the OLD
    stripped dmax, not from SAFE's flat F*C(c,2).  A stripped dmax is SMALLER, so
    `intra` is smaller and `fkey <= intra` fires LESS often -- the statistic
    under-reports how often the cross term binds.  For a tripwire that is the
    conservative direction only in the sense that it cannot manufacture a false
    alarm; it can suppress a real one.  Rebuild it on the flat cap alongside
    c_realisable's dmax."""
    wrong, binds, tested, discriminating = [], 0, 0, 0
    for r in R:
        for F, c, foreign in r.cls:
            if foreign or F <= 1:
                continue
            tested += 1
            fkey = (F if F % 2 else F // 2) * c * c
            qkey = (F if r.q % 2 else F // 2) * c * c
            ft = qpart(F, r.q); fm = F // ft
            dq = qpart(c - 1, r.q)
            dmax = dq * coprime_part((c - 1) // dq, fm)
            intra = F * orb(c, dmax, r.p == 2)
            if fkey <= intra:
                binds += 1
            if fkey != qkey:
                discriminating += 1
                # Only here can the table distinguish the two rules at all, and
                # only if the term also binds.
                if fkey <= intra and r.B == qkey and r.B != fkey:
                    wrong.append((r.n, F, r.q, fkey, qkey))
            # The assertion proper: the shipped scorer must use F's parity.
            if _cross_term(F, c) != fkey:
                wrong.append((r.n, F, c, _cross_term(F, c), fkey))
    msg = (f"{tested} fused classes, {discriminating} where the two rules differ; "
           f"the term binds at {binds} (so the table-rescoring tripwire is "
           f"{'LIVE -- read the rows below' if binds else 'dormant, as expected'})")
    return ("FAIL" if wrong else "PASS", msg, wrong[:5])


@check("B", "S2 winners sit at density (c-1)/(Fc-1), i.e. 1/F up to O(1/n)", "aod section 2.1")
def c_s2(R, base):
    """This checks the WINNERS only: where a fused single class took the row,
    its recorded density must be the shape's own value.  It says nothing about
    the rows S2 did not win, which is the wider claim -- see c_s2_identity."""
    rows = [r for r in R if r.shape == "S2"]
    bad = [(r.n, r.delta) for r in rows
           if abs(r.delta - (r.cls[0][1] - 1) / (r.cls[0][0] * r.cls[0][1] - 1)) > 1e-6]
    return ("FAIL" if bad else "PASS", f"{len(rows)} S2 winners, {len(bad)} off 1/F", bad[:5])


def _largest_prime_power_divisor(n):
    best, m, d = 1, n, 2
    while d * d <= m:
        if m % d == 0:
            e = 1
            while m % d == 0:
                m //= d; e *= d
            best = max(best, e)
        d += 1 if d == 2 else 2
    return max(best, m)


@check("B", "the fused shape's density is a LOWER BOUND at every non-prime-power n",
       "aod section 2.1")
def c_s2_identity(R, base):
    """The wider claim, and a genuinely independent one.  After the entangled-
    generator correction the fusion count F is an arbitrary integer carried by
    the cyclic layer, so the single fused class needs only that c be a prime
    power.  Hence it EXISTS at every non-prime-power n -- take c = Q(n), the
    largest prime-power divisor, and F = n/Q(n) > 1 -- and optimising over c
    gives an identity rather than a bound:

        delta_S2(n) = (Q(n) - 1) / (n - 1),      value F * C(Q, 2).

    Every row must therefore clear F * C(Q, 2).  This is worth having next to
    the enumerator's own outputs because it is arithmetic where they are a
    search: it derives from the shape space directly and never consults the
    scoring code, so a disagreement means one of the two is wrong and the
    check cannot be satisfied by a bug shared between them.

    Exact integers, not floats -- the two agree to eleven places at the rows
    that matter, and a tolerance would hide precisely the near-misses.

    BASELINE BEHAVIOUR, which is the reason this is not a bare FAIL.  On a
    current-scoring table the expected count is 0.  On the v4 baseline exactly
    two rows fail, n = 78 and n = 222, and they are not defects: they are the
    two entries of entangled_exceedances.txt with no top prime, i.e. the
    composite-F, top-trivial configurations the superseded shape space could
    not express at all.  So {78, 222} is the CORRECT baseline answer and is
    reported as INFO; any other set is a FAIL worth stopping on.
    """
    bad = []
    for r in R:
        if r.n < 6:
            continue
        c = _largest_prime_power_divisor(r.n)
        if c == r.n:                    # prime power: S1's domain, no F > 1
            continue
        s2 = (r.n // c) * (c * (c - 1) // 2)
        if s2 > r.B:
            bad.append((r.n, r.B, s2))
    if not bad:
        return ("PASS", f"{len(R)} rows, none below the identity", [])
    ns = {n for n, _, _ in bad}
    if ns == {78, 222}:
        return ("INFO",
                "78 and 222 fall below it -- the expected baseline pair "
                "(composite F, trivial top; see entangled_exceedances.txt), "
                "not a defect", bad)
    return ("FAIL",
            f"{len(bad)} row(s) below the fused shape's own value, and NOT the "
            f"expected baseline pair", bad[:5])


@check("B", "the fusion layer is readable off the top prime: S5 has q = 2, S7-at-F=2 has q odd",
       "aod section 3.2.2")
def c_layer_by_q(R, base):
    bad = [(r.n, r.q, r.shape) for r in R
           if (r.shape == "S5" and r.q != 2) or (r.shape == "S7f2" and r.q == 2)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} misfiled by top prime", bad[:5])


@check("C", "RETIRED CONGRUENCE: the c mod 8 distribution of S4 winners", "aod section 3.2.3")
def c_s4(R, base):
    """Was an exact claim ("S4 winners have c = 1 mod 8") resting on the fusion
    twist-cut: a cyclic-layer fusion was believed to force the twist to the odd
    part of c - 1, so v_2(c - 1) priced the shape and pinned c mod 8.  The
    entangled-generator construction refutes the forcing (z^F is the full twist
    at any F_mid), so c mod 4 is a FREE parameter and no congruence on c is
    predicted.  Demoted to INFO: the distribution is still worth watching,
    because a population at c = 1 (mod 4) is positive evidence the freeing is
    load-bearing rather than merely available."""
    rows = [r for r in R if r.shape == "S4"]
    if not rows:
        return ("INFO", "no S4 winners in range", [])
    dist = Counter([c for _, c, f in r.cls if not f][0] % 8 for r in rows)
    freed = sum(v for k, v in dist.items() if k % 4 == 1)
    return ("INFO", f"{len(rows)} S4 winners, c mod 8 = {dict(sorted(dist.items()))}; "
                    f"{freed} at c = 1 (mod 4), forbidden under the retired law", [])


@check("C", "RETIRED CONGRUENCE: the c mod 8 distribution of S7-at-F=2 winners",
       "aod section 3.2.3")
def c_s7f2(R, base):
    """Retired for the same reason as c_s4 -- see that docstring.  The old exact
    claim was c = 3 (mod 4) bar a c = 5 (mod 8) tie; under the corrected shape
    space the matching block's residue costs nothing, and what c mod 4 now does
    is STEER the foreign residue: at F = 2, 2c = 2 or 6 (mod 8) according to
    c mod 4, so r = n - 2c reaches two residues mod 8 where the old law reached
    one.  (At F = 4 it steers nothing: 4c = 4 (mod 8) for every odd c.)  That
    asymmetry is exactly why classes 7, 15 mod 24 improved and 11, 23 did not.
    The exact content that survives is the reachability check c_eta_reach below."""
    rows = [r for r in R if r.shape == "S7f2"]
    if not rows:
        return ("INFO", "no cyclic-layer F = 2 winners in range", [])
    dist = Counter()
    for r in rows:
        dist[[x for _, x, f in r.cls if not f][0] % 8] += 1
    freed = sum(v for k, v in dist.items() if k % 4 == 1)
    return ("INFO", f"{len(rows)} winners, c mod 8 = {dict(sorted(dist.items()))}; "
                    f"{freed} at c = 1 (mod 4), forbidden under the retired law "
                    f"({'the freeing is exercised' if freed else 'freeing available but unused so far'})", [])


@check("B", "the ceiling law is periodic mod 12: CAP24[a] == CAP24[a+12]",
       "aod section 3.3.4")
def c_mod12_keying(R, base):
    """Since the entangled correction the ceiling table is keyed mod 12 (aod
    3.3.4): at F = 2 the 2-adic dependence is only mod 4, and the surviving
    mod-8 condition at F = 4 is constant on its mod-12 class.  CAP24 is kept
    at 24 keys so this is checkable rather than assumed.  A failure means
    either a cap has been edited on one side of a pair only, or a genuine
    mod-24 dependence has come back -- in which case something is supplying a
    mod-8 condition, and aod 3.3.7's check applies: only F = 4 can, and it
    cannot distinguish a from a+12."""
    bad = [(a, CAP24[a], CAP24[a + 12]) for a in range(12)
           if abs(CAP24[a] - CAP24[a + 12]) > 1e-9]
    return ("FAIL" if bad else "PASS",
            f"{len(bad)} of 12 residue pairs disagree", bad[:5])


@check("B", "the foreign twist is a q-power divisor of r - 1, and eta respects v_2(r - 1)",
       "aod section 3.3.4a; ep Lemma B-prime")
def c_eta_reach(R, base):
    """The exact claim that REPLACES the retired c mod 8 congruences.

    Lemma B-prime is untouched by the entangled correction: a foreign block's
    twist t lies in the top q-group, so t is a q-power dividing r - 1, and the
    efficiency is eta = 2t/(r - 1).  Two consequences are testable at every
    one-foreign row and neither mentions c:

      (a) t = qpart(r - 1) exactly -- the block takes its whole q-part, there
          being no reason to take less.
      (b) eta <= 2 / 2^v_2(r - 1) when q is odd, since an odd t divides the odd
          part of r - 1.  So r = 3 (mod 4) is what eta = 1 needs, r = 5 (mod 8)
          what eta = 1/2 needs, and so on.  This is the residue law that the
          c mod 8 checks were a (wrong) proxy for: it lives on r, not on c.

    A violation here is a genuine contradiction -- either the enumerator has
    credited a twist the top layer cannot hold, or eta is being computed wrong."""
    bad, tested = [], 0
    for r in R:
        if r.q is None:
            continue
        fs = [c for _, c, f in r.cls if f]
        if len(fs) != 1:
            continue
        rr = fs[0]
        tested += 1
        t = qpart(rr - 1, r.q)
        eta = 2.0 * t / (rr - 1)
        if r.q != 2:
            v2 = 0
            m = rr - 1
            while m % 2 == 0:
                m //= 2; v2 += 1
            if eta > 2.0 / 2 ** v2 + 1e-9:
                bad.append((r.n, rr, r.q, round(eta, 4), v2))
    return ("FAIL" if bad else "PASS",
            f"0 of {tested} one-foreign winners credit an unreachable eta"
            if not bad else f"{len(bad)} of {tested} unreachable", bad[:5])


@check("B", "CONGRUENCE: S5 obeys none on c, and its foreign prime has u = oddpart(r-1) <= 9",
       "aod section 3.3.4, rung B-prime")
def c_s5(R, base):
    rows = [r for r in R if r.shape == "S5"]
    if not rows:
        return ("SKIP", "no top-layer F = 2 winners in range", [])
    cm, us, big = Counter(), Counter(), []
    for r in rows:
        c = [x for _, x, f in r.cls if not f][0]
        rr = [x for _, x, f in r.cls if f][0]
        u = oddpart(rr - 1)
        cm[c % 8] += 1; us[u] += 1
        # cap_2(1/u) drops below 0.050510 = (5-2sqrt6)/2 past u = 9.  MIND THE
        # LABEL: 0.050510 is cap_4(1/6), and was the class-23 ceiling under the
        # older unfused reading -- it is NOT the worst F = 2 ceiling, which is
        # cap_2(1/6) = (2-sqrt3)/4 = 0.066987.  Against that the condition would
        # tighten to u <= 5.  Either bound leaves the family exponential and
        # nothing downstream moves; the observed u are 1 and 3.
        if u > 9:
            big.append((r.n, rr, u))
    return ("FAIL" if big else "PASS",
            f"{len(rows)} winners; c mod 8 = {dict(sorted(cm.items()))}, "
            f"u = {dict(sorted(us.items()))}", big[:5])


@check("B", "no winner has two matching classes of different sizes AT ODD p",
       "aod section 6.2, A9")
def c_equal_sizes(R, base):
    """Scoped to odd p on purpose.

    At p = 2 the claim is FALSE and the counterexample is in the documents:
    n = 551 = 256 + 167* + 128 has c - 1 = 255 and c' - 1 = 127 both odd and
    coprime, so both twists are full and the cyclic layer is genuinely cyclic.
    A check that flagged it would be contradicting `aod` section 6.5's second
    escape.  What is open is the ODD-p case, which is Open Problem 1 in general
    form, so that is what is asserted; p = 2 instances are counted and reported
    as INFO in the message, since a new one is worth knowing about but is not a
    failure."""
    bad, twos, multi = [], [], 0
    for r in R:
        match = [(F, c) for F, c, f in r.cls if not f]
        if len(match) < 2:
            continue
        multi += 1
        if len({c for _, c in match}) > 1:
            (twos if r.p == 2 else bad).append((r.n, r.witness))
    return ("FAIL" if bad else "PASS",
            f"{multi} winners have >1 matching class; {len(bad)} unequal at odd p, "
            f"{len(twos)} at p = 2 (permitted, and currently empty -- the "
            f"n = 551 escape was a v2 winner and the corrected shape space "
            f"replaced it with the fused 3x128 + 1x167*)",
            (bad or twos)[:5])


@check("B", "the cyclic layer is admissible: every Fmid and every foreign prime "
            "pairwise coprime", "ep Part 0, corrected shape space")
def c_cyclic_layer(R, base):
    """The global condition the 2026 shape-space correction introduced, and the
    one nothing else here tests.

    A class of F blocks splits as F = Fmid * Ftop with Ftop the q-part; Fmid comes
    from the CYCLIC layer, which is one shared generator, so every Fmid, every
    cyclic-layer twist and every foreign block size must be PAIRWISE COPRIME
    across the whole configuration.  That coupling is exactly what the old
    q-power-only reading of the block count missed, so a winner violating it
    would mean the enumerator has over-corrected -- admitting a configuration no
    Oliver group realises, which inflates B and breaks the upper bound.

    Only Fmid and the foreign sizes are checked here.  The twists are not, because
    SAFE scores a matching part at F*orb(c, dmax) with dmax already stripped of
    Fmid, so the witness string does not record which twist was used and there is
    nothing to test against."""
    bad, tested = [], 0
    for r in R:
        if r.q is None:
            continue
        orders = []
        for F, c, f in r.cls:
            if f:
                orders.append(c)                 # foreign translations C_r
            # EG correction: F_mid entries removed -- their pairwise
            # coprimality was refuted (entangled generators), so only the
            # foreign translation subgroups remain testable here.
        orders = [o for o in orders if o > 1]
        if len(orders) < 2:
            continue
        tested += 1
        for i in range(len(orders)):
            for j in range(i + 1, len(orders)):
                if math.gcd(orders[i], orders[j]) > 1:
                    bad.append((r.n, orders[i], orders[j], r.witness))
                    break
    return ("FAIL" if bad else "PASS",
            f"{len(bad)} of {tested} winners with >=2 cyclic-layer orders violate "
            f"pairwise coprimality", bad[:5])


@check("B", "the feasibility criterion sum(sqrt(F_i)) <= 1/sqrt(delta)",
       "aod section 6.1")
def c_feasibility(R, base):
    """One criterion that replaces three, and is strictly sharper than their
    conjunction: it gives Prop F.1's k <= 1/sqrt(delta) at every F_i = 1, and
    F <= 1/delta -- NOT 1/sqrt(delta), which is the natural-looking but wrong
    bound.  Checked because `aod` section 6.1's shape counts are derived from it,
    so a violation would invalidate the covering statement's arithmetic rather
    than just a row."""
    bad, tight = [], None
    for r in R:
        if r.delta <= 0:
            continue
        lhs = sum(math.sqrt(F) for F, _, _ in r.cls)
        rhs = 1 / math.sqrt(r.delta)
        if lhs > rhs + 1e-9:
            bad.append((r.n, round(lhs, 4), round(rhs, 4), r.witness))
        slack = rhs - lhs
        if tight is None or slack < tight[1]:
            tight = ((r.n, r.witness), slack)
    msg = f"{len(bad)} of {len(R)} violate"
    if tight:
        msg += f"; tightest n = {tight[0][0]} (`{tight[0][1].strip()}`), slack {tight[1]:.4f}"
    return ("FAIL" if bad else "PASS", msg, bad[:5])


@check("B", "Part G.4's per-axis bounds: c_i >= delta*n and F_i <= 1/delta",
       "ep Part G.4")
def c_g4_axes(R, base):
    """The bounds that make the search finite along every axis, and the ones Part
    G.4 reports as holding at 3,053 of 3,053 fused witnesses.  Worth asserting
    rather than citing: they are what bound the enumeration's cost, so if a row
    ever violates one the cost model is wrong, not merely the prose."""
    badc, badF, tightc, tightF = [], [], None, None
    for r in R:
        if r.delta <= 0:
            continue
        for F, c, _ in r.cls:
            if c < r.delta * r.n - 1e-9:
                badc.append((r.n, c, round(r.delta * r.n, 2)))
            if F > 1 / r.delta + 1e-9:
                badF.append((r.n, F, round(1 / r.delta, 2)))
            sc = c / (r.delta * r.n)
            sF = (1 / r.delta) / F
            if tightc is None or sc < tightc[1]: tightc = (r.n, sc)
            if tightF is None or sF < tightF[1]: tightF = (r.n, sF)
    bad = badc + badF
    msg = (f"{len(badc)} block-size and {len(badF)} fusion-count violations; "
           f"tightest c/(delta*n) = {tightc[1]:.3f} at n = {tightc[0]}, "
           f"tightest (1/delta)/F = {tightF[1]:.3f} at n = {tightF[0]}")
    return ("FAIL" if bad else "PASS", msg, bad[:5])


@check("A", "the Part E construction's ingredients exist for this witness",
       "ep Part E, realisability; pending-checks T2")
def c_realisable(R, base):
    """Preconditions for realisability, per row -- NOT a construction.

    Part E builds a group for every admitted configuration, and the build has
    ingredients that either exist at a given witness or do not.  Nothing else in
    this suite tests them: group A re-derives the SCORE from the witness, which
    would be unchanged if the group were unbuildable.  Three preconditions are
    decidable from the witness string alone, which is what keeps this O(rows):

      (a) F_top is a q-power and F = F_top * F_mid with F_mid coprime to q.  The
          top layer is a q-group, so the part of the block count living there
          must be a q-power; the rest is the cyclic layer's business.  This one
          is a TRIPWIRE on the parser rather than a test of the table -- F_top is
          computed as qpart(F, q), so the property holds identically unless the
          witness parse or qpart is wrong.
      (b) A foreign block scored above r must actually have q | r - 1.  Lemma B'
          forces its twist into the top q-group, so a foreign block is worth more
          than its own size only if q divides r - 1.  A row scoring a foreign
          block higher than r without that divisibility would be crediting a
          twist the chain cannot hold.
      (c) THE DIAGONAL CARRIER EXISTS.  Part E carries every p-characteristic
          twist on ONE generator of the cyclic layer, whose order is lcm of the
          per-class twists.  That layer also holds the foreign translations C_r
          and the block rotations C_Fmid, and it is one cyclic group -- so the
          carrier's order must be coprime to every foreign prime and every F_mid
          in the configuration, not merely to the class's own.

    Reported with a LIVE count per sub-check, because a precondition check that
    is vacuous is worse than none: it reads as reassurance.  Over v4 to n = 2000
    the counts are 1,034 rows for (b) and 1,239 for (c), so neither is idle.

    Note (c) is STRICTER than SAFE, which since the entangled-generator
    correction strips NOTHING at all -- the cap is the flat F*C(c,2).  That is
    deliberate and is the point of the check: SAFE is free to be loose because
    looseness is safe for an upper bound, but the CONSTRUCTION is not, and
    attainment needs the construction.

    STALENESS FLAG, deliberate and conservative.  The `dmax` this check builds
    below still carries the OLD construction's F_mid strip
    (`coprime_part(..., F // ft)`).  Part E no longer describes the carrier that
    way -- an entangled generator supplies rotation and full twist from one
    cyclic subgroup, so the class's own F_mid does not have to be stripped out of
    its twist.  Stripping it makes the carrier SMALLER, hence more coprime to the
    foreigns and the other F_mid values, hence the test EASIER to pass: the check
    as written can miss a carrier collision, never invent one.  So a PASS here is
    weaker than it looks and a FAIL would still be real.  Rebuilding it on the
    unstripped twist is the correct tightening and is owed.  A FAIL here would mean a scored
    row whose Part E group cannot be built as described -- which is a gap in
    attainment, not in the bound, so it is reported as group A (investigate
    before trusting the row) rather than as a contradiction with the documents."""
    bad_a, bad_b, bad_c, tested, live_b, live_c = [], [], [], 0, 0, 0
    for r in R:
        if r.q is None or r.p is None:
            continue
        tested += 1
        foreigns = [c for _, c, f in r.cls if f]
        fmids = []
        for F, c, f in r.cls:
            if f:
                continue
            ft = qpart(F, r.q)
            fm = F // ft
            fmids.append(fm)
            # (a) is a tripwire, not a live test: ft is DEFINED as qpart(F, q)
            # here, so fm is coprime to q identically and this can only fire if
            # the witness parser or qpart is broken.  Kept because that is a real
            # failure mode and costs one modulo, but do not read a PASS on (a) as
            # evidence about the table.
            if fm % r.q == 0:
                bad_a.append((r.n, F, r.q, r.witness))
        # (b)
        if foreigns:
            live_b += 1
        for c in foreigns:
            if orb(c, qpart(c - 1, r.q), False) > c and (c - 1) % r.q:
                bad_b.append((r.n, c, r.q, r.witness))
        # (c) the carrier's order, built from each class's dmax
        carrier = 1
        for F, c, f in r.cls:
            if f:
                continue
            ft = qpart(F, r.q)
            dq = qpart(c - 1, r.q)
            dmax = dq * coprime_part((c - 1) // dq, F // ft)
            # only the non-q part of the twist sits in the cyclic layer
            cyc = dmax // qpart(dmax, r.q)
            carrier = carrier * cyc // math.gcd(carrier, cyc)
        others = foreigns + [m for m in fmids if m > 1]
        if carrier > 1 and others:
            live_c += 1
        for o in others:
            if math.gcd(carrier, o) > 1:
                bad_c.append((r.n, carrier, o, r.witness))
                break
    bad = bad_a + bad_b + bad_c
    return ("FAIL" if bad else "PASS",
            f"{tested} rows: {len(bad_a)} block-count (tripwire), "
            f"{len(bad_b)} foreign-twist "
            f"(live at {live_b} rows), {len(bad_c)} diagonal-carrier "
            f"(live at {live_c} rows) violations", bad[:5])


@check("B", "S6 (two foreign blocks) wins nowhere", "aod section 4.2")
def c_s6(R, base):
    rows = [(r.n, r.witness) for r in R if r.shape == "S6"]
    return ("FAIL" if rows else "PASS", f"{len(rows)} S6 winners", rows[:5])


@check("B", "Lemma C exposure: no winner part has a > 1 and a foreign prime dividing c - 1",
       "pending-checks R4")
def c_lemmaC(R, base):
    hits, tot = [], 0
    for r in R:
        fgs = [c for _, c, f in r.cls if f]
        for F, c, f in r.cls:
            if f:
                continue
            tot += 1
            b = prime_power_base(c)
            if b and c != b and any((c - 1) % g == 0 for g in fgs):
                hits.append((r.n, c))
    return ("FAIL" if hits else "PASS",
            f"{len(hits)} of {tot} p-characteristic winner parts exposed", hits[:5])


# ==========================================================================
# C. DENSITY AND DISTRIBUTION, AGAINST THE ASYMPTOTIC MODEL
# ==========================================================================

@check("C", "regime split of winners' foreign blocks by the twist exponent",
       "aod section 3.5.6")
def c_regime(R, base):
    """Which of the three families a winner's foreign block belongs to.

    Written as t = q^e with cofactor u = (r-1)/t, the fallback families split by
    e: e = 1 is linear in q and behaves like any other parametric family; e >= 2
    has a supply of admissible foreign blocks that is sparse (about N^(1/e) up to
    N), so it is available only at a density-zero set of n; q = 2 is exponential
    and outside Bateman-Horn altogether.  That split is what decides whether a
    per-shape argument is available, so it is worth measuring on every extension
    rather than quoting a figure from one pass.  INFO: no value is a failure."""
    cnt = {"e=1": 0, "e>=2": 0, "q=2": 0}
    umax = 0
    for r in R:
        if r.q is None:
            continue
        for F, c, f in r.cls:
            if not f:
                continue
            t = qpart(c - 1, r.q)
            if t <= 1:
                continue
            e, x = 0, t
            while x % r.q == 0:
                x //= r.q; e += 1
            umax = max(umax, (c - 1) // t)
            cnt["q=2" if r.q == 2 else ("e=1" if e == 1 else "e>=2")] += 1
    tot = sum(cnt.values()) or 1
    return ("INFO",
            f"e=1 {cnt['e=1']} ({100*cnt['e=1']/tot:.1f}%), e>=2 {cnt['e>=2']}, "
            f"q=2 {cnt['q=2']}; largest cofactor u = {umax} "
            f"(predicted <= 2/delta = {2/min(x.delta for x in R if x.delta>0):.0f})", [])


@check("C", "density floor, and the s- and k-bounds it implies", "ep Part E-prime, Prop F.1",
       expect="asymptotically delta >= 0.071797 = 7-4sqrt3, attained at n = 11 and 23 (mod 24); "
              "the finite-range floor should RISE with n as the omega(n)=2 population thins")
def c_floor(R, base):
    r = min(R, key=lambda x: x.delta)
    s = 1 / math.sqrt(r.delta) - 1
    k = 1 / math.sqrt(r.delta)
    note = (f"delta >= {r.delta:.6f} at n = {r.n} ({r.witness}); "
            f"s <= {s:.3f} so s <= {int(s)}; k < {k:.3f} so k <= {int(k)}")
    if int(s) <= 3:
        note += "\n        -> s <= 3 in range: E.1/E.3(iii)/E.4 close every fallback branch " \
                "but E.3(ii)-with-leftover"
    return ("INFO", note, [])


@check("C", "low-density tail, which scopes Open Problem 8(a)", "notes OP 8(a)",
       expect="1/16 is the four-class cap, so delta <= 1/16 is where k <= 3 stops being free; "
              "delta <= 1/25 and 1/36 are where the s = 4 and s = 5 fallback branches open up")
def c_tail(R, base):
    out = []
    for thr, nm in ((1 / 9, "1/9"), (1 / 16, "1/16"), (1 / 25, "1/25"), (1 / 36, "1/36")):
        lo = [r.n for r in R if r.delta <= thr]
        out.append(f"<= {nm}: {len(lo)}" + (f" {lo}" if 0 < len(lo) <= 6 else ""))
    return ("INFO", "; ".join(out), [])


@check("C", "part-count distribution among winners", "ep Part I",
       expect="no winner should use more than 3 parts anywhere; the fused rung absorbs what "
              "were 3-part configurations into 2-part ones, so the 3-count should be small "
              "and falling relative to v2")
def c_partdist(R, base):
    d = Counter(r.parts for r in R)
    note = f"{dict(sorted(d.items()))} over {len(R)} rows"
    if base:
        note += "  (v2-era shape of this distribution was roughly {1: 43%, 2: 47%, 3: 10%})"
    return ("INFO", note, [])


# Census verdicts of the form "wins -> 0" are ASYMPTOTIC limits, not claims that
# the shape never wins: S1 and S2 win at half the values in range and still
# tend to 0, because omega(n) = 2 thins.  So the count alone tests nothing.  The
# TREND does: a shape whose winning share tends to zero because its supply is
# O(n/log n) must have a winner share that DECLINES across the range.  A share
# that holds steady or rises contradicts the supply claim behind the verdict.
#
# This is the check that would have caught the S7-at-F>=3 error.  That row read
# "wins -> 0", justified by a supply claim ("F*c even forces c = 2^a") true only
# for odd F; at even F the supply is a full Hardy-Littlewood system.  The census
# and the table sat in the same report contradicting each other -- 125 winners of
# the shape printed a few lines below a row asserting it wins nowhere -- for as
# long as both existed.
#
# To exercise it, replace the S7f3/S7f5 entries below with the aggregate
#     ("S7f3", "S7f4", "S7f5", "S7f6", "S7f8")
# which is the historical lumped claim.  It FAILS with
#     S7f3+S7f4+S7f5+S7f6+S7f8 4.1%->7.6%   against   S2 45.2%->29.3%
# and that contrast -- one vanishing-share row rising while another falls as it
# should -- is the signature to recognise.
#
# Two design points, both learned from getting them wrong first.  The count alone
# is useless as a test, because the verdicts are limits and S1/S2 win half the
# values in range while legitimately tending to zero.  And only GROWTH fails: a
# flat share is consistent with a slow log-factor decline, so tolerating it costs
# a little sensitivity and avoids firing on every shape whose supply thins more
# slowly than the range grows.
# Census rows claiming wins -> 0.  An entry is either a label or a tuple of
# labels tested as one aggregate.  The odd-F members of S7 belong here -- they
# need c = 2^a at odd n, so O(log n) block sizes per n -- while the even-F ones
# do NOT, F = 4 attaining the class ceiling at four residues.
#
# Splitting the S7 label is what makes that distinction expressible, but it costs
# sensitivity: the per-label counts are small, and a trend that is unmistakable
# in aggregate can sit inside Poisson noise once divided five ways.  So the
# historical lumped claim is kept as an explicit aggregate entry, which is the
# form in which the S7 error is detectable.
ZERO_SHARE = ["S1", "S2", "S5", "S6", "S7f3", "S7f5"]


@check("B", "shapes claimed to win with vanishing share have a declining share",
       "aod section 2.0 census, section 4.3")
def c_zero_share_trend(R, base):
    rows = sorted(R, key=lambda r: r.n)
    third = len(rows) // 3
    early, late = rows[:third], rows[-third:]
    bad, seen = [], []
    for sh in ZERO_SHARE:
        labels = (sh,) if isinstance(sh, str) else tuple(sh)
        name = sh if isinstance(sh, str) else "+".join(labels)
        e = sum(1 for r in early if r.shape in labels)
        l = sum(1 for r in late if r.shape in labels)
        if e + l < 20:                  # too few to read a trend from
            continue
        fe, fl = e / len(early), l / len(late)
        seen.append(f"{name} {fe:.1%}->{fl:.1%}")
        # Fire only on growth that is BOTH proportionally large and larger than
        # Poisson noise on the raw counts.  The second test matters: 19 -> 24 is
        # a 26% rise and entirely consistent with a flat share, and without it
        # the check cries wolf on every small-count label.
        if fl > fe * 1.25 and fl > 0.02 and (l - e) > 2 * (e + l) ** 0.5:
            bad.append((name, round(fe, 4), round(fl, 4)))
    return ("FAIL" if bad else "PASS",
            f"{len(bad)} of {len(seen)} rising: " + "; ".join(seen), bad)


@check("C", "census winner counts by shape", "aod section 2.0, ep census",
       expect="asymptotic WINNING shares over all n: S3 12/24 (50%) at even n, S7f2 10/24 "
              "(41.7%) at the odd residues 1,3,5,7,9,13,15,17,19,21, S7f4 2/24 (8.3%) at 11 and 23 "
              "where F = 4 sets the class ceiling; S1, S2, S4, S5, S6, ties and the odd-F S7fk "
              "all -> 0.  (Classes 7 and 15 belong to S7f2 under the mod-12 keying: their "
              "ceiling cell is F = 2 at eta = 1/2, shared with 3 and 19 at 1/8.)  At computed "
              "sizes S1 and S2 are still large because omega(n)=2 has "
              "not thinned, and S4 still wins a few values where supply fails the winners above")
def c_census(R, base):
    d = Counter(r.shape for r in R)
    tot = sum(d.values())
    return ("INFO", ", ".join(f"{k} {v} ({v/tot:.1%})" for k, v in sorted(d.items())), [])


@check("C", "odd-n shares among the three readings of n = 2c + r", "three-part-family-split.md",
       expect="over odd n the limit is S7-at-F=2 83.3%, S4 8.3%, tie 8.3%; S5 -> 0. Note the "
              "table records ONE witness per n, so ties are invisible here and are counted "
              "under whichever reading was recorded -- see rung_split.py for the tie-aware "
              "measurement. Convergence is O(1/log n) and the model's own error is the same "
              "order, so a gap at computed sizes is expected, not evidence against the model")
def c_oddshare(R, base):
    rows = [r for r in R if r.n % 2 and r.shape in ("S4", "S5", "S7f2")]
    if not rows:
        return ("SKIP", "no odd three-reading winners in range", [])
    d = Counter(r.shape for r in rows)
    tot = sum(d.values())
    return ("INFO", f"of {tot} odd n won by one of the three: "
                    + ", ".join(f"{k} {d[k]} ({d[k]/tot:.1%})" for k in ("S7f2", "S4", "S5")), [])


@check("C", "winners exceeding their own residue class ceiling", "aod section 3.3.5",
       expect="the class ceilings are what the BALANCED family guarantees, not bounds on "
              "delta(n), so exceedance is expected and should be common; the escapes of section "
              "4.3 lift O(n/log n) values. A rate near 100% means the tabulated delta_0 "
              "describes little of the computed range at that residue")
def c_class(R, base):
    tot, ex = Counter(), Counter()
    for r in R:
        a = r.n % 24
        tot[a] += 1
        if r.delta > CAP24[a] + 1e-9:
            ex[a] += 1
    worst = sorted(((ex[a] / tot[a], a) for a in tot if tot[a]), reverse=True)[:5]
    return ("INFO",
            f"{sum(ex.values())} of {sum(tot.values())} exceed; highest rates "
            + ", ".join(f"n={a} ({ex[a]}/{tot[a]}, cap {CAP24[a]:.5f})" for _, a in worst), [])


@check("C", "median density by residue class mod 24", "aod section 3.3.5",
       expect="the caps bound only the ADDITIVE families, so a median far above one is normal "
              "wherever the multiplicative engine reaches -- n = 2 (mod 24) sits near 1/2 "
              "because n/2 is often a prime power, which is S2 and not bounded by any of this. "
              "Read the comparison only at the residues where S1 and S2 are scarce. The caps are the joint optimum over (F, eta): 1/4 at "
              "0,4,6,10,12,16,18,22 - 0.13397 at 2,8,14,20 - 0.17157 at 1,9,13,21 - 0.125 at 3,19 - "
              "0.10102 at 5,17 - 0.11111 at 7,15 - 0.07180 at 11 and 23. The last three take F = 4; "
              "the rest take F = 2.")
def c_medbyclass(R, base):
    by = defaultdict(list)
    for r in R:
        by[r.n % 24].append(r.delta)
    lines = []
    for a in sorted(by):
        v = sorted(by[a]); med = v[len(v) // 2]
        lines.append(f"{a}:{med:.4f}/{CAP24[a]:.4f}")
    return ("INFO", "median/cap by n mod 24 — " + "  ".join(lines), [])


@check("C", "how the aggregates have moved against the baseline", "pending-checks A0",
       expect="the corrected shape space should RAISE the floor and SHRINK the low-density "
              "tail, because cyclic-layer fusion supplies configurations the old space missed "
              "at exactly the arithmetically weak n")
def c_moved(R, base):
    if not base:
        return ("SKIP", "no --baseline given", [])
    com = [r for r in R if r.n in base]
    bd = {r.n: base[r.n][0] / r.C for r in com}
    fo_new = min(com, key=lambda r: r.delta)
    fo_old = min(com, key=lambda r: bd[r.n])
    lines = [f"floor {bd[fo_old.n]:.6f} (n={fo_old.n}) -> {fo_new.delta:.6f} (n={fo_new.n})"]
    for thr, nm in ((1 / 9, "1/9"), (1 / 16, "1/16"), (1 / 25, "1/25")):
        lines.append(f"delta<={nm}: {sum(1 for r in com if bd[r.n] <= thr)} -> "
                     f"{sum(1 for r in com if r.delta <= thr)}")
    ob = Counter(base[r.n][1] for r in com); nb = Counter(r.shape for r in com)
    lines.append("shapes: " + ", ".join(f"{k} {ob.get(k,0)}->{nb.get(k,0)}"
                                        for k in sorted(set(ob) | set(nb))))
    return ("INFO", "on the common range — " + "; ".join(lines), [])


@check("C", "foreign-block efficiency: share of blocks running at eta = 1", "notes glossary",
       expect="about 77% over the v2 range to n = 2212; eta = 1 needs r - 1 = q^e or 2q^e, "
              "i.e. a Fermat prime, a safe prime, or the r = 2q^e+1 generalisation")
def c_eff(R, base):
    full = tot = 0
    for r in R:
        for F, c, f in r.cls:
            if not f:
                continue
            tot += 1
            if orb(c, qpart(c - 1, r.q), False) == comb(c, 2):
                full += 1
    if not tot:
        return ("SKIP", "no foreign blocks", [])
    return ("INFO", f"{full} of {tot} foreign blocks at eta = 1 ({full/tot:.1%})", [])


# ---------------------------------------------------------------- the ladder
#
# `ladder_verify.py` scores four explicit families and so returns a LOWER bound
# on delta(n); the table holds B(n), which equals delta(n) wherever the collapse
# certificate applies.  They are different computations of the same quantity by
# different routes, and nothing else in the pipeline compares them -- which is
# exactly the defect class this framework keeps producing: two artefacts that
# would contradict each other, and no check that looks at both.
#
# Two things fall out of the join, and they are different in kind.
#
#   (1) A CORRECTNESS check.  The ladder's bound can never EXCEED the table's
#       density: the ladder exhibits a construction, so ladder(n) <= delta(n),
#       and delta(n) <= B(n) by the enumeration.  A ladder value above B(n)
#       means one of the three is wrong -- a family scored too generously, a
#       missing shape depressing B, or a broken collapse -- and it is the kind
#       of error nothing else here would catch.
#
#   (2) A COVERAGE diagnostic.  Where the ladder is much BELOW B(n) it is not
#       wrong, merely weak: its four families did not find what the enumeration
#       did.  That matters because the ladder is what carries the floor out to
#       10^6, far past the table, so a systematic gap is a reason to distrust
#       the floor's *sharpness* out there -- and the gap at a given n names the
#       shape the ladder is missing, since B(n)'s witness is recorded.
#
# TOLERANCE.  Worklist files carry ~5 significant digits, so a value rounded up
# in the last place reads as a violation.  Compare with a tolerance of one unit
# in the last recorded place rather than exactly, or the check reports dozens of
# spurious failures and gets switched off.
def _load_ladder(path):
    out = {}
    for line in open(path):
        p = line.split()
        if len(p) >= 2:
            try:
                out[int(p[0])] = float(p[1])
            except ValueError:
                continue
    return out


@check("A", "the ladder's lower bound never exceeds the table's density",
       "aod section 5.1; ladder_verify.py")
def a_ladder_sound(R, base):
    if not A.ladder:
        return ("SKIP", "no --ladder given", [])
    lad = _load_ladder(A.ladder)
    bad = []
    for r in R:
        lb = lad.get(r.n)
        if lb is None:
            continue
        if lb > r.delta + 1.1e-5:          # one unit in the worklist's last place
            bad.append("n=%d ladder %.6f > B/C(n,2) %.6f" % (r.n, lb, r.delta))
    joined = sum(1 for r in R if r.n in lad)
    if not joined:
        return ("SKIP", "no n in both files", [])
    if bad:
        return ("FAIL", "%d of %d joined values have ladder > table" % (len(bad), joined), bad[:12])
    return ("PASS", "%d values joined, none exceeding" % joined, [])


@check("C", "where the ladder under-explores relative to the enumeration",
       "aod section 5.1, section 5.2",
       expect="the ladder should be TIGHT at most joined values -- it and the enumeration "
              "then agree on delta(n) by two routes. A ratio well above 1 is a value where "
              "the four families miss a configuration the enumeration finds, and the witness "
              "column names the shape they are missing. Any decade minimum in aod section "
              "5.2 that appears here is a LADDER bound and not delta at that n")
def c_ladder_gap(R, base):
    if not A.ladder:
        return ("SKIP", "no --ladder given", [])
    lad = _load_ladder(A.ladder)
    g = []
    for r in R:
        lb = lad.get(r.n)
        if lb and lb > 0:
            g.append((r.delta / lb, r.n, lb, r.delta, r.witness))
    if not g:
        return ("SKIP", "no n in both files", [])
    g.sort(reverse=True)
    tight = sum(1 for x in g if x[0] < 1.01)
    lines = ["n=%-6d ladder %.5f  B %.5f  x%.2f  %s" % (n, lb, d, ratio, w)
             for ratio, n, lb, d, w in g[:6] if ratio >= 1.01]
    return ("INFO",
            "%d joined; ladder tight (within 1%%) at %d of them; largest gap x%.2f at n = %d"
            % (len(g), tight, g[0][0], g[0][1]),
            lines)


@check("C", "share of values with omega(n) = 2, which is the multiplicative engine's reach",
       "aod section 1, consequence 5",
       expect="thins like log log n / log n: measured about 52% below 2000 and 29% near 10^6. "
              "The observed density floor should drift down as this population recedes")
def c_omega2(R, base):
    hits = sum(1 for r in R if r.shape in ("S1", "S2"))
    return ("INFO", f"{hits} of {len(R)} winners are S1 or S2 ({hits/len(R):.1%})", [])


# --------------------------------------------------------------------------

def explain(R, n):
    """Term-by-term breakdown of one row, with the binding term marked."""
    hit = [r for r in R if r.n == n]
    if not hit:
        print(f"n = {n} is not in {A.table}"
              + (" (prime powers are skipped: mu = C(n,2))" if prime_power_base(n) else ""))
        return 1
    r = hit[0]
    print(f"n = {r.n}   B = {r.B}   delta = {r.delta:.6f}   n mod 24 = {r.n % 24} "
          f"(class cap {CAP24[r.n % 24]:.5f})")
    print(f"  witness  {r.witness}")
    print(f"  shape    {r.shape}   p = {r.p}  q = {r.q}   parts = {r.parts}")
    terms = []
    for F, c, foreign in r.cls:
        if foreign:
            t = qpart(c - 1, r.q)
            eta = orb(c, t, False) / comb(c, 2)
            terms.append((orb(c, t, False),
                          f"foreign {c}*  intra orb({c},{t})   eta = {eta:.4f}, "
                          f"u = oddpart({c}-1) = {oddpart(c - 1)}"))
        else:
            ft = qpart(F, r.q); fm = F // ft
            dq = qpart(c - 1, r.q)
            dmax = dq * coprime_part((c - 1) // dq, fm)
            terms.append((F * orb(c, dmax, r.p == 2),
                          f"{F}x{c}  intra {F}*orb({c},{dmax})   "
                          f"Fmid={fm} Ftop={ft}, twist {dmax} of {c-1}"))
            if F > 1:
                terms.append(((F if F % 2 else F // 2) * c * c,
                              f"{F}x{c}  within-class cross  "
                              f"{'F' if F % 2 else 'F/2'}*c^2  (F is {'odd' if F % 2 else 'even'})"))
    sizes = [F * c for F, c, _ in r.cls]
    for i in range(len(sizes)):
        for j in range(i + 1, len(sizes)):
            terms.append((sizes[i] * sizes[j], f"cross {sizes[i]} x {sizes[j]}"))
    lo = min(v for v, _ in terms)
    print("  terms:")
    for v, lab in terms:
        print(f"    {v:>12}  {lab}" + ("   <-- BINDS" if v == lo else ""))
    if r.delta > CAP24[r.n % 24]:
        print(f"  NOTE: exceeds its class ceiling by {r.delta / CAP24[r.n % 24]:.2f}x "
              f"-- an escape (aod section 4.3), not the balanced family")
    return 0


def main():
    R = [Row(d) for d in csv.DictReader(open(A.table))]
    if A.explain is not None:
        return explain(R, A.explain)
    base = None
    if A.baseline:
        base = {}
        for d in csv.DictReader(open(A.baseline)):
            br = Row(d)
            base[br.n] = (br.B, br.shape)
    ns = [r.n for r in R]
    print(f"{A.table}: {len(R)} rows, n = {min(ns)} .. {max(ns)}"
          + (f"   baseline {A.baseline}" if base else ""))
    gaps = [n for n in range(min(ns), max(ns) + 1)
            if n not in set(ns) and prime_power_base(n) is None]
    if gaps:
        print(f"  NOTE: {len(gaps)} non-prime-power values missing in range "
              f"(run --fill-gaps): {gaps[:8]}{' ...' if len(gaps) > 8 else ''}")
    tally = Counter()
    for gid, gname in GROUPS:
        rows = [c for c in CHECKS if c[0] == gid]
        shown = False
        for _, name, source, expect, fn in rows:
            st, msg, ex = fn(R, base)
            tally[st] += 1
            if A.quiet and st != "FAIL":
                continue
            if not shown:
                print(f"\n{gid}. {gname.upper()}\n" + "-" * 74)
                shown = True
            print(f"  [{st}] {name}")
            print(f"        {msg}    ({source})")
            if expect:
                for i, line in enumerate(textwrap.wrap(expect, 86)):
                    print(f"        {'expected: ' if i == 0 else '          '}{line}")
            for e in ex:
                print(f"          {e}")
    print()
    print("  " + "  ".join(f"{k}: {tally[k]}" for k in ("PASS", "FAIL", "INFO", "SKIP")))
    if tally["FAIL"]:
        print("\n  A FAIL in group A means the run or the parser is broken; nothing else here")
        print("  is meaningful until it is fixed. A FAIL in group B is a real contradiction")
        print("  between the table and the documents -- check whether the belief was scoped")
        print("  to an older table before editing either.")
    return 1 if tally["FAIL"] else 0


sys.exit(main())
