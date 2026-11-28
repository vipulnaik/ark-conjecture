"""Exact least 3-orbits of the S9 (F = 2) witnesses in three-uniform-note.md §4.2 (n = 63, 65, 221).
n = 78 (a 32-block, GF(32) arithmetic) is in s9_witness_78.py."""
import sys
from itertools import combinations
from collections import Counter
def check(c, d_gen, r, t_mult, label):
    # c prime matching block with multiplier d_gen; two r-blocks fused, swap, diagonal translation, diagonal multiplier
    N=c+2*r
    P=lambda i,x: c+r*i+x
    def mk(f): return [f(p) for p in range(N)]
    def on_r(fn):
        def f(p):
            if p<c: return p
            i,x=divmod(p-c,r); return fn(i,x)
        return f
    gens=[mk(lambda p:(p+1)%c if p<c else p), mk(lambda p:(p*d_gen)%c if p<c else p),
          mk(on_r(lambda i,x:P(i,(x+1)%r))), mk(on_r(lambda i,x:P(1-i,x))),
          mk(on_r(lambda i,x:P(i,(x*t_mult)%r)))]
    sets=list(combinations(range(N),3)); idx={s:k for k,s in enumerate(sets)}
    par=list(range(len(sets)))
    def find(x):
        while par[x]!=x: par[x]=par[par[x]]; x=par[x]
        return x
    for k,s in enumerate(sets):
        for g in gens:
            a,b=find(k),find(idx[tuple(sorted(g[v] for v in s))])
            if a!=b: par[a]=b
    cnt=Counter(find(i) for i in range(len(sets)))
    m=min(cnt.values()); print(label,"n=",N,"min 3-orbit",m, "orbits",len(cnt))
def ordmult(g,mod):
    k,x=1,g%mod
    while x!=1: x=x*g%mod; k+=1
    return k
def elt(order,mod):
    for g in range(2,mod):
        if ordmult(g,mod)==order: return g
check(29, elt(28,29), 17, elt(16,17), "29+2x17 (expect 272)")
check(31, elt(30,31), 17, elt(16,17), "31+2x17 (expect 272)")
check(127, elt(63,127), 47, elt(23,47), "127+2x47 (expect 2162)")
