#!/usr/bin/env python3
"""case_1035.py -- the last roomy pp+pp configuration: n = 1035, block 512 2-homogeneous (unusable), block 523 regular
(Z_523, k = 261 = 9 * 29 classes of 523 edges), exact reading, cap c = floor(T / 523) = 132 classes.
Lemma S with the coprime split 261 = 9 * 29: X on Z_9 within cap floor(132/29) = 4 with chi(X) = 30 (CP-SAT witness),
Y on Z_29 within cap floor(132/9) = 14: all vertices and 5 free edge orbits, chi(Y) = 29 - 5*29 = -116.
Delta0 = pull-backs' union, 1 - chi = (1 - 30)(1 + 116) = -3393, chi = 3394 = 1 + 13 * 261.
Lemma F: add 13 orbits of free minimal non-faces of even size (-261 each), searched explicitly (membership: S mod 9 in X
or S mod 29 in Y).  Faces stay within the cap.  usage: python3 case_1035.py -> ../outputs/case_1035.txt"""
import itertools, random, sys
sys.path.insert(0, '.')
from lemma_c_data import orbits, model
from ortools.sat.python import cp_model
M, psi = model(9, 4); M.Add(psi[1] == 30)
S = cp_model.CpSolver(); S.parameters.num_workers = 2; assert S.Solve(M) in (cp_model.OPTIMAL, cp_model.FEASIBLE)
orbs = orbits(9, 4)
X = set()
for i, (r, f, sz, st) in enumerate(orbs):
    if S.Value(M.GetBoolVarFromProtoIndex(i)):
        X |= {frozenset((x + d) % 9 for x in f) for d in range(9)}
assert sum((-1) ** (len(F) - 1) for F in X) == 30 and all(frozenset(G) in X for F in X for G in itertools.combinations(F, len(F) - 1) if G)
Yedges = {frozenset({x, (x + d) % 29}) for d in range(1, 6) for x in range(29)}
def inY(T): return len(T) == 1 or (len(T) == 2 and frozenset(T) in Yedges)
def inD(Sset): return frozenset(x % 9 for x in Sset) in X or inY({x % 29 for x in Sset})
k = 261
def free(Sset):
    T = frozenset(Sset); return all(frozenset((x + d) % k for x in Sset) != T for d in (87, 29, 9, 3))
rng = random.Random(3); need = 13; found = {}
for t in (2, 4, 6):
    found[t] = set()
    for _ in range(200000):
        Sset = tuple(sorted(rng.sample(range(k), t)))
        if inD(Sset) or not free(Sset): continue
        if not all(inD([x for x in Sset if x != y]) for y in Sset): continue
        found[t].add(min(tuple(sorted((x + d) % k for x in Sset)) for d in range(k)))
        if len(found[t]) >= need: break
    if len(found[t]) >= need: break
best = max(found, key=lambda u: len(found[u]))
line = (f"X on Z_9: {len(X)} faces, chi 30, largest {max(map(len, X))} points; Y: vertices + 5 edge orbits, chi -116; "
        f"chi(Delta0) = 3394 = 1 + 13*261; free minimal non-face orbits found by size: { {t: len(v) for t, v in found.items()} }; "
        f"closed: {len(found[best]) >= need} (size {best}, faces of at most {max(4 * 29, 2 * 9, best)} classes <= 132)")
open('../outputs/case_1035.txt', 'w').write(line + '\n'); print(line)
