"""bcp_floor_checks.py -- independent re-check of the elementary claims of notes/bcp-to-floor.md.
  (1) closed form delta(k,d) = (sqrt k + sqrt(d/2))^-2 = cap_k(2/d), against a grid search of the corrected objective
  (2) the Local Lemma: which (k,d) cover which n, at prime powers 16 and 9 and every prime 5 <= l < 200,
      and the per-class optimum over a wider grid (k in 1..12, even d <= 24)
  (3) orbitals: AGL-type group (F_p^k : <g>) x (C_r : C_Q) on kp + r points, entangled g, by direct orbit enumeration
Usage: python3 bcp_floor_checks.py"""
import math, itertools
from sympy import isprime, primitive_root
def delta(k, d): return 1 / (math.sqrt(k) + math.sqrt(d / 2)) ** 2
def cap(F, eta): return eta / (1 + math.sqrt(F * eta)) ** 2
# (1)
print("(1) closed form vs cap_k(2/d) vs grid search")
for k, d in [(1,2),(1,6),(2,2),(2,4),(2,6),(2,12),(4,6),(6,4),(12,2)]:
    N = 1500; best = 0
    for i in range(1, N):
        u = i / N
        for j in range(1, N):
            a = j / N
            if a > 1 - u: break
            v = min(u*u/k, 2*a*u, 2*a*a/d)
            if v > best: best, bu = v, u
    print(f"  (k,d)=({k},{d}) closed {delta(k,d):.5f} cap {cap(k,2/d):.5f} grid {best:.5f} u* {math.sqrt(k)/(math.sqrt(k)+math.sqrt(d/2)):.4f} grid-u {bu:.4f}")
# (2)
def units(m): return [x for x in range(m) if math.gcd(x, m) == 1]
def covered(k, d, m):
    U = units(m); R = {(d*q + 1) % m for q in U if math.gcd(d*q + 1, m) == 1}
    return {(k*p + r) % m for p in U for r in R}
primes = [l for l in range(5, 200) if isprime(l)]
print("(2) Local Lemma: classes n mod 12 covered (via mod 16 and mod 9), and failures at primes 5..199")
grid = [(k, d) for k in range(1, 13) for d in range(2, 25, 2)]
cov = {}
for k, d in grid:
    c16, c9 = covered(k, d, 16), covered(k, d, 9)
    # dependence only on n mod 4 / mod 3?
    dep4 = all(((x in c16) == (y in c16)) for x in range(16) for y in range(16) if x % 4 == y % 4)
    dep3 = all(((x in c9) == (y in c9)) for x in range(9) for y in range(9) if x % 3 == y % 3)
    badl = [l for l in primes if len(covered(k, d, l)) < l]
    cov[(k, d)] = {n for n in range(12) if (n % 16 in c16 or any(x % 4 == n % 4 and x in c16 for x in range(16))) and any(x % 3 == n % 3 and x in c9 for x in range(9))}
    if not (dep4 and dep3): print(f"  (k,d)=({k},{d}): solvability depends on more than n mod 4 / mod 3 (dep4={dep4}, dep3={dep3})")
    if badl and k <= 4 and d % 12 in (2, 4, 6, 0) and 12 % d == 0: print(f"  (k,d)=({k},{d}) fails at primes {badl}")
note = {0:(1,2),4:(1,2),6:(1,2),10:(1,2),1:(2,2),9:(2,2),2:(1,6),8:(1,6),3:(2,4),7:(2,4),5:(2,6),11:(4,6)}
for n in range(12):
    opts = sorted(((delta(k, d), k, d) for (k, d) in grid if n in cov[(k, d)] and k in (1, 2, 4) and 12 % d == 0), reverse=True)
    wide = sorted(((delta(k, d), k, d) for (k, d) in grid if n in cov[(k, d)] and not any(l for l in primes if len(covered(k, d, l)) < l)), reverse=True)
    print(f"  n={n:2d}: best in note's grid {opts[0][1:]} {opts[0][0]:.4f} (note: {note[n]}); runner-up {opts[1][1:]} {opts[1][0]:.4f}; best over k<=12, even d<=24: {wide[0][1:]} {wide[0][0]:.4f}")
# (3)
def orbitals(perms, npts):
    seen = set(); sizes = []
    for a in range(npts):
        for b in range(a + 1, npts):
            if (a, b) in seen: continue
            orb = {(a, b)}; fr = [(a, b)]
            while fr:
                x, y = fr.pop()
                for g in perms:
                    e = tuple(sorted((g[x], g[y])))
                    if e not in orb: orb.add(e); fr.append(e)
            seen |= orb; sizes.append(len(orb))
    return sorted(sizes)
print("(3) orbitals of (F_p^k : <g>) x (C_r : C_Q), entangled g")
for p, k, r, Q in [(5,2,13,3),(7,2,13,3),(5,3,11,5),(5,4,13,3),(7,4,31,5),(5,4,13,4),(11,1,7,3)]:
    z = primitive_root(p); pts = [((i, v), None) for i in range(k) for v in range(p)] + [(None, j) for j in range(r)]
    idx = {x: i for i, x in enumerate(pts)}
    def P(f): return [idx[f(x)] for x in pts]
    gens = []
    for j in range(k):   # translation of block j (the p-group F_p^k acts blockwise)
        gens.append(P(lambda x, j=j: (((x[0][0], (x[0][1] + (x[0][0] == j)) % p)), None) if x[1] is None else x))
    # entangled generator: block i -> block i+1, last block -> block 0 multiplied by a primitive root
    gens.append(P(lambda x: (((x[0][0] + 1, x[0][1]) if x[0][0] < k - 1 else (0, z * x[0][1] % p)), None) if x[1] is None else x))
    gens.append(P(lambda x: x if x[1] is None else (None, (x[1] + 1) % r)))
    w = next(a for a in range(2, r) if pow(a, Q, r) == 1)                                      # element of order Q in F_r^x
    gens.append(P(lambda x: x if x[1] is None else (None, x[1] * w % r)))
    s = orbitals(gens, len(pts))
    pred = {"kC(p,2)": k*p*(p-1)//2, "cross-block": ("p^2" if k == 2 else "2p^2 (antipodal)" if k == 4 else "-"), "kpr": k*p*r, "rQ": r*Q if Q % 2 else r*Q//2}
    print(f"  p={p} k={k} r={r} Q={Q}: min orbital {s[0]}, distinct sizes {sorted(set(s))}; predicted terms {pred}")
