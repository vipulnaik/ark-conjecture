#!/usr/bin/env python3
"""cyclic_chi_product.py -- certify chi = 1 on k points by the product construction
(session-log-17 Part 10).  For a coprime split k = a*b, Z/k = Z/a x Z/b, and nested proper
C_a-complexes A1 <= A2, C_b-complexes B1 <= B2, the complex
    X = P(A1, full_b)  u  P(full_a, B1)  u  P(A2, B2),   P(A,B) = {S : pi_a S in A, pi_b S in B},
is C_k-invariant and proper (A2, B2 not both full), and since chi(P(A,B)) = chi(A) chi(B)
(the simplicial product realises the product of spaces) chi(X) = 1 exactly when
    (a2 - a1)(b2 - b1) = (a1 - 1)(b1 - 1).
A-side: CP-SAT on a <= 11 points; B-side: graph chains (vertices plus edge orbits).
Checked by explicit face enumeration at k = 56 (5,839 faces, chi = 1).

Usage: python3 cyclic_chi_product.py      (the undecided k of mu_cyc_bounds.py below 2000; ~15 min)
"""
from math import gcd
from ortools.sat.python import cp_model
sys.path.insert(0, '.')
import mu_cyc_bounds as M
from sympy import primerange
def orbits(m):
    full=(1<<m)-1; rot=lambda x:((x<<1)|(x>>(m-1)))&full
    seen={};orbs=[]
    for x in range(1,full+1):
        if x in seen: continue
        o={x};y=rot(x)
        while y!=x: o.add(y);y=rot(y)
        for z in o: seen[z]=len(orbs)
        orbs.append((min(o),len(o)))
    return seen,orbs
_oc={}
def nested_solve(m, db, b1, tl=8):
    """A1 <= A2 C_m-complexes on m points, A1 proper, A2 proper or full (x2 of full var), with
       (a2-a1)*db == (a1-1)*(b1-1); returns (a1,a2) or None."""
    if m not in _oc: _oc[m]=orbits(m)
    seen,orbs=_oc[m]; full=seen[(1<<m)-1]
    Mo=cp_model.CpModel(); X1=[Mo.NewBoolVar('') for _ in orbs]; X2=[Mo.NewBoolVar('') for _ in orbs]
    Mo.Add(X1[full]==0)
    for i,(r,_) in enumerate(orbs):
        Mo.AddImplication(X1[i],X2[i])
        for b in range(m):
            if r>>b&1 and r^(1<<b):
                j=seen[r^(1<<b)]; Mo.AddImplication(X1[i],X1[j]); Mo.AddImplication(X2[i],X2[j])
    sg=lambda r:1 if bin(r).count('1')%2 else -1
    a1=sum(sg(r)*s*X1[i] for i,(r,s) in enumerate(orbs)); a2=sum(sg(r)*s*X2[i] for i,(r,s) in enumerate(orbs))
    Mo.Add((a2-a1)*db == (a1-1)*(b1-1))
    S=cp_model.CpSolver(); S.parameters.max_time_in_seconds=tl; S.parameters.num_workers=8
    r=S.Solve(Mo)
    if r in (cp_model.OPTIMAL,cp_model.FEASIBLE): return S.Value(a1),S.Value(a2),S.Value(X2[full])
    return None
def graph_pairs(m):
    sizes=[m if 2*d!=m else m//2 for d in range(1,m//2+1)]
    if m==2: sizes=[]
    pre=[0]
    for s in sizes: pre.append(pre[-1]+s)
    out=[]
    for i in range(len(pre)):
        for j in range(i,len(pre)):
            out.append((m-pre[i], m-pre[j]))
    out+= [(m-p,1) for p in pre]
    return out
def certify(k, AMAX=11):
    for a in sorted(d for d in range(2,AMAX+1) if k%d==0):
        b=k//a
        if gcd(a,b)!=1 or b > 2**a + 2: continue
        for (b1,b2) in graph_pairs(b):
            db=b2-b1
            res=nested_solve(a, db, b1)
            if res:
                a1,a2,a2full=res
                if a2full and b2==1: continue
                return (a,b,a1,a2,b1,b2)
    return None
ks=sorted({(r-1)//2 for r in primerange(5,4000) if M.status((r-1)//2,None)==M.UNK})
t=time.time(); done=0; fails=[]
for k in ks:
    c=certify(k)
    print(k, c, flush=True)
    if c: done+=1
    else: fails.append(k)
print(len(ks), "certified", done, "time", round(time.time()-t), "fails", fails[:40], len(fails))
