#!/usr/bin/env python3
"""Collapsibility is not self-dual under Alexander duality: the dunce hat.

D is a 13-vertex triangulation of the dunce hat: a 9-gon whose boundary reads
1,2,3,1,2,3,1,3,2 (the word a a a^-1 with a = 1-2-3-1), an inner ring of nine
new vertices 4..12 and a centre 13.  D has no free face, so it is not
collapsible.  Its Alexander dual D* = {V - s : s not in D} on the same 13
vertices collapses to a vertex.  So K = D* is collapsible and K* = D is not.

The same holds for an 8-vertex dunce hat (17 triangles, obtained from the
13-vertex one by edge contractions that keep the link condition): its dual
on 8 vertices, 205 faces of dimension 5, collapses to a vertex.  Eight is
the least possible vertex count, since a Z_2-acyclic complex on at most 7
vertices is collapsible (Bagchi-Datta) and the dual of a collapsible complex
is contractible.

The collapse is found by a random greedy search and then REPLAYED by an
independent checker (verify) that tests each elementary collapse from the
definition: s is a proper face of exactly one other face t of the current
complex, and |t| = |s| + 1.

Usage: python3 dunce_dual.py [seed] [--n8]
"""
import itertools, random, sys

N = 13
V = frozenset(range(1, N + 1))

def dunce13():
    lab = [1, 2, 3, 1, 2, 3, 1, 3, 2]
    c = [4 + i for i in range(9)]
    T = []
    for i in range(9):
        j = (i + 1) % 9
        T += [(lab[i], lab[j], c[i]), (lab[j], c[i], c[j]), (c[i], c[j], 13)]
    return [frozenset(t) for t in T]

def dunce8():
    T = "124 125 128 135 136 137 148 167 234 236 238 257 267 345 378 457 478"
    return [frozenset(int(ch) for ch in t) for t in T.split()]

def closure(facets):
    K = set()
    for f in facets:
        for k in range(len(f) + 1):
            K.update(frozenset(s) for s in itertools.combinations(sorted(f), k))
    return K

def dual(K):
    return {V - frozenset(s) for k in range(N + 1)
            for s in itertools.combinations(sorted(V), k) if frozenset(s) not in K}

def free_pairs(K):
    up = {}
    for s in K:
        for v in s:
            up.setdefault(s - {v}, []).append(s)
    return [(s, cof[0]) for s, cof in up.items()
            if s and len(cof) == 1 and cof[0] not in up]

def greedy(K, seed):
    rng = random.Random(seed)
    K = set(K)
    seq = []
    while True:
        fp = free_pairs(K)
        if not fp:
            return K, seq
        s, t = rng.choice(fp)
        K.discard(s); K.discard(t)
        seq.append((s, t))

def verify(K, seq):
    """Replay seq on K from the definition of an elementary collapse."""
    K = set(K)
    for s, t in seq:
        assert s in K and t in K and s < t and len(t) == len(s) + 1
        assert [u for u in K if s < u] == [t], "s is not free"
        K.discard(s); K.discard(t)
    return K

if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if a != "--n8"]
    seed = int(args[0]) if args else 0
    if "--n8" in sys.argv:
        N = 8
        V = frozenset(range(1, N + 1))
        T = dunce8()
    else:
        T = dunce13()
    D = closure(T)
    f = [sum(1 for s in D if len(s) == k) for k in (1, 2, 3)]
    deg = {}
    for t in T:
        for e in itertools.combinations(sorted(t), 2):
            deg[e] = deg.get(e, 0) + 1
    print("D: f-vector", f, " chi", f[0] - f[1] + f[2],
          " edges in 3 triangles:", sorted(e for e in deg if deg[e] == 3),
          " every edge in 2 or 3:", all(d in (2, 3) for d in deg.values()))
    print("D: free faces", len(free_pairs(D)), "(none, so D is not collapsible)")
    Ds = dual(D)
    assert dual(Ds) == D
    print("D*: faces", len(Ds) - 1, " dimension", max(map(len, Ds)) - 1)
    R, seq = greedy(Ds, seed)
    R2 = verify(Ds, seq)
    assert R2 == R
    rest = sorted(sorted(s) for s in R if s)
    print("D*: greedy collapse, seed", seed, "-", len(seq), "elementary collapses, replayed and checked; what is left:", rest)
    print("VERDICT:", "D* is collapsible, D is not" if len(rest) == 1 and len(rest[0]) == 1 else "greedy collapse stalled (inconclusive)")
