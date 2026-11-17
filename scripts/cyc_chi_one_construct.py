#!/usr/bin/env python3
"""cyc_chi_one_construct.py -- a C_k-invariant proper complex on Z_k with chi = 1, for k with a coprime split k = a b.

Construction.
  1. X on Z_a, Y on Z_b: layered complexes (all sets of < s points, plus chosen C-orbits of s-sets).
     Delta0 = {S : S mod a in X} cup {S : S mod b in Y}  (union of two pull-backs).  Since gcd(a, b) = 1,
     chi(Delta0) = x + y - x y, i.e. 1 - chi = (1 - x)(1 - y)   (cyc_pullback_union.py; checked by enumeration).
     Choose X, Y with (1 - x)(1 - y) = 0 mod k, so chi(Delta0) = 1 + c k.
  2. Correct by free C_k-orbits: adding an orbit of minimal non-faces of size t changes chi by (-1)^(t-1) k;
     orbits of minimal non-faces of one size t can be added in any combination (their proper subsets are untouched).
     Add |c| free orbits of the right parity.  The result is proper and C_k-invariant with chi = 1.
  3. If no split works but a proper divisor d of k has a construction, pull it back along Z_k -> Z_d
     ({S : S mod d in Delta}); pull-back keeps chi (each face F contributes prod over its fibres of
     sum_{T nonempty} (-1)^{|T|-1} = 1, times (-1)^{|F|-1}).
usage: python3 cyc_chi_one_construct.py k [k ...]     -> one line per k (writes nothing)"""
import sys, random, itertools
from math import gcd, comb
from sympy import factorint, divisors

def orbit_reps(d, s):
    seen = set(); out = []
    for f in itertools.combinations(range(d), s):
        if f in seen: continue
        o = {tuple(sorted((x + i) % d for x in f)) for i in range(d)}; seen |= o; out.append(sorted(o))
    return out
def layered(d, s, chosen):
    """(membership test, chi) of: all sets of < s points of Z_d, plus the s-sets of the chosen orbits"""
    top = set(); 
    for o in chosen: top |= {frozenset(f) for f in o}
    chi = sum((-1) ** (r - 1) * comb(d, r) for r in range(1, s)) + (-1) ** (s - 1) * len(top)
    def mem(S):
        return len(S) < s or (len(S) == s and frozenset(S) in top)
    return mem, chi
def canon(S, k):
    return min(tuple(sorted((x + i) % k for x in S)) for i in range(k))
def free(S, k):
    T = frozenset(S)
    return all(frozenset((x + i) % k for x in S) != T for i in divisors(k)[:-1] if i)

def construct(k, rng, tries=4000):
    f = factorint(k)
    if len(f) < 2: return None
    ps = list(f); splits = []
    for r in range(1, len(ps)):
        for A in itertools.combinations(ps, r):
            a = 1
            for p in A: a *= p ** f[p]
            if a < k // a or True: splits.append((a, k // a))
    for _ in range(tries):
        a, b = rng.choice(splits)
        if a > 40 or b > 4000: continue
        sa = rng.randint(1, min(a - 1, 4)); sb = rng.randint(1, min(b - 1, 3 if b > 60 else 4))
        oa = orbit_reps(a, sa); ob = orbit_reps(b, sb) if comb(b, sb) <= 200000 else None
        if ob is None: continue
        ca = [o for o in oa if rng.random() < 0.5]; cb = [o for o in ob if rng.random() < 0.5]
        if sa == a - 1 and len(ca) == len(oa): continue
        if sb == b - 1 and len(cb) == len(ob): continue
        mX, x = layered(a, sa, ca); mY, y = layered(b, sb, cb)
        if ((1 - x) * (1 - y)) % k: continue
        chi0 = x + y - x * y; c = (chi0 - 1) // k            # need to subtract c k
        if abs(c) > 50: continue
        def inD(S): return mX({v % a for v in S}) or mY({v % b for v in S})
        # minimal non-faces, free, of a parity giving -k (even size) if c > 0, +k (odd size) if c < 0
        need = abs(c); found = {}
        for t in range(2, 9):
            if need == 0: break
            if (t % 2 == 0) != (c > 0): continue
            for _ in range(20000):
                S = rng.sample(range(k), t)
                if inD(S): continue
                if not all(inD([v for v in S if v != w]) for w in S): continue
                if not free(S, k): continue
                found.setdefault(t, set()).add(canon(S, k))
                if len(found[t]) >= need: break
        if need == 0 or any(len(v) >= need for v in found.values()):
            t = max(found, key=lambda u: len(found[u])) if need else None
            if True:
                return dict(mX=mX, mY=mY, k=k, a=a, b=b, sX=sa, X=len(ca), x=x, sY=sb, Y=len(cb), y=y, chi0=chi0,
                            correction=c, t=t if need else None, orbits=sorted(found.get(t, set()))[:need] if need else [])
    return None

