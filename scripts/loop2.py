import sys, os, time, pickle; sys.path.insert(0,os.path.dirname(os.path.abspath(__file__)))
from cegar import *
import warnings; warnings.filterwarnings("ignore")
TMAX=int(sys.argv[1]); BUDGET=float(sys.argv[2]); BATCH=8
t0=time.time(); G=load_groups(); st=pickle.load(open(ST,"rb")); T=st['T']; active=st['active']; sol=st['sol']; T.new=[]
def ok(g,c): return (c==1) if g['exact'] else all((c-1)%q==0 for q in g['qs'])
def save():
    pickle.dump(dict(T=T,active=active,sol=sol),open(ST,"wb"))
RESOLVE=float(os.environ.get("N10_RESOLVE_TIMEOUT","600"))
if isinstance(sol,str):
    print(f"saved state is {sol}; re-solving current stage (limit {RESOLVE:.0f}s, {WORKERS} workers)...",flush=True)
    for gi in active: G[gi]['U']=unions(G[gi])
    sol=solve(T,active,G,timeout=RESOLVE)
    for gi in active: G[gi].pop('U',None)
    save(); print("  re-solve:", sol if isinstance(sol,str) else f"feasible, {len(sol)} in P",flush=True)
rounds=0
while True:
    if isinstance(sol,str): print("INFEASIBLE/UNKNOWN at this stage:",sol); break
    maxs=[i for i in sol if not any(i in T.below[j] for j in sol if j!=i)]
    solset=set(sol); cache={}
    def member(mk):
        if mk in cache: return cache[mk]
        i=T.lookup(mk)
        cache[mk]=(i in solset) if i is not None else any(embeds(mk,T.reps[j]) for j in maxs)
        return cache[mk]
    bad=[]; checked=0; timed=False
    for gi,g in enumerate(G):
        if g['t']>TMAX or gi in active: continue
        U=unions(g); c=sum(sg for mk,sg in U if member(mk)); checked+=1
        if not ok(g,c): bad.append(gi)
        if len(bad)>=BATCH: break
        if time.time()-t0>BUDGET: timed=True; break
    if not bad:
        print(("TIME BUDGET HIT; checked %d groups, none violated so far"%checked) if timed else
              f"PASSES every group with t <= {TMAX} (all checked; {len(active)} active, {len(T.reps)} templates, {len(sol)} in P)"); break
    for gi in bad:
        active.append(gi)
        for mk,sg in unions(G[gi]): T.id(mk)
    T.close()
    for gi in active: G[gi]['U']=unions(G[gi])
    sol=solve(T,active,G,timeout=float(os.environ.get('N10_SOLVE_TIMEOUT','300')))
    for gi in active: G[gi].pop('U',None)
    rounds+=1; save()
    print(f"  round {rounds}: +{len(bad)} groups (t={sorted({G[b]['t'] for b in bad})}); {len(T.reps)} templates; "
          f"{'feasible, '+str(len(sol))+' in P' if not isinstance(sol,str) else sol}  [{time.time()-t0:.0f}s]",flush=True)
    if time.time()-t0>BUDGET: print("time budget reached after round; state saved"); break
