"""The reducible (imprimitive, = fused 2 x c/2) block F_2 + F_{2^(a-1)} with H = AGammaL(1, 2^(a-1)) acting by
(t, x) -> (t, a*sigma(x) + b*t).  Least 3-orbit 2 * min3(AGammaL(1, 2^(a-1))), against AGammaL(1, 2^a).
    python3 j0a_p2_family.py 4 5 6 7
"""
import sys
from itertools import combinations
from collections import Counter
POLY={3:0b1011,4:0b10011,5:0b100101,6:0b1000011,7:0b10000011}
def mk(a):
    P=POLY[a]
    def m(x,y):
        r=0
        for i in range(a):
            if y>>i&1: r^=x<<i
        for i in range(2*a-2,a-1,-1):
            if r>>i&1: r^=P<<(i-a)
        return r
    return m
def orbits3(N,gens):
    sets=list(combinations(range(N),3)); idx={s:i for i,s in enumerate(sets)}
    par=list(range(len(sets)))
    def find(x):
        while par[x]!=x: par[x]=par[par[x]]; x=par[x]
        return x
    for i,s in enumerate(sets):
        for g in gens:
            a,b=find(i),find(idx[tuple(sorted(g[v] for v in s))])
            if a!=b: par[a]=b
    return min(Counter(find(i) for i in range(len(sets))).values())
for a in map(int,sys.argv[1:]):
    b=a-1; q=2**b; m=mk(b); c=2*q
    pts=[(t,x) for t in range(2) for x in range(q)]
    P=lambda t,x:q*t+x
    def g(f): return [P(*f(t,x)) for t,x in pts]
    gens=[g(lambda t,x:(t^1,x))]+[g(lambda t,x,i=i:(t,x^(1<<i))) for i in range(b)]+[g(lambda t,x:(t,m(2,x))),g(lambda t,x:(t,x^t)),g(lambda t,x:(t,m(x,x)))]
    M=mk(a)
    g2=[[x^1 for x in range(c)],[M(2,x) for x in range(c)],[M(x,x) for x in range(c)]]
    print(f"c={c}: F2+F_{q} with AGammaL(1,{q}): min3 {orbits3(c,gens)}; AGammaL(1,{c}): {orbits3(c,g2)}",flush=True)
