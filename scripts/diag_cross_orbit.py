"""Cross-orbit counterexample for three-uniform-note.md §4.1: diagonal AΓL(1,32) plus the block swap on 64 points.
Prints the intra 3-set orbit (9920) and the smallest 2+1 cross orbit (1984)."""
def mul(a,b):
    r=0
    for i in range(5):
        if b>>i&1: r^=a<<i
    for i in range(9,4,-1):
        if r>>i&1: r^=0b100101<<(i-5)
    return r
g=2  # primitive (x)
def gens():
    # points: (block, elt)
    yield lambda p:(p[0],p[1]^1)            # diag translation by 1
    yield lambda p:(p[0],mul(g,p[1]))       # diag mult by x
    yield lambda p:(p[0],mul(p[1],p[1]))    # diag Frobenius
    yield lambda p:(1-p[0],p[1])            # swap
G=list(gens())
def orbit(S):
    S=frozenset(S); seen={S}; st=[S]
    while st:
        T=st.pop()
        for f in G:
            U=frozenset(map(f,T))
            if U not in seen: seen.add(U); st.append(U)
    return len(seen)
print("intra",orbit([(0,0),(0,1),(0,2)]))
print("cross",orbit([(0,0),(0,1),(1,0)]))
cr=min(orbit([(0,0),(0,1),(1,z)]) for z in range(32)); print("min cross",cr)
