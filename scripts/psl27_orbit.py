import itertools, sys, time
from collections import defaultdict
exec(open('psl27.py').read().split('# ---- the involution-quotient')[0])
from orbitsearch import closure_masks, chi, chi_link, betti_mod, nonevasive
def coset_space(K):
    cos={}; pts=[]
    for g in G:
        c=frozenset(mul(g,k) for k in K)
        if c not in cos: cos[c]=len(pts); pts.append(c)
    act={x: tuple(cos[frozenset(mul(x,g) for g in c)] for c in pts) for x in G}
    return pts,act
def face_types(K):
    pts,act=coset_space(K); n=len(pts); types={}
    for H in subs:
        if len(H) in (1,168): continue
        for p in range(n):
            f=frozenset(act[h][p] for h in H)
            if len(f)<=1 or len(f)==n: continue
            orb=frozenset(frozenset(act[x][v] for v in f) for x in G)
            types.setdefault(orb,(len(H),len(f),len(orb)))
    return n,act,types
def search(Korder, maxk, limit, maxface=8):
    K=next(H for H in subs if len(H)==Korder)
    n,act,types=face_types(K)
    T=[t for t in types if types[t][1]<=maxface]
    summ=defaultdict(int)
    for t in types: summ[types[t]]+=1
    print(f"|G/K|={n}: {len(types)} face-orbit types, {len(T)} with face size <= {maxface}:",dict(sorted(summ.items())))
    full=(1<<n)-1; t0=time.time(); st=defaultdict(int)
    for k in range(1,maxk+1):
        for combo in itertools.combinations(range(len(T)),k):
            if time.time()-t0>limit: print("  time limit at k =",k); return
            F=closure_masks([T[i] for i in combo])
            if full in F: continue
            st['tried']+=1
            if chi(F)!=1: continue
            st['chi1']+=1
            if chi_link(F)!=1: continue
            st['link1']+=1
            if any(betti_mod(F,n,2)): st['F2fail']+=1; continue
            if any(betti_mod(F,n,3)) or any(betti_mod(F,n,7)): st['F37fail']+=1; continue
            st['acyclic237']+=1
            desc=[types[T[i]] for i in combo]
            try:
                ne=nonevasive(F,n,time.time()+20)
                print(f"  {desc}: {len(F)} faces, acyclic mod 2,3,7 -> {'NONEVASIVE <== COUNTEREXAMPLE' if ne else 'EVASIVE'}")
            except TimeoutError:
                print(f"  {desc}: {len(F)} faces, acyclic mod 2,3,7 -> NE recursion TIMEOUT (candidate!)")
    print(f"  up to {maxk} types: {dict(st)} ({time.time()-t0:.0f}s)")
if __name__=="__main__":
    search(int(sys.argv[1]),int(sys.argv[2]),float(sys.argv[3]),int(sys.argv[4]) if len(sys.argv)>4 else 8)
