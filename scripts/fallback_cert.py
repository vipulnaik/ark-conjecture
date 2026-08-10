#!/usr/bin/env python3
"""
fallback_cert.py -- certify, per n, that no fallback configuration attains B(n),
using the TRUE B(n) from a computed table.

See `fb_common.py` for the question, the soundness rule, and the shared
necessary conditions; see Part E-prime of `enumeration-proof.md` for the
theorems.  For a run that reaches far beyond the computed table by substituting
a proven LOWER bound for B(n), see `wide_cert.py`.

Reports two things per table:
  * how many values every relevant s-branch is settled at by theorem alone
    (Theorems E.1, E.3(iii), E.4), needing no search;
  * whether any candidate survives the eight necessary conditions anywhere.
An empty candidate list proves mu(n) = B(n) at each n in the table.

--no-theorems disables every Part E-prime clause: no s-branch is dispatched, so
all of them reach the search, and `e3ii_resolves` stops resolving.  A run in that
mode rests only on the eight necessary conditions of `fb_common.py` being
necessary -- a much smaller trusted base than this file's structure suggests --
so it is the mode to quote.  It should agree with the normal run exactly; if it
ever stops agreeing while the normal run passes, the error is localised at once
to E.1 / E.3(ii) / E.3(iii) / E.4, Lemma E.2's bound, or the MERSENNE / REPUNIT3
tables.

Unlike `wide_cert.py`, this file runs against the TRUE B(n), which is larger than
B_lo, so the foreign-cap filter bites less and the dispatched branches are
actually reached.  That makes this the run where --no-theorems carries evidential
weight -- see the per-branch dispatch report below.

Usage:
    python3 fallback_cert.py mu_table_safe_v4.csv [--verbose] [--no-theorems]
"""
import argparse, csv, sys
from math import comb
import fb_common as fb

ap = argparse.ArgumentParser()
ap.add_argument("table")
ap.add_argument("--verbose", action="store_true")
ap.add_argument("--no-theorems", action="store_true",
                help="dispatch nothing by theorem; every branch goes to the search")
a = ap.parse_args()
fb.set_use_theorems(not a.no_theorems)
if a.no_theorems:
    print("--no-theorems: every s-branch goes to the search; E.1, E.3(ii), "
          "E.3(iii), E.4,\n               Lemma E.2's bound and the MERSENNE / "
          "REPUNIT3 tables are all unused.\n")

rows = list(csv.DictReader(open(a.table)))
NMAX = max(int(r["n"]) for r in rows)
A = fb.Arith(NMAX + 2)
caps_m, caps_r = fb.cap_mersenne(A, NMAX), fb.cap_repunit(A, NMAX)

PP = [c for c in range(2, NMAX + 1) if A.prime_power(c)]

def candidates(n, B, skip):
    out = []
    for c in PP:
        if c + 2 > n:
            break
        p, _ = A.prime_power(c)
        for r in A.prime_divisors(c - 1):
            if r == p or not A.is_prime(r):
                continue
            out += fb.pair_candidates(A, n, B, c, r, p, skip_settled=skip)
            if out and not a.verbose:
                return out
    return out

bad, fully, branch_tot, branch_ok, reasons = [], 0, 0, 0, {}
# Regime census over the foreign parts that pass the gate.  The three regimes
# behave differently and the residue should be read as three named things rather
# than one count -- see arithmetic-of-density.md section 3.5.6.  e = 1 is linear
# in q and q-pinning is total there; e >= 2 has a density-zero supply of
# admissible foreign blocks; q = 2 is exponential and pinning is vacuous.
# O(rows * primes) on data already computed, so it costs nothing measurable.
regime = {"e=1": 0, "e>=2": 0, "q=2": 0}
for row in rows:
    n, B = int(row["n"]), int(row["mu_bound"])
    full, sm, per = fb.theorem_report(A, n, B, caps_m, caps_r)
    fully += full
    for s, (ok, why) in per.items():
        branch_tot += 1; branch_ok += ok
        if not ok:
            reasons[why] = reasons.get(why, 0) + 1
    for rr in range(3, n, 2):
        if not A.is_prime(rr):
            continue
        for qq in set(A.prime_divisors(rr - 1)):
            tt = fb.qpart(rr - 1, qq)
            if fb.orb(rr, tt) < B:
                continue
            ee = 0
            x = tt
            while x % qq == 0:
                x //= qq; ee += 1
            if qq == 2:
                regime["q=2"] += 1
            elif ee == 1:
                regime["e=1"] += 1
            else:
                regime["e>=2"] += 1
    skip = {s for s, (ok, _) in per.items() if ok}
    w = candidates(n, B, skip)
    if w:
        bad.append((n, B, float(row["density"]), w[:4]))

N = len(rows)
print(f"{a.table}: {N} values of n checked, n up to {NMAX}")
print(f"values where SOME fallback configuration could reach B(n): {len(bad)}")
for n, B, d, w in bad[:20]:
    print(f"   n={n} B={B} density={d:.4f}  candidates: {w}")
print()
print(f"settled by theorem alone, all branches: {fully} of {N} ({100*fully/N:.1f}%)")
print(f"s-branches dispatched by theorem: {branch_ok} of {branch_tot} "
      f"({100*branch_ok/branch_tot:.1f}%) -- the rest go to the search")
if a.no_theorems and branch_ok:
    sys.exit("INTERNAL ERROR: --no-theorems was set but branches were dispatched")
for why, k in sorted(reasons.items(), key=lambda t: -t[1]):
    print(f"    {k:5d}  {why}")
print()
tot_reg = sum(regime.values()) or 1
print("foreign parts passing the gate, by regime (aod section 3.5.6):")
print(f"    {regime['e=1']:6d}  e = 1      linear in q; q-pinning total here")
print(f"    {regime['e>=2']:6d}  e >= 2     supply of admissible r is density zero in n")
print(f"    {regime['q=2']:6d}  q = 2      exponential; q-pinning vacuous (Fermat branch)")
print(f"    e = 1 share {100*regime['e=1']/tot_reg:.1f}% -- if this ever falls, the "
      f"per-shape route narrows and the residue is mostly the hard branches")
print()
print(f"largest permitted s over the range: "
      f"{max(fb.s_max(int(r['n']), int(r['mu_bound'])) for r in rows)}")
if not bad:
    print()
    print("CERTIFIED.  At every n in this table, no admissible configuration that")
    print("invokes the unconditional fallback can attain B(n).  So the SAFE optimum")
    print("is fallback-free independently of tie-breaking, the Part E construction")
    print("realises it, and mu(n) = B(n) is proved at each of these n.")
    if a.no_theorems:
        print()
        print("AND IT RESTS ONLY ON THE EIGHT NECESSARY CONDITIONS.  No Part E-prime")
        print("theorem was consulted: every s-branch was searched and e3ii_resolves")
        print("resolved nothing.  The theorems explain why the search is cheap and are")
        print("what any statement about ALL n must go through, but they carry no weight")
        print("in the per-n proof above.")
    else:
        print()
        print("Rerun with --no-theorems to shrink the trusted base to the eight")
        print("necessary conditions alone.  Cheap, and worth redoing on every table")
        print("extension rather than citing a previous session for it.")
sys.exit(1 if bad else 0)
