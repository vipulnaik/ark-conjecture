#!/usr/bin/env python3
"""E.3(i)'s J0a residue at c = 27 (enumeration-proof.md, after J0a's (b)): every irreducible
H <= GL(3, 3) whose q'-generated subgroup has order <= 2 for some prime q != 13 (cyclic-layer
image <= C2, top prime q) has a +-H-orbit of size <= 2 on nonzero vectors, i.e. a pair orbital
of size <= 27.  Random sample of 2-generated subgroups."""
import random
from itertools import product
from math import gcd
p = 3
vecs = [v for v in product(range(3), repeat=3)]
vi = {v: i for i, v in enumerate(vecs)}
def perm(M):
    return tuple(vi[tuple(sum(M[r][k]*v[k] for k in range(3)) % 3 for r in range(3))] for v in vecs)
G = []
rows = list(product(range(3), repeat=3))
for M in product(rows, rows, rows):
    P = perm(M)
    if len(set(P)) == 27: G.append(P)
I = tuple(range(27)); NEG = perm(((2,0,0),(0,2,0),(0,0,2)))
def mul(a, b): return tuple(a[i] for i in b)
def order(a):
    k, x = 1, a
    while x != I: x = mul(a, x); k += 1
    return k
def close(gens, cap=3000):
    S = {I}; fr = [I]
    while fr:
        nf = []
        for x in fr:
            for g in gens:
                y = mul(g, x)
                if y not in S:
                    S.add(y); nf.append(y)
                    if len(S) > cap: return None
        fr = nf
    return frozenset(S)
add = {(i, j): vi[tuple((a + b) % 3 for a, b in zip(vecs[i], vecs[j]))] for i in range(27) for j in range(27)}
def irreducible(H):
    for v in range(1, 27):
        span = {0}
        for w in {A[v] for A in H}:
            new = set(span)
            for u in span:
                for k in (w, add[(w, w)]):
                    new.add(add[(u, k)])
            span = new
            # close under addition
            changed = True
            while changed:
                changed = False
                for x in list(span):
                    for y in list(span):
                        z = add[(x, y)]
                        if z not in span: span.add(z); changed = True
        if len(span) < 27: return False
    return True
random.seed(2)
seen = set(); tested = 0; worst = 0
for _ in range(6000):
    a, b = random.choice(G), random.choice(G)
    H = close([a, b])
    if H is None or H in seen: continue
    seen.add(H)
    ok = False
    for q in (2, 3, 5, 7, 11):
        K = close([h for h in H if gcd(order(h), q) == 1])
        if K is not None and len(K) <= 2: ok = True; break
    if not ok or not irreducible(H): continue
    tested += 1
    Hpm = close(list(H) + [NEG])
    m = min(len({A[v] for A in Hpm}) for v in range(1, 27))
    worst = max(worst, 27 * m // 2)
print(f"{len(seen)} subgroups sampled, {tested} irreducible with cyclic-layer image <= 2; largest least pair orbital {worst} (claim: <= 27)")
