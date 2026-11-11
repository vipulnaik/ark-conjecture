#!/usr/bin/env python3
"""pgroup_levels.py -- lower bounds for G*(n) from p-subgroups
(`threshold-beyond-mu.md` section 9).

If chi(Delta_P) = 1 then chi(Delta_P^Q) = 1 (mod p) for every p-subgroup Q
(Smith), and Delta_P^Q is an N*(Q)-invariant complex on Q's orbitals.  So
G*(n) >= the least budget B at which some N*(Q)-invariant complex on the
orbitals of Q, every face of total size at most B, has chi = 1 (mod p).
That least budget is computed here for every p-group in outputs/tom<n>.txt
with at most TMAX orbitals (CP-SAT over N*-orbits of faces).

Usage: python3 pgroup_levels.py n [TMAX=14]      (needs pynauty, ortools)
       python3 pgroup_levels.py 2x m            the group of translations of two blocks of size m, n = 2m
"""
import sys, json, itertools
from sympy import factorint
import pynauty
from ortools.sat.python import cp_model

TWO = sys.argv[1] == "2x"            # "2x m": the translations of two blocks of size m = p^a, n = 2m
if TWO:
    mm = int(sys.argv[2]); n = 2 * mm; TMAX = 99
else:
    n = int(sys.argv[1]); TMAX = int(sys.argv[2]) if len(sys.argv) > 2 else 14
PAIRS = list(itertools.combinations(range(1, n + 1), 2)); PID = {p: i for i, p in enumerate(PAIRS)}; NP = len(PAIRS)


def nstar_gens(orbitals):
    t = len(orbitals)
    adj = {v: [] for v in range(n + NP + t)}
    for (a, b), i in PID.items():
        adj[a - 1].append(n + i); adj[b - 1].append(n + i)
    for j, o in enumerate(orbitals):
        for e in o:
            adj[n + PID[tuple(e)]].append(n + NP + j)
    g = pynauty.Graph(n + NP + t, adjacency_dict=adj,
                      vertex_coloring=[set(range(n)), set(range(n, n + NP)), set(range(n + NP, n + NP + t))])
    gens = pynauty.autgrp(g)[0]
    return [[x[n + NP + j] - n - NP for j in range(t)] for x in gens]


def level(orbitals, p):
    t = len(orbitals); size = [len(o) for o in orbitals]; gens = nstar_gens(orbitals)
    w = [0] * (1 << t)
    for F in range(1, 1 << t):
        b = F & -F; w[F] = w[F ^ b] + size[b.bit_length() - 1]
    def act(g, F):
        x = 0
        while F:
            b = F & -F; x |= 1 << g[b.bit_length() - 1]; F ^= b
        return x
    rep = {}
    for F in range(1, 1 << t):
        if F in rep:
            continue
        orb, stack = {F}, [F]
        while stack:
            y = stack.pop()
            for g in gens:
                z = act(g, y)
                if z not in orb:
                    orb.add(z); stack.append(z)
        for y in orb:
            rep[y] = F
    reps = sorted(set(rep.values()), key=lambda F: w[F])
    osz = {}
    for F in rep:
        osz[rep[F]] = osz.get(rep[F], 0) + 1
    below = {F: {rep[F ^ (1 << i)] for i in range(t) if F >> i & 1 and F ^ (1 << i)} for F in reps}
    for B in sorted({w[F] for F in reps}):
        use = [F for F in reps if w[F] <= B]
        M = cp_model.CpModel(); X = {F: M.NewBoolVar(str(F)) for F in use}
        for F in use:
            for G in below[F]:
                M.AddImplication(X[F], X[G])
        z = M.NewIntVar(-10 ** 7, 10 ** 7, "z")
        M.Add(sum((1 if bin(F).count("1") % 2 else -1) * osz[F] * X[F] for F in use) == 1 + p * z)
        S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 60
        r = S.Solve(M)
        if r in (cp_model.OPTIMAL, cp_model.FEASIBLE):
            return B
        if r != cp_model.INFEASIBLE:
            return None
    return None


if TWO:
    (pp, aa), = factorint(mm).items()
    vecs = list(itertools.product(range(pp), repeat=aa)); vid = {v: i for i, v in enumerate(vecs)}
    add = lambda u, v: tuple((x + y) % pp for x, y in zip(u, v))
    orbs = []
    for blk in (0, 1):                # within a block: one orbital per difference class {d, -d}
        seen = set()
        for d in vecs[1:]:
            nd = tuple(-x % pp for x in d)
            if d in seen:
                continue
            seen |= {d, nd}
            orbs.append(sorted({tuple(sorted((blk * mm + vid[v] + 1, blk * mm + vid[add(v, d)] + 1))) for v in vecs}))
    orbs.append([(i + 1, mm + j + 1) for i in range(mm) for j in range(mm)])
    print(f"n = {n}: translations of two blocks of {mm}; orbital sizes {sorted(len(o) for o in orbs)}; "
          f"least budget with chi = 1 mod {pp}: {level(orbs, pp)}   (m(m-1) = {mm * (mm - 1)})")
    sys.exit(0)
best = (0, None); skipped = 0; done = 0
for line in open(f"../outputs/tom{n}.txt"):
    q = line.strip().split("|")
    order = int(q[0]); f = factorint(order)
    if order == 1 or len(f) != 1:
        continue
    orbs = json.loads(q[5])
    if len(orbs) > TMAX:
        skipped += 1; continue
    p = list(f)[0]; B = level(orbs, p); done += 1
    if B is not None and B > best[0]:
        best = (B, (order, sorted(len(o) for o in orbs)))
        print("  new best:", best, flush=True)
print(f"n = {n}: {done} p-groups with at most {TMAX} orbitals examined, {skipped} skipped; G*({n}) >= {best[0]}, from {best[1]}")
