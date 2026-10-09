"""Independent check of non-evasive single shapes at n = 6.
Recomputes the property from (L, A) by brute force over S6 (no shared code with shape6.c),
then checks an explicit decision tree (from dtree_tree.c) on all 2^15 graphs and reports its depth."""
import sys, itertools
n=6; E=[(i,j) for i in range(n) for j in range(i+1,n)]; idx={e:k for k,e in enumerate(E)}
def eid(a,b): return idx[(min(a,b),max(a,b))]
def bits(m): return [e for e in range(15) if m>>e&1]
def prop(L,A):
    pl=set()
    for p in itertools.permutations(range(n)):
        l=sum(1<<eid(p[E[e][0]],p[E[e][1]]) for e in bits(L)); a=sum(1<<eid(p[E[e][0]],p[E[e][1]]) for e in bits(A))
        pl.add((l,a))
    return [any(G&l==l and not G&a for l,a in pl) for G in range(1<<15)]
def parse(toks):
    t=next(toks)
    if t=='L': return int(next(toks))
    i=int(next(toks)); return (i,parse(toks),parse(toks))
def evalt(t,G,d=0):
    while isinstance(t,tuple): t=t[2] if G>>t[0]&1 else t[1]; d+=1
    return t,d
L,A,treefile=int(sys.argv[1]),int(sys.argv[2]),sys.argv[3]
f=prop(L,A); lines=open(treefile).read().split('\n'); t=parse(iter(lines[1].split()))
mx=0
for G in range(1<<15):
    v,d=evalt(t,G); assert v==f[G], G; mx=max(mx,d)
print("L present:",[E[e] for e in bits(L)],"A absent:",[E[e] for e in bits(A)],
      "| #true",sum(f),"| tree correct on all 32768, depth",mx)
