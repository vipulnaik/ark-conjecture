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
                    # Oliver readings, over-approximated (a superset keeps BAD certificates sound):
                    # killing T_X leaves M_X x (T_Y x| M_Y); exact if M_Y = 1 and gcd(|M_X|, p_Y) = 1;
                    # a reading mod r when M_Y is an r-group (r ranging over primes of |M_Y|, and every
                    # small prime when M_Y = 1)
                    exact=False; R=set()
                    for (pX,dX,pY,dY) in ((A,dA,B,dB),(B,dB,A,dA)):
                        if dY==1 and gcd(dX,pY)==1: exact=True
                        fY=factorint(dY)
                        if len(fY)==1: R|=set(fY)
                        if dY==1: R|=set(factorint(dX))|{pY}
                    good=lambda x: (x==1) if exact else all((x-1)%r==0 for r in R)
                    if any(good(x) for x in VA) or any(good(y) for y in VB) or any(good(x+y) for x in VA for y in VB):
                        continue
                    ok=False; open_cfg.append((n,T,A,dA,kA,B,dB,kB,q))
        closed_pairs+=ok
print('gap rows',len(rows),'prime pairs above T',pairs,'closed (every configuration has a complex meeting all its readings)',closed_pairs,
      '; prime-power (non-prime) witness pairs',pp_witness,'; open configurations',len(open_cfg))
print(open_cfg[:15])
