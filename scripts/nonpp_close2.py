#!/usr/bin/env python3
"""(header of merged_threshold_close.py, kept for its definitions)
merged_threshold_close.py -- merged-class and three-class witnesses of the 496 gap rows (threshold-beyond-mu.md §6.4), second pass.

MODEL (stated scope): every block has prime-power size; block groups Gamma_X = T x| M, M <= GammaL(1, .) (the scope of
ws_gapclose_pp.py); the m >= 2 orbits of a merged class (a, m) are INDEPENDENT copies with the SAME configuration,
swapped by N*: Gamma = prod_X Gamma_X^{m_X}.  (Copies with different configurations are not fused by N*: each is a type
of total <= C(a, 2) <= T and the full simplex on it gives chi = 1.  Linked copies -- subdirect products with cross
orbitals -- are NOT covered.)  Witnesses with a non-prime-power block are not modelled.
READINGS (level 1, from per-block GAP data: /tmp/ws/blockdata.txt and blockdata_m.txt, blockdata_m3.txt from ws_blockdata.g / ws_blockdata_m.g,
the last with blocks_m3.txt -> blockdata_m3.txt substituted):
Q = Gamma / O_p(Gamma) = prod Q_X^{m_X}, O^q(Q) = prod O^q(Q_X)^{m_X}.  For (p, q): O^q(Q) is cyclic iff O^q(Q_X) = 1 for
every merged X and the single blocks' O^q(Q_X) are cyclic of pairwise coprime orders; exact (chi = 1) iff Q is cyclic
in the same sense.  No reading: Gamma is not Oliver, nothing to close.
N*: conservatively ANY permutation of the classes preserving weights (so on a prime-power block only weight-threshold
complexes), except on a single prime block, where N* acts on the classes as C_k (as in section 6).
CLOSERS: disjoint unions (chi adds) of
  Delta_V on one size-class of blocks (all sets of its usable classes of total weight <= V; invariant under any N*),
  on a prime block, or m merged copies of one (N* acting on each copy's classes as C_k and permuting the copies), the
  disjoint union of the m images of one circulant graph on the k classes (all vertices, e free edge orbits, and for
  even k optionally the orbit of diameters): chi = m (k - k e - (k/2) h), faces of 2 classes;
  the chi values of C_k-invariant complexes within the cap from ws_budget_scan (quick_values, exact_values), and for odd k with
  cap >= 3 the complexes 'all vertices, all edge orbits, t free triangle orbits' (chi = k (1 - (k-1)/2 + t)), m copies;
  and, on one single prime block, a C_k-invariant complex with chi = t (roomy_close.chi1_ok, target t), faces <= T.
Each family is cut to its 3000 values of least |chi| (or least residue) before the sumsets: sound, since a
closure needs only one value.  Accept chi = 1 (exact reading) or chi = 1 mod Q (Q = product of the reading primes q).
usage: python3 merged_threshold_close.py -> ../outputs/merged_threshold_close.txt
       python3 merged_threshold_close.py three -> ../outputs/merged_threshold_close_three.txt (three-class witnesses only;
       the default run already includes them)"""
import ast, sys, io, contextlib, itertools
from math import gcd, comb, factorial
from functools import reduce, lru_cache
from collections import Counter
from sympy import factorint, isprime, primefactors
ARGV = list(sys.argv); sys.argv = ['x']
with contextlib.redirect_stdout(io.StringIO()):
    src = open('ws_budget_pp.py').read(); exec(src[:src.index('if __name__')])   # block_configs, weights
    from roomy_close import chi1_ok
    import ws_budget_scan as WB
BD = {}
for fn in ('/tmp/ws/blockdata.txt', '/tmp/ws/blockdata_m.txt', '/tmp/ws/blockdata_m3.txt'):
    for l in open(fn):
        v = l.split(); key = tuple(map(int, v[:4])); p = int(v[4])
        qd = {int(x.split(':')[0]): (x.split(':')[1] == 'true', int(x.split(':')[2])) for x in v[7:]}
        BD.setdefault(key, {})[p] = (v[5] == 'true', int(v[6]), qd)
def Q(a, c, p):
    D = BD[(a,) + c[:3]]; return D.get(p, D[0])
def readings(blocks):          # blocks: list of (a, m, cfg)
    ps = sorted({2, 3, 5, 7, 11, 13} | {r for a, m, c in blocks for r in primefactors(BD[(a,) + c[:3]][0][1])})
    exact = False; qs = set()
    def ok(parts, merged):
        if any(o != 1 for (cy, o) in merged): return False
        if not all(cy for cy, o in parts): return False
        return all(gcd(x[1], y[1]) == 1 for x, y in itertools.combinations(parts, 2))
    for p in ps:
        D = [(m, Q(a, c, p)) for a, m, c in blocks]
        if ok([(d[0], d[1]) for m, d in D if m == 1], [(d[0], d[1]) for m, d in D if m >= 2]): exact = True
        for q in ps:
            O = [(m, d[2].get(q, (d[0], d[1]))) for m, d in D]
            if ok([o for m, o in O if m == 1], [o for m, o in O if m >= 2]): qs.add(q)
    return exact, qs
