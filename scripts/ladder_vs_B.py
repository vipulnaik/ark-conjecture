#!/usr/bin/env python3
"""
ladder_vs_B.py -- compare `ladder_verify.py`'s per-n lower bound against B(n) at
EVERY tabulated n, and characterise every shortfall.

WHY THIS EXISTS, AND WHY IT IS NOT `validate_table_v3.py --ladder`.  That check
joins the table against the ladder's WORKLIST, and the worklist holds only the n
whose ladder score falls below the asymptotic ceiling -- i.e. it is selected by
LOW score.  A place where the ladder is loose is therefore systematically likely
to sit OUTSIDE the join, and the tightness check keeps passing while the ladder
understates elsewhere.  That is exactly what happened: with the scan window's
right end at 0.55 the ladder fell short of B at 274 of 32,861 tabulated values,
by up to 1.835x, and the worklist-joined check reported tight at 619 of 619
throughout.  This file joins on EVERY row instead, which is the whole point of
it; it is slower for the same reason and is not part of the routine battery.

WHAT A SHORTFALL DOES AND DOES NOT MEAN.  The ladder is a max over four families
scanned over a window, so it is a LOWER bound on delta(n) by construction: a
shortfall costs sharpness and never validity, and every floor the ladder has ever
reported stays valid.  What a shortfall does threaten is any statement that reads
the ladder as if it were B -- decade minima, worklist membership, "which n are
worth an exact B".  An OVER-score is the dangerous direction and would break
ladder <= B_refined, hence Corollary E.6; the run reports the two separately for
that reason, and a nonzero over count is a hard failure.

Exits nonzero if any row is over-scored, or (with --strict) if any row is short.

USAGE
    python3 ladder_vs_B.py mu_table_exact.csv
    python3 ladder_vs_B.py mu_table_exact.csv --ladder ../ladder_verify.py
    python3 ladder_vs_B.py mu_table_exact.csv --hi-x 0.55   # reproduce the defect
    python3 ladder_vs_B.py mu_table_exact.csv --strict      # fail on any shortfall

Cost is one full ladder scan per row with no early return -- about 2 ms per value
at n ~ 3*10^4, so a few minutes over a 30,000-row table.  Run it after any change
to the scan window, to a family's scoring, or to `orb`.
"""
import argparse
import builtins
import collections
import csv
import importlib.util
import os
import re
import sys
from math import comb

ap = argparse.ArgumentParser()
ap.add_argument("table", help="a mu_table CSV (mu_exact.py / mu_enumerate_v3.py schema)")
ap.add_argument("--ladder", default=None,
                help="path to ladder_verify.py (default: alongside this file, "
                     "then the working directory)")
ap.add_argument("--hi-x", type=float, default=None,
                help="override the ladder's scan window right end; use 0.55 to "
                     "reproduce the pre-2026-09 defect")
ap.add_argument("--lo-x", type=float, default=None, help="likewise the left end")
ap.add_argument("--worst", type=int, default=15, help="how many shortfalls to list")
ap.add_argument("--strict", action="store_true",
                help="exit nonzero on any shortfall, not only on an over-score")
A = ap.parse_args()


def find_ladder():
    if A.ladder:
        return A.ladder
    here = os.path.dirname(os.path.abspath(__file__))
    for cand in (os.path.join(here, "ladder_verify.py"), "ladder_verify.py"):
        if os.path.exists(cand):
            return cand
    sys.exit("ladder_verify.py not found; pass --ladder PATH")


rows = list(csv.DictReader(open(A.table)))
if not rows:
    sys.exit(f"{A.table}: no rows")
NMAX = max(int(r["n"]) for r in rows)

# ladder_verify.py reads its range off sys.argv and prints a report at import;
# both are suppressed here so it can be used as a library.
path = find_ladder()
saved_argv = sys.argv
sys.argv = ["ladder_verify.py", str(NMAX + 1000)]
spec = importlib.util.spec_from_file_location("lv", path)
lv = importlib.util.module_from_spec(spec)
real_print = builtins.print
builtins.print = lambda *a, **k: None
try:
    spec.loader.exec_module(lv)
except SystemExit:                    # the module ends with its own report
    pass
finally:
    builtins.print = real_print
    sys.argv = saved_argv

if A.lo_x is not None:
    lv.LO_X = A.lo_x
if A.hi_x is not None:
    lv.HI_X = A.hi_x

print(f"{A.table}: {len(rows)} rows, n up to {NMAX}")
print(f"ladder: {path}   window [{lv.LO_X}, {lv.HI_X}]\n")

short, over, exact = [], [], 0
for r in rows:
    n, B = int(r["n"]), int(r["mu_bound"])
    lad = lv.achieved(n, stop_at=None) * comb(n, 2)
    witness = r["witness"].split("(")[0].strip()
    if lad > B + 1e-6:
        over.append((n, lad, B, witness))
    elif lad < B - 1e-6:
        short.append((n, lad, B, B / max(lad, 1.0), witness))
    else:
        exact += 1

print(f"ladder equals B at {exact} of {len(rows)}; short at {len(short)}; "
      f"OVER at {len(over)}")

if over:
    print("\n*** OVER-SCORED -- this breaks ladder <= B_refined and hence "
          "Corollary E.6.  Not a sharpness issue.")
    for n, lad, B, w in over[:A.worst]:
        print(f"  n={n:7d} ladder={lad:12.1f} B={B:12d}  {w}")


def shape(w):
    ps = re.findall(r"(\d+)x(\d+)(\*?)", w)
    return "+".join(f"{f}x{'r' if s else 'c'}" for f, c, s in ps)


if short:
    short.sort(key=lambda t: -t[3])
    print(f"\nworst {min(A.worst, len(short))} shortfalls by ratio B/ladder:")
    for n, lad, B, ratio, w in short[:A.worst]:
        print(f"  n={n:7d} ladder={lad:12.0f} B={B:12d} ratio={ratio:.3f}  {w}")
    print("\nby winning shape (c = matching class, r = foreign):")
    for sh, k in collections.Counter(shape(w) for *_, w in short).most_common(10):
        print(f"  {k:6d}  {sh}")
    print("\nby n mod 12:", dict(sorted(collections.Counter(n % 12 for n, *_ in short).items())))
    # The diagnostic that identified the window as the cause: where the winning
    # matching class sits relative to the scan window.
    xs = []
    for n, lad, B, ratio, w in short:
        ps = re.findall(r"(\d+)x(\d+)(\*?)", w)
        mat = [int(f) * int(c) for f, c, s in ps if not s]
        if len(mat) == 1:
            xs.append(mat[0] / n)
    if xs:
        outside = sum(1 for x in xs if x > lv.HI_X or x < lv.LO_X)
        print(f"\nwinning matching share c/n over the shortfalls: "
              f"min {min(xs):.3f}, max {max(xs):.3f}; "
              f"{outside} of {len(xs)} lie OUTSIDE the scan window "
              f"[{lv.LO_X}, {lv.HI_X}]")
        if outside == len(xs):
            print("  -- every shortfall is a window clip, not a missing family.")
else:
    print("\nno shortfall: the four ladder families contain a B-optimal "
          "configuration at every tabulated n.")

sys.exit(1 if (over or (A.strict and short)) else 0)
