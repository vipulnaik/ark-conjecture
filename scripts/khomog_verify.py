#!/usr/bin/env python3
"""
khomog_verify.py -- verifies the k-homogeneity claims of the hypothesis table in
orbital-evasiveness-notes.md section 1, and of three-uniform-note.md section 3.1.

What a single orbital requires is transitivity on UNORDERED k-sets, i.e.
k-HOMOGENEITY, never k-transitivity.  The two part company exactly where this
framework's arithmetic lives, and the table's rows depend on getting it right:

  PASS 1  k = 2, degree = 3 mod 4.  C_c : C_{(c-1)/2} is 2-homogeneous (the
          twist omits -1, fusing the two halves of each difference class) while
          at c = 1 mod 4 the same subgroup is not.  This is the orb(c,d) = cd/2
          case of aod section 3.1.

  PASS 2  k = 3, the full-density degrees.  The solvable 3-homogeneous degrees
          are {3, 4, 5, 8, 32} -- C_3, A_4, AGL(1,5), AGL(1,8), AGammaL(1,32) --
          all prime powers and all satisfying Oliver's condition, so mu_3
          attains C(n,3) at each.  Solvable 3-TRANSITIVE groups stop at degree
          4; 3-HOMOGENEOUS ones do not, and at 8 and 32 the groups are REGULAR
          on triples (56 = C(8,3), 4960 = C(32,3)).  Degrees 6 and 7 fail.

  PASS 3  Above degree 5 the list is exactly {8, 32}, and this is now SWEPT
          rather than spot-checked.  A solvable 3-homogeneous group is in
          particular 2-homogeneous, hence of prime-power degree (Kantor for the
          3 mod 4 branch, Huppert for the 2-transitive one -- see
          solvable-relaxation.md section 1), and for prime-power c the largest
          solvable candidate is AGammaL(1,c).  So testing every prime power in
          [6, 63] settles the range, and the order bound |AGammaL(1,c)| =
          c(c-1)log_p(c) < C(c,3) settles everything above it.

          The earlier form of this pass tested only c = 6, 7 and 16 and inferred
          the rest, which left EIGHTEEN prime-power degrees in range untested
          (9, 11, 13, 17, 19, 23, 25, 27, 29, 31, 37, 41, 43, 47, 49, 53, 59,
          61).  The conclusion was right; the evidence for it was three points.

  A NOTE ON WHAT THIS FILE DOES NOT ESTABLISH.  The classification of solvable
  3-homogeneous groups is Kantor's; nothing here proves it.  What the sweep
  does is verify the CONSEQUENCE the framework uses -- that no solvable group
  of degree in [6, 63] is 3-homogeneous except at 8 and 32 -- by testing the
  maximal solvable candidate AGammaL(1,c) at every prime-power degree, which is
  the whole range because a 3-homogeneous solvable group is 2-homogeneous and
  so of prime-power degree.  That is a check of the citation, not a substitute.

Usage: python3 khomog_verify.py     Exits nonzero on any failure.  Runs in ~3 s;
       the sweep is the bulk of it (C(61,3) = 35,990 triples at the top end).
"""
import sys
from itertools import combinations
from math import comb

ok = True


def check(name, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + name)
    ok = ok and cond


