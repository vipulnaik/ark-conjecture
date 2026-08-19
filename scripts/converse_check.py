#!/usr/bin/env python3
"""
converse_check.py -- re-run the numerical checks behind Proposition F.4
(`enumeration-proof.md` Part F; discussion in `arithmetic-of-density.md` §6.7).

F.4 says a density floor FORCES a shifted-prime statement.  Its proof turns on
each part of a winning configuration having to clear delta*C(n,2) on its own,
and yields three inequalities that any winner must satisfy:

  (1) foreign parts:  (r-1)/Q <= 2/delta,  Q the largest prime-power divisor
                      of r-1.  This is the statement's content: r-1 carries a
                      prime-power divisor of BOUNDED COFACTOR.
  (2) foreign parts:  r >= delta*n.  The prime is linear in n.
  (3) all-matching:   n = M*p^b with M <= 1/delta, p^b a prime power.  This is
                      the branch that makes the exceptional set density zero
                      and so licenses the "almost all" in the statement.

WHAT THIS SCRIPT DOES AND DOES NOT ESTABLISH.  It tests the INEQUALITIES, not
the DERIVATION.  A wrong constant, or the unjustified layer assignment flagged
as `pending-checks.md` T8, would still produce inequalities that hold here,
because the table's winners satisfy the true statement whatever the proof says.
A PASS is therefore consistency, not confirmation; a FAIL is decisive.

Two derived numbers are reported because they are quoted in the documents and
will move as the table extends:

  * MAX COFACTOR: the largest (r-1)/Q occurring anywhere.  At the v4 frontier
    this is 12 -- (H)'s own d <= 12, recovered from the opposite direction.
    Quoted in `ep` F.4 and `aod` 6.7.  If it moves, both want editing, and a
    value above 12 would weaken the claim that (H)'s constant is the natural one.
  * SLACK: max cofactor against the bound 2/floor.  Quoted as "loose by a
    factor ~4"; it is the size of the sharpening question in the gap inventory.

Usage:
    python3 converse_check.py mu_table_safe_v4.csv
    python3 converse_check.py TABLE.csv --nmax 5000       # widen the range
    python3 converse_check.py TABLE.csv --delta0 0.04     # one global floor
    python3 converse_check.py TABLE.csv --verbose         # list every violation

By default each row is checked against ITS OWN density, which is the sharpest
form.  --delta0 instead checks every row against one floor, which is what the
Proposition is actually stated with, and is the mode to use when asking "does a
conjectured floor of 1/25 survive the data".

Exit status 1 if any inequality fails.
"""

import argparse
import csv
import re
import sys

from fb_common import Arith

# Foreign primes are starred in the witness column: "p=277 q=2: 1x619* + 4x139".
FOREIGN = re.compile(r"(\d+)\*")


def load(path, nmax, contiguous_only=True, frontier=None, gap=10):
    """Rows up to nmax.  The contiguous prefix is the default because the
    worklist rows above it are a deliberately low-density subsample, and
    mixing them into an aggregate misreports every share.

    The frontier is detected as the first gap wider than `gap`.  Ten is the
    right threshold and not an arbitrary one: the table skips prime powers, so
    consecutive entries are already a few apart inside the contiguous range,
    while the jump to the worklist is much larger -- at the v4 table the first
    gap above 10 is exactly 2600 -> 2627, reproducing the documented 2,186
    rows.  A threshold of 60 silently swallows four worklist rows and reports
    2,190, which is how this was found.  Pass --frontier to pin it instead."""
    rows = []
    with open(path) as fh:
        for r in csv.DictReader(fh):
            n = int(r["n"])
            if nmax and n > nmax:
                continue
            rows.append({"n": n, "delta": float(r["density"]),
                         "parts": int(r["parts"]), "witness": r["witness"],
                         "B": int(r["mu_bound"])})
    rows.sort(key=lambda r: r["n"])
    if frontier:
        rows = [r for r in rows if r["n"] <= frontier]
    elif contiguous_only and rows:
        cut = None
        for a, b in zip(rows, rows[1:]):
            if b["n"] - a["n"] > gap:
                cut = a["n"]
                break
        if cut is not None:
            rows = [r for r in rows if r["n"] <= cut]
    return rows


