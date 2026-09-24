#!/usr/bin/env python3
"""
metaproperty_ladder_check.py -- the named resistance metaproperties (orbital-evasiveness-notes.md section 7),
checked on every nontrivial monotone property at small n: exhaustive at n = 4, 5; random down-closures at n = 6.
Input: tom{n}.txt from oliver_tom.g, one Oliver subgroup class of S_n per line:
    order | transitive | exact | top primes | nontrivial-top primes | orbitals on pairs
Metaproperties (P monotone decreasing, empty graph in P, K_n not in P):
  OR     Oliver-resistant                    every Oliver group has an orbital in P
  VTOR   vertex-transitive Oliver-resistant  every transitive Oliver group has an orbital in P
  OCR    Oliver-chi-resistant                exact groups: chi = 1; others: chi = 1 mod each top prime
  TTR    trivial-top Oliver-chi-resistant    every exact (p-by-cyclic) group: chi = 1   [proved equal to OCR]
  NTR    nontrivial-top Oliver-chi-resist.   every group: chi = 1 mod each nontrivial-top prime
  VTOCR  vertex-transitive Oliver-chi-res.   OCR's condition on every transitive Oliver group
  GR     global-chi-resistant                chi(Delta_P) = 1
  SGR    small global-chi-resistant          chi(Delta_P) = 1 mod every prime p <= n
Also: every claimed implication, the Sylow form of SGR, and Alexander duality -- each metaproperty compared
between P and its dual P' = {G : complement of G not in P}.
USAGE   python3 metaproperty_ladder_check.py 5 all        python3 metaproperty_ladder_check.py 6 sample 1500
"""
import sys, json, itertools, random
import numpy as np
from collections import Counter
n=int(sys.argv[1]); mode=sys.argv[2] if len(sys.argv)>2 else "all"; samples=int(sys.argv[3]) if len(sys.argv)>3 else 0
path=sys.argv[4] if len(sys.argv)>4 else f"tom{n}.txt"
E=list(itertools.combinations(range(n),2)); eidx={e:i for i,e in enumerate(E)}; m=len(E); FULL=(1<<m)-1
masks=np.arange(1<<m,dtype=np.int64); canon=masks.copy()
for perm in itertools.permutations(range(n)):
    pe=[eidx[tuple(sorted((perm[u],perm[v])))] for u,v in E]
    img=np.zeros_like(masks)
    for i in range(m): img|=((masks>>i)&1)<<pe[i]
    canon=np.minimum(canon,img)
ids={c:i for i,c in enumerate(sorted(set(canon.tolist())))}
cls=np.array([ids[c] for c in canon.tolist()]); K=len(ids)
rep=np.zeros(K,dtype=np.int64)
for c,i in ids.items(): rep[i]=c
ecount=np.array([bin(int(r)).count("1") for r in rep]); labeled=np.bincount(cls,minlength=K)
empty=int(cls[0]); full=int(cls[FULL]); comp=np.array([int(cls[FULL^int(r)]) for r in rep])
below=[set() for _ in range(K)]
for i in range(K):
    r=int(rep[i]); s=r
    while True:
        below[i].add(int(cls[s]))
        if s==0: break
        s=(s-1)&r
primes=[p for p in range(2,n+1) if all(p%d for d in range(2,p))]
G=[]
for line in open(path):
    order,trans,exact,qs,ntq,orbs=line.rstrip("\n").split("|")
    orbs=[sum(1<<eidx[(e[0]-1,e[1]-1)] for e in o) for o in json.loads(orbs)]
    t=len(orbs); uc=[]; us=[]
    for T in range(1,1<<t):
        mk=0
        for j in range(t):
            if T>>j&1: mk|=orbs[j]
        uc.append(cls[mk]); us.append(bin(T).count("1"))
    G.append(dict(order=int(order),trans=(trans=="true"),exact=(exact=="true"),qs=json.loads(qs),ntq=json.loads(ntq),
                  single=[int(cls[o]) for o in orbs],uc=np.array(uc),sign=np.where(np.array(us)%2==1,1,-1)))
