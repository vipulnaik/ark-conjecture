import itertools, pynauty
from collections import defaultdict
L=[[1,2,3,4,5,6],[1,2,4,7,8,10],[1,3,6,25,27,30],[1,7,13,19,25],[2,5,6,14,17,18],[2,8,14,20,26],
   [3,4,5,21,22,23],[3,9,15,21,27],[4,10,16,22,28],[5,11,17,23,29],[6,12,18,24,30],[7,8,9,10,11,12],
   [7,9,11,13,15,17],[8,9,12,20,21,24],[10,11,12,28,29,30],[13,14,15,16,17,18],[13,16,18,19,22,24],
   [14,15,16,26,27,28],[19,20,21,22,23,24],[19,20,23,25,26,29],[25,26,27,28,29,30]]
L=[[v-1 for v in f] for f in L]
N=30
def autgroup():
    adj={i:[] for i in range(N+len(L))}
    for j,f in enumerate(L):
        for v in f: adj[v].append(N+j)
    g=pynauty.Graph(N+len(L),adjacency_dict=adj,vertex_coloring=[set(range(N)),set(range(N,N+len(L)))])
    gens,order,_,_,_=pynauty.autgrp(g)
    return [tuple(p[:N]) for p in gens], order
def closure_group(gens):
    ident=tuple(range(N)); G={ident}; fr=[ident]
    while fr:
        nf=[]
        for g in fr:
            for h in gens:
                k=tuple(h[g[i]] for i in range(N))
                if k not in G: G.add(k); nf.append(k)
        fr=nf
    return sorted(G)
if __name__=="__main__":
    gens,order=autgroup()
    print("Aut(A) order (on 30 vertices):",order)
    G=closure_group(gens); print("|G| =",len(G))
    # orbit of vertex 0 -> transitive?
    print("transitive:",len({g[0] for g in G})==N)
    # facet structure: orbits of G on the 21 facets
    fs=[frozenset(f) for f in L]
    def orb(f): return frozenset(frozenset(g[v] for v in f) for g in G)
    orbs=set(orb(f) for f in fs)
    print("facet orbits:",[(len(o), len(next(iter(o)))) for o in orbs])
    # stabilizer orders and shapes
    for o in orbs:
        f=next(iter(o)); stab=[g for g in G if frozenset(g[v] for v in f)==f]
        print(f"  {len(f)}-set: orbit {len(o)}, stabilizer order {len(stab)}")
    # point stabilizer order and its orbits on the 30 points (the 'suborbits')
    st=[g for g in G if g[0]==0]
    print("point stabilizer order",len(st))
    sub=defaultdict(set)
    seen=set()
    for x in range(N):
        if x in seen: continue
        o={g[x] for g in st}; seen|=o; sub[len(o)].add(frozenset(o))
    print("suborbits (size:count):",{k:len(v) for k,v in sub.items()})
    # is the 30-set A5/C2 = edges of icosahedron? check: 5-sets partition
    five=[f for f in fs if len(f)==5]; print("the 6 five-sets partition the vertices:", len(set().union(*five))==30)
    # links
    faces=set()
    for f in L:
        for k in range(1,len(f)+1):
            for c in itertools.combinations(sorted(f),k): faces.add(c)
    lk=[c for c in faces if 0 in c and len(c)>1]
    lkv=sorted({v for c in lk for v in c if v!=0}); print("link of vertex 0: on",len(lkv),"vertices; non-neighbours:",30-1-len(lkv))
