#!/usr/bin/env python3
"""J0a' at p = 2, k = 3, the first open homogeneous case (general-k-note.md §1): c = 64,
V = F_8^2, K = F_8^* scalars (or 1), H = K.Q with Q a 3-subgroup of GammaL(2, 8).

Builds a Sylow 3-subgroup P of GammaL(2, 8) (order 27), takes every subgroup Q of P,
with and without the scalars, keeps the irreducible ones (over F_2), tests semilinearity
(normalising a Singer cycle C_63) and computes the least 3-orbit of V x| H against
AGammaL(1, 64)'s 1344."""
import itertools
from itertools import combinations
from collections import Counter
def m8(a, b):
    r = 0
    for i in range(3):
        if b >> i & 1: r ^= a << i
    for i in (4, 3):
        if r >> i & 1: r ^= 0b1011 << (i - 3)
    return r
F = range(8)
inv8 = {a: next(b for b in F if m8(a, b) == 1) for a in range(1, 8)}
pts = [(x, y) for x in F for y in F]; ix = {v: i for i, v in enumerate(pts)}
def lin(M):   # M = (a, b, c, d): (x, y) -> (ax + by, cx + dy)
    a, b, c, d = M
    return tuple(ix[(m8(a, x) ^ m8(b, y), m8(c, x) ^ m8(d, y))] for x, y in pts)
phi = tuple(ix[(m8(x, x), m8(y, y))] for x, y in pts)
I = tuple(range(64))
def mul(a, b): return tuple(a[i] for i in b)
def order(g):
    k, x = 1, g
    while x != I: x = mul(g, x); k += 1
    return k
def close(gens):
    S = {I}; fr = [I]
    while fr:
        nf = []
        for x in fr:
            for g in gens:
                y = mul(g, x)
                if y not in S: S.add(y); nf.append(y)
        fr = nf
    return frozenset(S)
GL = [lin(M) for M in itertools.product(F, repeat=4) if m8(M[0], M[3]) ^ m8(M[1], M[2])]
o9 = [g for g in GL if order(g) == 9]
P = None
for g in o9:
    H = close([g, phi])
    if len(H) == 27: P = H; break
assert P, "no Sylow 3 found"
subsP = {close([a, b]) for a in P for b in P}
scal = [lin((s, 0, 0, s)) for s in range(1, 8)]
zs = next(z for z in scal if order(z) == 7)
singers = {close([g]) for g in GL if order(g) == 63}
def inv(g):
    h = [0]*64
    for i, j in enumerate(g): h[j] = i
    return tuple(h)
def semilinear(H, gens):
    return any(all(mul(mul(g, x), inv(g)) in S for g in gens for x in S) for S in singers)
def xorv(i, j):
    (a, b), (c, d) = pts[i], pts[j]; return ix[(a ^ c, b ^ d)]
def irreducible(H):
    for v in range(1, 64):
        span = {0}
        for w in {A[v] for A in H}:
            span |= {xorv(u, w) for u in span}
        if len(span) < 64: return False
    return True
def min3(H):
    trans = [tuple(xorv(i, t) for i in range(64)) for t in range(64)]
    gens = list(H)[:0] + [trans[1], trans[2], trans[4], trans[8], trans[16], trans[32]] + list(H)
    sets = list(combinations(range(64), 3)); idx = {s: i for i, s in enumerate(sets)}
    par = list(range(len(sets)))
    def find(x):
        while par[x] != x: par[x] = par[par[x]]; x = par[x]
        return x
    for i, s in enumerate(sets):
        for g in gens:
            a, b = find(i), find(idx[tuple(sorted(g[v] for v in s))])
            if a != b: par[a] = b
    return min(Counter(find(i) for i in range(len(sets))).values())
seen = set()
for Q in subsP:
    for withK in (False, True):
        gens = list(Q) + ([zs] if withK else [])
        H = close(gens)
        if H in seen: continue
        seen.add(H)
        if not irreducible(H): continue
        semi = semilinear(H, gens)
        print(f"|H| = {len(H)}, scalars {withK}, semilinear {semi}, least 3-orbit {min3(H)}  (AGammaL(1,64): 1344)")
