import json, sys, itertools
from collections import Counter
m=int(sys.argv[1]); gens=[[x-1 for x in g] for g in json.loads(open(sys.argv[2]).read().replace("\n",""))]
primes_G=json.loads(sys.argv[4])
G=[]
for line in open(sys.argv[3]):
    order,exact,qs,ntq,orbs=line.rstrip("\n").split("|")
    G.append(dict(order=int(order),exact=exact=="true",qs=json.loads(qs),ntq=json.loads(ntq),orbs=[sum(1<<(v-1) for v in o) for o in json.loads(orbs)]))
def apply(g,mask):
    r=0
    for i in range(m):
        if mask>>i&1: r|=1<<g[i]
    return r
orbit_of={}; orbits=[]
for mk in range(1<<m):
    if mk in orbit_of: continue
    O={mk}; fr=[mk]
    while fr:
        nf=[]
        for x in fr:
            for g in gens:
                y=apply(g,x)
                if y not in O: O.add(y); nf.append(y)
        fr=nf
    k=len(orbits); orbits.append(sorted(O))
    for x in O: orbit_of[x]=k
K=len(orbits); size=[bin(o[0]).count("1") for o in orbits]
below=[set() for _ in range(K)]
for k,o in enumerate(orbits):
    r=o[0]; s=r
    while True:
        below[k].add(orbit_of[s])
        if s==0: break
        s=(s-1)&r
for g in G:
    t=len(g['orbs']); U=[]
    for T in range(1,1<<t):
        mk=0
        for j in range(t):
            if T>>j&1: mk|=g['orbs'][j]
        U.append((1 if bin(T).count("1")%2 else -1, orbit_of[mk]))
    g['U']=U; g['single']=[orbit_of[o] for o in g['orbs']]
empty=orbit_of[0]; full=orbit_of[(1<<m)-1]
triv=[g for g in G if g['order']==1][0]
def meta(ch):
    chi={id(g):sum(s for s,u in g['U'] if u in ch) for g in G}
    c0=chi[id(triv)]
    OR = all(any(u in ch for u in g['single']) for g in G)
    OCR= all((chi[id(g)]==1) if g['exact'] else all((chi[id(g)]-1)%q==0 for q in g['qs']) for g in G)
    NTR= all(all((chi[id(g)]-1)%q==0 for q in g['ntq']) for g in G if g['order']>1)
    GR = c0==1
    SGR= all((c0-1)%p==0 for p in primes_G)
    return dict(OR=OR,OCR=OCR,NTR=NTR,GR=GR,SGR=SGR)
order=sorted(range(K),key=lambda i:size[i]); res=[]
def rec(k,ch):
    if k==K:
        if empty in ch and full not in ch: res.append(meta(ch))
        return
    i=order[k]; rec(k+1,ch)
    if below[i]-{i}<=ch: rec(k+1,ch|{i})
sys.setrecursionlimit(10000); rec(0,frozenset())
N=len(res); names=["OR","OCR","NTR","GR","SGR"]
print(f"{N} nontrivial invariant functions;", {n:sum(r[n] for r in res) for n in names})
for a,b in [("OCR","NTR"),("NTR","SGR"),("NTR","OR"),("OCR","GR"),("GR","SGR")]:
    print(f"  proved {a} => {b}: violations {sum(r[a] and not r[b] for r in res)}")
print("  open in the graph case:")
for a,b in [("NTR","OCR"),("NTR","GR"),("GR","NTR")]:
    print(f"    {a} but not {b}: {sum(r[a] and not r[b] for r in res)}")
print("  also: GR but not OR:",sum(r['GR'] and not r['OR'] for r in res),"; OR but not GR:",sum(r['OR'] and not r['GR'] for r in res),"; SGR but not GR:",sum(r['SGR'] and not r['GR'] for r in res))
