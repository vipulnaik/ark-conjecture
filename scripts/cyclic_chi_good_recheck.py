"""Recheck of the CP-SAT GOOD verdicts in outputs/cyclic_chi_modq.txt with a second solver
(HiGHS via scipy.milp) and orbit code written afresh: is there a C_k-invariant proper
complex on Z/k with chi = 1 (mod q)?  (10, 41) and (11, 73) are feasible controls.
Session-log-17 Part 12.  usage: python3 cyclic_chi_good_recheck.py"""
import numpy as np, sys
from scipy.optimize import milp, LinearConstraint, Bounds
def orbs(k):
    full=(1<<k)-1; rot=lambda x:((x<<1)|(x>>(k-1)))&full
    seen={}; R=[]
    for x in range(1,full):          # proper nonempty subsets only
        if x in seen: continue
        o=[x]; y=rot(x)
        while y!=x: o.append(y); y=rot(y)
        for z in o: seen[z]=len(R)
        R.append((x,len(o)))
    return seen,R
def check(k,q):
    seen,R=orbs(k); n=len(R)
    rows=[];lo=[];hi=[]
    for i,(r,s) in enumerate(R):
        for b in range(k):
            if r>>b&1 and r^(1<<b):
                j=seen[r^(1<<b)]; v=np.zeros(n+1); v[i]=1; v[j]-=1; rows.append(v); lo.append(-np.inf); hi.append(0)
    w=np.array([s if bin(r).count('1')%2 else -s for r,s in R]+[-q],float)
    rows.append(w); lo.append(1); hi.append(1)
    A=np.array(rows)
    res=milp(np.zeros(n+1),constraints=LinearConstraint(A,lo,hi),integrality=np.ones(n+1),
             bounds=Bounds([0]*n+[-1e6],[1]*n+[1e6]))
    return res.status, res.message
for k,q in [(10,107),(10,131),(10,137),(10,173),(10,179),(10,191),(11,103),(11,151),(10,41),(11,73)]:
    st,msg=check(k,q); print(k,q,'feasible' if st==0 else 'infeasible' if st==2 else msg,flush=True)
