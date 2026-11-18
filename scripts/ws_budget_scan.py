#!/usr/bin/env python3
"""ws_budget_scan.py -- the prime+prime gap configurations of ws_gapclose.py WITH the budget.

m*_N(Gamma) is the least B at which some N*-invariant complex on Gamma's orbitals, every face of total size
<= B, meets Gamma's condition (section 3).  A configuration separates mu*_N^fpf from mu*_cyc at n when no
complex with every face <= T = mu*_cyc(n) meets the condition.  ws_gapclose.py ignored the budget.

Classes: a prime block p with twist of order d has k = (p-1)/c classes, c = d (d even) or 2d, each of
w = p c / 2 edges; the cross orbital has a b edges > T.  Families tried, each face checked against T:
layered complexes pulled back from C_m (m | k; a face has at most s k/m classes), one side, a disjoint
union, or a join (face sizes add).  What fails here goes to the exact CP-SAT check (ws_budget_exact.py).
usage: python3 ws_budget_scan.py  -> ../outputs/ws_budget_scan.txt"""
import csv, sys
from math import comb, gcd
from functools import reduce, lru_cache
from sympy import isprime, factorint, divisors, mobius
L = {int(r['n']): int(r['L_new']) for r in csv.DictReader(open('../outputs/mu_cyc_bounds_4000.csv'))}
rows = [int(l.split()[0]) for l in open('../outputs/fpf_upper_scan.txt') if l[0].isdigit()]
def cls(p, d):
    c = d if d % 2 == 0 else 2 * d
    return (p - 1) // c, p * c // 2
def readings(A, dA, B, dB):
    exact = False; R = set()
    for (pX, dX, pY, dY) in ((A, dA, B, dB), (B, dB, A, dA)):
        fY = factorint(dY)
        if len(fY) > 1: continue
        if gcd(dX, pY) != 1:
            if dY == 1: R.add(pY)
            continue
        if dY == 1: exact = True
        else: R |= set(fY)
    return exact, R
