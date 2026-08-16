import pickle, sys
sys.setrecursionlimit(200000)
orbits, seen, below, full, chi1 = pickle.load(open('t162.pkl','rb'))
FULL=(1<<12)-1
def nonevasive(P):
    """P: frozenset of masks, downward closed, 0 in P, FULL not in P.
    Uses the standard recursion: a function on a subcube is non-evasive iff it
    is constant there, or some variable splits it into two non-evasive halves.
    Monotone shortcut for constancy: on the interval [k1, k1|free] a decreasing
    P is all-1 iff its TOP is in P, all-0 iff its BOTTOM is not."""
    memo={}
    def ne(k1, k0):
        key=(k1,k0)
        if key in memo: return memo[key]
        free = FULL & ~k1 & ~k0
        if free==0:
            # BASE CASE, and it must come FIRST.  "Non-evasive" means D < (number
            # of free variables).  With no free variables D = 0, which is NOT
            # less than 0, so a fully-queried subcube is evasive by convention.
            # Testing constancy first instead returns True here and the True
            # propagates all the way up, reporting every function non-evasive --
            # which is exactly what a first run of this script did.
            memo[key]=False; return False
        top = k1 | free
        if top in P or k1 not in P:      # constant on this subcube: D = 0 < free
            memo[key]=True; return True
        r=False
        f=free
        while f:
            b = f & -f; f ^= b
            if ne(k1|b, k0) and ne(k1, k0|b):
                r=True; break
        memo[key]=r; return r
    return ne(0,0)
hits=[]
for n,cs in enumerate(chi1):
    P=frozenset(m for i in cs for m in orbits[i])
    if 0 not in P or FULL in P: continue
    if nonevasive(P):
        hits.append(cs)
        print("NON-EVASIVE found: candidate #%d, |P|=%d, orbits=%d" % (n, len(P), len(cs)))
print("checked", len(chi1), "chi=1 candidates; non-evasive:", len(hits))
pickle.dump(hits, open('t162_hits.pkl','wb'))
