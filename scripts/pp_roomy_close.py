#!/usr/bin/env python3
"""pp_roomy_close.py -- the roomy pp+pp configurations (GammaL(1) twists; more than 14 usable classes), with the budget.

Closers, in order (each sound for N*-invariance as stated):
 (a) chi = 1 on a PRIME block within its cap (roomy_close.chi1_ok; N* acts on its classes as C_k, as in section 7);
 (b) a weight-threshold complex on a PRIME-POWER block: Delta_W = all sets of usable classes of total weight <= W
     (W <= T).  N* maps orbitals to orbitals of the same size, so Delta_W is N*-invariant whatever N* is.
     chi(Delta_W) = sum over nonempty sets of weight <= W of (-1)^(|S|-1), by a signed subset-sum.
     Accept chi = 1 (exact reading) or chi = 1 mod Q;
 (c) a disjoint union of a prime-block layered value and a Delta_W value meeting the reading (faces separate).
What is left is listed.  usage: python3 pp_roomy_close.py -> ../outputs/pp_roomy_close.txt"""
import sys, io, contextlib
from functools import reduce, lru_cache
sys.argv = ['x']
with contextlib.redirect_stdout(io.StringIO()):
    src = open('ws_budget_pp.py').read(); exec(src[:src.index('if __name__')])
    from roomy_close import chi1_ok
    import ws_budget_scan as WB
@lru_cache(maxsize=None)
def chi1(k, c): return chi1_ok(k, c)[0]
def threshold_chis(W, T, limit=200000):
    """chi(Delta_V) for every threshold V <= T, from the signed subset-sum of the usable weights W"""
    U = sorted(w for w in W if w <= T)
    f = {0: -1}                      # weight -> sum of (-1)^{|S|}... start with the empty set (sign +1 for (-1)^0)
    f = {0: 1}
    for w in U:
        g = dict(f)
        for s, v in f.items():
            if s + w <= T: g[s + w] = g.get(s + w, 0) - v
        f = g
        if len(f) > limit: return None
    out = set(); acc = 0
    for s in sorted(f):
        if s == 0: continue
        acc += -f[s]                 # (-1)^(|S|-1) = -(-1)^|S|
        out.add(acc)
    return out | {0}
res = {'a': 0, 'b': 0, 'c': 0, 'open': 0, 'skipped-limit': 0}; open_list = []
for n, a, b in sorted(pairs):
    T = L[n]
    for ca in CF[a]:
        for cb in CF[b]:
            if ca[3] == 1 and cb[3] == 1: continue
            exact, qs = readings(a, ca, b, cb)
            if not exact and not qs: continue
            WA, WB_ = weights(a, ca), weights(b, cb)
            if sum(1 for w in WA + WB_ if w <= T) <= 14: continue      # decided exactly by ws_budget_pp.py
            Q = None if exact else reduce(lambda u, v: u * v, qs, 1)
            good = (lambda x: x == 1) if exact else (lambda x: (x - 1) % Q == 0)
            # (a)
            if any(isprime(x) and chi1(cfg[3], T // weights(x, cfg)[0]) for x, cfg in ((a, ca), (b, cb))):
                res['a'] += 1; continue
            # (b)
            vals = {}
            lim = False
            for x, cfg, W in ((a, ca, WA), (b, cb, WB_)):
                if isprime(x):
                    k = cfg[3]; c = min(T // W[0], k - 1)
                    vals[x] = set(WB.quick_values(k, c)) | set(WB.exact_values(k, c))
                else:
                    v = threshold_chis(W, T)
                    if v is None: lim = True; v = {0}
                    vals[x] = v
            if any(good(x) for v in vals.values() for x in v): res['b'] += 1; continue
            if any(good(x + y) for x in vals[a] for y in vals[b]): res['c'] += 1; continue
            res['skipped-limit' if lim else 'open'] += 1; open_list.append((n, T, a, ca, b, cb, exact, sorted(qs)))
with open('../outputs/pp_roomy_close.txt', 'w') as fh:
    fh.write(f"roomy pp+pp configurations: {res}\n")
    for o in open_list[:200]: fh.write(f"{o}\n")
print(res); print(open_list[:10])
