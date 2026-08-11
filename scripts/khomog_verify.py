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

  PASS 3  Above degree 5 the list is exactly {8, 32}.  The order bound |AGammaL(1,c)| =
          c(c-1)log_2(c) >= C(c,3) fails from c = 64 on; at the one intermediate
          degree it permits, c = 16 (960 >= 560), the group is NOT 3-homogeneous
          -- so the finiteness is sharp rather than generous.

Usage: python3 khomog_verify.py     Exits nonzero on any failure.
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
check("k=3: AGL(1,8) is not 3-transitive (|G| = 56 < 8*7*6 = 336)",
      8 * 7 < 8 * 7 * 6)
check("k=3: AGammaL(1,32) is regular on the C(32,3)=4960 triples",
      agammal_orbits(32, 3) == [4960] == [comb(32, 3)])
check("k=3: AGL(1,32) alone is NOT 3-homogeneous (five orbits of 992)",
      agammal_orbits(32, 3, frobenius=False) == [992] * 5)
check("k=3: degree 16 is NOT 3-homogeneous though its order permits it (960 >= 560)",
      agammal_orbits(16, 3) == [80, 480] and 16 * 15 * 4 >= comb(16, 3))
infeasible = [c for c in (64, 128, 256) if c * (c - 1) * (c.bit_length() - 1) < comb(c, 3)]
check("k=3: the order bound fails from c = 64 on " + str(infeasible),
      infeasible == [64, 128, 256])

print("\n      The five solvable 3-homogeneous degrees, with their Oliver chains:")
print("       n= 3  C_3           Gamma_2 = 1,     layer 1,      quotient C_3   [1 triple]")
print("       n= 4  A_4           Gamma_2 = C_2^2, layer 1,      quotient C_3")
print("       n= 5  AGL(1,5)      Gamma_2 = 1,     layer C_5,    quotient C_4")
print("       n= 8  AGL(1,8)      Gamma_2 = C_2^3, layer 1,      quotient C_7   [regular]")
print("       n=32  AGammaL(1,32) Gamma_2 = C_2^5, layer C_31,   quotient C_5   [regular]")
print("      so delta_3 = 1 at all five, and the chain is not what bounds the list.")

sys.exit(0 if ok else 1)
