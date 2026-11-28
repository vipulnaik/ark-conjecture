"""Exact least 3-orbit of the n = 78 S9 witness (32 + 2x23*, q = 11): 506. three-uniform-note.md §4.2."""
from itertools import combinations
# points: 0..31 = F_32 block; 32+i*23+x for i in {0,1}, x in F_23
def gfmul(a,b):
    r=0
    for i in range(5):
        if b>>i&1: r^=a<<i
    for i in range(9,4,-1):
        if r>>i&1: r^=0b100101<<(i-5)
    return r
N=78
def P(i,x): return 32+23*i+x
gens=[]
gens.append([ (x^1) if x<32 else x for x in range(N)])            # translation F32
gens.append([ gfmul(2,x) if x<32 else x for x in range(N)])       # twist order 31
def tr(p):
    if p<32: return p
    i,x=divmod(p-32,23); return P(i,(x+1)%23)
gens.append([tr(p) for p in range(N)])                            # diagonal translation
def sw(p):
    if p<32: return p
    i,x=divmod(p-32,23); return P(1-i,x)
gens.append([sw(p) for p in range(N)])                            # swap
a=2  # order 11 mod 23
assert pow(a,11,23)==1
def mu(p):
    if p<32: return p
    i,x=divmod(p-32,23); return P(i,(a*x)%23)
gens.append([mu(p) for p in range(N)])
idx={}
sets=list(combinations(range(N),3))
for k,s in enumerate(sets): idx[s]=k
parent=list(range(len(sets)))
def find(x):
    while parent[x]!=x: parent[x]=parent[parent[x]]; x=parent[x]
    return x
for s in sets:
    for g in gens:
        t=tuple(sorted(g[v] for v in s))
        a1,b1=find(idx[s]),find(idx[t])
        if a1!=b1: parent[a1]=b1
from collections import Counter
cnt=Counter(find(i) for i in range(len(sets)))
sizes=sorted(cnt.values())
print("orbits",len(sizes),"min",sizes[:6])
# group order check
print("min orbit set example:")
m=min(cnt,key=cnt.get); print(sets[m], cnt[m])
