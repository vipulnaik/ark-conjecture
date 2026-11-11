#!/usr/bin/env python3
"""kset_block_levels.py -- the level-1 computation of `threshold-beyond-mu.md`
for one block at arity k = 3 (section 10 there).

For a group G on [n] acting on 3-subsets: its orbits, the types (orbits of N*,
the permutations of [n] carrying every G-orbit of 3-sets onto one), and the
least budget B at which some N*-invariant complex on the orbits, every face of
total size at most B, has chi = 1 (mod q).  N* is computed with nauty on the
graph points -- 3-sets -- orbits.

Cases: Z/r : C_t for (r, t, q) = (23, 11, 11), (29, 7, 7), (13, 3, 3) -- a
foreign block at cofactor 2, 4, 4 -- and AGL(1, 32) at q = 31 and q = 5.

Usage: python3 kset_block_levels.py        (needs pynauty, ortools; a few seconds)
"""
import itertools
from collections import Counter
import pynauty
from ortools.sat.python import cp_model

K = 3


def orbits_on_ksets(n, gens):
    ksets = list(itertools.combinations(range(n), K)); idx = {s: i for i, s in enumerate(ksets)}
    par = list(range(len(ksets)))
    def f(x):
        while par[x] != x:
            par[x] = par[par[x]]; x = par[x]
        return x
    for g in gens:
        for s, i in idx.items():
            j = idx[tuple(sorted(g[x] for x in s))]
            if f(i) != f(j):
                par[f(i)] = f(j)
    orbs = {}
    for i in range(len(ksets)):
        orbs.setdefault(f(i), []).append(i)
    return ksets, list(orbs.values())


def analyse(name, n, gens, q):
    ksets, orbs = orbits_on_ksets(n, gens); t = len(orbs); NK = len(ksets)
    adj = {v: [] for v in range(n + NK + t)}
    for i, s in enumerate(ksets):
        for x in s:
            adj[x].append(n + i)
    for j, o in enumerate(orbs):
        for i in o:
            adj[n + i].append(n + NK + j)
    g = pynauty.Graph(n + NK + t, adjacency_dict=adj,
                      vertex_coloring=[set(range(n)), set(range(n, n + NK)), set(range(n + NK, n + NK + t))])
    ggens, m1, m2, orb_of, _ = pynauty.autgrp(g)
    act = [[x[n + NK + j] - n - NK for j in range(t)] for x in ggens]
    size = [len(o) for o in orbs]
    types = Counter()
    for j in range(t):
        types[orb_of[n + NK + j]] += 1
    tot = Counter()
    for j in range(t):
        tot[orb_of[n + NK + j]] += size[j]
    print(f"{name}: {t} orbits on 3-sets, sizes {sorted(Counter(size).items())}; |N*| = {round(m1 * 10 ** m2)}; "
          f"types (orbits in type: how many) {sorted(Counter(types.values()).items())}; type totals {sorted(Counter(tot.values()).items())}")
    if t > 20:
        print("   too many orbits for the exact level"); return
    w = [0] * (1 << t)
    for F in range(1, 1 << t):
        b = F & -F; w[F] = w[F ^ b] + size[b.bit_length() - 1]
    def img(a, F):
        x = 0
        while F:
            b = F & -F; x |= 1 << a[b.bit_length() - 1]; F ^= b
        return x
    rep = {}
    for F in range(1, 1 << t):
        if F in rep:
            continue
        orb, stack = {F}, [F]
        while stack:
            y = stack.pop()
            for a in act:
                z = img(a, y)
                if z not in orb:
                    orb.add(z); stack.append(z)
        for y in orb:
            rep[y] = F
    osz = Counter(rep.values()); reps = sorted(osz, key=lambda F: w[F])
    below = {F: {rep[F ^ (1 << i)] for i in range(t) if F >> i & 1 and F ^ (1 << i)} for F in reps}
    for B in sorted({w[F] for F in reps}):
        use = [F for F in reps if w[F] <= B]
        M = cp_model.CpModel(); X = {F: M.NewBoolVar(str(F)) for F in use}
        for F in use:
            for G in below[F]:
                M.AddImplication(X[F], X[G])
        z = M.NewIntVar(-10 ** 7, 10 ** 7, "z")
        M.Add(sum((1 if bin(F).count("1") % 2 else -1) * osz[F] * X[F] for F in use) == 1 + q * z)
        S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 120
        r = S.Solve(M)
        if r in (cp_model.OPTIMAL, cp_model.FEASIBLE):
            chosen = sorted(bin(F).count("1") for F in use if S.Value(X[F]))
            print(f"   least budget with chi = 1 (mod {q}): {B}  (smallest orbit {min(size)}; all 3-sets {NK}); "
                  f"face-orbit sizes used {dict(Counter(chosen))}")
            return
        if r != cp_model.INFEASIBLE:
            print("   solver stopped at budget", B); return
    print(f"   no invariant complex with chi = 1 (mod {q}) at any budget below the full simplex")


def affine(r, t):
    gen = next(g for g in range(2, r) if all(pow(g, (r - 1) // p, r) != 1 for p in range(2, r) if (r - 1) % p == 0))
    z = pow(gen, (r - 1) // t, r)
    return [[(x + 1) % r for x in range(r)], [(z * x) % r for x in range(r)]]


for r, t, q in ((23, 11, 11), (29, 7, 7), (13, 3, 3)):
    analyse(f"Z/{r} : C_{t}, cofactor {(r - 1) // t}", r, affine(r, t), q)
# AGL(1,32): GF(32) = GF(2)[x]/(x^5 + x^2 + 1), elements as 5-bit integers
def mulx(a):
    a <<= 1
    return a ^ 0b100101 if a & 32 else a
gens32 = [[x ^ 1 for x in range(32)], [mulx(x) for x in range(32)]]
for q in (31, 5):
    analyse("AGL(1,32)", 32, gens32, q)
