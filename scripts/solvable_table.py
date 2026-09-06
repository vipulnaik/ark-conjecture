#!/usr/bin/env python3
"""
solvable_table.py -- compute B_solv(n) once, to a CSV.

WHY THIS IS A SEPARATE FILE.  `solvable_relaxation.py` used to compute B_solv
for every n and then run its twenty-two checks in the same process, so every
rerun of a check paid for the whole computation: 79 s at N = 85,000, ~3 h at
N = 10^6, because the scan is ~O(n) per value and ~O(N^2) overall.  That is the
same split `mu_exact.py` / `validate_table_v3.py` already draws on the Oliver
side, and for the same reason -- **the expensive thing is a value, the cheap
thing is a question about the values, and questions get asked far more often.**

THE SCORING CORE LIVES HERE AND NOWHERE ELSE.  `solvable_relaxation.py` imports
`build` and `best` from this file rather than carrying its own copy; a second
implementation of a score is exactly the arrangement that lets two artefacts
disagree silently, and this project has had that happen.

THE SHAPE SPACE (section 2 of `solvable-relaxation.md`).  An orbit of size s is
a transitive solvable group; to maximise its minimum orbital it is F blocks of
prime-power size c with s = F*c, each carrying AGL(1,c), the blocks permuted
transitively.  The within-block class always binds, so

    score(s) = max over prime-power c | s of (s/c)*C(c,2) = s*(P(s)-1)/2,

with P(s) the largest prime-power divisor.  Between orbits of sizes s_i, s_j
every cross pair is one class of exactly s_i*s_j.  Hence

    B_solv(n) = max over partitions n = s_1 + ... + s_k of
                min( min_i score(s_i), min_{i<j} s_i*s_j ).

USAGE.  Flags mirror `mu_exact.py` and `mu_ladder_exact.py`, so the three are
interchangeable at the command line and the output is read by the same tools.

    python3 solvable_table.py --nmax 1000000 --out solvable_table.csv
    # ... reissue the SAME command after an interruption; it resumes
    for i in $(seq 1 8); do
        python3 solvable_table.py --nmax 1000000 --out s.csv --chunks $i/8 &
    done
    head -1 s.csv.part1 > s.csv && \
        for i in $(seq 1 8); do tail -n +2 s.csv.part$i; done >> s.csv

    python3 solvable_table.py 1000 1100        # quick lookup to stdout

CHUNKING splits at nmax*(j/N)^(1/2), matching `mu_ladder_exact.py`, because the
cost per n is ~linear here too.  Each chunk builds its own sieve to nmax and is
independent.
"""
import argparse
import bisect
import csv
import os
import sys
import time
from math import comb, isqrt