@lru_cache(maxsize=None)
def orbit_counts(m, s):
    g = gcd(m, s); out = {}
    for e in divisors(g):
        f = sum(mobius(e2 // e) * comb(m // e2, s // e2) for e2 in divisors(g) if e2 % e == 0)
        if f: out[m // e] = f // (m // e)
    return tuple(sorted(out.items()))
@lru_cache(maxsize=None)
def families(k, cap):
    """[(base, sign, orbit counts, facemax_full, facemax_empty)] for layered complexes on k classes, at most
    cap classes per face"""
    out = []
    for m in divisors(k):
        if m < 2: continue
        f = k // m
        for s in range(1, min(m, 7)):
            if (s - 1) * f > cap: break
            base = 1 - (-1) ** (s - 1) * comb(m - 1, s - 1); sg = (-1) ** (s - 1)
            oc = orbit_counts(m, s) if s * f <= cap else ()      # s-sets allowed only if they fit
            out.append((base, sg, oc))
    return out
@lru_cache(maxsize=None)
def fam_mod(k, cap, Q):
    """per layered family: (g, reach mod g, base, sign); chi = base + sign t, t in reach + g Z (mod Q)"""
    out = [(Q, frozenset({0}), 0, 1)]          # the empty complex
    for base, sg, oc in families(k, cap):
        g = Q
        for d, c in oc:
            if c >= Q // gcd(d, Q): g = gcd(g, d)
        reach = {0}
        for d, c in oc:
            if g == 1: break
            for _ in range(min(c, g)):
                new = {(x + d) % g for x in reach}
                if new <= reach: break
                reach |= new
        out.append((g, frozenset(reach), base, sg))
    return out
@lru_cache(maxsize=None)
def exact_values(k, cap, lim=4000):
    out = {0}
    for base, sg, oc in families(k, cap):
        bits = 1; tot = 0
        for d, c in oc:
            for _ in range(min(c, lim // d + 1)): bits |= bits << d
            bits &= (1 << (lim + 1)) - 1
        t = 0
        while bits:
            if bits & 1: out.add(base + sg * t)
            bits >>= 1; t += 1
    return frozenset(out)
@lru_cache(maxsize=None)
def quick_values(k, cap):
    """skeleta of quotients within the cap: all sets of <= j points of Z_m, pulled back (j k/m <= cap)"""
    out = {0}
    for m in divisors(k):
        if m < 2: continue
        f = k // m
        for j in range(1, m):
            if j * f > cap: break
            out.add(1 + (-1) ** (j - 1) * comb(m - 1, j))
    return frozenset(out)
def closes(kA, cA, kB, cB, exact, R):
    QA, QB = quick_values(kA, cA), quick_values(kB, cB)
    if exact:
        if 1 in QA or 1 in QB or any(1 - x in QB for x in QA): return True
    else:
        Q0 = reduce(lambda u, v: u * v, R, 1)
        if any((x - 1) % Q0 == 0 for x in QA | QB) or any((x + y - 1) % Q0 == 0 for x in QA for y in QB): return True
    return slow_closes(kA, cA, kB, cB, exact, R)
def reach_t(oc, t):
    """is t a sum of orbit sizes, each size d used at most c_d times?"""
    if t < 0 or t > sum(d * c for d, c in oc): return False
    small = [(d, c) for d, c in oc]
    bits = 1
    for d, c in small:
        for _ in range(min(c, t // d + 1)): bits |= bits << d
        bits &= (1 << (t + 1)) - 1
    return bool(bits >> t & 1)
def exact_hit(k, cap, target):
    if target == 0: return True
    for base, sg, oc in families(k, cap):
        t = (target - base) * sg
        if t == 0 or (oc and t <= 2_000_000 and reach_t(oc, t)): return True
    return False
@lru_cache(maxsize=None)
def split_chi1(k, cap):
    """cyc_chi_one_construct.py's shape, budget-checked: coprime k = a b, skeleta X on Z_a (all sets of <= ja points)
    and Y on Z_b pulled back, (1 - x)(1 - y) = 0 mod k, so chi = 1 + c k; faces at most max(ja k/a, jb k/b) classes,
    the correction orbits (minimal non-faces, |S| <= 8) must also fit.  Heuristic here; survivors are checked by hand."""
    f = factorint(k)
    if len(f) < 2: return False
    ps = list(f)
    import itertools
    for r in range(1, len(ps)):
        for Aset in itertools.combinations(ps, r):
            a = 1
            for p in Aset: a *= p ** f[p]
            b = k // a
            if cap < 8: continue
            XA = exact_values(a, min(cap // b, a - 1)) if cap // b >= 1 else frozenset({0})
            XB = exact_values(b, min(cap // a, b - 1)) if cap // a >= 1 else frozenset({0})
            for x in XA:
                for y in XB:
                    if ((1 - x) * (1 - y)) % k == 0: return True
    return False
def slow_closes(kA, cA, kB, cB, exact, R):
    if exact:
        if exact_hit(kA, cA, 1) or exact_hit(kB, cB, 1): return True
        if split_chi1(kA, cA) or split_chi1(kB, cB): return True
        VB = exact_values(kB, cB)
        if any(exact_hit(kA, cA, 1 - y) for y in VB): return True
        VA, VB = exact_values(kA, cA), exact_values(kB, cB)
        return 1 in VA or 1 in VB or any(1 - x in VB for x in VA)
    Q = reduce(lambda u, v: u * v, R, 1)
    FA, FB = fam_mod(kA, cA, Q), fam_mod(kB, cB, Q)
    for g, reach, base, sg in FA + FB:
        if ((1 - base) * sg) % g in reach: return True
    for gA, rA, bA, sA in FA:
        for gB, rB, bB, sB in FB:
            G = gcd(gA, gB)
            SA = {(sA * t) % G for t in rA}; SB = {(sB * t) % G for t in rB}
            if any((1 - bA - bB - x) % G in SB for x in SA): return True
    return False
    # joins need face-size sums; tried in the exact check
def one_row(n):
    open_cfg = []; ncfg = 0
    if True:
        T = L[n]
        for a in range(3, n // 2 + 1):
            b = n - a
            if b <= a or not (isprime(a) and isprime(b)) or min(comb(a, 2), comb(b, 2)) <= T: continue
            for dA in divisors(a - 1):
                kA, wA = cls(a, dA)
                for dB in divisors(b - 1):
                    kB, wB = cls(b, dB)
                    if kA == 1 and kB == 1: continue
                    ex, R = readings(a, dA, b, dB)
                    if not ex and not R: continue
                    ncfg += 1
                    cA, cB = min(T // wA, kA - 1), min(T // wB, kB - 1)
                    if not closes(kA, cA, kB, cB, ex, R):
                        open_cfg.append((n, T, a, dA, kA, wA, cA, b, dB, kB, wB, cB, ex, sorted(R)))
    return ncfg, open_cfg
if __name__ == "__main__":
    from multiprocessing import Pool
    open_cfg = []; ncfg = 0
    with Pool(int(sys.argv[1]) if len(sys.argv) > 1 else 4) as P:
        for c, o in P.imap(one_row, rows, chunksize=4):
            ncfg += c; open_cfg += o
    with open('../outputs/ws_budget_scan.txt', 'w') as f:
        f.write(f"prime+prime configurations with a reading {ncfg}; not closed within budget by the families {len(open_cfg)}; rows {len({c[0] for c in open_cfg})}\n")
        f.write("(n, T, a, dA, kA, wA, capA, b, dB, kB, wB, capB, exact, R)\n")
        for c in open_cfg: f.write(f"{c}\n")
    print(open('../outputs/ws_budget_scan.txt').read()[:3000])
