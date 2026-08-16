import itertools, sys
sys.setrecursionlimit(100000)
pairs=[frozenset(x) for x in itertools.combinations(range(5),2)]
pidx={p:i for i,p in enumerate(pairs)}
def p5(cyc):
    q=list(range(5))
    for c in cyc:
        for i in range(len(c)): q[c[i]]=c[(i+1)%len(c)]
    return tuple(q)
def close5(gens):
    I=tuple(range(5)); G={I}; fr=[I]
    while fr:
        new=[]
        for x in fr:
            for g in gens:
                y=tuple(g[x[i]] for i in range(5))
                if y not in G: G.add(y); new.append(y)
        fr=new
    return G
A5=close5([p5([[0,1,2,3,4]]), p5([[0,1,2]])])
gens=[tuple(pidx[frozenset({q[a] for a in pairs[i]})] for i in range(10)) for q in A5]
N=10; FULL=(1<<N)-1
def act(g,m):
    r=0
    for i in range(N):
        if m>>i&1: r|=1<<g[i]
    return r
seen=[-1]*(1<<N); orbits=[]
for m in range(1<<N):
    if seen[m]>=0: continue
    k=len(orbits); o=[]; st=[m]; seen[m]=k
    while st:
        x=st.pop(); o.append(x)
        for g in gens:
            y=act(g,x)
            if seen[y]<0: seen[y]=k; st.append(y)
    orbits.append(o)
K=len(orbits); print("orbits on subsets:",K)
below=[set() for _ in range(K)]
for i,o in enumerate(orbits):
    for m in o:
        for b in range(N):
            if m>>b&1: below[i].add(seen[m&~(1<<b)])
    below[i].discard(i)
ch=True
while ch:
    ch=False
    for i in range(K):
        u=set()
        for j in below[i]: u|=below[j]
        if not u<=below[i]: below[i]|=u; ch=True
full=seen[FULL]
par=[sum(-1 if bin(m).count('1')%2 else 1 for m in o) for o in orbits]
topo=sorted([i for i in range(K) if i!=full], key=lambda i: bin(orbits[i][0]).count('1'))
def nonevasive(P):
    memo={}
    def ne(k1,k0):
        key=(k1,k0)
        if key in memo: return memo[key]
        free=FULL&~k1&~k0
        if free==0: memo[key]=False; return False
        if (k1|free) in P or k1 not in P: memo[key]=True; return True
        r=False; f=free
        while f:
            b=f&-f; f^=b
            if ne(k1|b,k0) and ne(k1,k0|b): r=True; break
        memo[key]=r; return r
    return ne(0,0)
cnt=0; chi1=0; hits=[]
cur=set()
def rec(k):
    global cnt, chi1
    if k==len(topo):
        if 0 not in cur: return
        cnt+=1
        p=sum(par[i] for i in cur)
        if p!=0: return
        chi1+=1
        P=frozenset(m for i in cur for m in orbits[i])
        if nonevasive(P):
            hits.append(sorted(cur))
            print("NON-EVASIVE  |P| =",len(P)," orbits:",sorted(cur))
        return
    i=topo[k]
    rec(k+1)
    if below[i]<=cur:
        cur.add(i); rec(k+1); cur.discard(i)
rec(0)
print("nontrivial invariant monotone properties:",cnt)
print("  chi(Delta_P)=1:",chi1)
print("  NON-EVASIVE:",len(hits))