def side_values(d, smax):
    """value -> (s, {size: count}) for layered complexes on Z_d, s <= smax, proper"""
    out = {}
    for s in range(1, min(smax, d - 1) + 1):
        orbs = orbit_reps(d, s); sizes = {}
        for o in orbs: sizes[len(o)] = sizes.get(len(o), 0) + 1
        base = sum((-1) ** (r - 1) * comb(d, r) for r in range(1, s)); sg = (-1) ** (s - 1)
        items = sorted(sizes.items())
        def rec(i, t, pick):
            if i == len(items):
                if s == d - 1 and all(pick.get(e, 0) == c for e, c in items): return
                v = base + sg * t
                if v not in out: out[v] = (s, dict(pick))
                return
            e, c = items[i]
            for n in range(c + 1):
                pick[e] = n; rec(i + 1, t + n * e, pick)
            del pick[e]
        if eval_size(items) <= 2_000_000: rec(0, 0, {})
    return out
def eval_size(items):
    p = 1
    for e, c in items: p *= c + 1
    return p
def realize(d, s, pick):
    orbs = orbit_reps(d, s); chosen = []; left = dict(pick)
    for o in orbs:
        if left.get(len(o), 0) > 0: chosen.append(o); left[len(o)] -= 1
    return layered(d, s, chosen)
def construct2(k, rng, samples=400000):
    f = factorint(k)
    if len(f) < 2: return None
    ps = list(f); best = None
    for r in range(1, len(ps)):
        for A in itertools.combinations(ps, r):
            a = 1
            for p in A: a *= p ** f[p]
            b = k // a
            if a > b: continue
            if a > 60: continue
            Va = side_values(a, a - 1 if a <= 12 else (4 if a <= 20 else 3)); Vb = side_values(b, 3 if b <= 120 else 2)
            byres = {}
            for m in divisors(k):
                ys = [y for y in Vb if (1 - y) % m == 0]
                if ys: byres[m] = min(ys, key=lambda y: abs(1 - y))
            for x in Va:
                m = k // gcd((1 - x) % k or k, k)
                if m in byres:
                    y = byres[m]; c = -((1 - x) * (1 - y)) // k     # chi0 = 1 + c k ... chi0 - 1 = -(1-x)(1-y)
                    if best is None or abs(c) < abs(best[0]): best = (c, a, b, x, Va[x], y, Vb[y])
    if best is None: return None
    c, a, b, x, (sa, pa), y, (sb, pb) = best
    mX, x2 = realize(a, sa, pa); mY, y2 = realize(b, sb, pb); assert (x2, y2) == (x, y)
    chi0 = x + y - x * y; assert chi0 - 1 == c * k
    def inD(S): return mX({v % a for v in S}) or mY({v % b for v in S})
    need = abs(c); found = {}
    for t in range(2, 10):
        if need == 0 or (t % 2 == 0) != (c > 0): continue
        for _ in range(samples):
            S = rng.sample(range(k), t)
            if inD(S) or not all(inD([v for v in S if v != w]) for w in S) or not free(S, k): continue
            found.setdefault(t, set()).add(canon(S, k))
            if len(found[t]) >= need: break
        if len(found.get(t, ())) >= need: break
    if need and not any(len(v) >= need for v in found.values()): return dict(fail='corrections', k=k, c=c, found={t: len(v) for t, v in found.items()})
    t = next((u for u in found if len(found[u]) >= need), None) if need else None
    return dict(mX=mX, mY=mY, k=k, a=a, b=b, sX=sa, X=sum(pa.values()), x=x, sY=sb, Y=sum(pb.values()), y=y,
                chi0=chi0, correction=c, t=t, orbits=sorted(found[t])[:need] if need else [])

