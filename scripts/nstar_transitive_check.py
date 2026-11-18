"""nstar_transitive_check.py -- for every soluble transitive group of degree n (files from
nstar_transitive_check.g), the type totals (orbits of N* on pairs, nauty on
points--pairs--orbitals), and m*_typ against fact 8 of orbital-evasiveness-notes.md 7.2,
n(q(n) - 1)/2.  Tests Conjecture P of threshold-beyond-mu.md §6.3.
Run with python3 -I (the file name must not shadow a stdlib module)."""
import sys, json, itertools, math, pynauty
from collections import Counter
def qn(n):
    best=1
    for p in range(2,n+1):
        if n%p==0 and all(p%d for d in range(2,p)):
            pk=1
            while n%(pk*p)==0: pk*=p
            best=max(best,pk)
    return best
for n in ([int(x) for x in sys.argv[1:]] or [6,10,12,14,15,18,20,21,22,26,28,30]):
    PAIRS=list(itertools.combinations(range(1,n+1),2)); PID={p:i for i,p in enumerate(PAIRS)}; NP=len(PAIRS)
    d0=0.25 if n%2==0 else 3-2*math.sqrt(2); C=n*(n-1)//2; q=qn(n); f8=n*(q-1)//2
    worst=0; arg=None; over=[]; cnt=0
    for line in open(f'/tmp/g/tr{n}.txt'):
        i,s=line.split('|',1); orbs=json.loads(s.replace(' ',''))
        t=len(orbs); adj={v:[] for v in range(n+NP+t)}
        for (a,b),k in PID.items(): adj[a-1].append(n+k); adj[b-1].append(n+k)
        for j,o in enumerate(orbs):
            for e in o: adj[n+PID[tuple(e)]].append(n+NP+j)
        g=pynauty.Graph(n+NP+t,adjacency_dict=adj,vertex_coloring=[set(range(n)),set(range(n,n+NP)),set(range(n+NP,n+NP+t))])
        orbits=pynauty.autgrp(g)[3]
        tot=Counter()
        for j,o in enumerate(orbs): tot[orbits[n+NP+j]]+=len(o)
        m=min(tot.values()); cnt+=1
        if m>worst: worst,arg=m,int(i)
        if m>f8: over.append((int(i),m,len(tot)))
    print(f"n={n}: {cnt} solvable transitive; max m*_typ = {worst} (T{n},{arg}), {worst/C:.3f} of C(n,2); fact-8 bound n(q-1)/2 = {f8}; "
          f"delta_cyc*C = {d0*C:.1f}; groups above the fact-8 bound: {over[:8]}{' ...' if len(over)>8 else ''} ({len(over)})",flush=True)
