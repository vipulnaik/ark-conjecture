#!/usr/bin/env python3
# cyclic_chi_one_small_faces.py -- L(k) directly: is there a C_k-invariant complex on Z_k with every face of at most
# (k-1)/2 points and chi = 1?  CP-SAT over orbit classes of faces, down-closure.  usage: python3 cyclic_chi_one_small_faces.py k
import itertools, sys
from ortools.sat.python import cp_model
k=int(sys.argv[1]); J=(k-1)//2
faces=[frozenset(c) for j in range(1,J+1) for c in itertools.combinations(range(k),j)]
orb={}; rep=[]
for f in faces:
    if f in orb: continue
    o=[frozenset((x+s)%k for x in f) for s in range(k)]
    i=len(rep); rep.append((f,len(set(o))))
    for g in o: orb[g]=i
M=cp_model.CpModel(); X=[M.NewBoolVar('') for _ in rep]
for i,(f,sz) in enumerate(rep):
    if len(f)>1:
        for x in f: M.AddImplication(X[i], X[orb[f-{x}]])
M.Add(sum((1 if len(f)%2 else -1)*sz*X[i] for i,(f,sz) in enumerate(rep))==1)
S=cp_model.CpSolver(); S.parameters.max_time_in_seconds=1500; S.parameters.num_workers=2
st=S.Solve(M); print(k, J, len(rep), S.StatusName(st))
if st in (cp_model.OPTIMAL,cp_model.FEASIBLE):
    mx=[sorted(f) for i,(f,sz) in enumerate(rep) if S.Value(X[i])]
    print(' faces (orbit reps):', len(mx), 'sizes', sorted(len(f) for f in mx)[-5:])
