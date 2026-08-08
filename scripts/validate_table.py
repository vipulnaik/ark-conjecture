#!/usr/bin/env python3
"""
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
import argparse, csv, math, re, sys
from collections import Counter, defaultdict
from math import comb

ap = argparse.ArgumentParser()
ap.add_argument("table")
ap.add_argument("--baseline", default=None,
                help="an earlier table to compare against; enables the monotonicity check")
ap.add_argument("--quiet", action="store_true", help="print FAILs only")
A = ap.parse_args()

# --------------------------------------------------------------------------
# parsing

WIT = re.compile(r"p=(\d+) q=(\d+):")
PART = re.compile(r"(\d+)x(\d+)(\*?)")


class Row:
    __slots__ = ("n", "C", "B", "delta", "parts", "certK", "certified",
                 "fallback", "witness", "p", "q", "cls", "shape")

    def __init__(self, d):
        self.n = int(d["n"]); self.C = int(d["C(n2)"]); self.B = int(d["mu_bound"])
        self.delta = float(d["density"]); self.parts = int(d["parts"])
        self.certK = int(d["certified_K"]); self.certified = d["certified"] == "1"
        self.fallback = d["fallback"] != "0"; self.witness = d["witness"]
        m = WIT.match(self.witness)
        self.p, self.q = (int(m.group(1)), int(m.group(2))) if m else (None, None)
        # cls: list of (F, c, is_foreign)
        self.cls = [(int(a), int(b), s == "*") for a, b, s in PART.findall(self.witness)]
        self.shape = classify(self)


def classify(r):
    """Census S-number of a winner. S7f2 is S7 at F = 2, kept separate from S5
    because they differ only by which layer holds the swap (aod section 3.2)."""
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
        return "S7"
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
            ft = qpart(F, r.q); fm = F // ft
            dq = qpart(c - 1, r.q)
            dmax = dq * coprime_part((c - 1) // dq, fm)
            terms.append(F * orb(c, dmax, r.p == 2))
            if F > 1:
                # Coefficient is keyed on the parity of F, NOT on q.  Under the
                # corrected shape space F = Fmid*Ftop need not be a q-power, so
                # "F for odd q, F/2 for q = 2" -- correct while every block count
                # was a q-power -- is no longer the rule.  What the divisibility
                # argument actually bounds is the minimum pair-orbital of a
                # transitive group of degree F, which is F/2 for even F and F for
                # odd F.  Both shipped enumerators key on F's parity.
                terms.append((F if F % 2 else F // 2) * c * c)
    sizes = [F * c for F, c, _ in r.cls]
    for i in range(len(sizes)):
        for j in range(i + 1, len(sizes)):
            terms.append(sizes[i] * sizes[j])
    return min(terms) if terms else 0


# mod-24 class ceilings, aod section 3.3.5
CAP24 = {0: .250000, 1: .171573, 2: .133975, 3: .125000, 4: .250000, 5: .101021,
         6: .250000, 7: .085786, 8: .133975, 9: .171573, 10: .250000, 11: .066987,
         12: .250000, 13: .171573, 14: .133975, 15: .085786, 16: .250000,
         17: .101021, 18: .250000, 19: .125000, 20: .133975, 21: .171573,
         22: .250000, 23: .050510}

# --------------------------------------------------------------------------
# check registry

CHECKS = []


def check(name, source):
    def deco(fn):
        CHECKS.append((name, source, fn))
        return fn
    return deco


# ---- structural integrity of the table itself ----------------------------

@check("parts sum to n, and every part is well formed", "ep Part G.3")
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
    return ("FAIL" if bad else "PASS", f"{len(bad)} malformed", bad[:5])


@check("foreign primes are pairwise distinct within a configuration", "ep Part E")
def c_distinct_foreign(R, base):
    bad = [r.n for r in R if len({c for _, c, f in r.cls if f}) != sum(1 for _, _, f in r.cls if f)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} with a repeated foreign prime", bad[:5])


@check("mu_bound is re-derivable from the witness by the G.3 formulas", "ep Part G.3")
def c_rederive(R, base):
    bad = [(r.n, r.B, score(r)) for r in R if score(r) != r.B]
    return ("FAIL" if bad else "PASS", f"{len(bad)} mismatches of {len(R)}", bad[:5])


@check("density column agrees with mu_bound / C(n,2)", "table")
def c_density(R, base):
    bad = [r.n for r in R if abs(r.delta - r.B / r.C) > 5e-7]
    return ("FAIL" if bad else "PASS", f"{len(bad)} mismatches", bad[:5])


@check("every row is certified and no optimum invokes the fallback", "ep Part E-prime")
def c_certified(R, base):
    unc = [r.n for r in R if not r.certified]
    fb = [r.n for r in R if r.fallback]
    st = "FAIL" if unc else ("INFO" if fb else "PASS")
    return (st, f"{len(unc)} uncertified, {len(fb)} fallback optima", (unc + fb)[:5])


@check("Proposition F.1: the part count obeys k < 1/sqrt(delta)", "ep Prop F.1")
def c_f1(R, base):
    bad = [(r.n, r.parts, 1 / math.sqrt(r.delta)) for r in R
           if r.delta > 0 and r.parts >= 1 / math.sqrt(r.delta)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} violations", bad[:5])


# ---- the model's structural claims ---------------------------------------

@check("no winner exceeds cap_F(eta) for its own F and eta", "aod section 3.3.8")
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


@check("S4 winners have c = 1 (mod 8)", "aod section 3.2.3")
def c_s4(R, base):
    rows = [r for r in R if r.shape == "S4"]
    bad = [(r.n, [c for _, c, f in r.cls if not f][0]) for r in rows
           if [c for _, c, f in r.cls if not f][0] % 8 != 1]
    if not rows:
        return ("SKIP", "no S4 winners in range", [])
    return ("FAIL" if bad else "PASS", f"{len(rows)} S4 winners, {len(bad)} off-pattern", bad[:5])


@check("S7 at F = 2 concentrates at c = 3 (mod 4); exceptions are the c = 5 (mod 8) tie or p = 2",
       "aod section 3.2.3")
def c_s7f2(R, base):
    rows = [r for r in R if r.shape == "S7f2"]
    if not rows:
        return ("SKIP", "no cyclic-layer F = 2 winners in range", [])
    odd = Counter()
    weird = []
    for r in rows:
        c = [x for _, x, f in r.cls if not f][0]
        odd[c % 8] += 1
        if c % 4 != 3 and c % 8 != 5 and r.p != 2:
            weird.append((r.n, c, c % 8))
    return ("FAIL" if weird else "PASS",
            f"{len(rows)} winners, c mod 8 = {dict(sorted(odd.items()))}", weird[:5])


@check("S5 obeys no congruence on c, and its foreign prime has small u = oddpart(r-1)",
       "aod section 3.3.4, rung B-prime")
def c_s5(R, base):
    rows = [r for r in R if r.shape == "S5"]
    if not rows:
        return ("SKIP", "no top-layer F = 2 winners in range", [])
    cm, us = Counter(), Counter()
    big = []
    for r in rows:
        c = [x for _, x, f in r.cls if not f][0]
        rr = [x for _, x, f in r.cls if f][0]
        u = oddpart(rr - 1)
        cm[c % 8] += 1; us[u] += 1
        if u > 9:                      # cap_2(1/u) drops below 0.050510 past u = 9
            big.append((r.n, rr, u))
    st = "FAIL" if big else "PASS"
    return (st, f"{len(rows)} winners; c mod 8 = {dict(sorted(cm.items()))}, "
                f"u = {dict(sorted(us.items()))}", big[:5])


@check("S5 winners all have q = 2 and S7-at-F=2 winners all have q odd", "aod section 3.2.2")
def c_layer_by_q(R, base):
    bad = [(r.n, r.q, r.shape) for r in R
           if (r.shape == "S5" and r.q != 2) or (r.shape == "S7f2" and r.q == 2)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} misfiled by top prime", bad[:5])


@check("S6 (two foreign blocks) wins nowhere", "aod section 4.2")
def c_s6(R, base):
    rows = [(r.n, r.witness) for r in R if r.shape == "S6"]
    return ("FAIL" if rows else "PASS", f"{len(rows)} S6 winners", rows[:5])


@check("S2 winners have omega(n) = 2 and density about 1/F", "aod section 2.1")
def c_s2(R, base):
    rows = [r for r in R if r.shape == "S2"]
    bad = []
    for r in rows:
        F, c, _ = r.cls[0]
        if abs(r.delta - (c - 1) / (F * c - 1)) > 1e-6:
            bad.append((r.n, r.delta, (c - 1) / (F * c - 1)))
    return ("FAIL" if bad else "PASS", f"{len(rows)} S2 winners, {len(bad)} off 1/F", bad[:5])


@check("no configuration with a fixed point (part of size 1)", "ep Part A")
def c_nofixed(R, base):
    bad = [r.n for r in R if any(F * c == 1 for F, c, _ in r.cls)]
    return ("FAIL" if bad else "PASS", f"{len(bad)} with a fixed point", bad[:5])


# ---- comparison against a baseline table ---------------------------------

@check("the rebuild never lowers a value against the baseline", "pending-checks R0")
def c_monotone(R, base):
    if not base:
        return ("SKIP", "no --baseline given", [])
    com = [r for r in R if r.n in base]
    lower = [(r.n, r.B, base[r.n]) for r in com if r.B < base[r.n]]
    higher = sum(1 for r in com if r.B > base[r.n])
    return ("FAIL" if lower else "PASS",
            f"{len(com)} common values: {higher} higher, {len(lower)} lower", lower[:5])


# ---- measured quantities: reported, not judged ---------------------------

@check("density floor, and the s- and k-bounds it implies", "ep Part E-prime, Prop F.1")
def c_floor(R, base):
    r = min(R, key=lambda x: x.delta)
    s = 1 / math.sqrt(r.delta) - 1
    k = 1 / math.sqrt(r.delta)
    note = (f"delta >= {r.delta:.6f} at n = {r.n} ({r.witness}); "
            f"s <= {s:.3f} so s <= {int(s)}; k < {k:.3f} so k <= {int(k)}")
    if int(s) <= 3:
        note += "  -- E.1/E.3(iii)/E.4 close every branch but E.3(ii)-with-leftover"
    return ("INFO", note, [])


@check("low-density tail, which scopes Open Problem 8(a)", "notes OP 8(a)")
def c_tail(R, base):
    out = []
    for thr, nm in ((1 / 9, "1/9"), (1 / 16, "1/16"), (1 / 25, "1/25"), (1 / 36, "1/36")):
        lo = [r.n for r in R if r.delta <= thr]
        out.append(f"<= {nm}: {len(lo)}" + (f" {lo}" if 0 < len(lo) <= 6 else ""))
    return ("INFO", "; ".join(out), [])


@check("part-count distribution among winners", "ep Part I")
def c_partdist(R, base):
    d = Counter(r.parts for r in R)
    return ("INFO", f"{dict(sorted(d.items()))} over {len(R)} rows", [])


@check("census winner counts by shape", "aod section 2.0, ep census")
def c_census(R, base):
    d = Counter(r.shape for r in R)
    return ("INFO", ", ".join(f"{k} {v}" for k, v in sorted(d.items())), [])


@check("winners exceeding their own residue class ceiling", "aod section 3.3.5")
def c_class(R, base):
    tot, ex = Counter(), Counter()
    for r in R:
        a = r.n % 24
        tot[a] += 1
        if r.delta > CAP24[a] + 1e-9:
            ex[a] += 1
    worst = sorted(((ex[a] / tot[a], a) for a in tot if tot[a]), reverse=True)[:4]
    return ("INFO",
            f"{sum(ex.values())} of {sum(tot.values())} exceed; highest rates "
            + ", ".join(f"n={a} ({ex[a]}/{tot[a]})" for _, a in worst),
            [])


@check("foreign-block efficiency: share of winners running at eta = 1", "notes glossary")
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


@check("Lemma C exposure: winner parts with a > 1 and a foreign prime dividing c - 1",
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
    return ("INFO" if not hits else "FAIL",
            f"{len(hits)} of {tot} p-characteristic winner parts exposed", hits[:5])


# --------------------------------------------------------------------------

def main():
    R = [Row(d) for d in csv.DictReader(open(A.table))]
    base = None
    if A.baseline:
        base = {int(d["n"]): int(d["mu_bound"]) for d in csv.DictReader(open(A.baseline))}
    ns = [r.n for r in R]
    print(f"{A.table}: {len(R)} rows, n = {min(ns)} .. {max(ns)}"
          + (f"   baseline {A.baseline}" if base else ""))
    gaps = [n for n in range(min(ns), max(ns) + 1)
            if n not in set(ns) and prime_power_base(n) is None]
    if gaps:
        print(f"  NOTE: {len(gaps)} non-prime-power values missing in range "
              f"(run --fill-gaps): {gaps[:8]}{' ...' if len(gaps) > 8 else ''}")
    print()
    tally = Counter()
    for name, source, fn in CHECKS:
        st, msg, ex = fn(R, base)
        tally[st] += 1
        if A.quiet and st != "FAIL":
            continue
        print(f"  [{st}] {name}")
        print(f"        {msg}    ({source})")
        for e in ex:
            print(f"          {e}")
    print()
    print("  " + "  ".join(f"{k}: {tally[k]}" for k in ("PASS", "FAIL", "INFO", "SKIP")))
    if tally["FAIL"]:
        print("\n  A FAIL means the table contradicts a documented belief. Before editing")
        print("  either, check whether the belief was scoped to an older table.")
    return 1 if tally["FAIL"] else 0


sys.exit(main())
