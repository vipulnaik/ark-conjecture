#!/usr/bin/env python3
"""ws_gapclose_pp.py -- the pp+pp gap rows (fpf_upper_scan.py, n <= 4000, given Conjecture P):
two single orbits of prime-power sizes a = p^e, b = r^f, not both prime, each credited C(., 2).

SCOPE: block groups Gamma_X = T x| M with M <= GammaL(1, .) (semilinear twists).  Affine M outside
GammaL(1) are NOT covered.

Readings are Gamma's own (level 1), exactly as OliverData (ws_oliver.g) computes them, assembled from
per-block data (ws_blockdata.g): for Gamma = Gamma_A x Gamma_B, Q = Gamma/O_p(Gamma) = Q_A x Q_B and
O^q(Q) = O^q(Q_A) x O^q(Q_B), cyclic iff both are cyclic of coprime orders.
Closing complexes: on a prime-power block (rank >= 2) only full skeleta of its class simplex,
which every class permutation fixes; on a prime block, also the layered complexes of ws_gapclose.py;
disjoint unions and joins of one complex on each side.
usage: python3 ws_gapclose_pp.py   (run from scripts/; calls gap)  -> ../outputs/ws_gapclose_pp.txt"""
import csv, subprocess, os
from math import comb, gcd
from functools import reduce
from sympy import factorint, divisors, isprime, primefactors
src = open('ws_gapclose.py').read(); exec(src[:src.index("open_cfg=[]")])   # layered_ok, orbit_counts, classes
L = {int(r['n']): int(r['L_new']) for r in csv.DictReader(open('../outputs/mu_cyc_bounds_4000.csv'))}
FAC = {}
def fac(x):
    if x not in FAC: FAC[x] = factorint(x)
    return FAC[x]
pp = lambda x: len(fac(x)) == 1

def block_configs(a):
    """(c, t, d, k): subgroups <w^c, w^d phi^t> of GammaL(1, a) up to conjugacy by F*, and their class counts"""
    (p, e), = fac(a).items(); N = a - 1; half = N // 2 if p != 2 else None; out = []
    for t in divisors(e):
        pt = pow(p, t)
        for c in divisors(N):
            for d in (range(gcd(c, pt - 1)) if t < e else [0]):
                par = list(range(c))
                def find(x):
                    while par[x] != x: par[x] = par[par[x]]; x = par[x]
                    return x
                for x in range(c):
                    for y in (((pt * x + d) % c) if t < e else x, ((x + half) % c) if half else x):
                        rx, ry = find(x), find(y)
                        if rx != ry: par[rx] = ry
                out.append((c, t, d, len({find(x) for x in range(c)})))
    return out

