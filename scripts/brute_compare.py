#!/usr/bin/env python3
"""
brute_compare.py -- compare the shipped enumerator against an independent naive
one, as a check on `mu_enumerate.py`'s PRUNING.

Why this and not just rerunning mu_enumerate.py: rerunning the shipped code
re-executes the same pruning, so it cannot detect a prune that is too aggressive.
`brute.py` was written separately from the Part 0 specification with no pruning,
no seed, and no precomputed part pool -- it enumerates (p, q) over all primes
plus the p=0 sentinel, then every multiset of admissible classes summing to n,
and scores each with the SAFE rule.  Agreement is therefore evidence about the
pruning rather than about the arithmetic.

BOTH were updated in 2026-08 for the corrected shape space, in which the block
count is F = Fmid * Ftop with Fmid supplied by the cyclic layer.  So point this
at the table the NEW enumerator produced; run against the old table it will
report a mismatch at roughly one n in seven, which is the defect, not a bug:

    naive HIGHER than table  ->  either the table predates the repair, or the
                                 shipped pruning discards a real configuration
    naive LOWER than table   ->  the naive enumerator is missing a shape

Cost is roughly |parts|^kmax per (p,q) pair, so it grows fast: n <= 120 is
seconds, n <= 260 is an overnight run.  Use --nmax to say how far.

Usage:
    python3 brute_compare.py mu_table_safe_v2.csv --nmax 260
    python3 brute_compare.py mu_table_safe_v2.csv --nmax 400 --kmax 3   # faster, weaker
    python3 brute_compare.py mu_table_safe_v2.csv --nmax 260 --resume runs/brute.jsonl
"""
import argparse, csv, json, os, signal, sys, time
from brute import B

ap = argparse.ArgumentParser()
ap.add_argument("table")
ap.add_argument("--nmax", type=int, default=120)
ap.add_argument("--nmin", type=int, default=6)
ap.add_argument("--nlist", default=None,
                help="comma-separated n to check instead of a range. The cost grows "
                     "like n^4.5, so a contiguous sweep stalls well below the values "
                     "that actually exercise the corrected shape space -- the first "
                     "S7 instance is n = 143 and the first S4 winner n = 247. A "
                     "targeted list reaches those for a fraction of the time.")
ap.add_argument("--kmax", type=int, default=4,
                help="max parts the naive enumerator considers (4 covers every "
                     "known winner shape; 3 is much faster and still meaningful)")
ap.add_argument("--resume", default=None,
                help="append-only JSONL of results; rerunning skips what is done")
ap.add_argument("--quiet", action="store_true")
A = ap.parse_args()

tbl = {}
for r in csv.DictReader(open(A.table)):
    tbl[int(r["n"])] = int(r["mu_bound"])

done = {}
if A.resume and os.path.exists(A.resume):
    for line in open(A.resume):
        d = json.loads(line)
        done[d["n"]] = d["brute"]
    print(f"resuming: {len(done)} values already checked")

if A.nlist:
    want = [int(x) for x in A.nlist.replace(",", " ").split()]
    missing = [n for n in want if n not in tbl]
    if missing:
        print(f"not in the table, skipping: {missing}")
    todo = [n for n in want if n in tbl and n not in done]
else:
    todo = [n for n in sorted(tbl) if A.nmin <= n <= A.nmax and n not in done]
where = f"from --nlist" if A.nlist else f"in [{A.nmin}, {A.nmax}]"
print(f"{len(todo)} value(s) to check {where} at kmax={A.kmax}"
      f"  (table has {len(tbl)} rows)")

# Long runs get interrupted.  Flush every result so --resume always has a
# complete prefix rather than whatever survived in a buffer.
fh = open(A.resume, "a") if A.resume else None
stop = {"now": False}
signal.signal(signal.SIGINT, lambda *a: stop.update(now=True))

mismatch, checked, t0 = [], 0, time.time()
for n in todo:
    if stop["now"]:
        print("\ninterrupted; progress saved" if fh else "\ninterrupted")
        break
    b = B(n, kmax=A.kmax)
    checked += 1
    if fh:
        fh.write(json.dumps({"n": n, "brute": b, "table": tbl[n]}) + "\n"); fh.flush()
    if b != tbl[n]:
        mismatch.append((n, tbl[n], b))
        print(f"  MISMATCH n={n}: table {tbl[n]}, naive {b}"
              f"  ({'naive HIGHER -- shipped pruning is too aggressive' if b > tbl[n] else 'naive LOWER -- naive enumerator is missing a shape'})")
    elif not A.quiet and checked % 20 == 0:
        print(f"  ... {checked}/{len(todo)}  n={n}  ({time.time()-t0:.0f}s)")

for n, want, got in ((n, v, done[n]) for n, v in tbl.items() if n in done):
    if want != got:
        mismatch.append((n, want, got))

print()
print(f"checked {checked} value(s) this run, {len(done)+checked} total, "
      f"in {time.time()-t0:.0f}s")
print(f"mismatches: {len(mismatch)}")
for m in mismatch:
    print(f"   n={m[0]} table={m[1]} naive={m[2]}")
if not mismatch and checked:
    print()
    print("AGREEMENT.  The shipped enumerator's pruning discards nothing that the")
    print("naive enumeration finds, over this range.  Note the direction that")
    print("matters: naive HIGHER than table would mean mu_enumerate.py prunes away")
    print("a real configuration, i.e. B(n) is too small and the upper bound fails.")
sys.exit(1 if mismatch else 0)