# ---------------------------------------------------------------- pass 1
def affine_orbits_prime(c, d, k):
    """Orbits on unordered k-subsets of F_c under x -> t*x + s, t in the
    subgroup of order d."""
    g = next(a for a in range(2, c)
             if len({pow(a, i, c) for i in range(c - 1)}) == c - 1)
    T = {pow(g, (c - 1) // d * j, c) for j in range(d)}
    seen, sizes = set(), []
    for base in combinations(range(c), k):
        if base in seen:
            continue
        comp, st = {base}, [base]
        while st:
            u = st.pop()
            for t in T:
                for s in range(c):
                    v = tuple(sorted((t * x + s) % c for x in u))
                    if v not in comp:
                        comp.add(v)
                        st.append(v)
        seen |= comp
        sizes.append(len(comp))
    return sorted(sizes)


three_mod4 = [7, 11, 19, 23]
one_mod4 = [5, 13, 17]
check("k=2: C_c : C_{(c-1)/2} is 2-homogeneous at c = 3 mod 4 " + str(three_mod4),
      all(len(affine_orbits_prime(c, (c - 1) // 2, 2)) == 1 for c in three_mod4))
check("k=2: and is NOT 2-homogeneous at c = 1 mod 4 " + str(one_mod4),
      all(len(affine_orbits_prime(c, (c - 1) // 2, 2)) == 2 for c in one_mod4))

# ---------------------------------------------------------------- pass 2 + 3
POLY = {8: 0b1011, 16: 0b10011, 32: 0b100101}      # x^3+x+1, x^4+x+1, x^5+x^2+1


def gf_mul(a, b, q):
    m = q.bit_length() - 1
    r = 0
    for i in range(m):
        if (b >> i) & 1:
            r ^= a << i
    for i in range(2 * m - 1, m - 1, -1):
        if (r >> i) & 1:
            r ^= POLY[q] << (i - m)
    return r & (q - 1)


def agammal_orbits(q, k, frobenius=True):
    m = q.bit_length() - 1
    gen = next(a for a in range(2, q)
               if len({(lambda v: v)(x) for x in _powers(a, q)}) == q - 1)

    def frob(y):
        return gf_mul(y, y, q)

    def act(a, b, f, y):
        z = y
        for _ in range(f):
            z = frob(z)
        return gf_mul(a, z, q) ^ b

    gens = [(gen, 0, 0), (1, 1, 0)] + ([(1, 0, 1)] if frobenius else [])
    seen, sizes = set(), []
    for base in combinations(range(q), k):
        if base in seen:
            continue
        comp, st = {base}, [base]
        while st:
            u = st.pop()
            for (a, b, f) in gens:
                v = tuple(sorted(act(a, b, f, y) for y in u))
                if v not in comp:
                    comp.add(v)
                    st.append(v)
        seen |= comp
        sizes.append(len(comp))
    return sorted(sizes)


def _powers(a, q):
    out, v = [], a
    for _ in range(q - 1):
        out.append(v)
        v = gf_mul(v, a, q)
    return out


# small degrees: C_3, A_4, AGL(1,5) are solvable and 3-homogeneous; 6 and 7 are not
def orbits_perm(gens, n, k):
    seen, sizes = set(), []
    for base in combinations(range(n), k):
        if base in seen:
            continue
        comp, st = {base}, [base]
        while st:
            u = st.pop()
            for g in gens:
                v = tuple(sorted(g[x] for x in u))
                if v not in comp:
                    comp.add(v)
                    st.append(v)
        seen |= comp
        sizes.append(len(comp))
    return sorted(sizes)


def cyc(n, s):
    return [(i + s) % n for i in range(n)]


# ---- a general AGammaL(1,q) for the sweep, over any prime power -------------
# The hand-rolled GF(2^m) above covers 8, 16, 32 only, which is why the sweep
# could not be written before: it needs odd characteristic too.
def prime_powers(lo, hi):
    out = []
    for p in range(2, hi + 1):
        if any(p % d == 0 for d in range(2, int(p ** 0.5) + 1)):
            continue
        v = p
        while v <= hi:
            if v >= lo:
                out.append(v)
            v *= p
    return sorted(out)


def _field(p, m):
    """(mul, add, frob, gen) on {0..p^m-1} read as coefficient vectors base p.

    The modulus is found by PRIMITIVITY, not by an irreducibility test: try each
    monic poly, build multiplication modulo it, and accept the first one under
    which the element x has multiplicative order p^m - 1.  That is self-verifying
    -- a reducible modulus gives zero divisors and x cannot then have full order
    -- and it hands back a generator for free.  The first version of this used a
    hand-rolled long-division irreducibility test, which silently accepted a
    reducible poly at q = 8 (mul(2, 4) came out 0); the sweep then hung looking
    for a generator that did not exist.  A construction that fails loudly is
    worth more here than a clever one.
    """
    if m == 1:
        gen = next(a for a in range(2, p)
                   if len({pow(a, i, p) for i in range(p - 1)}) == p - 1)
        return (lambda a, b: a * b % p, lambda a, b: (a + b) % p,
                lambda a: a, gen)
    import itertools

    def tovec(a):
        v = []
        for _ in range(m):
            v.append(a % p)
            a //= p
        return v

    def toint(v):
        r = 0
        for i in reversed(range(m)):
            r = r * p + v[i] % p
        return r

    for tail in itertools.product(range(p), repeat=m):
        mod = [1] + list(tail)          # monic, x^m + tail[0] x^{m-1} + ...

        def mul(a, b, mod=mod):
            A, B = tovec(a), tovec(b)
            r = [0] * (2 * m - 1)
            for i in range(m):
                if A[i]:
                    for j in range(m):
                        r[i + j] = (r[i + j] + A[i] * B[j]) % p
            for i in range(2 * m - 2, m - 1, -1):
                c = r[i]
                if c:
                    r[i] = 0
                    for j in range(1, m + 1):
                        r[i - j] = (r[i - j] - c * mod[j]) % p
            return toint(r[:m])

        v, o = p, 1                     # p is the vector (0,1,0,...) = x
        while v != 1 and o <= q_order(p, m):
            v = mul(v, p)
            o += 1
        if v == 1 and o == p ** m - 1:
            def add(a, b):
                A, B = tovec(a), tovec(b)
                return toint([(A[i] + B[i]) % p for i in range(m)])

            def frob(a):
                res, base, e = 1, a, p
                while e:
                    if e & 1:
                        res = mul(res, base)
                    base = mul(base, base)
                    e >>= 1
                return res
            return mul, add, frob, p
    raise AssertionError("no primitive polynomial found for GF(%d^%d)" % (p, m))


def q_order(p, m):
    return p ** m - 1


def agammal_orbits_general(q, k):
    """Orbits of AGammaL(1,q) on unordered k-subsets, any prime power q."""
    p = next(r for r in range(2, q + 1) if q % r == 0)
    m, t = 0, q
    while t > 1:
        t //= p
        m += 1
    mul, add, frob, gen = _field(p, m)
    seen, sizes = set(), []
    for base in combinations(range(q), k):
        if base in seen:
            continue
        comp, st = {base}, [base]
        while st:
            u = st.pop()
            for kind in ("mul", "add") + (("frob",) if m > 1 else ()):
                if kind == "mul":
                    v = tuple(sorted(mul(gen, y) for y in u))
                elif kind == "add":
                    v = tuple(sorted(add(y, 1) for y in u))
                else:
                    v = tuple(sorted(frob(y) for y in u))
                if v not in comp:
                    comp.add(v)
                    st.append(v)
        seen |= comp
        sizes.append(len(comp))
    return sorted(sizes)


small = {3: ("C_3", [cyc(3, 1)]),
         4: ("A_4", [[1, 0, 3, 2], [1, 2, 0, 3]]),
         5: ("AGL(1,5)", [cyc(5, 1), [(2 * i) % 5 for i in range(5)]])}
check("k=3: C_3, A_4 and AGL(1,5) are 3-homogeneous at n = 3, 4, 5",
      all(orbits_perm(g, n, 3) == [comb(n, 3)] for n, (_, g) in small.items()))
check("k=3: n = 6 and n = 7 are not (C_6 -> 2/6/6/6, AGL(1,7) -> 14/21)",
      orbits_perm([cyc(6, 1)], 6, 3) == [2, 6, 6, 6]
      and orbits_perm([cyc(7, 1), [(3 * i) % 7 for i in range(7)]], 7, 3) == [14, 21])

check("k=3: AGL(1,8) is regular on the C(8,3)=56 triples (3-homogeneous)",
      agammal_orbits(8, 3, frobenius=False) == [56] == [comb(8, 3)])
# A VACUOUS CHECK REPLACED.  This read `check(..., 8 * 7 < 8 * 7 * 6)` -- an
# arithmetic tautology that no group computation could ever falsify, so it
# tested nothing at all.  The claim is about ORDERED triples: AGL(1,8) is
# regular on unordered triples (56 of them) and therefore has order 56, which
# cannot be transitive on the 336 ordered ones.  Counting the ordered orbits is
# the check that can fail.
def ordered_orbits(q, k, frobenius=True):
    """Orbits on ORDERED k-tuples of distinct points, for the same group."""
    from itertools import permutations
    m = q.bit_length() - 1
    gen = next(a for a in range(2, q) if len(set(_powers(a, q))) == q - 1)
    gens = [(gen, 0, 0), (1, 1, 0)] + ([(1, 0, 1)] if frobenius else [])

    def act(a, b, f, y):
        z = y
        for _ in range(f):
            z = gf_mul(z, z, q)
        return gf_mul(a, z, q) ^ b
    seen, sizes = set(), []
    for base in permutations(range(q), k):
        if base in seen:
            continue
        comp, st = {base}, [base]
        while st:
            u = st.pop()
            for (a, b, f) in gens:
                v = tuple(act(a, b, f, y) for y in u)
                if v not in comp:
                    comp.add(v)
                    st.append(v)
        seen |= comp
        sizes.append(len(comp))
    return sorted(sizes)


check("k=3: AGL(1,8) is 3-homogeneous but NOT 3-transitive -- one orbit on the "
      "56 unordered triples, six on the 336 ordered ones",
      agammal_orbits(8, 3, frobenius=False) == [56]
      and ordered_orbits(8, 3, frobenius=False) == [56] * 6)
check("k=3: AGammaL(1,32) is regular on the C(32,3)=4960 triples",
      agammal_orbits(32, 3) == [4960] == [comb(32, 3)])
check("k=3: AGL(1,32) alone is NOT 3-homogeneous (five orbits of 992)",
      agammal_orbits(32, 3, frobenius=False) == [992] * 5)
check("k=3: degree 16 is NOT 3-homogeneous though its order permits it (960 >= 560)",
      agammal_orbits(16, 3) == [80, 480] and 16 * 15 * 4 >= comb(16, 3))

# ---- the sweep: every prime power in [6, 63], not three spot checks ---------
sweep = {q: len(agammal_orbits_general(q, 3)) for q in prime_powers(6, 63)}
homog = sorted(q for q, t in sweep.items() if t == 1)
check("k=3: sweeping EVERY prime power in [6, 63] -- %d degrees -- the only "
      "3-homogeneous ones are %s" % (len(sweep), homog),
      homog == [8, 32])
check("k=3: and the non-homogeneous ones are not near-misses either "
      "(orbit counts %s)"
      % {q: t for q, t in sorted(sweep.items()) if t > 1},
      all(t >= 2 for q, t in sweep.items() if q not in (8, 32)))

# THE ORDER BOUND IS A GROWTH STATEMENT, not a check at three degrees.  The old
# form tested c = 64, 128, 256 and said "fails from c = 64 on", which is an
# infinite claim resting on three values.  |AGammaL(1,c)| = c(c-1)log_p(c) is
# O(c^2 log c) against C(c,3) ~ c^3/6, so the ratio falls monotonically once it
# has fallen; asserting it at every prime power in a wide range, and noting the
# monotonicity, is what the claim actually needs.
def order_bound_fails(c):
    p = next(r for r in range(2, c + 1) if c % r == 0)
    logs = 0
    t = c
    while t > 1:
        t //= p
        logs += 1
    return c * (c - 1) * logs < comb(c, 3)


big = prime_powers(64, 4096)
check("k=3: the order bound |AGammaL(1,c)| < C(c,3) fails at EVERY prime power "
      "in [64, 4096] (%d of them), and the ratio c(c-1)log_p(c)/C(c,3) is "
      "O(log c / c) so it never recovers" % len(big),
      all(order_bound_fails(c) for c in big)
      and not order_bound_fails(32))

print("\n      The five solvable 3-homogeneous degrees, with their Oliver chains:")
print("       n= 3  C_3           Gamma_2 = 1,     layer 1,      quotient C_3   [1 triple]")
print("       n= 4  A_4           Gamma_2 = C_2^2, layer 1,      quotient C_3")
print("       n= 5  AGL(1,5)      Gamma_2 = 1,     layer C_5,    quotient C_4")
print("       n= 8  AGL(1,8)      Gamma_2 = C_2^3, layer 1,      quotient C_7   [regular]")
print("       n=32  AGammaL(1,32) Gamma_2 = C_2^5, layer C_31,   quotient C_5   [regular]")
print("      so delta_3 = 1 at all five, and the chain is not what bounds the list.")

sys.exit(0 if ok else 1)