def threshold_chis(W, T):
    U = sorted(w for w in W if w <= T)
    if U and U[0] == U[-1]:      # equal weights: Delta_V is the j-skeleton of the simplex on K vertices
        K = len(U); J = min(K, T // U[0])
        return {0} | {1 - (-1) ** j * comb(K - 1, j) for j in range(1, J + 1)}
    f = {0: 1}
    for w in U:
        g = dict(f)
        for s, v in f.items():
            if s + w <= T: g[s + w] = g.get(s + w, 0) - v
        f = g
    out = {0}; acc = 0
    for s in sorted(f):
        if s: acc -= f[s]; out.add(acc)
    return out
@lru_cache(maxsize=None)
def pvals(k, cap):
    out = frozenset(WB.quick_values(k, cap)) | frozenset(WB.exact_values(k, cap))
    if k % 2 and k >= 5 and cap >= 3:   # vertices, all (k-1)/2 (free) edge orbits, t free triangle orbits: chi = k(1 - (k-1)/2 + t);
        # free triangle orbits number (C(k,3) - [3 | k] k/3) / k >= (k-1)(k-2)/6 - 1
        h = (k - 1) // 2
        out |= frozenset(k * (1 - h + t) for t in range((k - 1) * (k - 2) // 6))
    return out
@lru_cache(maxsize=None)
def chi1c(k, cap, t): return chi1_ok(k, cap, target=t)[0]
CFG = {}
def cfgs(a):
    if a not in CFG: CFG[a] = block_configs(a)
    return CFG[a]

# ---------------------------------------------------------------------------------------------------------------
# nonpp_close2.py -- second pass on the non-prime-power witnesses (threshold-beyond-mu.md §6.4), correcting the model
# of nonpp_close.py and adding a reading test.
# MODEL. O (size a) is one Gamma-orbit with blocks of prime-power size b (P's induction; see nonpp_close.py), m = a/b.
#   A class of pairs inside a block, with its images in the other blocks, is ONE Gamma-orbital of weight m*w (w a class
#   weight of the block configuration), not m classes of weight w.  Cross-block classes are ignored (only loses
#   closures).  The prime-power block (c, 1) has its own classes.  ΓL(1) twists; C_k on prime blocks' classes.
# READING TEST (Lemma H, threshold-beyond-mu.md §6.4).  For a constituent X (O's blocks, or the c-block with m = 1) of
#   characteristic p_X and dimension d_X, block action T x| M with M = <w^c, w^d phi^t>, a reading (p, q) with
#   p != p_X forces: (q != p_X, d_X = 1, M a q-group) or (q = p_X, M a p_X-group) -- unless the block kernel K is
#   trivial, possible for O only if b * |M| <= (m - 1)!, or M is reducible on T (d >= 2), where K^B need not
#   contain T_B; such constituents impose no constraint.  Tested over p in the constituents' characteristics, the
#   primes of |M|, {2, 3} and "any other prime", and q in the same list.
# CLOSE: no reading (not Oliver); otherwise chi = 1 if an exact reading is possible (for p != p_X: d_X = 1 and M_X = 1),
#   else chi = 1 mod the product of all feasible q, from the classes above (thresholds, prime-block values, unions).
# usage: python3 nonpp_close2.py -> ../outputs/nonpp_close2.txt
lines = open('../outputs/merged_rows_scan.txt').read().strip().split('\n')[1:]
wits = sorted({(x[0], x[1], x[2]) for x in map(ast.literal_eval, lines)})
wits = [x for x in wits if not all(len(factorint(a)) == 1 for a, m in x[2])]
ppq = lambda a: len(factorint(a)) == 1
tau = lambda a: comb(a, 2) if ppq(a) else a * (max(p ** e for p, e in factorint(a).items()) - 1) // 2
def charp(a): return list(factorint(a))[0]
def morder(b, cfg):
    (ch, e), = factorint(b).items(); cc, t, d = cfg[:3]; N = b - 1
    g = gcd(cc, d * N // (ch ** t - 1)) if t < e else cc
    return N // g * (e // t if t < e else 1)
def irreducible(b, cfg):         # is the multiplicative part <w^g> of M irreducible on F_p^d?  (d = 1: always)
    (ch, e), = factorint(b).items()
    if e == 1: return True
    cc, t, d = cfg[:3]; N = b - 1
    g = gcd(cc, d * N // (ch ** t - 1)) if t < e else cc
    o = N // g
    return all((ch ** s - 1) % o for s in range(1, e) if e % s == 0)
def readings_of(parts):         # Lemma H (sharpened): feasible q's, and whether an exact reading is possible
    chars = {charp(b) for b, m, cfg, blk in parts}
    primes = set(chars)
    for b, m, cfg, blk in parts: primes |= set(factorint(morder(b, cfg)))
    primes |= {2, 3}
    isqpow = lambda x, r: x == 1 or set(factorint(x)) == {r}
    qs = set(); exact = False
    for p in primes | {0}:              # p = 0: a prime that is no constituent's characteristic
        ex = True
        for b, m, cfg, blk in parts:    # exact (Q cyclic) needs, for p != p_X: K's image T_X cyclic and M_X = 1
            px = charp(b); d = list(factorint(b).values())[0]
            if p == px or (blk and b * morder(b, cfg) <= factorial(m - 1)) or not irreducible(b, cfg): continue
            if not (d == 1 and morder(b, cfg) == 1): ex = False
        exact = exact or ex
        for q in primes:
            ok = True
            for b, m, cfg, blk in parts:
                px = charp(b); d = list(factorint(b).values())[0]; mo = morder(b, cfg)
                if p == px: continue
                if blk and b * mo <= factorial(m - 1): continue
                if not irreducible(b, cfg): continue                     # Lemma H needs K^B >= T_B (G primitive)
                if q != px and d == 1 and isqpow(mo, q): continue
                if q == px and isqpow(mo, px): continue
                ok = False; break
            if ok: qs.add(q)
    return exact, qs
def close(classes, prime_blocks, T, exact, Qm):
    """chi = 1 (exact) or chi = 1 mod Qm from disjoint unions of: thresholds on each family, C_k values on prime ones"""
    red = (lambda x: x) if exact else (lambda x: x % Qm)
    fams = [threshold_chis(W, T) for W in classes]
    for i, k, w0 in prime_blocks:
        if k >= 2 and T // w0 >= 2:
            fams[i] = fams[i] | {k - k * e - (k // 2) * h for e in range((k - 1) // 2 + 1) for h in ((0, 1) if k % 2 == 0 else (0,))}
            fams[i] = fams[i] | set(pvals(k, min(T // w0, k - 1)))
    fams = [set(sorted({red(y) for y in F}, key=abs)[:3000]) for F in fams]
    big = max(range(len(fams)), key=lambda i: len(fams[i]))
    vals = {0}
    for i, F in enumerate(fams):
        if i != big: vals = {red(x + y) for x in vals for y in F if not exact or abs(x + y) < 10**12}
    return any(red(1 - x) in fams[big] for x in vals)
res = Counter(); cres = Counter(); left = []; rows_open = set(); allrows = {x[0] for x in wits}
for n, T, w in wits:
    nps = [(a, m) for a, m in w if not ppq(a)]; pps = [(a, m) for a, m in w if ppq(a)]
    if len(nps) != 1 or nps[0][1] != 1 or len(pps) > 1 or (pps and pps[0][1] != 1):
        res['open: shape not modelled'] += 1; rows_open.add(n); left.append((n, T, w, 'shape')); continue
    c0 = pps[0][0] if pps else None; A = nps[0][0]
    divs = [b for b in range(2, A) if A % b == 0 and (A // b) * tau(b) > T]
    if not divs: res['closed: O has a type <= T (P induction)'] += 1; continue
    if any(not ppq(b) for b in divs): res['open: a non-prime-power block size passes'] += 1; rows_open.add(n); left.append((n, T, w, 'nonpp b', divs)); continue
    bad = []
    for b in divs:
        m = A // b
        for cb in cfgs(b):
            for cc in (cfgs(c0) if c0 else [None]):
                parts = [(b, m, cb, True)] + ([(c0, 1, cc, False)] if c0 else [])
                exact, qs = readings_of(parts)
                if not exact and not qs: cres['no reading (Lemma H)'] += 1; continue
                Qm = reduce(lambda u, v: u * v, qs, 1)
                classes = [[m * x for x in weights(b, cb)]] + ([weights(c0, cc)] if c0 else [])
                pb = []
                if isprime(b): pb.append((0, cb[3], m * weights(b, cb)[0]))
                if c0 and isprime(c0): pb.append((1, cc[3], weights(c0, cc)[0]))
                if close(classes, pb, T, exact, Qm): cres['closed (chi = 1, or 1 mod the feasible q)'] += 1; continue
                cres['open'] += 1; bad.append((b, cb[:4], cc[:4] if cc else None))
    print(n, w, len(bad), flush=True)
    if bad: res['open: configurations left'] += 1; rows_open.add(n); left.append((n, T, w, len(bad), bad[:5]))
    else: res['closed: every configuration'] += 1
with open('../outputs/nonpp_close2.txt', 'w') as fh:
    fh.write(f"witnesses: {dict(res)}\nconfigurations: {dict(cres)}\nrows with an open witness: {len(rows_open)} of {len(allrows)}\n")
    for x in left: fh.write(f"{x}\n")
print(open('../outputs/nonpp_close2.txt').read()[:3000])
