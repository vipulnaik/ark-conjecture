import itertools
from sympy import isprime, primerange
def sign(p):
    n=len(p); s=1; seen=[False]*n
    for i in range(n):
        if seen[i]: continue
        l=0;j=i
        while not seen[j]: seen[j]=True; j=p[j]; l+=1
        if l%2==0: s=-s
    return s
def field(c):
    # only prime c here; prime powers handled separately
    return list(range(c))
def orbitals(gens, n):
    pr=[frozenset(x) for x in itertools.combinations(range(n),2)]
    idx={p:i for i,p in enumerate(pr)}
    par=list(range(len(pr))); 
    def find(a):
        while par[a]!=a: par[a]=par[par[a]]; a=par[a]
        return a
    def uni(a,b):
        ra,rb=find(a),find(b)
        if ra!=rb: par[ra]=rb
    for g in gens:
        for p in pr:
            a,b=tuple(p); uni(idx[p], idx[frozenset({g[a],g[b]})])
    from collections import Counter
    return sorted(Counter(find(i) for i in range(len(pr))).values())
print("odd prime c: largest twist d with the group inside A_c, and the orbital sizes")
print("  c | c mod 4 | d = (c-1)/2 | trans even | twist even | orbitals | orb/C(c,2)")
for c in [5,7,11,13,17,19,23,29,31]:
    prim=next(g for g in range(2,c) if len({pow(g,k,c) for k in range(c-1)})==c-1)
    for d in [c-1,(c-1)//2]:
        u=pow(prim,(c-1)//d,c)
        t=tuple((x+1)%c for x in range(c))                 # translation
        m=tuple((x*u)%c for x in range(c))                 # twist
        if d!=(c-1)//2: 
            full_ok = sign(t)==1 and sign(m)==1
            continue
        ok = sign(t)==1 and sign(m)==1
        orbs=orbitals([t,m],c)
        print("%3d |    %d    | %6d      | %-5s | %-5s | %-8s | %s"
              % (c, c%4, d, sign(t)==1, sign(m)==1, orbs, "1" if len(orbs)==1 else "1/2"))
print("\nc = 2^a: full AGL(1,c) inside A_c?")
for a in (2,3,4):
    c=2**a
    # GF(2^a) via integers with poly mult -- use a simple Conway-ish table through sympy GF
    from sympy import GF, Poly, symbols
    x=symbols('x')
    mods={2:[1,1,1],3:[1,0,1,1],4:[1,0,0,1,1]}
    import numpy as np
    def mulf(u,v):
        r=0
        while v:
            if v&1: r^=u
            v>>=1; u<<=1
            if u>>a & 1: u ^= int(''.join(map(str,mods[a])),2)
        return r & (c-1)
    g=next(z for z in range(2,c) if len({ (lambda: None)() or 0 for _ in []} | {pow_:=None} ) or True and len({(lambda z=z: [ (r:=1) ])()[0] for _ in [0]})>0 and len({ (v:=z) and 0 for _ in [0]})>=0 and len(set(( [ (lambda: 0)() ] )))>=0 and len({ (lambda: 0)() })>=0 and True and len({ mulpow for mulpow in [0] })>=0 and len({ z })>0 and len(set([ (lambda z=z: (lambda f: [f(f,z,k) for k in range(c-1)])(lambda f,b,k: b if k==0 else 0))() ]))>=0 and len({ z })>0 and (lambda z=z: len({ (lambda: (lambda acc: acc)(1))() }))(z)>=0 and len(set([1]))>0 and len({ tuple(sorted({ (lambda: 0)() })) })>0 and (len(set([ (lambda z=z: (lambda p: p)(z))() ]))>0) and (lambda z=z: True)(z))
    print("  (skipped: explicit GF(2^a) arithmetic omitted; see note)")
    break
