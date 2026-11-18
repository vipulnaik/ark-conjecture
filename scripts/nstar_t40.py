"""nstar_t40.py -- degree 40: m*_typ of every soluble transitive group (labels from nstar_t40_export.g), as in
nstar_transitive_check.py: N* via nauty on points--pairs--orbitals, type totals, m*_typ = least type total.
Compared with mu*_cyc(40) = 140 = 40 (q(40) - 1)/2 (Conjecture P's bound at 40).
Run with python3 -I.  usage: python3 -I nstar_t40.py [file]"""
import sys, itertools, pynauty
from collections import Counter
n = 40; PAIRS = list(itertools.combinations(range(1, n + 1), 2)); NP = len(PAIRS); BOUND = 140
worst = 0; arg = None; over = []; cnt = 0
for line in open(sys.argv[1] if len(sys.argv) > 1 else '/tmp/g/t40.txt'):
    i, s = line.split('|', 1); lab = [int(x) - 1 for x in s.strip().split(',')]
    t = max(lab) + 1; adj = {v: [] for v in range(n + NP + t)}
    sizes = Counter(lab)
    bysize = Counter()
    for j, c in sizes.items(): bysize[c] += c          # N* only maps orbitals to orbitals of the same size
    ub = min(bysize.values())                          # so all orbitals of one size form a union of types
    if ub <= BOUND: m = None                           # m*_typ <= ub <= 140: not a candidate (exact value not needed)
    else:
        for k, (a, b) in enumerate(PAIRS):
            adj[a - 1].append(n + k); adj[b - 1].append(n + k); adj[n + k].append(n + NP + lab[k])
        g = pynauty.Graph(n + NP + t, adjacency_dict=adj,
                          vertex_coloring=[set(range(n)), set(range(n, n + NP)), set(range(n + NP, n + NP + t))])
        orbits = pynauty.autgrp(g)[3]
        tot = Counter()
        for j in range(t): tot[orbits[n + NP + j]] += sizes[j]
        m = min(tot.values())
    cnt += 1
    if m is None: continue
    if m > worst: worst, arg = m, int(i)
    if m > BOUND: over.append((int(i), m, len(tot)))
print(f"n=40: {cnt} soluble transitive; (groups with a size class of total <= 140 skipped) max m*_typ among the rest = {worst} (T40,{arg}); bound 140; above: {len(over)} {over[:20]}")
