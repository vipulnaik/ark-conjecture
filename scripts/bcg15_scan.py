#!/usr/bin/env python3
"""bcg15_scan.py -- where Hypothesis (BCG_{1/5}) of the short note holds.

For each n in [6, N] decide whether there are primes q, r, c with
  1. n = c + r (n even) or n = 2c + r (n odd),
  2. c >= n/5 and r >= n/5,
  3. r = d*q + 1 for some d in {2, 4, 6, 12},
  4. r does not divide c - 1,
exactly as the note states them, and report the n at which there are none.

Usage: python3 bcg15_scan.py N        (N = 120000 takes about two minutes)

Run of 2026-11-10 at N = 120000: 26 failures, the last at n = 6179; 22 of them
at n = 7 or 11 (mod 12), two of the four classes with a single admissible d.
The hypothesis is eventual, so the failures are not counterexamples to it.
"""
import numpy as np, sys
N=int(sys.argv[1])
s=np.ones(N+1,bool); s[:2]=False
for i in range(2,int(N**.5)+1):
    if s[i]: s[i*i::i]=False
isR=np.zeros(N+1,bool)
for d in (2,4,6,12):
    q=np.nonzero(s)[0]; r=d*q+1; r=r[r<=N]; isR[r[s[r]]]=True
fails=[]; mincnt=(10**9,0); small=[]
for n in range(6,N+1):
    lo=-(-n//5)
    if n%2==0:
        hi=n-lo                      # c=n-r>=n/5
        r=np.arange(lo,hi+1); c=n-r
    else:
        hi=n-2*lo
        r=np.arange(lo,hi+1); r=r[(n-r)%2==0]; c=(n-r)//2
    if len(r)==0: fails.append(n); continue
    ok=isR[r]&s[c]
    if ok.any():
        rr=r[ok]; cc=c[ok]; ok2=((cc-1)%rr!=0)
        k=int(ok2.sum())
    else: k=0
    if k==0: fails.append(n)
    elif n>1000 and k<mincnt[0]: mincnt=(k,n)
print("N",N,"failures:",len(fails),"last:",fails[-12:])
print("least number of representations for 1000<n<=N:",mincnt)
by={}
for n in fails: by[n%12]=by.get(n%12,0)+1
print("failures by class mod 12:",dict(sorted(by.items())))