def verify(r):
    """independent check.  chi(Delta0) by summing over exact supports R (mod a) and C (mod b):
    S <-> a 0/1 matrix on Z_a x Z_b (CRT); the signed count of matrices with exact row support R and column
    support C, sum (-1)^(|S|-1), is g(|R|, |C|), brute-forced for small sizes and checked against (-1)^(|R|+|C|);
    then each correction orbit is re-tested (non-face, all facets faces, free, distinct)."""
    k, a, b, mX, mY = r['k'], r['a'], r['b'], r['mX'], r['mY']
    def g_brute(p, q):
        tot = 0; cells = [(i, j) for i in range(p) for j in range(q)]
        for m in range(1, 1 << len(cells)):
            S = [cells[t] for t in range(len(cells)) if m >> t & 1]
            if {i for i, _ in S} == set(range(p)) and {j for _, j in S} == set(range(q)): tot += (-1) ** (len(S) - 1)
        return tot
    for p in range(1, 4):
        for q in range(1, 5 if p < 3 else 4):
            assert g_brute(p, q) == (-1) ** (p + q), (p, q)
    Rs = [R for r_ in range(1, a + 1) for R in itertools.combinations(range(a), r_)]
    Cs = [C for c_ in range(1, b + 1) for C in itertools.combinations(range(b), c_)] if b <= 14 else None
    if Cs is None:      # b large: group C by membership in Y and size, counted via orbits of the layered structure
        from collections import Counter
        cnt = Counter()
        for c_ in range(1, b + 1):
            tot = comb(b, c_)
            if c_ < r['sY']: cnt[(c_, True)] += tot
            elif c_ == r['sY']:
                inY = sum(1 for C in itertools.combinations(range(b), c_) if mY(set(C))) if comb(b, c_) <= 3_000_000 else None
                if inY is None: return None
                cnt[(c_, True)] += inY; cnt[(c_, False)] += tot - inY
            else: cnt[(c_, False)] += tot
        chi0 = 0
        for R in Rs:
            inX = mX(set(R))
            for (c_, inY), m in cnt.items():
                if inX or inY: chi0 += m * (-1) ** (len(R) + c_)
    else:
        chi0 = 0
        Yin = {C: mY(set(C)) for C in Cs}
        for R in Rs:
            inX = mX(set(R))
            for C in Cs:
                if inX or Yin[C]: chi0 += (-1) ** (len(R) + len(C))
    assert chi0 == r['chi0'], (chi0, r['chi0'])
    def inD(S): return mX({v % a for v in S}) or mY({v % b for v in S})
    reps = r['orbits']; assert len(set(reps)) == len(reps) == abs(r['correction'])
    for S in reps:
        assert not inD(S) and all(inD([v for v in S if v != w]) for w in S) and free(S, k)
        assert len(S) == r['t'] and (len(S) % 2 == 0) == (r['correction'] > 0)
    return chi0 - r['correction'] * k

if __name__ == "__main__":
    rng = random.Random(11); done = {}
    for k in map(int, sys.argv[1:]):
        via = [d for d in done if k % d == 0 and d < k]
        if via: print(k, "pull-back of the construction for", via[0], flush=True); done[k] = 1; continue
        r = construct2(k, rng)
        if r is not None and 'fail' in r: print(k, r, flush=True); continue
        if r is None: print(k, "NONE", flush=True); continue
        v = verify(r)
        if v == 1: done[k] = 1
        print(k, {kk: v for kk, v in r.items() if kk not in ('orbits', 'mX', 'mY')}, "verified chi =", v, flush=True)