rows = [int(l.split()[0]) for l in open('../outputs/fpf_upper_scan.txt') if l[0].isdigit()]
pairs = set()
for n in rows:
    T = L[n]
    for a in range(2, n // 2 + 1):
        b = n - a
        if b > a and pp(a) and pp(b) and not (isprime(a) and isprime(b)) and min(comb(a, 2), comb(b, 2)) > T:
            pairs.add((n, a, b))
sizes = sorted({x for _, a, b in pairs for x in (a, b)})
CF = {a: block_configs(a) for a in sizes}
os.makedirs('/tmp/ws', exist_ok=True)
if not os.path.exists('/tmp/ws/blockdata.txt'):
    with open('/tmp/ws/blocks.txt', 'w') as f:
        for a in sizes:
            for c, t, d, k in CF[a]: f.write(f"{a} {c} {t} {d}\n")
    subprocess.run(['gap', '-q', '-o', '8g', 'ws_blockdata.g'], check=True)
BD = {}
for l in open('/tmp/ws/blockdata.txt'):
    v = l.split(); key = tuple(map(int, v[:4])); p = int(v[4])
    qd = {int(x.split(':')[0]): (x.split(':')[1] == 'true', int(x.split(':')[2])) for x in v[7:]}
    BD.setdefault(key, {})[p] = (v[5] == 'true', int(v[6]), qd)
def Qdata(a, cfg, p):
    D = BD[(a,) + cfg[:3]]
    return D.get(p, D[0])                 # p not dividing |Gamma_X|: Q_X = Gamma_X
def Ocyc(dat, q):                         # O^q(Q_X): (cyclic?, order)
    cyc, order, qd = dat
    return qd.get(q, (cyc, order))
def readings(a, ca, b, cb):
    ordA = BD[(a,) + ca[:3]][0][1]; ordB = BD[(b,) + cb[:3]][0][1]
    ps = sorted({2, 3, 5, 7, 11, 13} | set(primefactors(ordA)) | set(primefactors(ordB)))
    exact = False; qs = set()
    for p in ps:
        QA, QB = Qdata(a, ca, p), Qdata(b, cb, p)
        if QA[0] and QB[0] and gcd(QA[1], QB[1]) == 1: exact = True
        for q in ps:
            (cA, oA), (cB, oB) = Ocyc(QA, q), Ocyc(QB, q)
            if cA and cB and gcd(oA, oB) == 1: qs.add(q)
    return exact, qs

from functools import lru_cache
@lru_cache(maxsize=None)
def small_sums(m, s_):
    """bitset of sums of non-free C_m-orbit sizes on s_-subsets (each orbit used at most once), or None if too big"""
    oc = orbit_counts(m, s_); tot = sum(d * c for d, c in oc.items() if d < m)
    if tot > 2_000_000: return None
    bits = 1
    for d, c in oc.items():
        if d < m:
            for _ in range(c): bits |= bits << d
    return bits
def layered_exact(k, target):
    """some layered complex (pulled back from C_m, m | k) with chi exactly = target"""
    for m in divisors(k):
        if m < 2: continue
        for s_ in range(1, m):
            base = 1 - (-1) ** (s_ - 1) * comb(m - 1, s_ - 1); sg = (-1) ** (s_ - 1)
            t = (target - base) * sg
            if t < 0: continue
            oc = orbit_counts(m, s_); free = oc.get(m, 0)
            if t > sum(d * c for d, c in oc.items()): continue
            bits = small_sums(m, s_)
            if bits is None: continue
            r = t % m
            while r <= t and (bits >> r) != 0:
                if (bits >> r) & 1 and (t - r) // m <= free: return True
                r += m
    return False
@lru_cache(maxsize=None)
def skel(k):
    # empty complex, and the full skeleta: all sets of at most j classes, 1 <= j <= k - 1
    return frozenset({0} | {1 + (-1) ** (j - 1) * comb(k - 1, j) for j in range(1, k)}) if k > 1 else frozenset({0})
CHI1 = set()       # class counts k with a constructed C_k-complex of chi = 1 (cyc_chi_one_construct.py)
if os.path.exists('../outputs/cyc_chi_one_construct.txt'):
    for l in open('../outputs/cyc_chi_one_construct.txt'):
        if 'verified chi = 1' in l or 'pull-back' in l: CHI1.add(int(l.split()[0]))
def chi1(k):
    return any(k % d == 0 for d in CHI1)       # pull-back from Z_d keeps chi
@lru_cache(maxsize=None)
def side_hits(x, k, target, Q):
    """some closing complex on block x (k classes) with chi = target (Q None) or = target mod Q"""
    S = skel(k)
    if isprime(x) and k > 1 and chi1(k) and (target == 1 if Q is None else (target - 1) % Q == 0): return True
    if Q is None:
        if target in S: return True
        if isprime(x) and k > 1 and layered_exact(k, target): return True
        return False
    if any((v - target) % Q == 0 for v in S): return True
    if isprime(x) and k > 1:
        for m in divisors(k):
            if m < 2: continue
            for s_ in range(1, m):
                base = 1 - (-1) ** (s_ - 1) * comb(m - 1, s_ - 1); sg = (-1) ** (s_ - 1)
                g, R = reach_mod(orbit_counts(m, s_), Q)
                if ((target - base) * sg) % g in R: return True
    return False
def reach_mod(oc, Q):
    g = Q
    for d, c in oc.items():
        if c >= Q // gcd(d, Q): g = gcd(g, d)
    reach = {0}
    for d, c in oc.items():
        if g == 1: break
        for _ in range(min(c, g)):
            new = {(x + d) % g for x in reach}
            if new <= reach: break
            reach |= new
    return g, reach
@lru_cache(maxsize=None)
def closes(a, kA, b, kB, exact, qs):
    Q = None if exact else reduce(lambda u, v: u * v, qs, 1)
    # one side, or a union: chi_A + chi_B = 1 (mod Q); try every skeleton value on one side
    if side_hits(a, kA, 1, Q) or side_hits(b, kB, 1, Q): return True
    for x in skel(kA):
        if side_hits(b, kB, 1 - x, Q): return True
    for y in skel(kB):
        if side_hits(a, kA, 1 - y, Q): return True
    if Q is not None:      # joins: 1 - chi = (1 - x)(1 - y)
        for x in skel(kA):
            Q2 = Q // gcd(Q, (1 - x) % Q)
            if Q2 == 1 or side_hits(b, kB, 1, Q2): return True
        for y in skel(kB):
            Q2 = Q // gcd(Q, (1 - y) % Q)
            if Q2 == 1 or side_hits(a, kA, 1, Q2): return True
    return False

open_cfg = []; closed = 0; noliver = 0; ncfg = 0
for n, a, b in sorted(pairs):
    ok = True
    for ca in CF[a]:
        for cb in CF[b]:
            kA, kB = ca[3], cb[3]
            if kA == 1 and kB == 1: continue
            ncfg += 1
            exact, qs = readings(a, ca, b, cb)
            if not exact and not qs: noliver += 1; continue
            if closes(a, kA, b, kB, exact, tuple(sorted(qs))): continue
            ok = False; open_cfg.append((n, a, ca, b, cb, exact, sorted(qs)))
    closed += ok
    print(n, a, b, ok, len(open_cfg), flush=True)
bad = sorted({c[0] for c in open_cfg})
with open('../outputs/ws_gapclose_pp.txt', 'w') as f:
    f.write(f"pp+pp witness pairs {len(pairs)} in {len({n for n, _, _ in pairs})} rows; configurations {ncfg} "
            f"(not Oliver {noliver}); pairs with every configuration closed {closed}; open configurations {len(open_cfg)}; "
            f"rows with an open configuration {len(bad)}: {bad}\n")
    for c in open_cfg[:80]: f.write(f"{c}\n")
print(open('../outputs/ws_gapclose_pp.txt').read()[:3000])
