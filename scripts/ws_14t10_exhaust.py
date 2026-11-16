#!/usr/bin/env python3
"""ws_14t10_exhaust.py -- every Oliver-chi-resistant 14T10 = PSL(3,2)-invariant monotone property on 14 points
(the battery of ws_level2_battery.py, all solutions enumerated by CP-SAT), then the exact decision-tree
complexity of each by dtree.c.  Non-evasive implies Oliver-chi-resistant, so D = 14 throughout settles 14T10.
Needs /tmp/ws/g14.txt (ws_level2_battery.g) and gcc."""
import subprocess, os
subprocess.check_call(['gcc','-O2','-o','/tmp/ws/dtree',os.path.join(os.path.dirname(os.path.abspath(__file__)),'dtree.c')])
src=open(os.path.join(os.path.dirname(os.path.abspath(__file__)),'ws_level2_battery.py')).read().split("    print(f\"14T{k}:")[0]
exec(src.replace("for k in (10, 30):","for k in (10,):"))
# enumerate all battery solutions for 14T10
M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in range(nv)]
M.Add(X[orb[0]] == 1); M.Add(X[orb[FULL]] == 0)
for v, S in enumerate(reps):
    for i in range(N):
        if S >> i & 1: M.AddImplication(X[v], X[orb[S ^ (1 << i)]])
for order, exact, qs, orbs in Hs:
    t = len(orbs); masks = [sum(1 << x for x in o) for o in orbs]; terms = {}
    for F in range(1, 1 << t):
        S = sum(masks[j] for j in range(t) if F >> j & 1)
        terms[orb[S]] = terms.get(orb[S], 0) + (1 if bin(F).count('1') % 2 else -1)
    chi = sum(c * X[v] for v, c in terms.items())
    if exact: M.Add(chi == 1)
    for q in qs:
        z = M.NewIntVar(-10 ** 6, 10 ** 6, ''); M.Add(chi == 1 + q * z)
class CB(cp_model.CpSolverSolutionCallback):
    def __init__(s): super().__init__(); s.sols=[]
    def on_solution_callback(s): s.sols.append([s.Value(x) for x in X])
S=cp_model.CpSolver(); S.parameters.enumerate_all_solutions=True; S.parameters.max_time_in_seconds=600
cb=CB(); r=S.Solve(M,cb); print('status',S.StatusName(r),'solutions',len(cb.sols))
import pickle; pickle.dump((reps,orb,cb.sols),open('/tmp/ws/sols10.pkl','wb'))
import pickle
reps,orb,sols=pickle.load(open("/tmp/ws/sols10.pkl","rb"))
from concurrent.futures import ThreadPoolExecutor
N=14
def tt(sol):
    return ''.join('1' if sol[orb[m]] else '0' for m in range(1<<N))
def D(sol):
    r=subprocess.run(['/tmp/ws/dtree'],input=f"{N}\n{tt(sol)}\n",capture_output=True,text=True)
    return int(r.stdout.strip())
with ThreadPoolExecutor(2) as ex: Ds=list(ex.map(D,sols))
from collections import Counter
print('properties',len(sols),'D distribution',sorted(Counter(Ds).items()),'non-evasive (D<14):',sum(d<N for d in Ds))
