#!/usr/bin/env python3
"""
lutz30.py -- the evasiveness argument for Lutz's contractible vertex-homogeneous complex (monotone-transitive-note
section 6 item 3a).  The 60-vertex complex K in the Benedetti-Lutz library has 441 facets {a u (b+30)} over one
family of 21 sets on {1..30}, i.e. K = A * A' (a join) with A Lutz's 5-dimensional Z-acyclic complex on 30 vertices,
whose facets are the list L below (the same as in lutzA.py).  By Welker (1999) a join is non-evasive iff a factor is, so K is non-evasive
iff A is.  A non-evasive complex has a vertex whose link is non-evasive, hence Z-acyclic, hence chi = 1.
This script checks: f-vector and chi(A) = 1, and chi(lk_A v) for every vertex v (all 0) -- so A, and K, are evasive.
USAGE  python3 lutz30.py
"""
import itertools
# facets of A, as in lutzA.py (copied so this needs no pynauty)
L=[[1,2,3,4,5,6],[1,2,4,7,8,10],[1,3,6,25,27,30],[1,7,13,19,25],[2,5,6,14,17,18],[2,8,14,20,26],
   [3,4,5,21,22,23],[3,9,15,21,27],[4,10,16,22,28],[5,11,17,23,29],[6,12,18,24,30],[7,8,9,10,11,12],
   [7,9,11,13,15,17],[8,9,12,20,21,24],[10,11,12,28,29,30],[13,14,15,16,17,18],[13,16,18,19,22,24],
   [14,15,16,26,27,28],[19,20,21,22,23,24],[19,20,23,25,26,29],[25,26,27,28,29,30]]
L=[[v-1 for v in f] for f in L]
N=30
N=30
faces = set()
for f in L:
    for k in range(1, len(f) + 1):
        faces.update(itertools.combinations(sorted(f), k))
fvec = [sum(1 for c in faces if len(c) == k) for k in range(1, 7)]
chi = sum((-1) ** (len(c) - 1) for c in faces)
print("A: f-vector", fvec, " chi =", chi)
link_chis = set()
for v in range(N):
    lk = [tuple(x for x in c if x != v) for c in faces if v in c and len(c) > 1]
    link_chis.add(sum((-1) ** (len(c) - 1) for c in lk))
print("chi of vertex links of A:", sorted(link_chis), "-> no link has chi = 1, so A is evasive, hence so is K = A * A'")
