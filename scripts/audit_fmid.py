#!/usr/bin/env python3
"""Does any configuration with two fused classes whose BLOCK COUNTS share a
prime score above B(n) anywhere in the table?

WHY THE QUESTION EXISTS.  The enumerator does not require the block counts of
two fused classes to be coprime, because no argument makes that a necessary
condition: a block-permutation image is a QUOTIENT of the cyclic layer rather
than a subgroup of it, so two classes' rotations need not compete for orders
there, and a diagonal cyclic-layer rotation realises the shared reading.  This
script is the empirical half of that: it checks that admitting such
configurations changes no value in range.

WHAT IT DOES AND DOES NOT COVER.  It screens F-vs-F shares between two (or
three) FUSED classes, and nothing else.  The other two ways a block count could
have mattered are covered by argument rather than by this script, and should not
be cited to it:
  * F_mid versus another class's twist -- Part E carries every p-characteristic
    twist diagonally on one cyclic generator, so distinct classes need no
    coprimality between twists, nor between a twist and a rotation;
  * F_mid versus a foreign prime r -- covered by counting: a foreign block
    matters only if orb(r, .) >= B, forcing r >= sqrt(2B), and r | F_mid then
    makes the class size F*c >= r*c overrun n.

SCORING IS DELIBERATELY OPTIMISTIC (every matching part at F*C(c,2), the foreign
part at its best efficiency over all q): if even the optimistic score never
exceeds B(n), no exact reading can either.  Being optimistic on the candidate
side and comparing against a recorded B(n) that is itself a valid score means
both directions of the comparison are safe.

SCOPE CUTS, stated rather than buried.  Only rows with delta <= 0.13 are
screened (two fused classes need sum sqrt(F) >= 2*sqrt(2), so delta <= 1/8, plus
slack for the optimistic scoring), and F is capped at FMAX below.  Both are
bounds on where such a configuration could possibly win, not on where one could
exist.
"""
import csv
from math import comb, gcd, isqrt

N = 2700
sieve = bytearray([1]) * (N + 1)
sieve[0] = sieve[1] = 0
for i in range(2, isqrt(N) + 1):
    if sieve[i]:
        sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
ispp = bytearray(N + 1)
base = [0] * (N + 1)
for p in range(2, N + 1):
    if sieve[p]:
        q = p
        while q <= N:
            ispp[q] = 1
            base[q] = p
            q *= p
PP = [c for c in range(2, N + 1) if ispp[c]]

# best foreign efficiency over any top prime (same rule as ladder_verify EFF)
EFF = [0.0] * (N + 1)
for r in range(3, N + 1, 2):
    if not sieve[r]:
        continue
    m = r - 1
    a, x = 0, m
    while x % 2 == 0:
        x //= 2; a += 1
    best, y, d = 1, x, 3
    while d * d <= y:
        if y % d == 0:
            e = 1
            while y % d == 0:
                y //= d; e += 1
            best = max(best, d ** (e - 1))
        d += 2
    if y > 1:
        best = max(best, y)
    EFF[r] = max((2 ** a) / m, 2 * best / m)

rows = []
for r in csv.DictReader(open('/mnt/user-data/uploads/mu_table_safe_v4.csv')):
    n = int(r['n'])
    if n <= 2600:
        rows.append((n, int(r['mu_bound'])))

def coeff(F):
    return F if F % 2 else F // 2

FMAX = 25          # scope cut: see the module docstring
hits = []
checked = 0
for n, B in rows:
    C2 = comb(n, 2)
    delta = B / C2
    # two fused classes need sum sqrt(F) >= 2*sqrt2, feasible only if
    # delta <= 1/8; add slack for the optimistic scoring
    if delta > 0.130:
        continue
    checked += 1
    # candidate fused parts: (F, c) with F >= 2, F*C(c,2) >= B, coeff*c^2 >= B
    parts = []
    for F in range(2, FMAX + 1):
        cf = coeff(F)
        for c in PP:
            s = F * c
            if s > n - 2:
                break
            if F * comb(c, 2) < B or cf * c * c < B:
                continue
            parts.append((F, c, s))
    parts.sort(key=lambda t: t[2])
    for i in range(len(parts)):
        F1, c1, s1 = parts[i]
        for j in range(i, len(parts)):
            F2, c2, s2 = parts[j]
            if base[c1] != base[c2]:
                continue                     # both classes must be p-characteristic
            if gcd(F1, F2) == 1:
                continue                     # never rejected: not our delta
            if s1 * s2 < B:
                continue
            rem = n - s1 - s2
            if rem < 0:
                break
            v0 = min(F1 * comb(c1, 2), F2 * comb(c2, 2),
                     coeff(F1) * c1 * c1, coeff(F2) * c2 * c2, s1 * s2)
            if rem == 0:                     # k = 2, both fused
                if v0 > B:
                    hits.append((n, B, v0, (F1, c1), (F2, c2), None))
            elif rem >= 3 and sieve[rem]:    # k = 3, foreign prime
                r = rem
                # NOTE: r is NOT tested against the home prime here.  A foreign
                # part must have a prime different from p = base[c1] = base[c2],
                # so r == base[c1] would be inadmissible -- but admitting it is
                # PERMISSIVE for a hit-screen (it can only add candidates, never
                # remove one), which is the safe direction for this script.
                v = min(v0, s1 * r, s2 * r, EFF[r] * comb(r, 2))
                if v > B:
                    hits.append((n, B, v, (F1, c1), (F2, c2), r))
    # three fused classes sharing a prime pairwise or partially: only feasible
    # at delta <= 1/(3 sqrt2)^2 = 0.0555
    if delta <= 0.062:
        for i in range(len(parts)):
            F1, c1, s1 = parts[i]
            for j in range(i, len(parts)):
                F2, c2, s2 = parts[j]
                if s1 + s2 + 4 > n:
                    break
                for k in range(j, len(parts)):
                    F3, c3, s3 = parts[k]
                    if s1 + s2 + s3 > n:
                        break
                    if s1 + s2 + s3 != n:
                        continue
                    if not (base[c1] == base[c2] == base[c3]):
                        continue
                    if gcd(F1, F2) == 1 and gcd(F1, F3) == 1 and gcd(F2, F3) == 1:
                        continue
                    v = min(F1 * comb(c1, 2), F2 * comb(c2, 2), F3 * comb(c3, 2),
                            coeff(F1) * c1 * c1, coeff(F2) * c2 * c2,
                            coeff(F3) * c3 * c3, s1 * s2, s1 * s3, s2 * s3)
                    if v > B:
                        hits.append((n, B, v, (F1, c1), (F2, c2), (F3, c3)))

print(f"rows with delta <= 0.13 screened: {checked} of {len(rows)}")
print(f"shared-Fmid configurations with optimistic score > B(n): {len(hits)}")
for h in hits[:30]:
    print("  ", h)
