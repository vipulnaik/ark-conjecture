#!/usr/bin/env python3
"""
rung_split.py -- resolve section 3.9.2's outcome table by FUSION LAYER.

The table there was taken by asking whether the winning configuration fuses its
two c-blocks.  That conflates two different shapes:

    S7 at F = 2   swap in the CYCLIC layer.  Fmid = 2, so the twist is cut to
                  the odd part of c-1 and the gain follows the c mod 8 law.
                  The top prime q is free, so the foreign efficiency is free.
    S5            swap in the TOP layer.  Forces q = 2, so Fmid = 1 and the
                  twist is full -- 2*C(c,2) for every odd prime power c -- but
                  the foreign twist is the 2-part of r-1, i.e. eta = 1/u.

They obey different laws and only the first is a party to the 3.9 prediction,
so the columns have to be separated before the observed split can be compared
against it.  This script recomputes the same band with four outcomes.

For n = 2c + r with c a prime power and r prime, the three readings score:

    S4   min( C(c,2),          c*c,  orb(r, t) over ANY q,  c*r  )
    S7   min( 2*orb(c, odd(c-1)),  2*c*c,  orb(r, t) over ODD q,  2*c*r )
    S5   min( 2*C(c,2),          c*c,  orb(r, t) at q = 2,      2*c*r )

The within-class cross term is F*c^2 for odd q and (F/2)*c^2 for q = 2, which
is why S7 carries 2*c*c and S5 carries c*c.

The c/n window is each residue's own balance point plus or minus 0.05, which is
count_check.py's convention.  Use --flat LO,HI to compare against a single
window shared by every residue; the two do not agree, and the per-residue one is
the measurement the section 3.9 prediction is about, since that prediction is
a statement about configurations AT the class ceiling.

Usage:
    python3 rung_split.py --nmin 200000 --nmax 206000
    python3 rung_split.py --nmin 200000 --nmax 206000 --flat 0.10,0.42
"""
import argparse, sys
from math import comb

ap = argparse.ArgumentParser()
ap.add_argument("--nmin", type=int, default=200_000)
ap.add_argument("--nmax", type=int, default=206_000)
ap.add_argument("--window", type=float, default=0.05,
                help="half-width of the c/n window around the residue's own balance "
                     "point, matching count_check.py's convention")
ap.add_argument("--flat", default=None,
                help="LO,HI to override with a single window for every n (diagnostic)")
A = ap.parse_args()

N = A.nmax
sieve = bytearray([1]) * (N + 1)
sieve[0] = sieve[1] = 0
for i in range(2, int(N ** 0.5) + 1):
    if sieve[i]:
        sieve[i * i::i] = bytearray(len(sieve[i * i::i]))

base = [0] * (N + 1)          # base prime of a prime power, else 0
for p in range(2, N + 1):
    if sieve[p]:
        v = p
        while v <= N:
            base[v] = p
            v *= p
PPs = [x for x in range(2, N + 1) if base[x]]
print(f"sieved to {N:,}", file=sys.stderr)


def orb(c, t, char2):
    raw = c * t // 2 if (char2 or t % 2 == 0) else c * t
    return min(raw, comb(c, 2))


def oddpart(x):
    while x % 2 == 0:
        x //= 2
    return x


# For each prime r, the best foreign intra-orbital under three regimes for q.
ORB_ANY = [0] * (N + 1)       # q unconstrained          -> S4
ORB_ODD = [0] * (N + 1)       # q odd                    -> S7 at F = 2
ORB_TWO = [0] * (N + 1)       # q = 2                    -> S5
for r in range(3, N + 1):
    if not sieve[r]:
        continue
    m = r - 1
    t2 = 1
    while m % 2 == 0:
        m //= 2
        t2 *= 2
    ORB_TWO[r] = orb(r, t2, False)
    best_odd, u, d = 0, m, 3
    while d * d <= u:                     # largest prime-power divisor of odd part
        if u % d == 0:
            t = 1
            while u % d == 0:
                u //= d
                t *= d
            best_odd = max(best_odd, orb(r, t, False))
        d += 2
    if u > 1:
        best_odd = max(best_odd, orb(r, u, False))
    ORB_ODD[r] = best_odd
    ORB_ANY[r] = max(ORB_TWO[r], best_odd)

