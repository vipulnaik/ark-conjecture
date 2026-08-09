"""Reference implementation of the Part E construction, in Python.

Builds the permutation group for a witness configuration and computes its
u-orbital sizes directly, so the recipe the GAP script encodes can be checked
against known values before anyone trusts GAP output.
"""
import itertools, sys
from math import comb

# ---------- GF(p^a) as ints 0..p^a-1, coefficient vectors base p ----------
def gf(p, a):
    """Return (mul, elements, generator) for GF(p^a)."""
    if a == 1:
        mul = lambda x, y: (x * y) % p
        g = next(g for g in range(2, p) if len({pow(g, k, p) for k in range(p - 1)}) == p - 1) if p > 2 else 1
        return mul, list(range(p)), g
    def tolist(x):
        out = []
        for _ in range(a):
            out.append(x % p); x //= p
        return out
    def toint(v):
        return sum(c * p ** i for i, c in enumerate(v))
    def polymul(u, v, m):
        r = [0] * (2 * a - 1)
        for i, ui in enumerate(u):
            for j, vj in enumerate(v):
                r[i + j] = (r[i + j] + ui * vj) % p
        for i in range(len(r) - 1, a - 1, -1):          # reduce by m (monic, deg a)
            co = r[i]
            if co:
                r[i] = 0
                for j in range(a):
                    r[i - a + j] = (r[i - a + j] - co * m[j]) % p
        return r[:a]
    # find an irreducible monic poly of degree a: x^a + sum m[j] x^j
    for cand in itertools.product(range(p), repeat=a):
        m = list(cand)
        # irreducible iff x^(p^a) = x and no proper subfield fixes -- test by
        # checking the multiplicative order structure of the ring is a field
        ring = list(range(p ** a))
        ok = True
        for x in ring[1:]:
            xv = tolist(x)
            # x is a zero divisor iff x*y == 0 for some y != 0
            if any(toint(polymul(xv, tolist(y), m)) == 0 for y in ring[1:]):
                ok = False; break
        if ok:
            mul = lambda x, y, m=m: toint(polymul(tolist(x), tolist(y), m))
            order = p ** a - 1
            for g in range(2, p ** a):
                seen, cur = set(), 1
                for _ in range(order):
                    cur = mul(cur, g); seen.add(cur)
                if len(seen) == order:
                    return mul, list(range(p ** a)), g
    raise RuntimeError(f"no field GF({p}^{a})")

def add_field(p, a, x, y):
    """Addition in GF(p^a) = componentwise mod p on base-p digits."""
    if a == 1:
        return (x + y) % p
    out, mulp = 0, 1
    for _ in range(a):
        out += ((x % p + y % p) % p) * mulp
        x //= p; y //= p; mulp *= p
    return out

# ---------- the construction ----------
def build(p, q, classes):
    """classes: list of dicts
         {'F': int, 'c': int, 'foreign': bool, 'd': int}
       'd' is the twist ORDER (the construction's refined twist).
    Returns (n, generators as tuples).  Layout: classes in order, class i
    occupying F_i blocks of c_i consecutive points."""
    offs, n = [], 0
    for cl in classes:
        offs.append(n); n += cl['F'] * cl['c']
    gens = []
    def blank():
        return list(range(n))
    for ci, cl in enumerate(classes):
        F, c, base = cl['F'], cl['c'], offs[ci]
        if cl['foreign']:
            a, pp = 1, c
        else:
            pp = c; a = 0; t = c
            while t % p == 0: t //= p; a += 1
            assert p ** a == c, f"class size {c} is not a power of {p}"
        mul, elts, gen = gf(*( (c,1) if cl['foreign'] else (p,a) ))
        # --- translations, INDEPENDENT per block (this is what gives F*orb) ---
        for b in range(F):
            for s in ([1] if cl['foreign'] else [p ** k for k in range(a)]):
                g = blank()
                for x in range(c):
                    g[base + b * c + x] = base + b * c + (
                        (x + s) % c if cl['foreign'] else add_field(p, a, x, s))
                gens.append(tuple(g))
        # --- the twist, DIAGONAL across the blocks of this class ---
        d = cl['d']
        if d > 1:
            order = c - 1
            assert order % d == 0, f"twist {d} does not divide {c}-1"
            u = 1
            for _ in range(order // d):
                u = mul(u, gen)                      # u has multiplicative order d
            g = blank()
            for b in range(F):
                for x in range(c):
                    g[base + b * c + x] = base + b * c + (
                        (x * u) % c if cl['foreign'] else mul(x, u))
            gens.append(tuple(g))
        # --- the block rotation, order F ---
        if F > 1:
            g = blank()
            for b in range(F):
                for x in range(c):
                    g[base + b * c + x] = base + ((b + 1) % F) * c + x
            gens.append(tuple(g))
    return n, gens

def orbital_sizes(n, gens):
    pairs = list(itertools.combinations(range(n), 2))
    idx = {pr: i for i, pr in enumerate(pairs)}
    seen = [False] * len(pairs); sizes = []
    for i, start in enumerate(pairs):
        if seen[i]: continue
        seen[i] = True; frontier = [start]; size = 1
        while frontier:
            nf = []
            for (u, v) in frontier:
                for g in gens:
                    au, av = g[u], g[v]
                    pr = (au, av) if au < av else (av, au)
                    j = idx[pr]
                    if not seen[j]:
                        seen[j] = True; size += 1; nf.append(pr)
            frontier = nf
        sizes.append(size)
    return sorted(sizes)

def predicted(p, q, classes):
    """The value formula's terms, for comparison."""
    terms = {}
    def orb(c, t, char2):
        return min(c * t // 2 if (t % 2 == 0 or char2) else c * t, comb(c, 2))
    for i, cl in enumerate(classes):
        F, c = cl['F'], cl['c']
        if cl['foreign']:
            terms[f"intra[{i}] foreign {c}"] = orb(c, cl['d'], False)
        else:
            terms[f"intra[{i}] {F}x{c}"] = F * orb(c, cl['d'], p == 2)
            if F > 1:
                terms[f"cross[{i}] within-class"] = (F if F % 2 else F // 2) * c * c
    sz = [cl['F'] * cl['c'] for cl in classes]
    for i in range(len(sz)):
        for j in range(i + 1, len(sz)):
            terms[f"cross[{i},{j}]"] = sz[i] * sz[j]
    return terms
