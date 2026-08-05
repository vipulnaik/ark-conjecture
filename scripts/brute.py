"""Independent naive re-implementation of the Part G.3 configuration score.
No pruning, no seeds: enumerate (p,q) and all multisets of parts summing to n.
Written from enumeration-proof.md Part G.3 + Part E's value formula only."""
from math import comb
from sympy import factorint, isprime

def pp(x):
    if x<2: return None
    f=factorint(x)
    return (list(f)[0], list(f.values())[0]) if len(f)==1 else None

def qpart(x,q):
    t=1
    while x%q==0: x//=q; t*=q
    return t

def ORB(c,t,char2):
    raw = c*t//2 if (char2 or t%2==0) else c*t
    return min(raw, comb(c,2))

def score(n,p,q,parts):
    # parts: list of (F,c,foreign)
    fs=[c for F,c,fg in parts if fg]
    if len(fs)!=len(set(fs)): return None
    terms=[]
    for F,c,fg in parts:
        if fg:
            terms.append(F*ORB(c,qpart(c-1,q),False))
        else:
            d=c-1
            for r in fs:
                while d%r==0: d//=r
            terms.append(F*comb(c,2) if d<c-1 else F*ORB(c,d,p==2))  # SAFE
        if F>1: terms.append((F if q%2 else F//2)*c*c)
    S=[F*c for F,c,_ in parts]
    for i in range(len(S)):
        for j in range(i+1,len(S)): terms.append(S[i]*S[j])
    return min(terms)

def B(n, kmax=4):
    primes=[x for x in range(2,n+1) if isprime(x)]
    best=0
    for p in [0]+primes:
        for q in primes:
            # admissible parts
            pool=[]
            for c in range(2,n+1):
                d=pp(c)
                if not d: continue
                fg = d[0]!=p
                if fg and d[1]>1: continue
                if fg:
                    pool.append((1,c,True))
                else:
                    F=1
                    while F*c<=n:
                        pool.append((F,c,False)); F*=q
            def rec(i,rem,sel):
                nonlocal best
                if rem==0:
                    if sel:
                        v=score(n,p,q,sel)
                        if v and v>best: best=v
                    return
                if len(sel)>=kmax: return
                for j in range(i,len(pool)):
                    F,c,fg=pool[j]
                    if F*c>rem: continue
                    rec(j,rem-F*c,sel+[pool[j]])
            rec(0,n,[])
    return best
