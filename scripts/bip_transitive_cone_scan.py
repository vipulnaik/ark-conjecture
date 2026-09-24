#!/usr/bin/env python3
"""
bip_transitive_cone_scan.py -- bipartiteness against every transitive Oliver group at n = 6, 10 (table of
marks) and 14, 18, 22 (transitive-groups library): chi of the fixed complex, the group's condition, and whether
the complex is a CONE (some orbital addable to every bipartite union -- contractible, so blind at every rung).
Result: all 481 groups resistant, all cones.   USAGE  python3 bip_transitive_cone_scan.py
"""
import sys, json
def bip_add(state, edges):
    p, r = state; p = p[:]; r = r[:]
    def find(x):
        par = 0
        while p[x] != x: par ^= r[x]; x = p[x]
        return x, par
    for u, v in edges:
        (a, pa), (b, pb) = find(u), find(v)
        if a == b:
            if pa == pb: return None
        else: p[a] = b; r[a] = pa ^ pb ^ 1
    return (p, r)
def faces(orbs, n, budget=400000):
    t=len(orbs); F=[]; stack=[(0,(list(range(n)),[0]*n),())]
    while stack:
        i,st,S=stack.pop()
        if i==t:
            if 0<len(S)<t: F.append(frozenset(S))
            if len(F)>budget: return None
            continue
        stack.append((i+1,st,S)); ns=bip_add(st,orbs[i])
        if ns is not None: stack.append((i+1,ns,S+(i,)))
    return F
for path,n in [("tom6.txt",6),("tom10.txt",10),("trans14.txt",14),("trans18.txt",18),("trans22.txt",22)]:
    tr=cone=res=skip=0; tmax=0
    for line in open(path):
        order,trans,exact,qs,ntq,orbs=line.rstrip("\n").split("|")
        if trans!="true": continue
        tr+=1; orbs=[[(e[0]-1,e[1]-1) for e in o] for o in json.loads(orbs)]; tmax=max(tmax,len(orbs))
        F=faces(orbs,n)
        if F is None: skip+=1; continue
        chi=sum((-1)**(len(f)-1) for f in F)
        ok=(chi==1) if exact=="true" else all((chi-1)%q==0 for q in json.loads(qs))
        res+=ok; Fs=set(F)
        cone+=any(frozenset([o]) in Fs and all((f|{o}) in Fs for f in Fs) for o in range(len(orbs)))
    print(f"n={n:2d}: {tr:3d} transitive Oliver groups (max orbitals {tmax}); chi-resistant {res}; cone complexes {cone}; skipped {skip}")