# Each residue's balance point x*, from the ceiling table of section 3.3.  The
# window is x* +- 0.05, which is count_check.py's convention: a CONSTANT RELATIVE
# half-width around the point the class's own cap is derived at, not a fixed
# interval shared across residues.  A flat window covers regions that cannot
# reach the ceiling at some residues and clips the balance point at others.
R2, R3, R6 = 2 ** 0.5, 3 ** 0.5, 6 ** 0.5
XSTAR = {}
for a in (1, 9, 13, 21, 7, 15):
    XSTAR[a] = (2 - R2) / 2                  # 0.29289
for a in (3, 19):
    XSTAR[a] = 0.25
for a in (5, 17, 23):
    XSTAR[a] = (R6 - 2) / 2                  # 0.22474
XSTAR[11] = (R3 - 1) / 4                     # 0.18301

FLAT = None
if A.flat:
    FLAT = tuple(float(x) for x in A.flat.split(","))

import bisect
counts = {}
member = {a: {} for a in range(24)}
for a in range(24):
    counts[a] = {"S4": 0, "S7": 0, "S5": 0, "tie": 0, "none": 0}
detail = {"S5_r": {}}

for n in range(A.nmin | 1, A.nmax + 1, 2):
    if base[n]:
        continue                                  # prime powers are S1
    if FLAT:
        wlo, whi = FLAT
    else:
        x = XSTAR[n % 24]
        wlo, whi = x - A.window, x + A.window
    lo = bisect.bisect_left(PPs, int(wlo * n))
    hi = bisect.bisect_right(PPs, int(whi * n))
    best, who, bestr = 0, None, None
    for k in range(lo, hi):
        c = PPs[k]
        r = n - 2 * c
        if r < 3 or not sieve[r]:
            continue
        if base[c] == r or (c - 1) % r == 0:      # Lemma C / distinctness
            continue
        ch2 = base[c] == 2
        v4 = min(comb(c, 2), c * c, ORB_ANY[r], c * r)
        v7 = min(2 * orb(c, oddpart(c - 1), ch2), 2 * c * c, ORB_ODD[r], 2 * c * r)
        v5 = min(2 * comb(c, 2), c * c, ORB_TWO[r], 2 * c * r)
        for v, tag in ((v4, "S4"), (v7, "S7"), (v5, "S5")):
            if v > best:
                best, who, bestr = v, {tag}, r
            elif v == best and v > 0:
                who.add(tag)
                if tag == "S5":
                    bestr = r
    a = n % 24
    for tg in (who or ()):
        member[a][tg] = member[a].get(tg, 0) + 1
    if not who:
        counts[a]["none"] += 1
    elif len(who) > 1:
        counts[a]["tie"] += 1
    else:
        tag = next(iter(who))
        counts[a][tag] += 1
        if tag == "S5":
            detail["S5_r"][bestr] = detail["S5_r"].get(bestr, 0) + 1

groups = [("1,3,5,9,11,13,17,19,21", [1, 3, 5, 9, 11, 13, 17, 19, 21]),
          ("7", [7]), ("15", [15]), ("23", [23])]
print(f"{'n mod 24':>22} {'S7@F=2':>8} {'S4':>7} {'S5':>7} {'tie':>7} {'N':>6}")
tot = {"S4": 0, "S7": 0, "S5": 0, "tie": 0}
for label, res in groups:
    c = {k: sum(counts[a][k] for a in res) for k in ("S4", "S7", "S5", "tie")}
    m = sum(c.values())
    for k in tot:
        tot[k] += c[k]
    if m:
        print(f"{label:>22} {c['S7']/m:>7.1%} {c['S4']/m:>6.1%} "
              f"{c['S5']/m:>6.1%} {c['tie']/m:>6.1%} {m:>6}")
m = sum(tot.values())
print(f"{'all odd n':>22} {tot['S7']/m:>7.1%} {tot['S4']/m:>6.1%} "
      f"{tot['S5']/m:>6.1%} {tot['tie']/m:>6.1%} {m:>6}")
print()
print("HOW OFTEN EACH READING IS IN THE ARGMAX SET (wins outright or ties):")
for label, res in groups:
    mm = {k: sum(member[a].get(k,0) for a in res) for k in ("S4","S7","S5")}
    tt = sum(counts[a][k] for a in res for k in ("S4","S7","S5","tie"))
    print(f"   {label:>22}  S7 {mm['S7']/tt:>6.1%}  S4 {mm['S4']/tt:>6.1%}  S5 {mm['S5']/tt:>6.1%}   of {tt}")
print()
print("foreign primes used by the S5 winners (r = 2^a*u + 1):")
for r, k in sorted(detail["S5_r"].items(), key=lambda t: -t[1])[:12]:
    print(f"   r = {r:>7}  u = {oddpart(r-1):>5}  wins {k}")
