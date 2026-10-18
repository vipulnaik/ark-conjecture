"""lemma_c_share.py -- pending-checks R6 item 3: Lemma C's foreign strip against realised groups.

A matching block F_c (c = p^a, F = 1) whose cyclic twist d SHARES a prime r with a foreign block Z_r (r | d | c - 1).
Group G = <translations of F_c, g, w>:
    g = (x -> A x,          y -> y + 1)      A of order d; the chain element, diagonal on both blocks
    w = (x -> B x^(p^f),    y -> omega y)    any semilinear top element, any multiplier omega in F_r^*
w is kept when (i) it normalises <g> (so the layer N = P<g> stays cyclic over P), and (ii) the least m with w^m in <g> is
a prime power q^e > 1 (top layer a q-group).  Every such G is an Oliver group in the class the enumerator scores.
Lemma C (coupling): the realised foreign twist t = ord(omega) divides ord_r(p).
Refined credit for the same partition and q: min(orb(c, strip(c-1, [r])), orb(r, q-part of r-1), c*r) -- the matching twist
stripped of r, the foreign twist UNcoupled.  Checks: (1) coupling holds in every realised group; (2) the realised minimum
orbital never exceeds the refined credit (an excess would be a group --refined under-counts); (3) the largest realised
foreign twist per (c, r), against the credited q-part.  Negative control: --nocouple drops condition (i)'s consistency by
letting omega ignore the power map (the group is then not normalising), and must report coupling violations.
Also: (4) the realised minimum never exceeds the sharing bound min(r*ord_r(p), C(r,2)) of Corollary C', and (5) the licence
B(n) > that bound at n = c + r, B from outputs/mu_table_safe_v4.csv.
Usage: python3 lemma_c_share.py [--cmax 49] [--nocouple]"""
import sys, os, argparse
from math import comb, gcd
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import shape_realize as sr

ap = argparse.ArgumentParser(); ap.add_argument("--cmax", type=int, default=49); ap.add_argument("--nocouple", action="store_true")
args = ap.parse_args()
isprime = lambda m: m > 1 and all(m % k for k in range(2, int(m ** .5) + 1))
def ppow(m):
    for q in range(2, m + 1):
        if m % q == 0:
            while m % q == 0: m //= q
            return q if m == 1 else None
def mord(x, m):
    k, y = 1, x % m
    while y != 1: y = y * x % m; k += 1
    return k
def qpart(x, q):
    v = 1
    while x % q == 0: x //= q; v *= q
    return v
def strip(x, r):
    while x % r == 0: x //= r
    return x
def comp(u, v): return tuple(u[i] for i in v)          # u after v
def inv(u):
    r = [0] * len(u)
    for i, j in enumerate(u): r[j] = i
    return tuple(r)

tested = viol = under = overshare = 0
import csv
BT = {int(row['n']): int(row['mu_bound']) for row in csv.DictReader(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'outputs', 'mu_table_safe_v4.csv')))}
summary = {}
for c in range(4, args.cmax + 1):
    p = ppow(c)
    if not p: continue
    a = round(__import__("math").log(c, p))
    els, add, mul, one, gen = sr.field(p, a)
    idx = {x: i for i, x in enumerate(els)}
    zero = els[0] if a > 1 else 0
    nz = [x for x in els if x != zero]
    frob = lambda x, f: sr.power(mul, x, p ** f, one) if x != zero else zero
    basis = [one] if a == 1 else [tuple(1 if j == i else 0 for j in range(a)) for i in range(a)]
    for r in [x for x in range(3, c) if isprime(x) and x != p and (c - 1) % x == 0]:
        N = c + r
        trans = [tuple([idx[add(x, e)] for x in els] + list(range(c, N))) for e in basis]
        for d in [x for x in range(r, c) if (c - 1) % x == 0 and x % r == 0]:
            A = sr.power(mul, gen, (c - 1) // d, one)
            g = tuple([idx[mul(A, x)] for x in els] + [c + (y + 1) % r for y in range(r)])
            gp = [tuple(range(N))]
            while True:
                nx = comp(g, gp[-1])
                if nx == gp[0]: break
                gp.append(nx)
            gset = set(gp)
            seen_w = set()
            for f in range(a):
                for B in nz:
                    for om in range(1, r):
                        w = tuple([idx[mul(B, frob(x, f))] for x in els] + [c + (om * y) % r for y in range(r)])
                        conj = comp(comp(w, g), inv(w))
                        if conj not in gset and not args.nocouple: continue
                        if args.nocouple and conj in gset: continue
                        m, wm = 1, w
                        while wm not in gset and m <= 4 * c * r: wm = comp(w, wm); m += 1
                        if wm not in gset: continue
                        q = ppow(m)
                        if not q: continue
                        key = (f, om, frozenset([comp(w, h) for h in gp][:1]))
                        tested += 1
                        t = mord(om, r)
                        if mord(p, r) % t:
                            viol += 1
                            if viol <= 5: print(f"  COUPLING VIOLATION c={c} r={r} d={d} f={f} omega={om}: t={t}, ord_r(p)={mord(p, r)}")
                        if args.nocouple: continue
                        allo = sr.orbitals(N, trans + [g, w])
                        realised = allo[0]
                        credit = min(sr.orb(c, strip(c - 1, r), p == 2), sr.orb(r, qpart(r - 1, q), False), c * r)
                        if realised > credit:
                            under += 1
                            if under <= 3: print(f"  refined under-count c={c} r={r} d={d} q={q}: realised {realised} > refined credit {credit}")
                        if realised > min(r * mord(p, r), comb(r, 2)):
                            overshare += 1
                            print(f"  SHARING BOUND EXCEEDED c={c} r={r} d={d} q={q}: realised {realised}")
                        s = summary.setdefault((c, r), [0, set(), 0, 0])
                        s[0] = max(s[0], t); s[1].add(q); s[2] = max(s[2], realised)
                        s[3] = max(s[3], max(sr.orb(c, strip(c - 1, r), p == 2) if True else 0, 0))
print(f"realisable sharing groups tested: {tested}; coupling violations: {viol}; refined under-counts: {under}; sharing-bound excesses: {overshare}")
if not args.nocouple:
    print("\n   c   r  ord_r(p)  max realised foreign t  credited q-part(r-1) per q   max realised min-orbital  refined credit (best q)  sharing bound min(r*ord, C(r,2))   B(c+r)  licence")
    for (c, r), (t, qs, rm, _) in sorted(summary.items()):
        p = ppow(c); o = mord(p, r)
        cred = {q: qpart(r - 1, q) for q in sorted(qs)}
        best = max(min(sr.orb(c, strip(c - 1, r), p == 2), sr.orb(r, qpart(r - 1, q), False), c * r) for q in qs)
        print(f"{c:4d} {r:3d} {o:6d} {t:14d}           {str(cred):24s} {rm:12d} {best:22d} {min(r * o, comb(r, 2)):20d} {BT.get(c + r, '-')!s:>8} {('ok' if BT.get(c + r, 0) > max(rm, best) else 'FAILS') if c + r in BT else 'no row'}")
