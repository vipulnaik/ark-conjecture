"""J0a' data point (general-k-note.md §1): at c = 25, k = 3, the non-semilinear 2-group C4 wr C2 <= GL(2,5)
(order 32 > the 2-part 16 of GammaL(1,25)) has least 3-orbit 100, against 200 for AGammaL(1,25)."""
from itertools import combinations
from collections import Counter
p=5
pts=[(x,y) for x in range(p) for y in range(p)]
ix={v:i for i,v in enumerate(pts)}; N=len(pts)
def mk(f): return [ix[f(v)] for v in pts]
gens=[mk(lambda v:((v[0]+1)%p,v[1])), mk(lambda v:(v[0],(v[1]+1)%p)),
      mk(lambda v:((2*v[0])%p,v[1])), mk(lambda v:(v[0],(2*v[1])%p)), mk(lambda v:(v[1],v[0]))]
def orbits(gens,k=3):
    sets=list(combinations(range(N),k)); idx={s:i for i,s in enumerate(sets)}; par=list(range(len(sets)))
    def find(x):
        while par[x]!=x: par[x]=par[par[x]]; x=par[x]
        return x
    for i,s in enumerate(sets):
        for g in gens:
            a,b=find(i),find(idx[tuple(sorted(g[v] for v in s))])
            if a!=b: par[a]=b
    return sorted(Counter(find(i) for i in range(len(sets))).values())
print("wreath C4wrC2 on F_5^2: 3-orbits", orbits(gens)[:5])
# AGammaL(1,25): F_25 = F_5[i], i^2 = 2 (non-residue mod 5)
def mul(a,b): return ((a[0]*b[0]+2*a[1]*b[1])%p,(a[0]*b[1]+a[1]*b[0])%p)
# find generator of F_25^*
def order(z):
    k,w=1,z
    while w!=(1,0): w=mul(w,z); k+=1
    return k
g=next(z for z in pts if z!=(0,0) and order(z)==24)
fro=lambda v:(v[0],(-v[1])%p)   # frobenius x->x^5 : a+b i -> a - b i
gens2=[mk(lambda v:((v[0]+1)%p,v[1])), mk(lambda v:(v[0],(v[1]+1)%p)), mk(lambda v:mul(g,v)), mk(fro)]
print("AGammaL(1,25): 3-orbits", orbits(gens2)[:5])
