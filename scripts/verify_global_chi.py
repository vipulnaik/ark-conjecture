#!/usr/bin/env python3
"""verify_global_chi.py -- recheck a property written by `global_chi_forced.py`.

  1. P is closed under deleting an edge.
  2. chi(Delta_P) = 1, recomputed with the classes of subgraphs of H0 listed by
     repeated edge deletion (the solver lists them another way) and the orbit
     sizes n!/|Aut| taken on all n vertices.
  3. Smith's congruence, which uses membership in P only and no counting of
     classes: for every p-group Q in outputs/tom<n>.txt with at most TMAX
     orbitals, chi of the fixed complex Delta_P^Q is 1 modulo p.

Usage: python3 verify_global_chi.py ../outputs/global_chi_2km_10.json [TMAX=12] [group file]
  group file: default ../outputs/tom<n>.txt; at n = 14, the output of pgroups_small.g
"""
import sys, json, itertools, os
from math import factorial
from sympy import factorint
import pynauty

J = json.load(open(sys.argv[1])); n, MODE = J["n"], J["mode"]; m = n // 2
TMAX = int(sys.argv[2]) if len(sys.argv) > 2 else 12


def cert(edges):
    adj = {i: [] for i in range(n)}
    for a, b in edges:
        adj[a].append(b); adj[b].append(a)
    return pynauty.certificate(pynauty.Graph(n, adjacency_dict=adj))


def aut(edges):
    adj = {i: [] for i in range(n)}
    for a, b in edges:
        adj[a].append(b); adj[b].append(a)
    _, m1, m2, _, _ = pynauty.autgrp(pynauty.Graph(n, adjacency_dict=adj))
    return round(m1 * 10 ** m2)


def in_h0(edges):
    if MODE.endswith("star"):
        common = set(edges[0])
        for e in edges:
            common &= set(e)
        if len(common) >= 1:
            return True
        if MODE == "star":
            return False
    if MODE.startswith("tri"):            # every component has at most 3 vertices
        deg = {}
        for a, b in edges:
            deg.setdefault(a, set()).add(b); deg.setdefault(b, set()).add(a)
        return all(len({v} | nb | set().union(*(deg[u] for u in nb))) <= 3 for v, nb in deg.items())
    par = list(range(n))
    def f(x):
        while par[x] != x:
            par[x] = par[par[x]]; x = par[x]
        return x
    for a, b in edges:
        par[f(a)] = f(b)
    sz = {}
    for x in {y for e in edges for y in e}:
        sz[f(x)] = sz.get(f(x), 0) + 1
    if max(sz.values()) > m:
        return False
    reach = {0}
    for s in sz.values():
        reach |= {r + s for r in reach if r + s <= m}
    return any(sum(sz.values()) - r <= m for r in reach)


D = [[tuple(e) for e in H] for H in J["D"]]
Dc = {cert(H) for H in D}
assert len(Dc) == len(D) and not any(in_h0(H) for H in D)
member = lambda edges: in_h0(edges) or cert(edges) in Dc
bad = sum(1 for H in D if len(H) > 1 and not all(member([e for e in H if e != d]) for d in H))
print(f"n = {n}, H0 mode {MODE}: |D| = {len(D)}; members of D with a deleted-edge subgraph outside P: {bad}")
assert bad == 0
# classes of subgraphs of H0, by edge deletion from H0
H0s = []
if MODE.endswith("star"):
    H0s.append([(0, i) for i in range(1, n)])
if MODE.startswith("2km"):
    H0s.append(list(itertools.combinations(range(m), 2)) + list(itertools.combinations(range(m, n), 2)))
if MODE.startswith("tri"):
    H0s.append([e for i in range(n // 3) for e in ((3 * i, 3 * i + 1), (3 * i, 3 * i + 2), (3 * i + 1, 3 * i + 2))])
H0 = max(H0s, key=len)
layer = {cert(H): H for H in H0s}; forced = dict(layer)
while layer:
    nxt = {}
    for H in layer.values():
        if len(H) > 1:
            for d in H:
                G = [e for e in H if e != d]; c = cert(G)
                if c not in forced and c not in nxt:
                    nxt[c] = G
    forced.update(nxt); layer = nxt
chi = sum((1 if len(H) % 2 else -1) * (factorial(n) // aut(H)) for H in list(forced.values()) + D)
print(f"subgraph classes of H0: {len(forced)};  chi(Delta_P) = {chi};  e_max(P) = {max(len(H0), max(len(H) for H in D))}")
assert chi == 1
tom = sys.argv[3] if len(sys.argv) > 3 else f"../outputs/tom{n}.txt"
if os.path.exists(tom):
    done = fail = 0
    for line in open(tom):
        q = line.strip().split("|"); order = int(q[0]); f = factorint(order)
        if order == 1 or len(f) != 1:
            continue
        orbs = [[(a - 1, b - 1) for a, b in o] for o in json.loads(q[5])]
        if len(orbs) > TMAX:
            continue
        p = list(f)[0]; x = 0; t = len(orbs)  # noqa
        for F in range(1, 1 << t):
            G = [e for i in range(t) if F >> i & 1 for e in orbs[i]]
            if member(G):
                x += 1 if bin(F).count("1") % 2 else -1
        done += 1; fail += (x - 1) % p != 0
    print(f"Smith: {done} p-groups with at most {TMAX} orbitals; congruence failing at {fail}")
    assert fail == 0
