import itertools
def dunce(m):
    pts=[(i,j) for i in range(m+1) for j in range(m+1-i)]
    def lab(p):
        i,j=p
        # boundary sides, parametrised t = 0..m:  AB(t)=(t,0), BC(t)=(m-t,t), AC(t)=(0,t); all three identified
        t=None
        if j==0: t=i
        elif i+j==m: t=j
        elif i==0: t=j
        if t is None: return ("int",i,j)
        return ("v0",) if t in (0,m) else ("b",t)
    tris=[]
    for i in range(m):
        for j in range(m-i):
            tris.append(((i,j),(i+1,j),(i,j+1)))
            if i+j+1<m: tris.append(((i+1,j),(i,j+1),(i+1,j+1)))
    # geometric edges -> label pairs; valid simplicial complex iff distinct geometric simplices that are NOT identified by the
    # boundary identification never share a label set
    def geo_key(p,q):
        return frozenset((p,q))
    lt=[frozenset(lab(p) for p in t) for t in tris]
    if any(len(x)<3 for x in lt) or len(set(lt))<len(lt): return None
    edge_geo={}
    for t in tris:
        for p,q in itertools.combinations(t,2):
            L=frozenset((lab(p),lab(q)))
            if len(L)<2: return None
            on_bdry=all(lab(x)[0]!="int" for x in (p,q)) and (p[1]==0 and q[1]==0 or p[0]+p[1]==m and q[0]+q[1]==m or p[0]==0 and q[0]==0)
            edge_geo.setdefault(L,set()).add(("bdry" if on_bdry else geo_key(p,q)))
    if any(len(v)>1 for v in edge_geo.values()): return None
    labels=sorted({lab(p) for p in pts}); idx={l:k for k,l in enumerate(labels)}
    facets=[sum(1<<idx[l] for l in x) for x in lt]
    return len(labels),facets
for m in range(3,9):
    r=dunce(m)
    print(m, "invalid" if r is None else f"valid: {r[0]} vertices, {len(r[1])} triangles")
    if r: break
