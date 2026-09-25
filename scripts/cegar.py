import sys, json, pickle, time, itertools, os
import networkx as nx
from networkx.algorithms import isomorphism as iso
from ortools.sat.python import cp_model
n=10; E=list(itertools.combinations(range(n),2)); eidx={e:i for i,e in enumerate(E)}; FULL=(1<<45)-1
ST="/tmp/g/n10/state.pkl"
def graph(mk):
    g=nx.Graph(); g.add_nodes_from(range(n)); g.add_edges_from(E[i] for i in range(45) if mk>>i&1); return g
def load_groups():
    G=[]
    for line in open("/mnt/user-data/outputs/ark-collapse/tom10.txt"):
        order,trans,exact,qs,ntq,orbs=line.rstrip("\n").split("|")
        orbs=[sum(1<<eidx[(min(a,b)-1,max(a,b)-1)] for a,b in o) for o in json.loads(orbs)]
        G.append(dict(order=int(order),exact=exact=="true",qs=json.loads(qs),orbs=orbs,t=len(orbs)))
    return G
def unions(g):
    t=g['t']; out=[]
    for T in range(1,1<<t):
        mk=0
        for j in range(t):
            if T>>j&1: mk|=g['orbs'][j]
        if mk!=FULL: out.append((mk,1 if bin(T).count("1")%2 else -1))
    return out
def adjm(mk):
    a=[0]*n
    for i,(u,v) in enumerate(E):
        if mk>>i&1: a[u]|=1<<v; a[v]|=1<<u
    return a
_prof={}
def profile(mk):
    if mk in _prof: return _prof[mk]
    a=adjm(mk); d=[bin(x).count("1") for x in a]
    nd=[sorted((d[w] for w in range(n) if a[v]>>w&1),reverse=True) for v in range(n)]
    _prof[mk]=(a,d,nd); return _prof[mk]
def _embeds(hmk, gmk):
    """True iff graph hmk is isomorphic to a spanning subgraph of gmk (both on n vertices)."""
    if bin(hmk).count("1")>bin(gmk).count("1"): return False
    H,dh,nh=profile(hmk); Gm,dg,ng=profile(gmk)
    if any(x<y for x,y in zip(sorted(dg,reverse=True),sorted(dh,reverse=True))): return False
    cand=[]
    for v in range(n):
        m=0
        for c in range(n):
            if dg[c]>=dh[v] and all(x>=y for x,y in zip(ng[c],nh[v])): m|=1<<c
        if not m: return False
        cand.append(m)
    img=[-1]*n
    def go(placed,used):
        if placed==(1<<n)-1: return True
        # choose unplaced v with fewest viable candidates
        best=None; bm=0; bc=99
        for v in range(n):
            if placed>>v&1: continue
            need=0; nb=H[v]&placed
            while nb:
                w=(nb&-nb).bit_length()-1; nb&=nb-1; need|=1<<img[w]
            m=cand[v]&~used
            mm=0; x=m
            while x:
                c=(x&-x).bit_length()-1; x&=x-1
                if Gm[c]&need==need: mm|=1<<c
            k=bin(mm).count("1")
            if k==0: return False
            if k<bc: bc=k; best=v; bm=mm
        x=bm
        while x:
            c=(x&-x).bit_length()-1; x&=x-1
            img[best]=c
            if go(placed|1<<best,used|1<<c): return True
        img[best]=-1; return False
    return go(0,0)

