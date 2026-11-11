#!/usr/bin/env python3
"""nstar_types.py -- the types of every Oliver class at small degree, and
nu*(n) = the largest m*_typ over NONTRIVIAL Oliver groups
(`threshold-beyond-mu.md` section 9).

N*(Gamma) is the group of permutations of [n] carrying every orbital onto an
orbital; its orbits on the orbitals are the types, and m*_typ(Gamma) is the
smallest total of a type.  N* is computed as the automorphism group of the
graph  points -- pairs -- orbitals  (three colour classes), with nauty.

Usage: python3 nstar_types.py 10      (reads ../outputs/tom<n>.txt; needs pynauty)
"""
import sys, json, itertools
from collections import Counter
import pynauty

n = int(sys.argv[1])
PAIRS = list(itertools.combinations(range(1, n + 1), 2))
PID = {p: i for i, p in enumerate(PAIRS)}
NP = len(PAIRS)


def types(orbitals):
    t = len(orbitals)
    adj = {v: [] for v in range(n + NP + t)}
    for (a, b), i in PID.items():
        adj[a - 1] += [n + i]
        adj[b - 1] += [n + i]
    for j, o in enumerate(orbitals):
        for e in o:
            adj[n + PID[tuple(e)]].append(n + NP + j)
    g = pynauty.Graph(n + NP + t, directed=False, adjacency_dict=adj,
                      vertex_coloring=[set(range(n)), set(range(n, n + NP)), set(range(n + NP, n + NP + t))])
    gens, m1, m2, orbits, _ = pynauty.autgrp(g)
    tot = Counter()
    for j, o in enumerate(orbitals):
        tot[orbits[n + NP + j]] += len(o)
    return sorted(tot.values()), round(m1 * 10 ** m2)


rows = []
for line in open(f"../outputs/tom{n}.txt"):
    p = line.strip().split("|")
    if len(p) < 6:
        continue
    orbs = json.loads(p[5])
    tt, nstar = types(orbs)
    rows.append((int(p[0]), p[1] == "true", len(orbs), min(len(o) for o in orbs), tt, nstar))
print("classes:", len(rows))
single = [r for r in rows if len(r[4]) == 1]
print("groups with a single type:", [(r[0], r[2]) for r in single], "(order, orbitals)")
nontriv = [r for r in rows if r[0] > 1]
nu = max(r[4][0] for r in nontriv)
print("mu* =", max(r[3] for r in rows), "  nu* = max m*_typ over nontrivial groups =", nu)
print("m*_typ distribution over nontrivial groups:", sorted(Counter(r[4][0] for r in nontriv).items()))
print("groups attaining nu*: (order, transitive, orbitals, m*, type totals, |N*|)")
for r in nontriv:
    if r[4][0] == nu:
        print("  ", r)
print("groups with m*_typ > m*:", sum(1 for r in rows if r[4][0] > r[3]))
