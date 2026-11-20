#!/usr/bin/env python3
"""burnside_ocr.py -- M*_OCR(n) and mu*_chi-type per-group values from the Burnside-ring formulation
(burnside-ring-view.md).  A graph property P is a down-closed set of isomorphism classes; its Burnside element is
its equivariant Euler characteristic chi_{S_n}(Delta_P) in B(S_n) has mark chi(Delta_P^G) at G, and
chi(Delta_P^G) = sum over nonempty classes C in P of s_G(C), the signed count of burnside_marks.g.  CP-SAT over 0/1 class variables, down-closure by one-edge deletions, the nontrivial
property (K_n excluded), and mark conditions.
  M*_OCR(n): least B with a property of e_max <= B meeting chi = 1 at every trivial-top Oliver class (fact 5 makes
             this the full Oliver-chi-resistance condition).
  per group: least B meeting the condition of that class alone; the maximum over trivial-top classes is the
             trivial-top part of mu*_chi(n) *at level 'chi of the fixed complex of a graph property'*.
usage: python3 burnside_ocr.py N  (reads /tmp/marks_N.txt from burnside_marks.g) -> ../outputs/burnside_ocr_N.txt"""
import sys, itertools
from ortools.sat.python import cp_model
N = int(sys.argv[1])
L = open(f'/tmp/marks_{N}.txt').read().split('\n')
reps = []; groups = []
for l in L:
    if l.startswith('C '): _, r, e = l.split(); reps.append((int(r), int(e)))
    elif l.startswith('G '):
        parts = l.split(' ', 4); groups.append((int(parts[1]), parts[2] == 'true', parts[3] == 'true', eval(parts[4])))
E = list(itertools.combinations(range(N), 2)); m = len(E)
perms = list(itertools.permutations(range(N)))
eperm = [[E.index(tuple(sorted((p[u], p[v])))) for (u, v) in E] for p in perms]
def canon(mask):
    return min(sum(1 << pe[i] for i in range(m) if mask >> i & 1) for pe in eperm)
cid = {canon(r): k for k, (r, e) in enumerate(reps)}
down = []                                          # (C, D): D a one-edge deletion class of C
for k, (r, e) in enumerate(reps):
    for i in range(m):
        if r >> i & 1: down.append((k, cid[canon(r & ~(1 << i))]))
full = max(range(len(reps)), key=lambda k: reps[k][1]); empty = min(range(len(reps)), key=lambda k: reps[k][1])
def least_B(conds):
    for B in range(1, m + 1):
        md = cp_model.CpModel(); x = [md.NewBoolVar(f'x{k}') for k in range(len(reps))]
        md.Add(x[empty] == 1); md.Add(x[full] == 0)
        for k, (r, e) in enumerate(reps):
            if e > B: md.Add(x[k] == 0)
        for c, d in down: md.AddImplication(x[c], x[d])
        for mk in conds:
            md.Add(sum(mk[k] * x[k] for k in range(len(reps)) if reps[k][1] > 0) == 1)
        s = cp_model.CpSolver(); s.parameters.max_time_in_seconds = 120
        st = s.Solve(md)
        if st in (cp_model.OPTIMAL, cp_model.FEASIBLE): return B
        if st != cp_model.INFEASIBLE: return f'>={B}?'
    return None
tt = [g for g in groups if g[1]]
out = [f"n = {N}: {len(reps)} graph classes, {len(groups)} subgroup classes, {len(tt)} trivial-top Oliver"]
out.append(f"M*_OCR({N}) = {least_B([g[3] for g in tt])}")
per = [(least_B([g[3]]), g[0], g[2]) for g in tt]
out.append(f"per trivial-top class (least B, |G|, transitive): {sorted(per, key=lambda t: (-t[0] if isinstance(t[0], int) else 0))}")
out.append(f"max over trivial-top classes = {max(t[0] for t in per if isinstance(t[0], int))}")
open(f'../outputs/burnside_ocr_{N}.txt', 'w').write('\n'.join(out) + '\n'); print('\n'.join(out))

# Minimal infeasible subsystem at B = (M*_OCR - 1): which trivial-top classes jointly force the jump.
def feasible(conds, B):
    md = cp_model.CpModel(); x = [md.NewBoolVar(f'x{k}') for k in range(len(reps))]
    md.Add(x[empty] == 1); md.Add(x[full] == 0)
    for k, (r, e) in enumerate(reps):
        if e > B: md.Add(x[k] == 0)
    for c, d in down: md.AddImplication(x[c], x[d])
    for mk in conds: md.Add(sum(mk[k] * x[k] for k in range(len(reps)) if reps[k][1] > 0) == 1)
    s = cp_model.CpSolver(); s.parameters.max_time_in_seconds = 120
    return s.Solve(md) in (cp_model.OPTIMAL, cp_model.FEASIBLE)
ocr = least_B([g[3] for g in tt])
if isinstance(ocr, int) and ocr > 1:
    keep = list(range(len(tt)))
    for i in list(keep):
        trial = [j for j in keep if j != i]
        if not feasible([tt[j][3] for j in trial], ocr - 1): keep = trial
    gi = [i for i, g in enumerate(groups) if g[1]]          # position among all subgroup classes (GAP order)
    line = f"minimal set of trivial-top classes forcing e_max >= {ocr} (|G|, transitive, GAP class index): " + str([(tt[j][0], tt[j][2], gi[j] + 1) for j in keep])
    with open(f'../outputs/burnside_ocr_{N}.txt', 'a') as fh: fh.write(line + '\n')
    print(line)
