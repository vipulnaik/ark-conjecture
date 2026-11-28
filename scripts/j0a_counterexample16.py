#!/usr/bin/env python3
"""A reducible (hence imprimitive) block beating AGammaL(1, 16) at k = 3: not a counterexample to J0a', which concerns primitive blocks -- it is the fused class 2 x 8 (general-k-note.md §1).

V = F_2 + F_8 (16 points, (t, x)), H = AGammaL(1, 8) acting linearly by
    (t, x) -> (t, a*sigma(x) + b*t),   a in F_8^*, b in F_8, sigma a power of Frobenius.
H fixes the subspace t = 0, so it is reducible and not semilinear; |H| = 168.  The block
group V x| H is Oliver: the 2-group V.(b-part) is normal, then C_7, then C_3.
Its least orbit on 3-sets is 112, against 80 for AGammaL(1, 16)."""
from itertools import combinations
from collections import Counter
def m8(a, b):
    r = 0
    for i in range(3):
        if b >> i & 1: r ^= a << i
    for i in (4, 3):
        if r >> i & 1: r ^= 0b1011 << (i - 3)
    return r
def m16(a, b):
    r = 0
    for i in range(4):
        if b >> i & 1: r ^= a << i
    for i in (6, 5, 4):
        if r >> i & 1: r ^= 0b10011 << (i - 4)
    return r
def orbits3(N, gens):
    sets = list(combinations(range(N), 3)); idx = {s: i for i, s in enumerate(sets)}
    par = list(range(len(sets)))
    def find(x):
        while par[x] != x: par[x] = par[par[x]]; x = par[x]
        return x
    for i, s in enumerate(sets):
        for g in gens:
            a, b = find(i), find(idx[tuple(sorted(g[v] for v in s))])
            if a != b: par[a] = b
    return sorted(Counter(find(i) for i in range(len(sets))).values())
# points (t, x) -> index 8*t + x ; translations of V, and H's generators
P = lambda t, x: 8 * t + x
pts = [(t, x) for t in range(2) for x in range(8)]
def g(f): return [P(*f(t, x)) for t, x in pts]
gens = [g(lambda t, x: (t ^ 1, x)), g(lambda t, x: (t, x ^ 1)), g(lambda t, x: (t, x ^ 2)), g(lambda t, x: (t, x ^ 4)),
        g(lambda t, x: (t, m8(2, x))),                 # a = generator of F_8^*
        g(lambda t, x: (t, x ^ t)),                    # b = 1 (x -> x + t)
        g(lambda t, x: (t, m8(x, x)))]                 # Frobenius
o = orbits3(16, gens)
print("V x| AGammaL(1,8) on F_2+F_8: least 3-orbit", o[0], "orbit sizes", o)
gl = [list(range(16))]
gens16 = [[x ^ 1 for x in range(16)], [m16(2, x) for x in range(16)], [m16(x, x) for x in range(16)]]
print("AGammaL(1,16): least 3-orbit", orbits3(16, gens16)[0])
