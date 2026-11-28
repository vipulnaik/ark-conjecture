"""Exact least 3-orbit of the n = 182 witness 2x32 + 2x59* (q = 29) in three-uniform-note.md §4.2: 1984.
Chain: 2-group (F_32^2 and the swap of the 32-blocks), cyclic layer (C31 twist, diagonal C59
translations, swap of the 59-blocks), top C29 (diagonal 59-twist)."""
from itertools import combinations
from collections import Counter
def gfmul(a, b):
    r = 0
    for i in range(5):
        if b >> i & 1: r ^= a << i
    for i in range(9, 4, -1):
        if r >> i & 1: r ^= 0b100101 << (i - 5)
    return r
N = 182
def pt(p):
    if p < 64: return ('m',) + divmod(p, 32)
    return ('f',) + divmod(p - 64, 59)
def ix(t):
    return t[1] * 32 + t[2] if t[0] == 'm' else 64 + t[1] * 59 + t[2]
def g(f): return [ix(f(pt(p))) for p in range(N)]
w = next(x for x in range(2, 59) if pow(x, 29, 59) == 1)
gens = [g(lambda t: ('m', t[1], t[2] ^ 1) if t[0] == 'm' and t[1] == 0 else t),
        g(lambda t: ('m', t[1], t[2] ^ 1) if t[0] == 'm' and t[1] == 1 else t),
        g(lambda t: ('m', 1 - t[1], t[2]) if t[0] == 'm' else t),
        g(lambda t: ('m', t[1], gfmul(2, t[2])) if t[0] == 'm' else t),
        g(lambda t: ('f', t[1], (t[2] + 1) % 59) if t[0] == 'f' else t),
        g(lambda t: ('f', 1 - t[1], t[2]) if t[0] == 'f' else t),
        g(lambda t: ('f', t[1], (w * t[2]) % 59) if t[0] == 'f' else t)]
sets = list(combinations(range(N), 3)); idx = {s: i for i, s in enumerate(sets)}
par = list(range(len(sets)))
def find(x):
    while par[x] != x: par[x] = par[par[x]]; x = par[x]
    return x
for i, s in enumerate(sets):
    for gg in gens:
        a, b = find(i), find(idx[tuple(sorted(gg[v] for v in s))])
        if a != b: par[a] = b
c = Counter(find(i) for i in range(len(sets)))
print("least 3-orbit", min(c.values()), "orbits", len(c))
