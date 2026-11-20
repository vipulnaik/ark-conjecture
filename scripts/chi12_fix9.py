#!/usr/bin/env python3
"""chi12_fix9.py -- level-2 value m*_chi at n = 12 for the two Oliver classes that
chi_level10.py cannot enumerate: <(1 2 3)> and Sym{1,2,3}, each fixing the other 9
points (lines 7 and 54 of tom12.txt; both exact readings, chi = 1).

Both groups have the same invariant graphs: G = H + S + t, where H is any graph on
the 9 fixed points, S a set of fixed points joined to all of 1, 2, 3, and t whether
the triangle 123 is present.  Its orbits (vertices of the fixed complex) number
e(H) + |S| + t and its edges e(H) + 3|S| + 3t.  Graphs H come from nauty's geng up to
isomorphism; for one labelling of H every S is taken, weighted by 9!/|Aut H|, which
counts the labelled invariant graphs exactly.  Classes are S_12 isomorphism classes
(nauty certificates); the signed count s(C) is the sum of (-1)^(orbits - 1).

The model is chi_level10.analyse_lazy's, solved by HiGHS (CP-SAT stalls on the large coefficients): x_C, chi = sum s(C) x_C = 1, and
the cover relations of the full embedding order among the enumerated classes, so a
'feasible' verdict is exact.
usage: GENG=/path/to/geng python3 chi12_fix9.py b [b ...]
"""
import os, sys, subprocess, itertools, math, time
os.environ.setdefault('CHI_N', '12'); os.environ.setdefault('CHI_TOM', '/tmp/tom12.txt')
sys.argv, _args = sys.argv[:1] + ['1', '18'], sys.argv[1:]
import chi_level10 as cl
import pynauty, networkx as nx
import numpy as np, scipy.sparse as sp, highspy
from scipy.optimize import milp, LinearConstraint, Bounds

GENG = os.environ.get('GENG', 'geng')
F9 = list(range(3, 12))               # fixed points (0-based); 0, 1, 2 are moved


def aut_size(edges):
    adj = {v: [] for v in range(9)}
    for a, b in edges: adj[a].append(b)
    return pynauty.autgrp(pynauty.Graph(9, adjacency_dict=adj))[1]


def classes(b):
    out = subprocess.run([GENG, '-q', '9', f'0:{b}'], capture_output=True, text=True).stdout.split()
    cls = {}
    for g6 in out:
        H = nx.from_graph6_bytes(g6.encode())
        he = [(a + 3, c + 3) for a, c in H.edges()]
        w = math.factorial(9) // round(aut_size(list(H.edges())))
        eh = len(he)
        for t in (0, 1):
            tri = [(0, 1), (0, 2), (1, 2)] if t else []
            for k in range((b - eh - 3 * t) // 3 + 1):
                for S in itertools.combinations(F9, k):
                    edges = he + tri + [(v, m) for v in S for m in (0, 1, 2)]
                    if not edges: continue          # the empty graph is not a face
                    c = cl.cert(edges)
                    s = w * (1 if (eh + k + t) % 2 else -1)
                    if c in cls: cls[c][0] += s
                    else: cls[c] = [s, edges]
    return cls


def solve(cls):
    keys = list(cls); G = []
    for k in keys:
        g = nx.Graph(); g.add_nodes_from(range(12)); g.add_edges_from(cls[k][1]); G.append(g)
    E = [g.number_of_edges() for g in G]
    D = [sorted((d for _, d in g.degree()), reverse=True) for g in G]
    # full embedding poset, built upward with transitivity as in chi_level10.analyse;
    # only cover relations go into the model (the rest follow by transitivity)
    order = sorted(range(len(keys)), key=lambda i: E[i])
    down = [0] * len(keys)
    for j in order:
        got = 0
        for i in sorted((i for i in range(len(keys)) if E[i] < E[j]), key=lambda i: -E[i]):
            if got >> i & 1: continue
            if cl.degseq_ok(D[i], D[j]) and cl.embeds(G[i], G[j]):
                got |= (1 << i) | down[i]
        down[j] = got
    rel = []
    for j in range(len(keys)):
        below = [i for i in range(len(keys)) if down[j] >> i & 1]
        for i in below:
            if not any(down[k] >> i & 1 for k in below if k != i):
                rel.append((i, j))
    known, rounds = None, 0
    while True:
        rounds += 1; print(f"  round {rounds}: {len(rel)} relations", flush=True) if os.environ.get("V") else None
        # HiGHS MILP: CP-SAT stalls on the subset-sum equality (coefficients up to 9!)
        nk = len(keys)
        A = sp.lil_matrix((1 + len(rel), nk))
        for i, k in enumerate(keys): A[0, i] = cls[k][0]
        for r, (i, j) in enumerate(rel): A[1 + r, j] = 1; A[1 + r, i] = -1     # x_j <= x_i
        lo = np.r_[1, -np.inf * np.ones(len(rel))]; hi = np.r_[1, np.zeros(len(rel))]
        h = highspy.Highs(); h.setOptionValue('output_flag', False)
        h.setOptionValue('time_limit', 1800.0)
        h.setOptionValue('mip_feasibility_tolerance', 1e-10)
        h.setOptionValue('primal_feasibility_tolerance', 1e-10)
        A = A.tocsc()
        lp = highspy.HighsLp(); lp.num_col_ = nk; lp.num_row_ = A.shape[0]
        lp.col_cost_ = np.zeros(nk); lp.col_lower_ = np.zeros(nk); lp.col_upper_ = np.ones(nk)
        lp.row_lower_ = lo; lp.row_upper_ = hi
        lp.a_matrix_.format_ = highspy.MatrixFormat.kColwise
        lp.a_matrix_.start_ = A.indptr; lp.a_matrix_.index_ = A.indices; lp.a_matrix_.value_ = A.data
        lp.integrality_ = [highspy.HighsVarType.kInteger] * nk
        h.passModel(lp); h.run()
        ms = h.getModelStatus()
        if ms == highspy.HighsModelStatus.kInfeasible:
            return 'INFEASIBLE', len(rel), rounds, None
        if ms != highspy.HighsModelStatus.kOptimal:
            return 'unknown', len(rel), rounds, None
        res_x = np.array(h.getSolution().col_value)
        xv = np.round(res_x).astype(int)
        assert sum(cls[k][0] * xv[i] for i, k in enumerate(keys)) == 1
        on = [i for i in range(nk) if xv[i]]
        off = [i for i in range(nk) if not xv[i]]
        new = []      # every cover relation is in the model, so the family is closed
        if not new:
            return 'feasible', len(rel), rounds, [cls[keys[i]][1] for i in on]
        rel += new


if __name__ == '__main__':
    for b in map(int, _args):
        t0 = time.time(); cls = classes(b)
        res, nrel, rounds, fam = solve(cls)
        print(f"b = {b}: {len(cls)} classes, {nrel} embedding relations, {rounds} rounds -> {res} ({time.time() - t0:.0f}s)", flush=True)
        if fam is not None:
            print("  family (one representative per class): " + '; '.join(str(sorted(e)) for e in fam), flush=True)
            break
