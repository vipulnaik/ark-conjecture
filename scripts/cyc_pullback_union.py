#!/usr/bin/env python3
"""cyc_pullback_union.py -- chi = 1 for C_k-invariant complexes on k points, as a union of two pull-backs A = pi_{d1}^{-1} X, B = pi_{d2}^{-1} Z.
chi(A cup B) = chi X + chi Z - chi(A cap B);  with g = gcd(d1, d2),
chi(A cap B) = - sum_{S subset Z_g nonempty} (-1)^{|S|} a_S b_S,  a_S = sum_{F in X, F mod g = S} (-1)^{|F|}."""
import itertools, random, sys
from math import gcd
from sympy import divisors
def layered_faces(d, s, chosen_orbits):
    """all subsets of Z_d of size < s, plus the s-sets in the chosen orbits"""
    faces=[f for r in range(1,s) for f in itertools.combinations(range(d),r)]
    faces+= [f for o in chosen_orbits for f in o]
    return faces
def orbits_of(d, s):
    seen=set(); out=[]
    for f in itertools.combinations(range(d),s):
        if f in seen: continue
        o={tuple(sorted((x+i)%d for x in f)) for i in range(d)}; seen|=o; out.append(sorted(o))
    return out
def profile(faces, g):
    a={}; chi=0
    for f in faces:
        S=frozenset(x%g for x in f); sg=(-1)**len(f)
        a[S]=a.get(S,0)+sg; chi-=sg
    return chi, a
def rand_complex(d, rng):
    s=rng.randint(1, min(d-1, 4 if d<=24 else 3))
    orbs=orbits_of(d,s); ch=[o for o in orbs if rng.random()<rng.random()]
    if s==d-1 and len(ch)==len(orbs): pass
    return (s, tuple(len(o) for o in ch)), layered_faces(d,s,ch)

_ORB={}
def all_orbits(d, smax):
    if (d,smax) in _ORB: return _ORB[(d,smax)]
    out=[]
    for s in range(1, min(smax, d-1)+1): out+= [(s,o) for o in orbits_of(d,s)]
    _ORB[(d,smax)]=out; return out
def rand_general(d, rng, smax):
    """random C_d-invariant complex: orbits layer by layer, an orbit allowed when all its facets are present"""
    p=rng.random(); faces=set(); desc=[]
    for s,o in all_orbits(d, smax):
        f=o[0]
        if s>1 and any(g not in faces for g in itertools.combinations(f,s-1)): continue
        if s==1 or rng.random()<p:
            faces|=set(o); desc.append((s,len(o)))
    return desc, list(faces)
def search(argv):
    k=int(argv[0]); trials=int(argv[1]); rng=random.Random(7)
    D=[d for d in divisors(k) if 1<d<k and d<=60]
    for t in range(trials):
        d1,d2=rng.choice(D),rng.choice(D); g=gcd(d1,d2)
        sm1=6 if d1<=12 else (4 if d1<=24 else 3); sm2=6 if d2<=12 else (4 if d2<=24 else 3)
        k1,F1=rand_general(d1,rng,sm1); k2,F2=rand_general(d2,rng,sm2)
        c1,a=profile(F1,g); c2,b=profile(F2,g)
        inter=-sum((-1)**len(S)*a[S]*b.get(S,0) for S in a)
        if c1+c2-inter==1:
            print(k,"chi=1:",d1,k1,d2,k2,"(chi X, chi Z, chi cap) =",c1,c2,inter); return
    print(k,"none")

def verify():
    """the intersection formula against explicit face enumeration (small k)"""
    import itertools
    rng=random.Random(3); bad=0; done=0
    for trial in range(300):
        k=rng.choice([12,18,20,24])
        D=[d for d in divisors(k) if 1<d<k]
        d1,d2=rng.choice(D),rng.choice(D); g=gcd(d1,d2)
        _,F1=rand_complex(d1,rng); _,F2=rand_complex(d2,rng)
        X={frozenset(f) for f in F1}; Z={frozenset(f) for f in F2}
        # explicit complex on Z_k: S face iff image mod d1 in X or image mod d2 in Z
        chi=0
        # enumerate faces by DFS over subsets containing images ok (k <= 24: restrict to sizes <= 8 suffices? no: do full via down-closure generation)
        faces=set(); skip=False
        if max([0]+[len(f)*k//d for F,d in [(X,d1),(Z,d2)] for f in F])>15: continue
        for F,d in [(X,d1),(Z,d2)]:
            for f in F:
                fib=[x for x in range(k) if x%d in f]
                if len(fib)>15: break
                for r in range(1,len(fib)+1):
                    for S in itertools.combinations(fib,r):
                        if frozenset(x%d for x in S)==f: faces.add(S)
        chi=sum((-1)**(len(S)-1) for S in faces); done+=1
        c1,a=profile(F1,g); c2,b=profile(F2,g)
        inter=-sum((-1)**len(S)*a[S]*b.get(S,0) for S in a)
        if chi!=c1+c2-inter: bad+=1; print("MISMATCH",k,d1,d2,chi,c1+c2-inter)
    print("compared",done,"mismatches",bad)
    
if __name__=="__main__":
    if sys.argv[1]=="verify": verify()
    else: search(sys.argv[1:])
