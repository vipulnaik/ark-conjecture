import itertools
from collections import Counter
def sgn(p):
    n=len(p); s=1; seen=[False]*n
    for i in range(n):
        if seen[i]: continue
        l=0;j=i
        while not seen[j]: seen[j]=True; j=p[j]; l+=1
        if l%2==0: s=-s
    return s
def rank_mod(rows,nc,p):
    rows=[r[:] for r in rows]; rank=0; piv={}
    for r in rows:
        for c in range(nc):
            if r[c]%p:
                if c in piv:
                    f=r[c]*pow(piv[c][c],p-2,p)%p; pr=piv[c]
                    for k in range(c,nc): r[k]=(r[k]-f*pr[k])%p
                else:
                    piv[c]=r; rank+=1; break
    return rank
def homology(faces,p):
    """faces: iterable of frozensets of INTEGER edge-indices.  Sorting integers
    gives a genuine total order, so the boundary signs are consistent; sorting
    frozensets does NOT (set '<' is subset containment, a partial order) and
    silently produces d.d != 0 and negative Betti numbers."""
    lvl={}
    for f in faces: lvl.setdefault(len(f),[]).append(f)
    idx={d:{f:i for i,f in enumerate(fs)} for d,fs in lvl.items()}
    rk={}
    for d in sorted(lvl):
        if d==0 or (d-1) not in idx: continue
        rows=[]
        for f in lvl[d]:
            row=[0]*len(lvl[d-1])
            for j,e in enumerate(sorted(f)):
                s=frozenset(f-{e}); row[idx[d-1][s]]=(row[idx[d-1][s]]+(1 if j%2==0 else p-1))%p
            rows.append(row)
        rk[d]=rank_mod(rows,len(lvl[d-1]),p)
    return {d-1: len(lvl[d])-rk.get(d,0)-rk.get(d+1,0) for d in sorted(lvl) if d>=1}
def build(n):
    E=[frozenset(x) for x in itertools.combinations(range(n),2)]
    eidx={e:i for i,e in enumerate(E)}
    cyc=set()
    for perm in itertools.permutations(range(1,n)):
        v=(0,)+perm
        cyc.add(frozenset(eidx[frozenset({v[i],v[(i+1)%n]})] for i in range(n)))
    An=[p for p in itertools.permutations(range(n)) if sgn(p)==1]
    def ap(p,c): return frozenset(eidx[frozenset({p[a] for a in E[e]})] for e in c)
    seen=set(); orbs=[]
    for c in sorted(cyc,key=sorted):
        if c in seen: continue
        o={ap(p,c) for p in An}; seen|=o; orbs.append(o)
    def down(gens):
        P=set()
        for g in gens:
            g=sorted(g)
            for r in range(len(g)+1):
                for s in itertools.combinations(g,r): P.add(frozenset(s))
        return P
    return cyc, orbs, down
n=5
cyc,orbs,down = build(n)
L=down(cyc); P0=down(orbs[0]); P1=down(orbs[1]); M=P0&P1
print("n=5  |L|=%d |P0|=%d |M|=%d  orbit sizes %s"%(len(L),len(P0),len(M),[len(o) for o in orbs]))
print("P0\\M face sizes:",dict(Counter(len(f) for f in P0-M)))
for p,lab in ((1000003,"Q"),(2,"F2"),(3,"F3")):
    print(" %-2s : H~(L)=%s   H~(P0)=%s   H~(M)=%s" % (lab,
        {d:v for d,v in homology(L,p).items() if v} or 0,
        {d:v for d,v in homology(P0,p).items() if v} or 0,
        {d:v for d,v in homology(M,p).items() if v} or 0))
print("\nREGRESSION: H~(P0) must be Q-acyclic with F2 = {1:1,2:1}  (RP^2)")
