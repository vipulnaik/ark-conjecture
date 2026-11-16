import csv, sys
from math import comb, gcd
from sympy import isprime, factorint, divisors
sys.argv=['x']; sys.path.insert(0,'.'); import cyclic_chi_recursive as C
L={int(r['n']):int(r['L_new']) for r in csv.DictReader(open('../outputs/mu_cyc_bounds_4000.csv'))}
rows=[(int(l.split()[0]),l) for l in open('../outputs/fpf_upper_scan.txt') if l[0].isdigit()]
_V={}
import pickle
import mu_cyc_bounds as MB
EX=pickle.load(open('../outputs/cyclic_nested_pairs.pkl','rb'))
def vals(k):
    """values of chi attained by C_k-invariant proper complexes on k points: exact sets for k <= 9,
    otherwise skeleta of k and of every divisor (pull-back keeps chi)"""
    if k in _V: return _V[k]
    out={0}
    if k>1:
        if k in EX: out|={e[0] for e in EX[k]}
        for m in divisors(k):
            if m<2: continue
            if m in EX: out|={e[0] for e in EX[m]}
            b=1
            for s in range(0,m-1):          # s-skeleton, s <= m - 2
                b=comb(m-1,s); out.add(1-(-1)**s*b)
    if k>1 and MB.status(k, None)==MB.BAD: out.add(1)     # chi = 1 attained exactly (ATT1, pull-back)
    _V[k]=out; return out

from sympy import mobius
_OC={}
def orbit_counts(m,s):
    """{orbit size: number of orbits} for C_m acting on s-subsets of Z_m"""
    if (m,s) in _OC: return _OC[(m,s)]
    g=gcd(m,s); out={}
    for e in divisors(g):
        f=sum(mobius(e2//e)*comb(m//e2,s//e2) for e2 in divisors(g) if e2%e==0)
        if f: out[m//e]=f//(m//e)
    _OC[(m,s)]=out; return out
def layered_ok(k,test_res,target_exact):
    """complexes pulled back from C_m on m points (m | k): the full (s-1)-skeleton plus any union of
    C_m-orbits of s-faces, 1 <= s <= m-1 (all proper).  chi = base + (-1)^s t, t a sum of orbit sizes.
    test_res(q) -> residues r with chi = r mod q acceptable; target_exact: require chi = 1."""
    for m in divisors(k):
        if m<2: continue
        for s_ in range(1,m):
            base=1-(-1)**(s_-1)*comb(m-1,s_-1) if s_>=1 else 0
            oc=orbit_counts(m,s_); sg=(-1)**s_
            if target_exact:
                t=(1-base)*sg; tot=sum(d*c for d,c in oc.items())
                if t<0 or t>tot or t>5_000_000: continue
                bits=1
                for d,c in oc.items():
                    for _ in range(min(c, t//d+1)): bits|=bits<<d
                    bits&=(1<<(t+1))-1
                if bits>>t&1: return True
            else:
                q=test_res
                reach={0}
                for d,c in oc.items():
                    for _ in range(min(c,q)): reach|={(x+d)%q for x in reach}
                if any((base+sg*t-1)%q==0 for t in reach): return True
    return False

def resset(k,Q):
    """chi mod Q over the layered complexes of layered_ok (and the empty complex)"""
    out={0}
    if k<2: return out
    for m in divisors(k):
        if m<2: continue
        for s_ in range(1,m):
            base=1-(-1)**(s_-1)*comb(m-1,s_-1); sg=(-1)**s_
            reach={0}
            for d,c in orbit_counts(m,s_).items():
                for _ in range(min(c,Q)):
                    new={(x+d)%Q for x in reach}
                    if new<=reach: break
                    reach|=new
            out|={(base+sg*t)%Q for t in reach}
    return out
def classes(p,d):          # unordered classes of the twist subgroup of order d in Z_p^*
    return (p-1)//d if d%2==0 else (p-1)//(2*d)
open_cfg=[]; closed_pairs=0; pairs=0; pp_witness=0
for n,l in rows:
    T=L[n]
    for a in range(3,n-2):
        b=n-a
        if b<=a or min(comb(a,2),comb(b,2))<=T: continue
        if not (isprime(a) and isprime(b)):
            if len(factorint(a))==1 and len(factorint(b))==1: pp_witness+=1
            continue
        pairs+=1; ok=True
        for A,B in ((a,b),(b,a)):                 # P = T_A ; B's twist a q-power
            for dB in divisors(B-1):
                f=factorint(dB)
                if len(f)>1: continue
                q=list(f)[0] if f else None        # dB = 1: no twist on B
                kB=classes(B,dB)
                for dA in divisors(A-1):
                    if dA%B==0: continue           # H/P cyclic needs gcd(|M_A|, B) = 1
                    kA=classes(A,dA)
                    if kA==1 and kB==1: continue   # both 2-homogeneous: a mu* group
                    # a complex with chi = 1 exactly (satisfies every reading), from one side or a disjoint union
                    VA,VB=vals(kA),vals(kB)
                    # Gamma's own Oliver readings (level 1, H = Gamma): an orientation (X, Y) is
                    # available when P = T_X, C = M_X x T_Y is cyclic (gcd(|M_X|, p_Y) = 1) and
                    # Gamma/C = M_Y is a q-group; exact when M_Y = 1, otherwise mod q
                    exact=False; R=set()
                    for (pX,dX,pY,dY) in ((A,dA,B,dB),(B,dB,A,dA)):
                        if gcd(dX,pY)!=1: continue
                        fY=factorint(dY)
                        if len(fY)>1: continue
                        if dY==1: exact=True
                        else: R|=set(fY)
                    good=lambda x: (x==1) if exact else all((x-1)%r==0 for r in R)
                    if any(good(x) for x in VA) or any(good(y) for y in VB) or any(good(x+y) for x in VA for y in VB):
                        continue
                    # layered complexes on one side (every reading at once)
                    def side_ok(k):
                        if k<2: return False
                        if exact: return layered_ok(k,None,True)
                        from functools import reduce
                        Q=reduce(lambda a,b:a*b,R,1)
                        return layered_ok(k,Q,False)
                    if side_ok(kA) or side_ok(kB): continue
                    if not exact:                  # disjoint union of a layered complex on each side
                        from functools import reduce
                        Q=reduce(lambda a,b:a*b,R,1); RB=resset(kB,Q)
                        if any((1-x)%Q in RB for x in resset(kA,Q)): continue
                    ok=False; open_cfg.append((n,T,A,dA,kA,B,dB,kB,q))
        closed_pairs+=ok
print('gap rows',len(rows),'prime pairs above T',pairs,'closed (every configuration has a complex meeting all its readings)',closed_pairs,
      '; prime-power (non-prime) witness pairs',pp_witness,'; open configurations',len(open_cfg))
print(open_cfg[:15])