nf=1
for k in range(2,n+1): nf*=k
def ppart(p):
    x=nf; r=1
    while x%p==0: x//=p; r*=p
    return r
syl={p:[i for i,g in enumerate(G) if g['order']==ppart(p)] for p in primes}
def meta(Pset):
    inP=np.zeros(K,bool); inP[list(Pset)]=True
    chi=[int((g['sign']*inP[g['uc']]).sum()) for g in G]
    res=[any(inP[c] for c in g['single']) for g in G]
    ocr=[(c==1) if g['exact'] else all((c-1)%q==0 for q in g['qs']) for g,c in zip(G,chi)]
    ntr=[all((c-1)%q==0 for q in g['ntq']) for g,c in zip(G,chi)]
    glob=int(sum(labeled[i]*(-1)**(ecount[i]-1) for i in Pset if ecount[i]>0))
    M=dict(OR=all(res), VTOR=all(r for r,g in zip(res,G) if g['trans']),
           OCR=all(ocr), TTR=all(c==1 for c,g in zip(chi,G) if g['exact']), NTR=all(ntr),
           VTOCR=all(o for o,g in zip(ocr,G) if g['trans']), GR=(glob==1), SGR=all((glob-1)%p==0 for p in primes))
    M['sylow']=all(any((chi[i]-1)%p==0 for i in syl[p]) for p in primes)
    return M
def dual(Pset): return frozenset(i for i in range(K) if comp[i] not in Pset)
def downsets():
    order=sorted(range(K),key=lambda i:ecount[i])
    def rec(k,ch):
        if k==K: yield ch; return
        i=order[k]; yield from rec(k+1,ch)
        if below[i]-{i}<=ch: yield from rec(k+1,ch|{i})
    yield from rec(0,frozenset())
def props():
    if mode=="all":
        for D in downsets():
            if empty in D and full not in D: yield D
    else:
        rng=random.Random(7); pool=[i for i in range(K) if i!=full]
        for _ in range(samples):
            D=set()
            for g in rng.sample(pool,rng.randint(1,4)): D|=below[g]
            if full not in D: yield frozenset(D)
NAMES=["OR","VTOR","OCR","TTR","NTR","VTOCR","GR","SGR"]
IMPS=[("OCR","NTR"),("NTR","SGR"),("NTR","OR"),("OCR","OR"),("TTR","GR"),("GR","SGR"),("OR","VTOR"),
      ("OCR","VTOCR"),("VTOCR","VTOR")]
hold=Counter(); viol=Counter(); sep=Counter(); dualmis=Counter(); total=0
for D in props():
    total+=1; M=meta(D); Md=meta(dual(D))
    for k in NAMES: hold[k]+=M[k]; dualmis[k]+=(M[k]!=Md[k])
    if M['OCR']!=M['TTR']: viol['OCR<=>TTR']+=1
    if M['SGR']!=M['sylow']: viol['SGR<=>Sylow form']+=1
    for a,b in IMPS:
        if M[a] and not M[b]: viol[f"{a}=>{b}"]+=1
    for a in NAMES:
        for b in NAMES:
            if a!=b and M[a] and not M[b]: sep[(a,b)]+=1
print(f"n={n} ({mode}): {K} graph classes, {len(G)} Oliver groups ({sum(g['trans'] for g in G)} transitive), {total} nontrivial monotone properties")
print("  satisfying each:", dict((k,hold[k]) for k in NAMES))
print("  violations (implications, OCR<=>TTR collapse, Sylow form):", dict(viol) if viol else "NONE")
print("  P vs its dual, mismatches per metaproperty:", dict((k,dualmis[k]) for k in NAMES))
interesting=[("SGR","NTR"),("OR","NTR"),("NTR","GR"),("GR","NTR"),("VTOR","OR"),("VTOCR","OCR"),("VTOCR","NTR"),
             ("OR","GR"),("GR","OR"),("SGR","GR"),("GR","TTR"),("OR","OCR")]
print("  separations (holds / fails):", ", ".join(f"{a}/{b} {sep[(a,b)]}" for a,b in interesting))
