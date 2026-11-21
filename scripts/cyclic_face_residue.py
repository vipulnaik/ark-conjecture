#!/usr/bin/env python3
"""cyclic_face_residue.py -- R(m, J, l): is there a complex on m points, invariant under C_m acting regularly,
with every face of at most J points, whose chi is = 1 (mod l)?  (l = 0 means chi = 1 exactly.)
CP-SAT over orbit classes of faces with down-closure.  Used by three_p_coverage.py and two_p_nlevel_coverage.py."""
import itertools, functools
from ortools.sat.python import cp_model

@functools.lru_cache(None)
def classes(m, J):
    orb, rep = {}, []
    for j in range(1, J + 1):
        for c in itertools.combinations(range(m), j):
            f = frozenset(c)
            if f in orb: continue
            o = {frozenset((x + s) % m for x in f) for s in range(m)}
            for g in o: orb[g] = len(rep)
            rep.append((f, len(o)))
    return rep, orb

@functools.lru_cache(None)
def R(m, J, l):
    """True if such a complex exists (chi = 1 mod l), False if none, None if undecided."""
    J = min(J, m - 1)
    if J <= 0: return (0 - 1) % l == 0 if l else False        # only the empty complex: chi = 0
    rep, orb = classes(m, J)
    M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in rep]
    for i, (f, sz) in enumerate(rep):
        if len(f) > 1:
            for x in f: M.AddImplication(X[i], X[orb[f - {x}]])
    chi = sum((1 if len(f) % 2 else -1) * sz * X[i] for i, (f, sz) in enumerate(rep))
    if l: z = M.NewIntVar(-10**7, 10**7, ''); M.Add(chi == 1 + l * z)
    else: M.Add(chi == 1)
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 120; S.parameters.num_workers = 2
    st = S.Solve(M)
    return {cp_model.OPTIMAL: True, cp_model.FEASIBLE: True, cp_model.INFEASIBLE: False}.get(st, None)
