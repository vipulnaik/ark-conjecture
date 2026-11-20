#!/usr/bin/env python3
# cyclic_small_face_chis.py -- V(m): every chi of a C_m-invariant complex on Z_m with faces of at most (m-1)/2 points
# (one CP-SAT feasibility call per candidate value).  Writes /tmp/vsets.json.
import itertools, sys, json
from ortools.sat.python import cp_model
def model(m):
    J=(m-1)//2
    faces=[frozenset(c) for j in range(1,J+1) for c in itertools.combinations(range(m),j)]
    orb={}; rep=[]
    for f in faces:
        if f in orb: continue
        o={frozenset((x+s)%m for x in f) for s in range(m)}
        i=len(rep); rep.append((f,len(o)))
        for g in o: orb[g]=i
    return rep, orb
def vset(m):
    rep,orb=model(m)
    lo=-sum(sz for f,sz in rep if len(f)%2==0); hi=sum(sz for f,sz in rep if len(f)%2)
    out=[]
    for c in range(lo,hi+1):
        M=cp_model.CpModel(); X=[M.NewBoolVar('') for _ in rep]
        for i,(f,sz) in enumerate(rep):
            if len(f)>1:
                for x in f: M.AddImplication(X[i], X[orb[f-{x}]])
        M.Add(sum((1 if len(f)%2 else -1)*sz*X[i] for i,(f,sz) in enumerate(rep))==c)
        S=cp_model.CpSolver(); S.parameters.max_time_in_seconds=60; S.parameters.num_workers=2
        st=S.Solve(M)
        if st in (cp_model.OPTIMAL,cp_model.FEASIBLE): out.append(c)
        elif st!=cp_model.INFEASIBLE: out.append(('?',c))
    return out
R={}
for m in [1,3,5,7,9,11,13]:
    if m==1: R[m]=[0]; continue
    R[m]=vset(m); print(m, R[m] if len(R[m])<40 else (len(R[m]), R[m][:10], R[m][-5:]), flush=True)
json.dump(R,open('/tmp/vsets.json','w'))
