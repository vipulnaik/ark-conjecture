#!/usr/bin/env python3
"""cyclic_chi_small.py -- is chi = 1 attainable by a C_k-invariant proper complex on k points
whose faces have at most S vertices?  CP-SAT over the C_k-orbits of faces.  A FEASIBLE answer
is a certificate (chi = 1 attainable at k, hence at every multiple of k by pull-back);
INFEASIBLE says nothing about larger faces.

Usage: python3 cyclic_chi_small.py k S [seconds]     e.g. 30 5 -> FEASIBLE (session-log-17 Part 9)
"""
from ortools.sat.python import cp_model
k=int(sys.argv[1]); S=int(sys.argv[2])
def canon(fs):
    return min(tuple(sorted((x+s)%k for x in fs)) for s in range(k))
orbs={}
for sz in range(1,S+1):
    for fs in itertools.combinations(range(k),sz):
        c=canon(fs)
        if c not in orbs: orbs[c]=0
        orbs[c]+=1
reps=list(orbs); idx={r:i for i,r in enumerate(reps)}
M=cp_model.CpModel(); X=[M.NewBoolVar(str(i)) for i in range(len(reps))]
for r in reps:
    if len(r)>1:
        for i in range(len(r)):
            sub=canon(r[:i]+r[i+1:]); M.AddImplication(X[idx[r]],X[idx[sub]])
M.Add(sum(((1 if len(r)%2 else -1)*orbs[r])*X[idx[r]] for r in reps)==1)
Sv=cp_model.CpSolver(); Sv.parameters.max_time_in_seconds=float(sys.argv[3]) if len(sys.argv)>3 else 120; Sv.parameters.num_workers=8
st=Sv.Solve(M); print(k,S,len(reps),Sv.StatusName(st))
if st in (cp_model.OPTIMAL,cp_model.FEASIBLE):
    ch=[r for r in reps if Sv.Value(X[idx[r]])]
    from collections import Counter
    print(Counter(len(r) for r in ch), Counter(orbs[r] for r in ch))
