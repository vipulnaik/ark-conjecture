#!/usr/bin/env python3
"""forcing10_core_check.py -- independent check of the 7-group infeasible core at n = 10, B = 21 (forcing10.py --core).
Rebuilds the core's classes and conditions with networkx monomorphism tests (not emb.c), then decides feasibility
with SciPy's HiGHS MILP (not CP-SAT).  Groups are matched by (order, sorted orbit sizes); any extra class with the
same key only adds conditions, so INFEASIBLE remains a valid lower bound.
usage: python3 forcing10_core_check.py -> ../outputs/forcing10_core_check.txt"""
import os, sys, json, itertools
os.environ['CHI_N'] = '10'; sys.argv = ['x']
import chi_level10 as C
import networkx as nx
B = 21
CORE = [(12, [2, 2, 2, 3, 6, 6, 12, 12]), (12, [2, 3, 4, 6, 6, 12, 12]), (12, [2, 3, 3, 3, 4, 6, 12, 12]),
        (20, [5, 10, 10, 20]), (25, [5, 5, 5, 5, 25]), (36, [2, 4, 6, 9, 12, 12]), (192, [1, 12, 16, 16])]
rows = []
for line in open('../outputs/tom10.txt'):
    p = line.strip().split('|'); orbs = json.loads(p[5])
    key = (int(p[0]), sorted(len(o) for o in orbs))
    if key in [(o, s) for o, s in CORE]: rows.append((key, p[2] == 'true', orbs))
cls = {}; graphs = []; E = []; conds = []
for key, exact, orbs in rows:
    terms = {}
    for F in C.subsets([len(o) for o in orbs], B):
        edges = [(a - 1, b - 1) for i in F for a, b in orbs[i]]
        c = C.cert(edges)
        if c not in cls:
            cls[c] = len(graphs); g = nx.Graph(); g.add_nodes_from(range(10)); g.add_edges_from(edges); graphs.append(g); E.append(len(edges))
        terms[cls[c]] = terms.get(cls[c], 0) + (1 if len(F) % 2 else -1)
    conds.append((key, exact, terms))
K = len(graphs)
below = [[i for i in range(K) if E[i] < E[j] and nx.algorithms.isomorphism.GraphMatcher(graphs[j], graphs[i]).subgraph_is_monomorphic()] for j in range(K)]
import numpy as np
from scipy.optimize import milp, LinearConstraint, Bounds
rowsA = []; lo = []; hi = []
for j2 in range(K):
    for i2 in below[j2]:
        r = np.zeros(K); r[j2] = 1; r[i2] = -1; rowsA.append(r); lo.append(-np.inf); hi.append(0)    # x_j <= x_i
for key, ex, terms in conds:
    if not ex: continue                     # mod-q readings dropped: fewer conditions keep INFEASIBLE valid
    r = np.zeros(K)
    for k, v in terms.items(): r[k] = v
    rowsA.append(r); lo.append(1); hi.append(1)                                                  # chi = 1
res = milp(c=np.zeros(K), constraints=LinearConstraint(np.array(rowsA), lo, hi), integrality=np.ones(K), bounds=Bounds(0, 1))
sols = 'feasible' if res.status == 0 else ('INFEASIBLE' if res.status == 2 else f'status {res.status}: {res.message}')
line = (f"core rebuilt: {len(rows)} groups (exact readings: {[ex for _, ex, _ in conds]}), {K} classes; "
        f"HiGHS MILP over down-closed assignments meeting every condition: {sols} (networkx monomorphism, no CP-SAT, no emb.c)")
open('../outputs/forcing10_core_check.txt', 'w').write(line + '\n'); print(line)
