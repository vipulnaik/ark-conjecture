import random, itertools
def closure(facets):
    F=set()
    for f in facets:
        s=f
        while True:
            F.add(s)
            if s==0: break
            s=(s-1)&f
    return F
def dual(F,N):
    full=(1<<N)-1
    return {S for S in range(1<<N) if (full^S) not in F}
def free_pairs(F):
    # (sigma,tau): tau a maximal face, sigma a codim-1 face of tau contained in no other face
    cnt={}
    for t in F:
        b=t
        while b:
            v=b&-b; b^=v; s=t^v
            cnt.setdefault(s,[]).append(t)
    out=[]
    for s,ts in cnt.items():
        if len(ts)==1 and s!=0:
            t=ts[0]
            # tau must be maximal: no face strictly above tau
            out.append((s,t))
    maxl={t for t in F if not any((t|(1<<i)) in F for i in range(20) if not t>>i&1)}
    return [(s,t) for s,t in out if t in maxl]
def greedy_collapse(F,rng,tries=1):
    for _ in range(tries):
        G=set(F)
        while True:
            fp=free_pairs(G)
            if not fp: break
            s,t=rng.choice(fp); G.discard(s); G.discard(t)
        nonempty=[x for x in G if x]
        if len(nonempty)==1: return True
    return False
def random_collapsible(N,steps,rng):
    """random elementary expansions from a single vertex: add (sigma,tau), tau=sigma+w, sigma missing, all other facets of tau present."""
    F={0,1<<rng.randrange(N)}
    for _ in range(steps):
        cand=[]
        for t in range(1,1<<N):
            if t in F or bin(t).count("1")<2: continue
            missing=[]; b=t
            while b:
                w=b&-b; b^=w
                if (t^w) not in F: missing.append(t^w)
                if len(missing)>1: break
            if len(missing)==1: cand.append((missing[0],t))
        if not cand: break
        s,t=rng.choice(cand); F.add(s); F.add(t)
    return F
