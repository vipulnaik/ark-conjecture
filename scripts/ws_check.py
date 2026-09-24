import json, itertools, sys
import numpy as np
def load_groups(path):
    G=[]
    for line in open(path):
        parts=line.rstrip("\n").split("|")
        order,exact,qs=parts[:3]; orbs=parts[-1]; ntq=parts[3] if len(parts)==5 else "[]"
        G.append(dict(order=int(order),exact=(exact=="true"),qs=json.loads(qs),ntq=json.loads(ntq),orbs=[frozenset(o) for o in json.loads(orbs)]))
    return G
def fixed_chi(faceset,orbs):
    t=len(orbs); chi=0
    for k in range(1,t+1):
        for T in itertools.combinations(range(t),k):
            U=frozenset().union(*(orbs[i] for i in T))
            if U in faceset: chi+=(-1)**(k-1)
    return chi
def condition_ok(chi,g):
    return chi==1 if g['exact'] else all((chi-1)%q==0 for q in g['qs'])
def rank_mod(M,p):
    M=M.astype(np.int64)%p; r=0; R,C=M.shape
    for c in range(C):
        piv=np.nonzero(M[r:,c])[0]
        if len(piv)==0: continue
        k=r+piv[0]; M[[r,k]]=M[[k,r]]; M[r]=(M[r]*pow(int(M[r,c]),p-2,p))%p
        for i in np.nonzero(M[:,c])[0]:
            if i!=r: M[i]=(M[i]-M[i,c]*M[r])%p
        r+=1
        if r==R: break
    return r
def reduced_betti(faceset,p):
    by={}
    for f in faceset: by.setdefault(len(f)-1,[]).append(tuple(sorted(f)))
    D=max(by); idx={d:{f:i for i,f in enumerate(by[d])} for d in by}; rk={}
    for d in range(0,D+1):
        if d not in by or d-1 not in by: rk[d]=0; continue
        M=np.zeros((len(by[d-1]),len(by[d])),dtype=np.int64)
        for j,f in enumerate(by[d]):
            for k in range(len(f)): M[idx[d-1][f[:k]+f[k+1:]],j]=(-1)**k
        rk[d]=rank_mod(M,p)
    return {d:len(by.get(d,[]))-rk.get(d,0)-rk.get(d+1,0) for d in range(-1,D+1) if len(by.get(d,[]))-rk.get(d,0)-rk.get(d+1,0)}
if __name__=="__main__":
    faces={frozenset(f) for f in json.load(open("/tmp/g/rp2_faces.json"))}
    G=load_groups("/tmp/g/rp2_oliver.txt")
    allok=True
    for g in G:
        c=fixed_chi(faces,g['orbs']); ok=condition_ok(c,g); allok&=ok
        print(f"  Oliver subgroup of order {g['order']:2d}, orbits {[sorted(o) for o in g['orbs']]}: chi = {c:2d}  {'ok' if ok else 'FAILS'}")
    print("RP2_6 Oliver-chi-resistant for A5:", allok)
    for p in (2,3,5,1000003): print(f"  reduced Betti over F_{p}:", reduced_betti(faces,p) or "none (acyclic)")