def build(N):
    """Sieve to N and return (PPL, P, SCORE, is_prime_power, best).

    Everything the score needs, built once.  Returned as a tuple rather than
    stored in globals so that a caller can hold two ranges at once and so that
    `solvable_relaxation.py` cannot accidentally read a half-built table.
    """
    # ---- prime powers, and P(s) = largest prime-power divisor -------------------
    sieve = bytearray([1]) * (N + 1)
    sieve[0] = sieve[1] = 0
    for i in range(2, isqrt(N) + 1):
        if sieve[i]:
            sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
    pps = set()
    for p in [x for x in range(2, N + 1) if sieve[x]]:
        v = p
        while v <= N:
            pps.add(v)
            v *= p
    P = [0] * (N + 1)
    for c in sorted(pps):
        for s in range(c, N + 1, c):
            if c > P[s]:
                P[s] = c
    SCORE = [0] * (N + 1)
    for s in range(2, N + 1):
        SCORE[s] = s * (max(P[s], 1) - 1) // 2


    PPL = sorted(pps)


    def best(n, allow_three=False):
        """B_solv(n) and an optimal partition.

        THE TWO-PART SCAN IS CANDIDATE-ENUMERATED, NOT A SWEEP, and the reason is
        arithmetic rather than engineering.  The old form looped a over 2..n/2, so
        the whole run was O(N^2): 126 s over a 50k-row table and ~20 min over a 144k
        one -- the same quadratic shape `validate_table_v3.py`'s gap scan had.

        A part only matters if SCORE[a] = a*(P(a)-1)/2 exceeds the running best, and
        writing a = m*P(a) that is a*a/m > 2*bv up to O(a).  With bv near its true
        value -- delta_solv >= 0.12 in range -- this forces m <= 2 or 3: **the
        admissible a are the prime powers and small multiples of them**, not an
        interval.  So we enumerate a = m*c over prime powers c, m ascending, and
        stop at the first m whose whole family is excluded by a*a <= 2*m*bv.  That
        is an exact restatement of "SCORE[a] > bv", not a heuristic: every a the
        sweep would have accepted is generated.

        Pass 1 takes m = 1 first precisely so bv is near-optimal before pass 2 sizes
        its own bound -- the same ordering lesson as `mu_ladder_exact.py`'s scan,
        where the prune is only as strong as the best-so-far.

        Measured 5x, and verified equal to the sweep at every n in [6, 4000) and on
        400 values near 50,000."""
        bv, bp = SCORE[n], (n,)

        def try_a(a):
            nonlocal bv, bp
            sa = SCORE[a]
            if sa <= bv:
                return
            sb = SCORE[n - a]
            if sb <= bv:
                return
            v = sa if sa < sb else sb
            p = a * (n - a)
            if p < v:
                v = p
            if v > bv:
                bv, bp = v, (a, n - a)

        if not allow_three:
            lo = 2
            while lo * (lo - 1) // 2 <= bv:      # SCORE[a] <= C(a,2) bounds a below
                lo += 1
            for i in range(bisect.bisect_left(PPL, lo),
                           bisect.bisect_right(PPL, n // 2)):
                try_a(PPL[i])
            m = 2
            while True:
                amax = n // 2
                if amax * amax <= 2 * m * bv:    # the whole m-family is excluded
                    break
                amin = isqrt(2 * m * bv) + 1
                i0 = bisect.bisect_left(PPL, max(2, -(-amin // m)))
                i1 = bisect.bisect_right(PPL, amax // m)
                for i in range(i0, i1):
                    try_a(m * PPL[i])
                m += 1
            return bv, bp
        for a in range(2, n // 2 + 1):
            v = min(SCORE[a], SCORE[n - a], a * (n - a))
            if v > bv:
                bv, bp = v, (a, n - a)
        if allow_three:
            for a in range(2, n // 3 + 1):
                if SCORE[a] <= bv and a * (n - a) <= bv:
                    continue
                for b in range(a, (n - a) // 2 + 1):
                    c = n - a - b
                    v = min(SCORE[a], SCORE[b], SCORE[c], a * b, a * c, b * c)
                    if v > bv:
                        bv, bp = v, (a, b, c)
        return bv, bp
    return PPL, P, SCORE, pps, sieve, best


# ---------------------------------------------------------------- driver
HEADER = "n,C(n2),b_solv,density,parts,partition"


def hms(sec):
    sec = int(max(sec, 0)); h, r = divmod(sec, 3600); m, s = divmod(r, 60)
    return f"{h}:{m:02d}:{s:02d}" if h else f"{m}:{s:02d}"


def read_done(path):
    """(set of n already written, header-ok).  A partial final line left by a
    hard kill is TRUNCATED rather than skipped -- same semantics as
    `mu_exact.py`'s, so the two resume identically."""
    if not (os.path.exists(path) and os.path.getsize(path) > 0):
        return set(), True
    ncol = len(HEADER.split(","))
    with open(path, "rb") as fh:
        raw = fh.read()
    text = raw.decode("utf-8", "replace")
    done, good_end, pos = set(), 0, 0
    for i, line in enumerate(text.splitlines(keepends=True)):
        nbytes = len(line.encode("utf-8", "replace"))
        stripped = line.rstrip("\r\n")
        if i == 0:
            if stripped.lstrip("\ufeff") != HEADER:
                return set(), False
            good_end = pos + nbytes
        elif line.endswith("\n"):
            f = stripped.split(",")
            if len(f) >= ncol and f[0].isdigit():
                done.add(int(f[0]))
                good_end = pos + nbytes
        pos += nbytes
    if good_end < len(raw):
        with open(path, "r+b") as fh:
            fh.truncate(good_end)
    return done, True


def run(nmax, out, start=6, done=frozenset(), append=False, quiet=False, every=20000):
    PPL, P, SCORE, pps, sieve, best = build(nmax)
    todo = [n for n in range(start, nmax + 1) if n not in pps]
    if not todo:
        if not quiet:
            print(f"{out}: nothing to do in [{start}, {nmax}]")
        return
    # WORK, NOT COUNT.  The scan's cost grows with n, so a count-based ETA
    # drifts low for the whole run -- wrong in the reassuring direction, which
    # is the one direction a "wait or optimise?" figure must not be.
    total_work = float(sum(todo)); done_work = 0.0
    t0 = time.time(); last = t0; k = 0
    tag = os.path.basename(out)
    with open(out, "a" if append else "w", newline="") as fh:
        w = csv.writer(fh)
        if not append:
            w.writerow(HEADER.split(","))
            fh.flush()
        for n in todo:
            v, part = best(n)
            C2 = comb(n, 2)
            w.writerow([n, C2, v, f"{v / C2:.6f}", len(part),
                        " + ".join(str(x) for x in part)])
            k += 1; done_work += float(n)
            now = time.time()
            if not quiet and every and (k % every == 0 or now - last >= 30):
                fh.flush(); last = now
                el = now - t0
                frac = done_work / total_work if total_work else 1.0
                eta = el * (1 - frac) / frac if frac > 0 else 0.0
                print(f"{time.strftime('%H:%M:%S')}  {tag}: n = {n:,}, {k:,}/{len(todo):,} "
                      f"rows ({100 * frac:.1f}% of work), {k / el if el else 0:,.0f} rows/s, "
                      f"elapsed {hms(el)}, eta {hms(eta)}", file=sys.stderr, flush=True)
    if not quiet:
        print(f"{out}: wrote {len(todo)} rows, n in [{todo[0]}, {todo[-1]}]")


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--nmin", type=int)
    ap.add_argument("--nmax", type=int, default=10000)
    ap.add_argument("--out", default="solvable_table.csv")
    ap.add_argument("--fill-gaps", action="store_true")
    ap.add_argument("--quiet", action="store_true")
    ap.add_argument("--progress", type=int, default=20000, metavar="ROWS")
    ap.add_argument("--chunks", metavar="i/N")
    ap.add_argument("lo", type=int, nargs="?")
    ap.add_argument("hi", type=int, nargs="?")
    a = ap.parse_args()

    if a.lo is not None and a.hi is not None:
        PPL, P, SCORE, pps, sieve, best = build(a.hi + 1)
        print(HEADER)
        for n in range(a.lo, a.hi + 1):
            if n in pps:
                continue
            v, part = best(n)
            print(f"{n},{comb(n,2)},{v},{v/comb(n,2):.6f},{len(part)},"
                  f"{' + '.join(str(x) for x in part)}")
        return 0

    out, lo, hi = a.out, None, a.nmax
    if a.chunks:
        i, N = (int(x) for x in a.chunks.split("/"))
        if not 1 <= i <= N:
            print("--chunks i/N needs 1 <= i <= N"); return 2
        edge = lambda j: max(2, int(a.nmax * (j / N) ** 0.5))
        lo = edge(i - 1) + 1 if i > 1 else 6
        hi = edge(i) if i < N else a.nmax
        out = f"{a.out}.part{i}"
    done, ok = read_done(out)
    if not ok:
        print(f"refusing to append to {out}: its first line is not this version's "
              f"header\n    {HEADER}"); return 2
    resume = (max(done) + 1) if (done and not a.fill_gaps) else None
    start = a.nmin if a.nmin is not None else (resume or lo or 6)
    if done and not a.quiet:
        print(f"{out}: {len(done)} rows present; "
              + (f"rescanning from {start} for gaps" if a.fill_gaps
                 else f"resuming at n = {start}"))
    run(hi, out, start=start, done=done, append=bool(done), quiet=a.quiet,
        every=a.progress)
    if a.chunks and not a.quiet:
        print(f"  (chunk covers n in [{lo}, {hi}])")
    return 0


if __name__ == "__main__":
    sys.exit(main())
