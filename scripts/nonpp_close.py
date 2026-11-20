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
from math import gcd, comb
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
# nonpp_close.py -- the gap-row witnesses with a non-prime-power orbit O of size a (threshold-beyond-mu.md §6.4).
# By Conjecture P's induction (conjecture-p-proof.md, Lemma 1 and Step 5), N*(Gamma^O) has a block system with blocks
# of some size b | a and m*_typ(Gamma^O) <= (a/b) tau(b); N*(Gamma)^O <= N*(Gamma^O), so if (a/b) tau(b) <= T for every
# proper divisor b > 1 of a, O has a type of total <= T and the full simplex on it gives chi = 1.  Otherwise, for each
# prime-power b with (a/b) C(b, 2) > T, model O's in-block classes as m = a/b copies of one prime-power block
# configuration (Gamma^O transitive makes the blocks equivalent), permuted by N*, ignoring cross-block classes (only
# loses closures), and require chi = 1 exactly (so every reading is met, whatever Gamma is), using the closers above on
# those copies and on the witness's prime-power block.  Non-prime-power b passing the test are not modelled.
# MODEL ASSUMPTIONS: ΓL(1) twists on prime-power blocks; N* preserves O's block system of size b; C_k on prime blocks.
# usage: python3 nonpp_close.py -> ../outputs/nonpp_close.txt
lines = open('../outputs/merged_rows_scan.txt').read().strip().split('\n')[1:]
wits = sorted({(x[0], x[1], x[2]) for x in map(ast.literal_eval, lines)})
wits = [x for x in wits if not all(len(factorint(a)) == 1 for a, m in x[2])]
ppq = lambda a: len(factorint(a)) == 1
tau = lambda a: comb(a, 2) if ppq(a) else a * (max(p ** e for p, e in factorint(a).items()) - 1) // 2
def close_exact(blocks, T):
    fams = [threshold_chis(m * weights(a, c), T) for a, m, c in blocks]
    for i, (a, m, c) in enumerate(blocks):
        k = c[3]
        if isprime(a) and k >= 2 and T // weights(a, c)[0] >= 2:
            fams[i] = fams[i] | {m * (k - k * e - (k // 2) * h) for e in range((k - 1) // 2 + 1) for h in ((0, 1) if k % 2 == 0 else (0,))}
            cap = min(T // weights(a, c)[0], k - 1)
            fams[i] = fams[i] | {m * x for x in pvals(k, cap)}
    fams = [set(sorted(F, key=abs)[:3000]) for F in fams]
    big = max(range(len(fams)), key=lambda i: len(fams[i]))
    vals = {0}
    for i, F in enumerate(fams):
        if i != big: vals = {x + y for x in vals for y in F if abs(x + y) < 10**12}
    if any(1 - x in fams[big] for x in vals): return True
    for i, (a, m, c) in enumerate(blocks):
        if not (isprime(a) and m == 1) or c[3] < 2: continue
        k = c[3]; cap = min(T // weights(a, c)[0], k - 1)
        rest = {0}
        for j, F in enumerate(fams):
            if j != i: rest = {x + y for x in rest for y in F if abs(x + y) < 10**12}
        for y in sorted(rest, key=abs)[:40]:
            if abs(1 - y) < 10**6 and chi1c(k, cap, 1 - y): return True
    return False
res = Counter(); left = []; rows_open = set(); allrows = {x[0] for x in wits}
for n, T, w in wits:
    nps = [(a, m) for a, m in w if not ppq(a)]; pps = [(a, m) for a, m in w if ppq(a)]
    if len(nps) != 1 or nps[0][1] != 1 or len(pps) > 1 or (pps and pps[0][1] != 1):
        res['open: shape not modelled (several or merged non-prime-power orbits)'] += 1; rows_open.add(n); left.append((n, T, w, 'shape')); continue
    c0 = pps[0][0] if pps else None
    A = nps[0][0]
    divs = [b for b in range(2, A) if A % b == 0 and (A // b) * tau(b) > T]
    if not divs: res['closed: O has a type <= T (P induction)'] += 1; continue
    if any(not ppq(b) for b in divs): res['open: a non-prime-power block size passes'] += 1; rows_open.add(n); left.append((n, T, w, 'nonpp b', divs)); continue
    ok = True
    for b in divs:
        for cb in cfgs(b):
            for cc in (cfgs(c0) if c0 else [None]):
                blocks = [(b, A // b, cb)] + ([(c0, 1, cc)] if c0 else [])
                if not close_exact(blocks, T): ok = False; left.append((n, T, w, b, cb[:4], cc[:4] if cc else None)); break
            if not ok: break
        if not ok: break
    print(n, w, ok, flush=True)
    if ok: res['closed: every modelled configuration, chi = 1'] += 1
    else: res['open: a configuration left'] += 1; rows_open.add(n)
with open('../outputs/nonpp_close.txt', 'w') as fh:
    fh.write(f"witnesses: {dict(res)}\nrows with an open witness: {len(rows_open)} of {len(allrows)}\n")
    for x in left: fh.write(f"{x}\n")
print(open('../outputs/nonpp_close.txt').read()[:2500])