def check(rows, ar, delta0=None, verbose=False):
    res = {"foreign": 0, "onepart": 0,
           "v1": [], "v2": [], "v3": [],
           "max_cofactor": (0, None),
           "tight1": (0.0, None), "tight2": (9e9, None), "tight3": (0.0, None)}

    for row in rows:
        n, d = row["n"], (delta0 if delta0 else row["delta"])
        if d <= 0:
            continue

        # (1) and (2): every starred prime in the witness
        for m in FOREIGN.finditer(row["witness"]):
            r = int(m.group(1))
            if not ar.is_prime(r):
                continue                      # not a foreign prime; skip
            res["foreign"] += 1
            Q = ar.largest_pp_divisor(r - 1)
            cof = (r - 1) / Q
            bound1 = 2 / d
            if cof > bound1:
                res["v1"].append((n, r, Q, round(cof, 2), round(bound1, 2)))
            if cof / bound1 > res["tight1"][0]:
                res["tight1"] = (cof / bound1, (n, r, Q))
            if cof > res["max_cofactor"][0]:
                res["max_cofactor"] = (cof, (n, r, Q))

            if r < d * n:
                res["v2"].append((n, r, round(d * n, 1)))
            if r / (d * n) < res["tight2"][0]:
                res["tight2"] = (r / (d * n), (n, r))

        # (3): the all-matching branch, identified by a single part
        if row["parts"] == 1:
            res["onepart"] += 1
            pb = ar.largest_pp_divisor(n)
            M = n // pb
            if M > 1 / d:
                res["v3"].append((n, pb, M, round(1 / d, 2)))
            if M * d > res["tight3"][0]:
                res["tight3"] = (M * d, (n, pb, M))

    return res


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("table")
    ap.add_argument("--nmax", type=int, default=0, help="cap n (0 = no cap)")
    ap.add_argument("--delta0", type=float, default=None,
                    help="check every row against ONE floor instead of its own density")
    ap.add_argument("--all-rows", action="store_true",
                    help="include worklist rows past the contiguous frontier")
    ap.add_argument("--frontier", type=int, default=None,
                    help="pin the contiguous frontier instead of detecting it")
    ap.add_argument("--gap", type=int, default=10,
                    help="gap width that marks the frontier (default 10)")
    ap.add_argument("--verbose", action="store_true", help="list every violation")
    A = ap.parse_args()

    rows = load(A.table, A.nmax, contiguous_only=not A.all_rows,
                frontier=A.frontier, gap=A.gap)
    if not rows:
        print("no rows loaded"); return 2
    nmax = max(r["n"] for r in rows)
    ar = Arith(nmax + 2)
    floor = min(r["delta"] for r in rows)

    mode = f"global floor delta0 = {A.delta0}" if A.delta0 else "each row against its own density"
    print(f"{A.table}: {len(rows)} rows, n <= {nmax}"
          f"{'' if A.all_rows else ' (contiguous prefix)'}")
    print(f"observed floor {floor:.6f} at n = "
          f"{min(rows, key=lambda r: r['delta'])['n']}")
    print(f"mode: {mode}\n")

    R = check(rows, ar, A.delta0, A.verbose)

    rowsfmt = "{:<52} {:>7} {:>11}"
    print(rowsfmt.format("inequality (F.4)", "checked", "violations"))
    print("-" * 72)
    print(rowsfmt.format("(1) (r-1)/Q <= 2/delta   [the statement's content]",
                         R["foreign"], len(R["v1"])))
    print(rowsfmt.format("(2) r >= delta*n         [prime is linear in n]",
                         R["foreign"], len(R["v2"])))
    print(rowsfmt.format("(3) M <= 1/delta, n=M*p^b [licenses 'almost all']",
                         R["onepart"], len(R["v3"])))
    print()

    if R["tight1"][1]:
        print(f"tightest (1): ratio/bound {R['tight1'][0]:.4f} at "
              f"n,r,Q = {R['tight1'][1]}")
    if R["tight2"][1]:
        print(f"tightest (2): r/(delta*n) {R['tight2'][0]:.3f} at n,r = {R['tight2'][1]}")
    if R["tight3"][1]:
        print(f"tightest (3): M/(1/delta) {R['tight3'][0]:.4f} at "
              f"n,p^b,M = {R['tight3'][1]}")
    print()

    mc, where = R["max_cofactor"]
    if where:
        print(f"MAX COFACTOR (r-1)/Q anywhere: {mc:.0f}  at n,r,Q = {where}")
        print(f"   compare (H)'s own d <= 12.  Quoted in `ep` F.4 and `aod` 6.7;")
        print(f"   edit both if this moves.")
        bound = 2 / (A.delta0 if A.delta0 else floor)
        print(f"SLACK: bound 2/floor = {bound:.0f} against {mc:.0f} used"
              f"  ->  loose by a factor {bound / mc:.1f}")
        print(f"   this is the size of the sharpening question"
              f" (`pending-checks.md` gap inventory).")

    if A.verbose:
        for key, label in (("v1", "(1)"), ("v2", "(2)"), ("v3", "(3)")):
            for v in R[key]:
                print(f"   VIOLATION {label}: {v}")

    bad = len(R["v1"]) + len(R["v2"]) + len(R["v3"])
    print()
    if bad:
        print(f"*** {bad} violation(s) -- F.4 is contradicted by the table. ***")
        print("Check the derivation before the data: a violation here means either")
        print("the Proposition is wrong or a constant in it is.")
    else:
        print("All inequalities hold.  NOTE: this is consistency, not confirmation.")
        print("The checks test the inequalities, not the derivation -- in particular")
        print("not the step (`pending-checks.md` T8) that the foreign twist Q must be")
        print("a prime power, without which F.4 is vacuous rather than false.")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
