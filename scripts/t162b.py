import sys, collections
sys.setrecursionlimit(100000)
def perm_from_cycles(cycles, n=12):
    p=list(range(n))
    for cyc in cycles:
        for i in range(len(cyc)): p[cyc[i]-1]=cyc[(i+1)%len(cyc)]-1
    return tuple(p)
gens=[perm_from_cycles([[1,12],[4,5]]),perm_from_cycles([[1,12],[8,9]]),
      perm_from_cycles([[1,5,9],[4,8,12]]),perm_from_cycles([[2,10],[3,11],[4,8],[5,9]]),
      perm_from_cycles([[1,7],[2,8,10,4],[3,9,11,5],[6,12]])]
def act(g,mask):
    m=0
    for i in range(12):
        if mask>>i&1: m|=1<<g[i]
    return m
seen=[-1]*4096; orbits=[]
for m in range(4096):
    if seen[m]>=0: continue
    k=len(orbits); o=[]; stack=[m]; seen[m]=k
    while stack:
        x=stack.pop(); o.append(x)
        for g in gens:
            y=act(g,x)
            if seen[y]<0: seen[y]=k; stack.append(y)
    orbits.append(o)
K=len(orbits)
# covers: orbit j is an immediate predecessor of i
below=[set() for _ in range(K)]
for i,o in enumerate(orbits):
    for m in o:
        for b in range(12):
            if m>>b&1: below[i].add(seen[m & ~(1<<b)])
    below[i].discard(i)
ch=True
while ch:
    ch=False
    for i in range(K):
        u=set()
        for j in below[i]: u|=below[j]
        if not u<=below[i]: below[i]|=u; ch=True
full=seen[4095]
par=[sum(-1 if bin(m).count('1')%2 else 1 for m in o) for o in orbits]
# enumerate ideals (down-sets) of the poset restricted to allowed = all but `full`
allowed=[i for i in range(K) if i!=full]
# a down-set must not contain any i whose below[] includes full -- impossible since full is maximal
topo=sorted(allowed, key=lambda i: bin(orbits[i][0]).count('1'))
pos_of={o:k for k,o in enumerate(topo)}
ideals=[]
def rec(k, chosen, parity):
    if k==len(topo):
        ideals.append((frozenset(chosen), parity)); return
    i=topo[k]
    rec(k+1, chosen, parity)                      # exclude i
    if below[i] <= chosen:                        # include i only if legal
        chosen.add(i); rec(k+1, chosen, parity+par[i]); chosen.discard(i)
rec(0,set(),0)
print("nontrivial-capable down-sets (excluding the full-set orbit):", len(ideals))
chi1=[c for c,p in ideals if p==0 and len(c)>1]
print("of those, with sum of (-1)^|S| = 0  (i.e. chi(Delta_P) = 1):", len(chi1))
import pickle
pickle.dump((orbits,seen,below,full,chi1), open('t162.pkl','wb'))
