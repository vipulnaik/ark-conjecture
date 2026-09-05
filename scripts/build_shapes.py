#!/usr/bin/env python3
"""
build_shapes.py -- Part E realisability at the two points R8 owes: an F = 4
cyclic-layer fused class (n = 451, `4x71 + 1x167*`, q = 83) and the ladder
argmin n = 2759 (`2x653 + 1x1453*`, q = 11, foreign twist 11^2).

For each: build the Oliver group from Part E's recipe as explicit permutations
of the n points, machine-check the chain (bottom p-group, cyclic middle layer,
q-group on top, each normal in the next), compute EVERY pair-orbital exactly by
connected components on C(n,2) pairs, and compare against the enumeration's
terms.  Nothing is taken from the construction on faith.

The entangled generator z rotates the F blocks and multiplies by step
multipliers a_0..a_{F-1} whose product is a generator g of F_c^*; then z^F is
multiplication by g on every block, so one cyclic subgroup supplies both the
block count F_mid and the full twist.
"""
import sys
import numpy as np
from math import comb
from scipy.sparse import coo_matrix
from scipy.sparse.csgraph import connected_components
from sympy import primitive_root, isprime, factorint

def build(c, F, r, q, texp):
    """points: block i point x -> i*c + x for i < F; foreign point y -> F*c + y."""
    n = F * c + r
    g = primitive_root(c)
    # step multipliers: a_0 = ... = a_{F-2} = 1, a_{F-1} = g  =>  product g
    def perm(f):
        return np.fromiter((f(v) for v in range(n)), dtype=np.int64, count=n)
    def block(v): return (v // c, v % c) if v < F * c else (None, v - F * c)
    def z(v):
        i, x = block(v)
        if i is None: return v
        j = (i + 1) % F
        a = g if i == F - 1 else 1
        return j * c + (a * x) % c
    def tau_i(i):
        return lambda v: (v // c) * c + ((v % c) + 1) % c if v // c == i and v < F * c else v
    def tau_r(v): return v if v < F * c else F * c + ((v - F * c) + 1) % r
    # top element: multiplier of order q^texp on F_r, trivial elsewhere
    gr = primitive_root(r)
    m = pow(gr, (r - 1) // q**texp, r)
    def h(v): return v if v < F * c else F * c + (m * (v - F * c)) % r
    gens = {"z": perm(z), "t_r": perm(tau_r), "h": perm(h)}
    for i in range(F):
        gens[f"tau_{i}"] = perm(tau_i(i))
    return n, gens, m

def compose(a, b):  # a after b
    return a[b]

def order(p):
    ident = np.arange(len(p)); cur = p.copy(); k = 1
    while not np.array_equal(cur, ident):
        cur = p[cur]; k += 1
    return k

def pair_orbitals(n, perms):
    """connected components of the graph on C(n,2) pairs joined by each perm."""
    a, b = np.triu_indices(n, k=1)
    idx = np.full(n * n, -1, dtype=np.int64)
    idx[a * n + b] = np.arange(len(a))
    rows, cols = [], []
    for p in perms:
        pa, pb = p[a], p[b]
        lo, hi = np.minimum(pa, pb), np.maximum(pa, pb)
        rows.append(np.arange(len(a))); cols.append(idx[lo * n + hi])
    rows = np.concatenate(rows); cols = np.concatenate(cols)
    G = coo_matrix((np.ones(len(rows), dtype=np.int8), (rows, cols)), shape=(len(a), len(a)))
    k, lab = connected_components(G, directed=True, connection="weak")
    return np.bincount(lab)

def check_chain(n, gens, F, c, r, q):
    z, tr, h = gens["z"], gens["t_r"], gens["h"]
    taus = [gens[f"tau_{i}"] for i in range(F)]
    ok = True
    # bottom layer: translations of the F blocks, elementary abelian p-group of order c^F
    for t in taus:
        assert order(t) == c
    # middle layer generator: z * t_r (commuting, coprime orders) has order F*(c-1)*r
    oz, otr = order(z), order(tr)
    print(f"  ord z = {oz} (= F(c-1) = {F*(c-1)}), ord t_r = {otr}, gcd = {np.gcd(oz, otr)}")
    ok &= oz == F * (c - 1) and otr == r and np.gcd(oz, otr) == 1
    # z^F acts as a scalar generator on every block: check z^F fixes block index and is a multiplier of order c-1
    zF = z.copy()
    for _ in range(F - 1): zF = zF[z]
    blk = np.arange(n) // c
    ok &= np.all(blk[zF[:F * c]] == blk[:F * c])
    ok &= order(zF) == c - 1
    print(f"  z^F preserves blocks: {np.all(blk[zF[:F*c]] == blk[:F*c])}, ord z^F = {order(zF)} (= c-1 = {c-1})")
    # top: h has order q^e, normalises <z, t_r, taus>: conjugates t_r to a power, commutes with z and taus
    oh = order(h); print(f"  ord h = {oh}, q-power: {set(factorint(oh)) == {q}}")
    ok &= set(factorint(oh)) == {q}
    hinv = np.argsort(h)
    conj = h[tr[hinv]]
    # conj should be t_r^m for some m: check it is a power of t_r
    cur = tr.copy(); is_pow = False
    for _ in range(r):
        if np.array_equal(cur, conj): is_pow = True; break
        cur = cur[tr]
    print(f"  h t_r h^-1 is a power of t_r: {is_pow};  h commutes with z: {np.array_equal(h[z], z[h])}")
    ok &= is_pow and np.array_equal(h[z], z[h])
    # z normalises the translation group: z tau_i z^-1 is a product of block translations
    zinv = np.argsort(z)
    for i in range(F):
        cz = z[taus[i][zinv]]
        # must move points only within one block by a constant shift
        v = np.arange(F * c); w = cz[:F * c]
        ok &= np.all(w // c == v // c)
        shifts = set(((w - v) % c)[(v // c) == ((i + 1) % F)])
        ok &= len(shifts) == 1
    print(f"  z normalises the bottom p-group: {bool(ok)}")
    return ok

def run(label, c, F, r, q, texp, predicted):
    print(f"\n=== {label}: n = {F*c + r} = {F}x{c} + {r}*, p = {c}, q = {q}, foreign twist {q}^{texp} ===")
    n, gens, m = build(c, F, r, q, texp)
    ok = check_chain(n, gens, F, c, r, q)
    sizes = pair_orbitals(n, list(gens.values()))
    sizes = sorted(sizes.tolist())
    print(f"  pair-orbitals ({len(sizes)}): {sizes[:6]}{' ...' if len(sizes) > 6 else ''}  sum = {sum(sizes)} = C(n,2) = {comb(n,2)}")
    print(f"  m* = {sizes[0]}   predicted terms: {predicted}   B(n) from table = {min(predicted.values())}")
    good = ok and sizes[0] == min(predicted.values()) and sum(sizes) == comb(n, 2)
    print("  PASS" if good else "  FAIL")
    return good

if __name__ == "__main__":
    ok = True
    # n = 451: 4x71 + 167*, q = 83, r-1 = 2*83
    ok &= run("F = 4 cyclic-layer fusion", c=71, F=4, r=167, q=83, texp=1,
              predicted={"intra 4*C(71,2)": 4 * comb(71, 2), "within-class (F/2)c^2": 2 * 71 * 71,
                         "foreign orb(167,83)": 167 * 83, "cross 284*167": 284 * 167})
    # n = 2759: 2x653 + 1453*, q = 11, r-1 = 1452 = 4*3*11^2, twist 121
    ok &= run("ladder argmin", c=653, F=2, r=1453, q=11, texp=2,
              predicted={"intra 2*C(653,2)": 2 * comb(653, 2), "within-class c^2": 653 * 653,
                         "foreign orb(1453,121)": 1453 * 121, "cross 1306*1453": 1306 * 1453})
    sys.exit(0 if ok else 1)
