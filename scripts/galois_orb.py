"""galois_orb.py -- pending-checks A28: the Galois layer's contribution to a stripped matching block.

For c = p^a (a >= 2), a cyclic twist of order d dividing D = strip(c-1, foreign primes), and a top prime q | a, the
block's stabiliser may also contain a non-split semilinear top element sigma = zeta^i * Frob^f, Frob^f of order
q^e = a/f.  In logarithms F_c^x = Z/(c-1):
    lambda = zeta^((c-1)/d) : e -> e + s,  s = (c-1)/d
    sigma                   : e -> p^f * e + i
    -1                      : e -> e + (c-1)/2        (p odd; -1 = 1 in characteristic 2)
sigma is admissible iff its q^e-th power lies in <lambda>, i.e. s | i*(c-1)/(p^f-1), so that the cyclic-layer image stays
of order d and the top quotient is C_{q^e}.
    orb(c, d)       = c * |+-<lambda>| / 2                         (the cyclic reading, what mu_enumerate scores)
    orb+(c, d, q)   = c * max over e, i of (min orbit of <lambda, sigma, -1> on Z/(c-1)) / 2
Prints every (c, stripped primes, d, q) with orb+ > orb, and summarises which d are affected.

Result (proved in enumeration-proof.md, Part E''' addendum): with the full stripped twist d = D the Galois layer never raises the
minimum orbit, and for every d | D, orb+(c, d, q) <= orb(c, D).  So B_refined+ = B_refined.  This script checks both
statements exhaustively to CMAX.

Usage: python3 galois_orb.py [CMAX=400]
"""
import sys, itertools
from math import comb
from sympy import factorint, primefactors, divisors

CMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 400


def min_orbit(N, gens):
    seen = [False] * N
    best = N
    for x in range(N):
        if seen[x]:
            continue
        orb = {x}
        fr = [x]
        while fr:
            y = fr.pop()
            for g in gens:
                z = g(y)
                if z not in orb:
                    orb.add(z)
                    fr.append(z)
        for z in orb:
            seen[z] = True
        best = min(best, len(orb))
    return best


rows = []
full_twist_gain = 0
for c in range(4, CMAX + 1):
    f = factorint(c)
    if len(f) != 1:
        continue
    (p, a), = f.items()
    if a < 2:
        continue
    N = c - 1
    P = primefactors(N)
    pm = [lambda y, h=N // 2: (y + h) % N] if p != 2 else []
    for k in range(len(P) + 1):
        for strip in itertools.combinations(P, k):
            D = N
            for r in strip:
                while D % r == 0:
                    D //= r
            for d in divisors(D):
                s = N // d
                lam = lambda y, s=s: (y + s) % N
                base = min_orbit(N, [lam] + pm)
                for q in primefactors(a):
                    if q in strip:
                        continue
                    best, wit = base, None
                    qe = q
                    while a % qe == 0:
                        pf = p ** (a // qe)
                        for i in range(N):
                            if (i * (N // (pf - 1))) % s:
                                continue
                            sig = lambda y, pf=pf, i=i: (pf * y + i) % N
                            m = min_orbit(N, [lam, sig] + pm)
                            if m > best:
                                best, wit = m, (qe, i)
                        qe *= q
                    if best > base:
                        rows.append((c, strip, D, d, q, base, best, wit))
                        if d == D:
                            full_twist_gain += 1

print(f"c = p^a <= {CMAX}, a >= 2: cases where a non-split semilinear top element raises the minimum intra-orbit")
for c, strip, D, d, q, base, m, w in rows:
    print(f"  c={c:4d} stripped {list(strip)!s:10s} D={D:4d} twist d={d:4d} q={q}: orb {c*base//2:7d} -> orb+ {c*m//2:7d}"
          f"  (x{m // base}; Frob order {w[0]}, sigma = zeta^{w[1]} Frob)")
print(f"{len(rows)} cases; with the full stripped twist d = D: {full_twist_gain}")
beat = []
for c, strip, D, d, q, base, m, w in rows:
    p = list(factorint(c))[0]
    full = min(c * (D if (p == 2 or D % 2 == 0) else 2 * D) // 2, comb(c, 2))
    if c * m // 2 > full:
        beat.append((c, strip, d, q))
print(f"cases where orb+(c, d) exceeds the full stripped twist's cyclic orb(c, D): {len(beat)} {beat[:5]}")
