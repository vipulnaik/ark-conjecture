#!/usr/bin/env python3
"""ws_level1_filter.py -- for each Oliver subgroup H in /tmp/ws/lvl1.txt (from ws_level1_filter.g): is there an
N*_G(H)-invariant proper complex on H-orbits meeting H's condition (chi = 1 if exact, chi = 1 mod each q)?  If not,
every nontrivial monotone G-invariant function is evasive (threshold-beyond-mu.md section 13)."""
import json, itertools
from ortools.sat.python import cp_model
from collections import defaultdict
res=defaultdict(list)
for l in open('/tmp/ws/lvl1.txt'):
    m,k,order,exact,qs,sizes,gens=l.strip().split('|')
    exact=exact=='true'; qs=json.loads(qs); sizes=json.loads(sizes); gens=json.loads(gens)
    t=len(sizes); full=(1<<t)-1
    gens=[[x-1 for x in g] for g in gens]
    act=lambda g,F: sum(1<<g[i] for i in range(t) if F>>i&1)
    rep={}; reps=[]
    for F in range(1,full):
        if F in rep: continue
        orb={F}; st=[F]
        while st:
            x=st.pop()
            for g in gens:
                y=act(g,x)
                if y not in orb: orb.add(y); st.append(y)
        for y in orb: rep[y]=F
        reps.append((F,len(orb)))
    idx={F:i for i,(F,_) in enumerate(reps)}
    M=cp_model.CpModel(); X=[M.NewBoolVar('') for _ in reps]
    for i,(F,_) in enumerate(reps):
        for j in range(t):
            if F>>j&1 and F^(1<<j): M.AddImplication(X[i],X[idx[rep[F^(1<<j)]]])
    chi=sum((1 if bin(F).count('1')%2 else -1)*c*X[i] for i,(F,c) in enumerate(reps))
    if exact: M.Add(chi==1)
    for q in qs:
        z=M.NewIntVar(-10**6,10**6,''); M.Add(chi==1+q*z)
    S=cp_model.CpSolver(); S.parameters.max_time_in_seconds=60
    r=S.Solve(M)
    forced = r==cp_model.INFEASIBLE
    res[(m,k)].append((forced,int(order),t,sorted(sizes)))
for key,v in res.items():
    f=[x for x in v if x[0]]
    print(key, 'Oliver classes',len(v),' settle (no admissible invariant complex):',len(f), f[:3])
