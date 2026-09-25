"""Secret-shuffler evasiveness at n = 4, exhaustively (orbital-evasiveness-notes.md section 7.11).

A property is secret-shuffler non-evasive iff some decision tree whose leaves are certificates resolves, for every isomorphism
class, at least one labelled representative in fewer than N = C(n,2) queries (one shuffle at the start suffices).
The search: at each node, the querier picks an edge and the cooperating shuffler routes each class to an answer one of its
labelled copies can give. Also runs the control (ordinary non-evasiveness: every labelled graph resolved).
"""
import itertools, sys
from functools import lru_cache
sys.setrecursionlimit(10000)
n=4; E=list(itertools.combinations(range(n),2)); N=len(E)
pm=[[E.index(tuple(sorted((p[a],p[b])))) for a,b in E] for p in itertools.permutations(range(n))]
canon=lambda g: min(sum(1<<q[i] for i in range(N) if g>>i&1) for q in pm)
classes=sorted({canon(g) for g in range(1<<N)}); cid={c:i for i,c in enumerate(classes)}; K=len(classes)
cls_of=[cid[canon(g)] for g in range(1<<N)]
below=[{cid[canon(c & ~(1<<i))] for i in range(N) if c>>i&1}|{k} for k,c in enumerate(classes)]
empty=cid[0]; full=cid[(1<<N)-1]
props=[frozenset(k for k in range(K) if m>>k&1) for m in range(1<<K)]
props=[D for D in props if empty in D and full not in D and all(all(b in D for b in below[k]) for k in D)]
def shuffler_nonevasive(P):
    inP=[cls_of[g] in P for g in range(1<<N)]
    @lru_cache(None)
    def cert(q,a): return len({inP[g] for g in range(1<<N) if g&q==a})==1
    @lru_cache(None)
    def reps(q,a): return frozenset(cls_of[g] for g in range(1<<N) if g&q==a)
    @lru_cache(None)
    def f(q,a,C):
        if not C: return True
        d=bin(q).count("1")
        if cert(q,a): return d<N
        if d>=N-1: return False
        for i in range(N):
            if q>>i&1: continue
            q2=q|1<<i; r0=reps(q2,a); r1=reps(q2,a|1<<i); Cl=sorted(C)
            if any(c not in r0 and c not in r1 for c in Cl): continue
            f0=[c for c in Cl if c not in r1]; f1=[c for c in Cl if c not in r0]; free=[c for c in Cl if c in r0 and c in r1]
            for bits in range(1<<len(free)):
                C0=set(f0); C1=set(f1)
                for j,c in enumerate(free): (C1 if bits>>j&1 else C0).add(c)
                if f(q2,a,frozenset(C0)) and f(q2,a|1<<i,frozenset(C1)): return True
        return False
    return f(0,0,frozenset(range(K)))
def ordinary_nonevasive(P):
    inP=[cls_of[g] in P for g in range(1<<N)]
    @lru_cache(None)
    def f(q,a):
        if len({inP[g] for g in range(1<<N) if g&q==a})==1: return bin(q).count("1")<N
        if bin(q).count("1")>=N-1: return False
        return any(f(q|1<<i,a) and f(q|1<<i,a|1<<i) for i in range(N) if not q>>i&1)
    return f(0,0)
ss=[shuffler_nonevasive(P) for P in props]
ev=["{empty}" if P=={empty} else ("not K4" if len(P)==K-1 else f"{len(P)} classes") for P,ok in zip(props,ss) if not ok]
print(f"n = 4: {len(props)} nontrivial properties; secret-shuffler non-evasive {sum(ss)}; evasive {ev}")
print(f"control: ordinarily non-evasive {sum(ordinary_nonevasive(P) for P in props)} (expected 0)")
