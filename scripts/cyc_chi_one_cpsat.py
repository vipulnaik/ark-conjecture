#!/usr/bin/env python3
"""cyc_chi_one_cpsat.py -- is there a C_m-invariant proper complex on m points with chi = 1?  Exact, by CP-SAT over
all C_m-orbits of proper subsets (closure as implications).  usage: python3 cyc_chi_one_cpsat.py m [m ...]
Result (outputs/cyc_chi_one.txt): m = 6, 10, 14, 15, 18, 20 no; m = 12 yes."""
import itertools, sys
from ortools.sat.python import cp_model
def orbits(m):
    seen=set(); orbs=[]
    for r in range(1,m):
        for f in itertools.combinations(range(m),r):
            if f in seen: continue
            o=frozenset(tuple(sorted((x+i)%m for x in f)) for i in range(m))
            seen|=o; orbs.append((r,f,o))
    return orbs
def feasible(m, target, orbs=None):
    orbs=orbs or orbits(m); idx={}
    for i,(r,f,o) in enumerate(orbs):
        for g in o: idx[g]=i
    M=cp_model.CpModel(); x=[M.NewBoolVar(f"x{i}") for i in range(len(orbs))]
    for i,(r,f,o) in enumerate(orbs):
        if r>1:
            for g in itertools.combinations(f,r-1): M.AddImplication(x[i], x[idx[g]])
    M.Add(sum((-1)**(r-1)*len(o)*x[i] for i,(r,f,o) in enumerate(orbs))==target)
    S=cp_model.CpSolver(); S.parameters.max_time_in_seconds=120; S.parameters.num_workers=8
    st=S.Solve(M)
    return {cp_model.OPTIMAL:True,cp_model.FEASIBLE:True,cp_model.INFEASIBLE:False}.get(st,None)
if __name__=="__main__":
    for m in map(int,sys.argv[1:]):
        orbs=orbits(m)
        print(m, len(orbs), "chi=1:", feasible(m,1,orbs), flush=True)
