#!/usr/bin/env python3
"""cyclic_chi_recursive.py -- certify chi = 1 on k points by the product construction,
with BOTH sides built recursively (session-log-17 Part 11).

NP[m] is a set of triples (x, y, f): there are C_m-invariant complexes A1 <= A2 on m
points with chi(A1) = x, chi(A2) = y, A1 proper, and f = (A2 is the full simplex).
Sources, each a theorem or an exhaustive computation:
  * exact: every nested pair on m <= 8 points (np.py-style enumeration, cached in
    ../outputs/cyclic_nested_pairs.pkl if present) -- here f = (y == 1), since no
    proper complex on m <= 11 points has chi = 1;
  * graph chains: vertices plus edge orbits, nested by adding orbits;
  * pull-back from every divisor d | m (inflation preserves chi and inclusion);
  * products: for a coprime split m = a*b, P(A1,B1) <= P(A2,B2) for pairs from NP[a],
    NP[b] -- chi multiplies, and the product is full only if both factors are;
  * "anything inside the full simplex": (x, 1, True) for every realisable proper x.
CERTIFY k: a coprime split k = a*b and (a1,a2,fa) in NP[a], (b1,b2,fb) in NP[b], not
both fa and fb, with (a2 - a1)(b2 - b1) = (a1 - 1)(b1 - 1).  The complex
P(A1, full) u P(full, B1) u P(A2, B2) then has chi = 1 (Part 10).
A certified k is BAD for a trivial top; so is every multiple (pull-back).

Values are capped at |v| <= CAP to keep the sets finite; the cap only loses
certificates, never creates a false one.

Usage: python3 cyclic_chi_recursive.py [KMAX=2000]     (run from scripts/)
"""
import sys, os, pickle
from math import gcd
from functools import lru_cache

KMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 2000
CAP = 1500
EXACT = {}
_pk = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'outputs', 'cyclic_nested_pairs.pkl')
if os.path.exists(_pk):
    EXACT = pickle.load(open(_pk, 'rb'))          # m -> set of (x, y)


def divisors(m):
    return [d for d in range(1, m + 1) if m % d == 0]


def graph_chain(m):
    if m < 3:
        return {(m, m, False)} | ({(m, 1, True)} if m > 1 else set())
    sizes = [m if 2 * d != m else m // 2 for d in range(1, m // 2 + 1)]
    pre = [0]
    for s in sizes:
        pre.append(pre[-1] + s)
    out = set()
    for i in range(len(pre)):
        for j in range(i, len(pre)):
            out.add((m - pre[i], m - pre[j], False))
        out.add((m - pre[i], 1, True))
    return out


def prime_skeleton_chain(p):
    """p prime >= 5: every orbit of nonempty proper faces is free (size p).  Adding all
    edge orbits, then triangle orbits, then tetrahedron orbits, one at a time, keeps a
    complex at every step; chi moves by -p, +p, -p.  Returns the nested pairs (with
    values within CAP) along that chain."""
    E, T, Q = (p - 1) // 2, (p - 1) * (p - 2) // 6, (p - 1) * (p - 2) * (p - 3) // 24
    vals = [p * (1 - s) for s in range(E + 1)]
    vals += [p * (1 - E + t) for t in range(1, T + 1)]
    vals += [p * (1 - E + T - u) for u in range(1, Q + 1)]
    pos = [v for v in vals if abs(v) <= CAP]
    out = set()
    for i in range(len(pos)):
        for j in range(i, len(pos)):
            out.add((pos[i], pos[j], False))
    return out


def skeleton_chain(m, maxdim):
    """Any m: add all edge orbits, then all triangle orbits, then (if maxdim >= 3)
    tetrahedron orbits, one orbit at a time; every prefix is a complex.  Orbit sizes
    are computed, so non-free orbits (m with small divisors) are handled."""
    from itertools import combinations
    def canon(f):
        return min(tuple(sorted((x + s) % m for x in f)) for s in range(m))
    vals = [m]; cur = m
    for dim in range(1, maxdim + 1):
        seen = {}
        for f in combinations(range(m), dim + 1):
            if f[0] != 0:
                break
            c = canon(f)
            if c not in seen:
                # orbit size = m / |stabiliser|
                st = sum(1 for s in range(m) if tuple(sorted((x + s) % m for x in c)) == c)
                seen[c] = m // st
        sign = -1 if dim % 2 else 1
        for c in sorted(seen):
            if len(c) == m:
                continue
            cur += sign * seen[c]; vals.append(cur)
    pos = [v for v in vals if abs(v) <= CAP]
    return {(pos[i], pos[j], False) for i in range(len(pos)) for j in range(i, len(pos))}


def is_prime(m):
    return m > 1 and all(m % d for d in range(2, int(m ** 0.5) + 1))


@lru_cache(maxsize=None)
def NP(m):
    if m == 1:
        return frozenset({(0, 0, False), (0, 1, True)})
    S = set()
    if m in EXACT:
        S |= {(x, y, y == 1) for x, y in EXACT[m]}
    S |= graph_chain(m)
    if is_prime(m) and m >= 5:
        S |= prime_skeleton_chain(m)
    elif 3 <= m <= 60:
        S |= skeleton_chain(m, 3 if m <= 40 else 2)
    for d in divisors(m):
        if 1 < d < m:
            S |= NP(d)
    for a in divisors(m):
        b = m // a
        if 1 < a < b and gcd(a, b) == 1:
            A, B = NP(a), NP(b)
            for (x1, y1, f1) in A:
                for (x2, y2, f2) in B:
                    lo, hi = x1 * x2, y1 * y2
                    if abs(lo) <= CAP and abs(hi) <= CAP:
                        S.add((lo, hi, f1 and f2))
    S = {t for t in S if abs(t[0]) <= CAP and abs(t[1]) <= CAP}
    xs = {x for x, _, _ in S} | {y for _, y, f in S if not f}
    S |= {(x, 1, True) for x in xs}
    return frozenset(S)


def certify(k):
    for a in divisors(k):
        b = k // a
        if not (1 < a < b and gcd(a, b) == 1):
            continue
        A, B = NP(a), NP(b)
        Bset = {}
        for (b1, b2, fb) in B:
            Bset.setdefault((b1, b2), set()).add(fb)
        b1s = {b1 for b1, _ in Bset}
        for (a1, a2, fa) in A:
            if a2 == a1:
                continue
            for b1 in b1s:
                num = (a1 - 1) * (b1 - 1)
                if num % (a2 - a1):
                    continue
                b2 = b1 + num // (a2 - a1)
                fbs = Bset.get((b1, b2))
                if fbs and (not fa or False in fbs):
                    return (a, b, a1, a2, b1, b2)
    return None


if __name__ == "__main__":
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import mu_cyc_bounds as M
    from sympy import primerange
    ks = sorted({(r - 1) // 2 for r in primerange(5, 2 * KMAX + 2) if M.status((r - 1) // 2, None) == M.UNK})
    cert, fail = [], []
    for k in ks:
        c = certify(k)
        (cert if c else fail).append((k, c))
    print(f"undecided k <= {KMAX} (trivial top): {len(ks)}; certified chi = 1: {len(cert)}; still open: {len(fail)}")
    print("certified:", [k for k, _ in cert])
    print("open:", [k for k, _ in fail])
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'outputs', 'cyclic_chi_certified.txt')
    with open(out, 'w') as fh:
        fh.write("# k, then the certificate (a, b, a1, a2, b1, b2): chi = 1 on k points by the product construction\n")
        for k, c in cert:
            fh.write(f"{k} {c}\n")
    print("written", out)
