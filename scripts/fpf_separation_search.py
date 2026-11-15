#!/usr/bin/env python3
"""fpf_separation_search.py -- search for n <= 4000 with mu*_N^fpf(n) > mu*_cyc(n) (session-log-17 Part 21).
Two constructions, each a level-1 lower bound once its joint goodness check passes:
  two_foreign: n = r1 + r2, G = (C_r1 x| C_{q^e1}) x (C_r2 x| C_{q^e2}), both blocks rescored (value C(min r, 2));
  two_r:       n = 2r + r\x27, G = (C_r x| C_{q^e})^2 x (C_r\x27 x| C_{q^e\x27}), the two r-blocks merged by N* (value
               min(r(r-1), C(r\x27,2))).
Joint goodness: no invariant complex on the classes, faces under the value, chi = 1 (mod q), by CP-SAT.
Compared against L_new of outputs/mu_cyc_bounds_4000.csv.  Run from the repo root.
usage: python3 scripts/fpf_separation_search.py two_foreign|two_r"""
import sys
MODE = sys.argv[1]
if MODE == "two_foreign":
    import csv, itertools
    from sympy import isprime, factorint
    from ortools.sat.python import cp_model
    rows={int(r['n']):int(r['L_new']) for r in csv.DictReader(open('outputs/mu_cyc_bounds_4000.csv'))}
    C2=lambda x:x*(x-1)//2
    def decomps(r):
        m=(r-1)//2; out=[]
        for q,e0 in factorint(m).items():
            if q==2: continue
            for e in range(1,e0+1): out.append((m//q**e,q,e))
        return out
    _good={}
    def joint_good(k1,k2,q):
        """no (C_k1 x C_k2)-invariant complex on A (k1 pts) + B (k2 pts), every face proper on
        each side, with chi = 1 mod q"""
        key=(k1,k2,q)
        if key in _good: return _good[key]
        fullA=(1<<k1)-1; fullB=(1<<k2)-1
        rotA=lambda x:((x<<1)|(x>>(k1-1)))&fullA if k1>1 else x
        rotB=lambda x:((x<<1)|(x>>(k2-1)))&fullB if k2>1 else x
        rep={}; reps=[]
        for a in range(fullA):            # proper on A (excludes full)
            for b in range(fullB):
                if a==0 and b==0: continue
                if (a,b) in rep: continue
                orb={(a,b)}; st=[(a,b)]
                while st:
                    x,y=st.pop()
                    for z in ((rotA(x),y),(x,rotB(y))):
                        if z not in orb: orb.add(z); st.append(z)
                for z in orb: rep[z]=(a,b)
                reps.append(((a,b),len(orb)))
        idx={F:i for i,(F,_) in enumerate(reps)}
        M=cp_model.CpModel(); X=[M.NewBoolVar('') for _ in reps]
        for i,((a,b),_) in enumerate(reps):
            for j in range(k1):
                if a>>j&1:
                    s=(a^(1<<j),b)
                    if s!=(0,0): M.AddImplication(X[i],X[idx[rep[s]]])
            for j in range(k2):
                if b>>j&1:
                    s=(a,b^(1<<j))
                    if s!=(0,0): M.AddImplication(X[i],X[idx[rep[s]]])
        sg=lambda a,b:1 if (bin(a).count('1')+bin(b).count('1'))%2 else -1
        z=M.NewIntVar(-10**7,10**7,'')
        M.Add(sum(sg(*F)*sz*X[i] for i,(F,sz) in enumerate(reps))==1+q*z)
        S=cp_model.CpSolver(); S.parameters.max_time_in_seconds=60; S.parameters.num_workers=2
        r=S.Solve(M)
        _good[key]= (r==cp_model.INFEASIBLE)
        return _good[key]
    P=[r for r in range(3,4000) if isprime(r)]
    D={r:decomps(r) for r in P}
    hits=[]
    for n in sorted(rows):
        L=rows[n]
        for r1 in P:
            r2=n-r1
            if r2<=r1: break
            if not isprime(r2) or C2(r1)<=L: continue
            for k1,q1,e1 in D[r1]:
                for k2,q2,e2 in D[r2]:
                    if q1!=q2 or k1<2 or k2<2 or k1+k2>22: continue
                    if joint_good(k1,k2,q1):
                        hits.append((n,L,C2(r1),r1,r2,k1,k2,q1,e1,e2))
    print(len(hits))
    for h in hits[:30]: print(h, '%.4f vs %.4f'%(h[2]/C2(h[0]),h[1]/C2(h[0])))
else:
    import csv, itertools, sys
    from sympy import isprime, factorint
    from ortools.sat.python import cp_model
    rows={int(r['n']):int(r['L_new']) for r in csv.DictReader(open('outputs/mu_cyc_bounds_4000.csv'))}
    C2=lambda x:x*(x-1)//2
    def decomps(r):
        m=(r-1)//2; out=[(m,1,0)]
        for q,e0 in factorint(m).items():
            if q==2: continue
            for e in range(1,e0+1): out.append((m//q**e,q,e))
        return out
    def good(blocks, V, q):
        """blocks: list of (k, class size); group prod C_k; faces = tuples of subsets with total < V;
        is there an invariant complex with chi = 1 mod q (q = 1: chi = 1 exactly)?  returns True if NONE"""
        ks=[k for k,_ in blocks]; N=sum(ks); off=[sum(ks[:i]) for i in range(len(ks))]
        sz=[s for k,s in blocks for _ in range(k)]
        def rot(F,i):
            k=ks[i]; o=off[i]; part=(F>>o)&((1<<k)-1)
            part=((part<<1)|(part>>(k-1)))&((1<<k)-1) if k>1 else part
            return (F & ~(((1<<k)-1)<<o)) | (part<<o)
        w=lambda F: sum(sz[j] for j in range(N) if F>>j&1)
        faces=[F for F in range(1,1<<N) if w(F)<V]
        fs=set(faces); rep={}; reps=[]
        for F in faces:
            if F in rep: continue
            orb={F}; st=[F]
            while st:
                x=st.pop()
                for i in range(len(ks)):
                    y=rot(x,i)
                    if y not in orb: orb.add(y); st.append(y)
            for y in orb: rep[y]=F
            reps.append((F,len(orb)))
        idx={F:i for i,(F,_) in enumerate(reps)}
        M=cp_model.CpModel(); X=[M.NewBoolVar('') for _ in reps]
        for i,(F,_) in enumerate(reps):
            for j in range(N):
                if F>>j&1 and F^(1<<j): M.AddImplication(X[i],X[idx[rep[F^(1<<j)]]])
        chi=sum((1 if bin(F).count('1')%2 else -1)*c*X[i] for i,(F,c) in enumerate(reps))
        if q==1: M.Add(chi==1)
        else:
            z=M.NewIntVar(-10**7,10**7,''); M.Add(chi==1+q*z)
        S=cp_model.CpSolver(); S.parameters.max_time_in_seconds=60; S.parameters.num_workers=2
        return S.Solve(M)==cp_model.INFEASIBLE
    hits=[]
    for n in sorted(rows):
        if n%2==0: continue
        L=rows[n]; found=None
        for r in range(3,n//2+1):
            rp=n-2*r
            if rp<3 or not (isprime(r) and isprime(rp)) or r==rp: continue
            V=min(r*(r-1), C2(rp))
            if V<=L: continue
            for k,q,e in decomps(r):
                for kp,qp,ep in decomps(rp):
                    if q!=qp or 2*k+kp>18: continue
                    if good([(k,C2(r)//k),(k,C2(r)//k),(kp,C2(rp)//kp)], V, q):
                        if found is None or V>found[0]: found=(V,r,rp,k,kp,q,e,ep)
        if found: hits.append((n,L,found)); print(n,L,found,round(found[0]/C2(n),4),round(L/C2(n),4),flush=True)
    print('hits',len(hits))
