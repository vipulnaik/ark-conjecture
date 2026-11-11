#!/usr/bin/env python3
"""threshold_scan.py -- the sparse-evasiveness threshold with foreign blocks at
full capacity (`threshold-beyond-mu.md`), over the one-foreign shapes
n = F*c + r and the pure fused shapes n = F*c, for 6 <= n <= N.

A foreign block of prime size r under top prime q (twist t = the q-part of
r - 1, or t = 1 with trivial top) has k = C(r,2)/orb(r,t) cyclotomic
pair-orbitals.  Where k is 1, or k <= 7 with q outside the exact exceptional
set of `cyclic_chi_values.py`, or k in {8,...,11,13} with q > 2^k, the block is
scored C(r,2) in place of orb(r,t).

Prints: agreement of the OLD rule with the table (a check on this enumerator),
the old and new floors, and the number of rows that improve.

Usage: python3 threshold_scan.py N      (N = 4000 takes about ten minutes)
Run from scripts/; reads ../outputs/mu_table_ladder.csv.
"""
import sys, csv
from math import comb
from sympy import primerange, factorint, divisors
N=int(sys.argv[1])
BAD={1:set(),2:set(),3:{2},4:{3},5:{2,3},6:{2,5,7},7:{2,3,5,13}}
def good(k,q):                    # q=None: trivial top
    if k==1: return True
    if k in BAD: return q is None or q not in BAD[k]
    if k in (8,9,10,11,13): return q is None or q>2**k   # crude: |chi-1| <= 2^k
    return False
def orb(r,t):
    raw=r*t//2 if t%2==0 else r*t
    return min(raw,comb(r,2))
capold={}; capnew={}
for r in primerange(3,N):
    f=factorint(r-1); bo=orb(r,1); bn=bo
    opts=[(None,1)]+[(q,q**e) for q,e in f.items()]
    for q,t in opts:
        o=orb(r,t); bo=max(bo,o)
        k=comb(r,2)//o
        bn=max(bn, comb(r,2) if good(k,q) else o)
    capold[r]=bo; capnew[r]=bn
pp={}
for p in primerange(2,N):
    x=p
    while x<N: pp[x]=p; x*=p
T={int(r['n']):int(r['mu_bound']) for r in csv.DictReader(open('../outputs/mu_table_ladder.csv')) if int(r['n'])<=N}
def val(F,c,r,cap):
    t=[F*comb(c,2), F*c*r, cap]
    if F>1: t.append((F if F%2 else F//2)*c*c)
    return min(t)
res={}
primes=list(primerange(3,N))
for n in sorted(T):
    bo=bn=0; wn=None
    for F in divisors(n):                      # no foreign block
        c=n//F
        if c in pp and F>1:
            v=min(F*comb(c,2),(F if F%2 else F//2)*c*c); bo=max(bo,v); bn=max(bn,v)
    for r in primes:
        m=n-r
        if m<2: break
        for F in divisors(m):
            c=m//F
            if c in pp and pp[c]!=r:
                vo=val(F,c,r,capold[r]); vn=val(F,c,r,capnew[r])
                if vo>bo: bo=vo
                if vn>bn: bn=vn; wn=(F,c,r)
    res[n]=(bo,bn,wn)
over=[n for n in res if res[n][0]>T[n]]
eq=sum(1 for n in res if res[n][0]==T[n])
print("old rule, this one-foreign family vs table: equal at",eq,"of",len(res),"; exceeding the table (must be 0):",len(over))
C=lambda n: comb(n,2)
fo=min((T[n]/C(n),n) for n in res); fn=min((max(res[n][1],T[n])/C(n),n) for n in res)
print("floor of mu*/C(n,2):",fo,"  floor with foreign blocks at full capacity:",fn, res[fn[1]])
imp=sum(1 for n in res if res[n][1]>T[n])
print("rows improved:",imp,"of",len(res))
for n in (2759,2183):
    if n in res: print(n,T[n],res[n],round(max(res[n][1],T[n])/C(n),4))
for lo,hi in ((6,100),(100,1000),(1000,N)):
    if not any(lo<=n<hi for n in res): continue
    x=min((max(res[n][1],T[n])/C(n),n) for n in res if lo<=n<hi); print("min over [%d,%d):"%(lo,hi),x)
by={}
for n in res:
    if n>N//2: by.setdefault(n%12,[]).append(max(res[n][1],T[n])/C(n))
print("upper half, by class mod 12: max of new density:",{k:round(max(v),4) for k,v in sorted(by.items())})
