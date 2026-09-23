#!/usr/bin/env python3
"""
metaproperty_ladder_check.py -- the five named resistance metaproperties (orbital-evasiveness-notes.md 7.1)
checked on every nontrivial monotone property at small n: exhaustive at n = 4, 5; random down-closures at n = 6.
Needs tom{n}.txt from oliver_tom.g (every Oliver subgroup class of S_n with its condition and orbitals).

USAGE   python3 metaproperty_ladder_check.py 5 all        python3 metaproperty_ladder_check.py 6 sample 1500
Reports: properties satisfying each metaproperty; violations of the claimed implications and of the Sylow
characterisation of small global-chi-resistance; counts and examples of each separation.
"""

import sys, json, itertools, random
import numpy as np
n=int(sys.argv[1]); mode=sys.argv[2] if len(sys.argv)>2 else "all"; samples=int(sys.argv[3]) if len(sys.argv)>3 else 0
E=list(itertools.combinations(range(n),2)); eidx={e:i for i,e in enumerate(E)}; m=len(E)
masks=np.arange(1<<m,dtype=np.int64)
canon=masks.copy()
for perm in itertools.permutations(range(n)):
    pe=[eidx[tuple(sorted((perm[u],perm[v])))] for u,v in E]
    img=np.zeros_like(masks)
    for i in range(m): img|=((masks>>i)&1)<<pe[i]
    canon=np.minimum(canon,img)
cls_of_canon={c:i for i,c in enumerate(sorted(set(canon.tolist())))}
cls=np.array([cls_of_canon[c] for c in canon.tolist()]); K=len(cls_of_canon)
rep=np.zeros(K,dtype=np.int64)
for c,i in cls_of_canon.items(): rep[i]=c
ecount=np.array([bin(int(r)).count("1") for r in rep]); labeled=np.bincount(cls,minlength=K)
empty=cls[0]; full=cls[(1<<m)-1]
below=[set() for _ in range(K)]                    # classes of subgraphs of each class
for i in range(K):
    r=int(rep[i]); s=r
    while True:
        below[i].add(int(cls[s]))
        if s==0: break
        s=(s-1)&r
primes=[p for p in range(2,n+1) if all(p%d for d in range(2,p))]
G=[]
for line in open(f"tom{n}.txt"):
    order,trans,tag,orbs=line.rstrip("\n").split("|")
    tag="exact" if tag=="exact" else json.loads(tag)
    orbs=[sum(1<<eidx[(e[0]-1,e[1]-1)] for e in o) for o in json.loads(orbs)]
    t=len(orbs); ucls=[]; usz=[]
    for T in range(1,1<<t):
        mk=0
        for j in range(t):
            if T>>j&1: mk|=orbs[j]
        ucls.append(cls[mk]); usz.append(bin(T).count("1"))
    G.append(dict(order=int(order),tag=tag,single=[int(cls[o]) for o in orbs],
                  ucls=np.array(ucls),sign=np.where(np.array(usz)%2==1,1,-1)))
nfact=1
for k in range(2,n+1): nfact*=k
def ppart(p):
    x=nfact; r=1
    while x%p==0: x//=p; r*=p
    return r
syl={p:[g for g in G if g['order']==ppart(p)] for p in primes}
def meta(Pset):
    inP=np.zeros(K,bool); inP[list(Pset)]=True
    chis=[int((g['sign']*inP[g['ucls']]).sum()) for g in G]
    OR=all(any(inP[c] for c in g['single']) for g in G)
    ok=[(c==1) if g['tag']=="exact" else all(c%q==1%q for q in g['tag']) for g,c in zip(G,chis)]
    OCR=all(ok); TTR=all(o for o,g in zip(ok,G) if g['tag']=="exact")
    glob=int(sum(labeled[i]*(-1)**(ecount[i]-1) for i in Pset if ecount[i]>0))
    GR=glob==1; SGR=all(glob%p==1%p for p in primes)
    sylow_ok=all(any(((int((g['sign']*inP[g['ucls']]).sum()))-1)%p==0 for g in syl[p]) for p in primes)
    return dict(OR=OR,OCR=OCR,TTR=TTR,GR=GR,SGR=SGR,sylow=sylow_ok,glob=glob)
def downsets():
    order=sorted(range(K),key=lambda i:ecount[i])
    def rec(k,chosen):
        if k==K:
            yield chosen; return
        i=order[k]
        yield from rec(k+1,chosen)
        if below[i]-{i}<=chosen: yield from rec(k+1,chosen|{i})
    yield from rec(0,frozenset())
def props():
    if mode=="all":
        for D in downsets():
            if empty in D and full not in D: yield D
    else:
        rng=random.Random(7); nonfull=[i for i in range(K) if i!=full]
        for _ in range(samples):
            gens=rng.sample(nonfull,rng.randint(1,4)); D=set()
            for g in gens: D|=below[g]
            if full not in D: yield frozenset(D)
from collections import Counter
C=Counter(); ex={}; viol=Counter(); total=0; hold=Counter()
imps=[("OCR","TTR"),("TTR","GR"),("GR","SGR"),("OCR","OR")]
for D in props():
    total+=1; M=meta(D)
    for key in ('OR','OCR','TTR','GR','SGR'): hold[key]+=M[key]
    for a,b in imps:
        if M[a] and not M[b]: viol[(a,b)]+=1
    if M['SGR']!=M['sylow']: viol[('SGR<=>sylow',)]+=1
    for a,b in [("TTR","OCR"),("GR","TTR"),("SGR","GR"),("OR","OCR"),("OR","GR"),("GR","OR"),("TTR","OR"),("OR","TTR")]:
        if M[a] and not M[b]:
            C[(a,b)]+=1; ex.setdefault((a,b),(sorted(int(ecount[i]) for i in D),M['glob']))
print(f"n={n} ({mode}): {K} graph classes, {len(G)} Oliver groups, {total} nontrivial monotone properties")
print("  properties satisfying each:",dict(hold))
print("  violations of claimed implications / of SGR <=> Sylow residues:",dict(viol) if viol else "NONE")
for (a,b) in [("TTR","OCR"),("GR","TTR"),("SGR","GR"),("OR","OCR"),("OR","GR"),("GR","OR"),("TTR","OR"),("OR","TTR")]:
    k=C.get((a,b),0)
    print(f"  {a:4s} but not {b:4s}: {k:6d}" + (f"   e.g. member edge-counts {ex[(a,b)][0][:12]}..., global chi {ex[(a,b)][1]}" if k else ""))
