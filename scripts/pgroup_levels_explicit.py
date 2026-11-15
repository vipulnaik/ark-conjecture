#!/usr/bin/env python3
"""pgroup_levels_explicit.py -- Smith lower bounds for G*(n) from hand-picked p-subgroups,
for n whose table of marks is not in outputs/ (threshold-beyond-mu.md section 7).

Same computation as pgroup_levels.py (its level() is reused): the least budget at which
an N*(Q)-invariant complex on Q's orbitals has chi = 1 (mod p).  Groups with more than
22 orbitals are skipped.  With a second argument, also writes the groups in tom format
for verify_global_chi.py's Smith check.

usage: python3 pgroup_levels_explicit.py 15|21|33|35 [group file to write]
"""
import sys, itertools
n=int(sys.argv[1]); WRITE = sys.argv[2] if len(sys.argv) > 2 else None
src=open('pgroup_levels.py').read().split('\nif TWO:\n    (pp')[0]
sys.argv=['x',str(n)]
exec(src)
def cyc(*cycles):
    p=list(range(n+1))
    for c in cycles:
        for i,x in enumerate(c): p[x]=c[(i+1)%len(c)]
    return p
def orbitals(gens):
    seen=set(); orbs=[]
    for e in itertools.combinations(range(1,n+1),2):
        if e in seen: continue
        orb={e}; st=[e]
        while st:
            a,b=st.pop()
            for g in gens:
                f=tuple(sorted((g[a],g[b])))
                if f not in orb: orb.add(f); st.append(f)
        seen|=orb; orbs.append(sorted(orb))
    return orbs
def blocks(sizes):
    out=[];s=1
    for k in sizes: out.append(list(range(s,s+k))); s+=k
    return out
G={}
if n==15:
    b=blocks([5,5,5])
    G['Z5 diag on 3x5']=([cyc(*b)],5)
    G['Z5^3 on 3x5']=([cyc(x) for x in b],5)
    G['Z5^2 (a,b,a+b) on 3x5']=([cyc(b[0],b[2]),cyc(b[1],b[2])],5)
    t=blocks([3]*5)
    G['Z3^5 on 5x3']=([cyc(x) for x in t],3)
    G['Z3 diag on 5x3']=([cyc(*t)],3)
    G['Z3^2 on 9 + Z3 on 3+3']=([cyc([1,2,3],[4,5,6],[7,8,9]),cyc([1,4,7],[2,5,8],[3,6,9]),cyc([10,11,12]),cyc([13,14,15])],3)
    s=blocks([7,7,1])
    G['Z7 diag on 2x7 +1']=([cyc(s[0],s[1])],7)
    G['Z7^2 on 2x7 +1']=([cyc(s[0]),cyc(s[1])],7)
    G['Z13 +2']=([cyc(list(range(1,14)))],13)
    G['Z11 +4']=([cyc(list(range(1,12)))],11)
    G['Z2^? : (Z2)^3 regular on 8, Z2^2 on 4, Z2 on 2, +1']=([cyc([1,2],[3,4],[5,6],[7,8]),cyc([1,3],[2,4],[5,7],[6,8]),cyc([1,5],[2,6],[3,7],[4,8]),cyc([9,10],[11,12]),cyc([9,11],[10,12]),cyc([13,14])],2)
if n==21:
    b=blocks([7,7,7])
    G['Z7 diag on 3x7']=([cyc(*b)],7)
    G['Z7^3 on 3x7']=([cyc(x) for x in b],7)
    G['Z7^2 (a,b,a+b) on 3x7']=([cyc(b[0],b[2]),cyc(b[1],b[2])],7)
    t=blocks([3]*7)
    G['Z3^7 on 7x3']=([cyc(x) for x in t],3)
    t9=blocks([9,9,3])
    G['Z3^2 on 9, Z3^2 on 9, Z3 on 3']=([cyc([1,2,3],[4,5,6],[7,8,9]),cyc([1,4,7],[2,5,8],[3,6,9]),cyc([10,11,12],[13,14,15],[16,17,18]),cyc([10,13,16],[11,14,17],[12,15,18]),cyc([19,20,21])],3)
    f=blocks([5,5,5,5,1])
    G['Z5^4 on 4x5 +1']=([cyc(x) for x in f[:4]],5)
    G['Z19 +2']=([cyc(list(range(1,20)))],19)
    G['Z17 +4']=([cyc(list(range(1,18)))],17)
    G['Z2^4 on 16, Z2^2 on 4, +1']=([cyc(*[[i,i+1] for i in range(1,16,2)]),cyc(*[[i,i+2] for i in (1,2,5,6,9,10,13,14)]),cyc(*[[i,i+4] for i in (1,2,3,4,9,10,11,12)]),cyc(*[[i,i+8] for i in range(1,9)]),cyc([17,18],[19,20]),cyc([17,19],[18,20])],2)
if n in (33,35):
    if n==33:
        b=blocks([11,11,11]); G['Z11^3 on 3x11']=([cyc(x) for x in b],11)
        b=blocks([3]*11)
    else:
        b=blocks([7]*5); G['Z7^5 on 5x7']=([cyc(x) for x in b],7)
        b5=blocks([5]*7); G['Z5^7 on 7x5']=([cyc(x) for x in b5],5)
for name,(gens,p) in G.items():
    o=orbitals(gens); t=len(o)
    if t>22: print(name,'t =',t,'skipped',flush=True); continue
    print(f"{name}: t = {t}, sizes {sorted(len(x) for x in o)}, least budget chi=1 mod {p}: {level(o,p)}",flush=True)
if WRITE:
    import json
    with open(WRITE,'w') as f:
        for name,(gens,p) in G.items():
            f.write(f"{p}|false|false|[{p}]|[{p}]|{json.dumps([[list(e) for e in x] for x in orbitals(gens)])}\n")
