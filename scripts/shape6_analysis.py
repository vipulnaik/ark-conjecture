"""shape6_analysis.py WORKDIR -- structure of the 21 non-evasive single shapes at n = 6 (oen §9.6).
Run after shape6_run.sh has filled WORKDIR (shapes.txt, sv/pNNNN, sv/pNNNN.d, tabD.bin for p1217).
  (1) classify: degrees of the present/absent/irrelevant parts, complement and negation partners;
  (2) unique witness: are the placements' subcubes pairwise disjoint?  Tabulated against non-evasiveness
      over all 1,909 parity survivors;
  (3) opening blocks for the D = 13 example: non-adaptive sets of k edges keeping D optimal;
  (4) phased strategies (cherries, leaf-leaf, cross, centres in each order): best achievable depth."""
import sys, os, re, itertools, functools, collections
import numpy as np
os.chdir(sys.argv[1] if len(sys.argv) > 1 else '.')
sys.setrecursionlimit(10000)
E=[(i,j) for i in range(6) for j in range(i+1,6)]; idx={e:k for k,e in enumerate(E)}; p3=[3**i for i in range(15)]
P=[[idx[tuple(sorted((p[a],p[b])))] for a,b in E] for p in itertools.permutations(range(6))]
def pm(p,m): return sum(1<<p[e] for e in range(15) if m>>e&1)
sh={int(m[1]):(int(m[2]),int(m[3])) for m in (re.match(r'S (\d+) L (\d+) A (\d+)',l) for l in open('shapes.txt')) if m}
Dv={int(f[1:5]):int(open('sv/'+f).read()) for f in os.listdir('sv') if f.endswith('.d')}
ids=sorted(i for i,d in Dv.items() if d<15)
print('(1) non-evasive survivors:',len(ids))
tabs={i:open('sv/p%04d'%i).read().split('\n')[1] for i in ids}; inv={v:k for k,v in tabs.items()}
full=(1<<15)-1
def comp(t): return ''.join(t[full^g] for g in range(1<<15))
def deg(m): return [sum(1 for e in range(15) if m>>e&1 and v in E[e]) for v in range(6)]
for i in ids:
    L,A=sh[i+1]; F=full&~L&~A
    print(f"  p{i:04d} D={Dv[i]} |L|={bin(L).count('1')} |A|={bin(A).count('1')} |F|={bin(F).count('1')} #true={tabs[i].count('1')}"
          f" present={[E[e] for e in range(15) if L>>e&1]} absent={[E[e] for e in range(15) if A>>e&1]} complement->{inv.get(comp(tabs[i]))}")
tab=collections.Counter()
for s,(L,A) in sh.items():
    pl={(pm(p,L),pm(p,A)) for p in P}
    tab[(all((l1&a2) or (l2&a1) for (l1,a1),(l2,a2) in itertools.combinations(pl,2)), (s-1) in ids)]+=1
print('(2) (unique witness, non-evasive) -> count:',dict(tab))
N3=3**15; raw=np.fromfile('tabD.bin',dtype=np.uint8); D=raw[:N3]; lo=raw[N3:2*N3]; hi=raw[2*N3:]
def fix(c,S,bits):
    for k,e in enumerate(S): c-=(2-((bits>>k)&1))*p3[e]
    return c
print('(3) opening blocks keeping D = 13:')
for k in range(1,6):
    good=[S for S in itertools.combinations(range(15),k) if max(int(D[fix(N3-1,S,b)]) for b in range(1<<k))+k<=13]
    print(f"  k={k}: {len(good)} blocks" + (f", e.g. {[E[e] for e in good[0]]}" if good else ''))
cl={'cherry':[(0,1),(0,2),(3,4),(3,5)],'leafleaf':[(1,2),(4,5),(1,4),(1,5),(2,4),(2,5)],
    'cross':[(0,4),(0,5),(1,3),(2,3)],'centres':[(0,3)]}
def run(order):
    phases=[[idx[e] for e in cl[k]] for k in order]
    @functools.lru_cache(None)
    def R(c):
        if lo[c]==hi[c]: return 0
        for ph in phases:
            unk=[e for e in ph if (c//p3[e])%3==2]
            if unk: return min(1+max(R(c-2*p3[e]),R(c-p3[e])) for e in unk)
    return R(N3-1)
print('(4) phased strategies:')
for order in itertools.permutations(['leafleaf','cross','centres']):
    print('  ',('cherry',)+order, run(('cherry',)+order))
# (5) block decomposition: at each state take the largest non-adaptive optimal block, recurse on outcomes up to S6
def st(c): return [(c//p3[i])%3 for i in range(15)]
def canon(c):
    s=st(c); best=0
    for p in P:
        t=[0]*15
        for e in range(15): t[p[e]]=s[e]
        best=max(best,sum(v*p3[i] for i,v in enumerate(t)))
    return best
def block(c):
    unk=[e for e in range(15) if st(c)[e]==2]; d=int(D[c])
    for k in range(min(len(unk),6),0,-1):
        for S in itertools.combinations(unk,k):
            outs=[fix(c,S,b) for b in range(1<<k)]
            if all(int(D[o])+k<=d for o in outs): return S,outs
seen={}
def walk(c):
    k=canon(c)
    if k in seen: return
    seen[k]=1
    if lo[c]==hi[c]: return
    S,outs=block(c)
    for o in outs: walk(o)
walk(N3-1)
print('(5) distinct states (up to S6) in the block decomposition:',len(seen))
