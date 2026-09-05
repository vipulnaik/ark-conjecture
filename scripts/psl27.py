#!/usr/bin/env python3
"""PSL(2,7) = GL(3,2), order 168: the involution-quotient complex on the regular
set, and orbit complexes on its transitive sets.  Reuses orbitsearch's filters."""
import itertools, sys, time
from collections import defaultdict
# GL(3,2) acting on the 7 nonzero vectors of F_2^3 (as ints 1..7)
def matvec(M,v):
    out=0
    for i in range(3):
        b=0
        for j in range(3):
            if M[i][j] and (v>>j&1): b^=1
        if b: out|=1<<i
    return out
def perm_of(M): return tuple(matvec(M,v)-1 for v in range(1,8))
A=((0,1,0),(0,0,1),(1,0,1))          # companion matrix of x^3+x+1, order 7
B=((1,0,0),(0,0,1),(0,1,0))          # a transposition-like involution
def mul(p,q): return tuple(p[q[i]] for i in range(len(q)))
ident7=tuple(range(7))
G={ident7}; fr=[ident7]; gens=[perm_of(A),perm_of(B)]
while fr:
    nf=[]
    for g in fr:
        for h in gens:
            k=mul(h,g)
            if k not in G: G.add(k); nf.append(k)
    fr=nf
G=sorted(G); assert len(G)==168, len(G)
gidx={g:i for i,g in enumerate(G)}
def order(g):
    k,o=g,1
    while k!=ident7: k=mul(g,k); o+=1
    return o
inv=[g for g in G if order(g)==2]; print("involutions:",len(inv))
# subgroups by closing pairs (all subgroups of PSL(2,7) are 2-generated)
def gen_sub(gs):
    S={ident7}; f=[ident7]
    while f:
        nf=[]
        for g in f:
            for h in gs:
                k=mul(h,g)
                if k not in S: S.add(k); nf.append(k)
        f=nf
    return frozenset(S)
subs=set()
for a in G:
    for b in G:
        if gidx[b]<gidx[a]: continue
        subs.add(gen_sub([a,b]))
byorder=defaultdict(list)
for H in subs: byorder[len(H)].append(H)
print("subgroups by order:",{k:len(v) for k,v in sorted(byorder.items())})
# ---- the involution-quotient complex on the regular set (168 vertices) -----
# faces = S with all pairwise x^-1 y involutions  <=>  S subset of a left coset xV,
# V a Klein four-group (pairwise commuting involutions in a D8 Sylow generate C2^2)
kleins=[H for H in byorder[4] if all(order(h)<=2 for h in H)]
print("Klein four-groups:",len(kleins),"  (cyclic C4's:",len(byorder[4])-len(kleins),")")
def inverse(g):
    r=[0]*7
    for i,x in enumerate(g): r[x]=i
    return tuple(r)
faces=set()
for V in kleins:
    for x in G:
        coset=frozenset(gidx[mul(x,v)] for v in V)
        for k in range(1,5):
            for c in itertools.combinations(sorted(coset),k): faces.add(c)
fv=defaultdict(int)
for f in faces: fv[len(f)-1]+=1
chi=sum((-1)**d*fv[d] for d in fv)
print("involution complex: f =",[fv[d] for d in range(4)],"chi =",chi,"(needs 1; |G| =",len(G),")")
# shared edges between tetrahedra of different Klein groups = the fusion
tet=[frozenset(gidx[mul(x,v)] for v in V) for V in kleins for x in G]
tetset=set(tet); edges_in=defaultdict(int)
for t in tetset:
    for e in itertools.combinations(sorted(t),2): edges_in[e]+=1
print("edges lying in >1 tetrahedron (fusion):",sum(1 for e,c in edges_in.items() if c>1),"of",len(edges_in))
import numpy as np
def betti2(F,n):
    by=defaultdict(list)
    for f in F: by[len(f)-1].append(f)
    idx={d:{f:i for i,f in enumerate(sorted(v))} for d,v in by.items()}
    top=max(by)
    def rank(d):
        rows=idx.get(d-1,{}); cols=sorted(by[d])
        M=np.zeros((len(cols),len(rows)),dtype=np.uint8)
        for j,f in enumerate(cols):
            for k in range(len(f)):
                g=f[:k]+f[k+1:]
                if g in rows: M[j,rows[g]]^=1
        r=0
        for c in range(M.shape[1]):
            piv=np.nonzero(M[r:,c])[0]
            if len(piv)==0: continue
            p=r+piv[0]; M[[r,p]]=M[[p,r]]
            nz=np.nonzero(M[:,c])[0]
            for i in nz:
                if i!=r: M[i]^=M[r]
            r+=1
            if r==M.shape[0]: break
        return r
    rk={d:rank(d) for d in range(1,top+1)}
    return [ (len(by[d])-(rk.get(d,0) if d>=1 else 0)) - rk.get(d+1,0) - (1 if d==0 else 0) for d in range(top+1)]
print("involution complex reduced Betti over F2:",betti2(faces,168))
