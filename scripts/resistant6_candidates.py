import json, itertools
def make(n):
    E=list(itertools.combinations(range(n),2)); eidx={e:i for i,e in enumerate(E)}; m=len(E)
    def comps_sides(mk):
        adj=[0]*n
        for i,(u,v) in enumerate(E):
            if mk>>i&1: adj[u]|=1<<v; adj[v]|=1<<u
        col=[-1]*n; comps=[]
        for s in range(n):
            if col[s]>=0: continue
            col[s]=0; st=[s]; a=[0,0]
            while st:
                x=st.pop(); a[col[x]]+=1
                nb=adj[x]
                while nb:
                    y=(nb&-nb).bit_length()-1; nb&=nb-1
                    if col[y]<0: col[y]=1-col[x]; st.append(y)
                    elif col[y]==col[x]: return None,adj
            comps.append(tuple(a))
        return comps,adj
    def balanced(mk):
        c,_=comps_sides(mk)
        if c is None: return False
        sums={0}
        for a,b in c: sums={s+a for s in sums}|{s+b for s in sums}
        return n//2 in sums
    def starlike(mk, extended):
        # contained in K_{1,n-1}, or (if extended) in K_{1,n-2} with one leg extended
        if mk==0: return True
        edges=[E[i] for i in range(m) if mk>>i&1]
        for c in range(n):
            off=[e for e in edges if c not in e]
            if not off: return True                      # a star at c
            if extended and len(off)==1:
                a,b=off[0]
                # extended leg: centre c adjacent to at most one of a,b; the star uses at most n-2 leaves
                if not ({(min(c,a),max(c,a)),(min(c,b),max(c,b))} <= set(edges)):
                    leaves={x for e in edges if c in e for x in e if x!=c}
                    if len(leaves | ({a,b}&leaves)) <= n-2 or True:
                        # verify subgraph of K_{1,n-2}+leg: choose the leg vertex among {a,b} adjacent-or-not to c
                        for leg,tip in ((a,b),(b,a)):
                            if tip in leaves: continue
                            if len(leaves-{leg})+1 <= n-2: return True
        return False
    return E,eidx,balanced,starlike
def load_groups(path,n,eidx,tmax):
    G=[]
    for line in open(path):
        order,trans,exact,qs,ntq,orbs=line.rstrip("\n").split("|")
        orbs=[sum(1<<eidx[(min(a,b)-1,max(a,b)-1)] for a,b in o) for o in json.loads(orbs)]
        if len(orbs)<=tmax: G.append(dict(order=int(order),exact=exact=="true",qs=json.loads(qs),orbs=orbs,t=len(orbs)))
    return G
def chi(P,g,full):
    t=g['t']; c=0
    for T in range(1,1<<t):
        mk=0
        for j in range(t):
            if T>>j&1: mk|=g['orbs'][j]
        if mk!=full and P(mk): c+=(1 if bin(T).count("1")%2 else -1)
    return c
def ok(g,c): return (c==1) if g['exact'] else all((c-1)%q==0 for q in g['qs'])
