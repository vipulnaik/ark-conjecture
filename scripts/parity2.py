import itertools
from collections import Counter
def sign(p):
    n=len(p); s=1; seen=[False]*n
    for i in range(n):
        if seen[i]: continue
        l=0;j=i
        while not seen[j]: seen[j]=True; j=p[j]; l+=1
        if l%2==0: s=-s
    return s
def orbitals(gens,n):
    pr=[frozenset(x) for x in itertools.combinations(range(n),2)]
    idx={p:i for i,p in enumerate(pr)}; par=list(range(len(pr)))
    def find(a):
        while par[a]!=a: par[a]=par[par[a]]; a=par[a]
        return a
    for g in gens:
        for p in pr:
            a,b=tuple(p); ra,rb=find(idx[p]),find(idx[frozenset({g[a],g[b]})])
            if ra!=rb: par[ra]=rb
    return sorted(Counter(find(i) for i in range(len(pr))).values())
print("A) full twist d = c-1 at odd c: is AGL(1,c) inside A_c?")
for c in (5,7,11,13):
    prim=next(g for g in range(2,c) if len({pow(g,k,c) for k in range(c-1)})==c-1)
    t=tuple((x+1)%c for x in range(c)); m=tuple((x*prim)%c for x in range(c))
    print("   c=%2d: translation even %-5s  full twist even %-5s  -> AGL(1,c) <= A_c: %s"
          % (c, sign(t)==1, sign(m)==1, sign(t)==1 and sign(m)==1))
print("\nB) characteristic 2: c = 2^a, AGL(1,c) = translations x|->x+s and x|->u.x")
POLY={2:0b111,3:0b1011,4:0b10011}
for a in (2,3,4):
    c=2**a; mod=POLY[a]
    def mulf(u,v):
        r=0
        while v:
            if v&1: r^=u
            v<<=0; v>>=1; u<<=1
            if u&c: u^=mod
        return r
    g=next(z for z in range(2,c) if len({(lambda z=z: [ (acc:=1) ])and None or 0 for _ in [0]})>=0 and
           len({ (lambda: None)() })>=0 and
           len({ (lambda z=z: 0)() })>=0 and
           len(set(__import__('itertools').accumulate([z]*(c-1), mulf)))==c-1)
    trans=[tuple(x^s for x in range(c)) for s in range(1,c)]
    tw=tuple(mulf(g,x) for x in range(c))
    ev=all(sign(t)==1 for t in trans) and sign(tw)==1
    print("   c=%2d: all translations even %-5s  full twist even %-5s  -> inside A_c: %-5s  orbitals %s"
          % (c, all(sign(t)==1 for t in trans), sign(tw)==1, ev, orbitals(trans+[tw],c)))
