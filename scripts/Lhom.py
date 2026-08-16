import itertools, sys
from collections import Counter
def rank_f2(rows):
    """Gaussian elimination over F2 with rows as Python ints (bitsets)."""
    piv={}; rank=0
    for r in rows:
        while r:
            b=r.bit_length()-1
            if b in piv: r^=piv[b]
            else: piv[b]=r; rank+=1; break
    return rank
def rank_modp(rows,nc,p):
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
def L_complex(n):
    E=[frozenset(x) for x in itertools.combinations(range(n),2)]
    eidx={e:i for i,e in enumerate(E)}
    cyc=set()
    for perm in itertools.permutations(range(1,n)):
        v=(0,)+perm
        cyc.add(frozenset(eidx[frozenset({v[i],v[(i+1)%n]})] for i in range(n)))
    P=set()
    for g in cyc:
        g=sorted(g)
        for r in range(len(g)+1):
            for s in itertools.combinations(g,r): P.add(frozenset(s))
    return len(cyc), P
def homology_f2(P):
    lvl={}
    for f in P: lvl.setdefault(len(f),[]).append(f)
    idx={d:{f:i for i,f in enumerate(fs)} for d,fs in lvl.items()}
    rk={}
    for d in sorted(lvl):
        if d==0 or (d-1) not in idx: continue
        rows=[]
        for f in lvl[d]:
            m=0
            for e in f: m |= 1<<idx[d-1][frozenset(f-{e})]
            rows.append(m)
        rk[d]=rank_f2(rows)
    return {d-1: len(lvl[d])-rk.get(d,0)-rk.get(d+1,0) for d in sorted(lvl) if d>=1}
for n in (5,6,7,8):
    nc,P = L_complex(n)
    h = homology_f2(P)
    nz={d:v for d,v in h.items() if v}
    print("n=%d: %5d Ham cycles, |L| = %8d faces, dim %d, H~(L;F2) = %s"
          % (n, nc, len(P), max(len(f) for f in P)-1, nz), flush=True)