FULLMASK=(1<<(n*(n-1)//2))-1
def embeds(hmk, gmk):
    """H <= G up to isomorphism (spanning); tested directly or as complement(G) <= complement(H), whichever is sparser."""
    if bin(hmk).count("1")>bin(gmk).count("1"): return False
    if bin(FULLMASK^gmk).count("1") < bin(hmk).count("1"):
        return _embeds(FULLMASK^gmk, FULLMASK^hmk)
    return _embeds(hmk, gmk)
from fast import embeds_c, canon
embeds=embeds_c
class Templates:
    def __init__(s): s.reps=[]; s.graphs=[]; s.buckets={}; s.memo={}; s.below={}   # below[i] = set of templates contained in i
    def key(s,g): return (g.number_of_edges(), tuple(sorted(d for _,d in g.degree())), nx.weisfeiler_lehman_graph_hash(g,iterations=3))
    def _cm(s):
        if not hasattr(s,'cmap'): s.cmap={canon(r):i for i,r in enumerate(s.reps)}
        return s.cmap
    def id(s,mk):
        if mk in s.memo: return s.memo[mk]
        cm=s._cm(); c=canon(mk)
        if c in cm: s.memo[mk]=cm[c]; return cm[c]
        i=len(s.reps); s.reps.append(mk); s.graphs.append(None); cm[c]=i; s.memo[mk]=i; s.new.append(i); return i
    def lookup(s,mk):
        if mk in s.memo: return s.memo[mk]
        i=s._cm().get(canon(mk))
        if i is not None: s.memo[mk]=i
        return i
    def contains(s,big,small):
        return embeds(s.reps[small], s.reps[big])
    def tri(s,i):
        if not hasattr(s,'_tri'): s._tri={}
        if i not in s._tri:
            a=adjm(s.reps[i]); s._tri[i]=sum(bin(a[u]&a[v]).count("1") for u in range(n) for v in range(u+1,n) if a[u]>>v&1)//3
        return s._tri[i]
    def close(s):
        """containment for new templates, using transitivity (below-sets are kept transitively closed)."""
        ec=lambda i: bin(s.reps[i]).count("1")
        for i in s.new: s.below.setdefault(i,set())
        for i in s.new:
            others=[j for j in range(len(s.reps)) if j!=i and j not in s.below[i]]
            # downward: j inside i
            down=set()
            for j in sorted((j for j in others if ec(j)<=ec(i)), key=lambda j:-ec(j)):
                if j in down: continue
                if s.tri(j)>s.tri(i): continue
                if embeds(s.reps[j],s.reps[i]): down.add(j); down|=s.below[j]
            s.below[i]|=down
            # upward: i inside j
            up=set()
            for j in sorted((j for j in others if ec(j)>=ec(i) and j not in down), key=ec):
                if j in up: continue
                if any(k in s.below[j] for k in up): up.add(j); continue
                if s.tri(i)>s.tri(j): continue
                if embeds(s.reps[i],s.reps[j]): up.add(j)
            for j in up:
                s.below[j].add(i); s.below[j]|=s.below[i]
        # restore transitive closure
        changed=True
        while changed:
            changed=False
            for i in range(len(s.reps)):
                ext=set()
                for j in s.below[i]: ext|=s.below[j]
                if not ext<=s.below[i]: s.below[i]|=ext; changed=True
        s.new=[]

def solve(T,active,G,timeout=60):
    m=cp_model.CpModel(); x=[m.NewBoolVar(f"x{i}") for i in range(len(T.reps))]
    for i,b in T.below.items():
        for j in b: m.AddImplication(x[i],x[j])
    for gi in active:
        g=G[gi]; terms=[(T.id(mk),sg) for mk,sg in g['U']]
        expr=sum(sg*x[i] for i,sg in terms)
        if g['exact']: m.Add(expr==1)
        else:
            L=1
            for q in g['qs']: L=L*q//__import__('math').gcd(L,q)
            k=m.NewIntVar(-10**6,10**6,f"k{gi}"); m.Add(expr-1==L*k)
    sv=cp_model.CpSolver(); sv.parameters.max_time_in_seconds=timeout; sv.parameters.num_workers=8
    r=sv.Solve(m)
    if r in (cp_model.OPTIMAL,cp_model.FEASIBLE): return {i for i in range(len(x)) if sv.Value(x[i])}
    return "INFEASIBLE" if r==cp_model.INFEASIBLE else "UNKNOWN"
