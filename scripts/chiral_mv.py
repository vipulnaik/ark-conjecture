#!/usr/bin/env python3
"""
chiral_mv.py -- the Mayer-Vietoris computation for the chiral halves of the
Hamiltonian-cycle complex.  Supports `pending-checks.md` R10 and section 6 of
`chiral-graph-properties.md`.

THE OBJECT.  L is the simplicial complex on E(K_n) whose faces are the
subgraphs of Hamiltonian cycles -- that is, every linear forest (a disjoint
union of paths covering the vertices) together with the Hamiltonian cycles
themselves.  When n = 1 (mod 4) the S_n-orbit of Hamiltonian cycles splits into
two A_n-orbits, because the stabiliser D_2n lies inside A_n exactly then, and
the two halves P0, P1 are the chiral graph properties this is about.

    P0 u P1 = L,   M := P0 n P1,   H~(P0) = H~(P1)  by the outer symmetry,

so Mayer-Vietoris gives

    H~(P0) (+) H~(P1)  =  coker( H~(L) --> H~(M) ),

and the whole answer is the Smith normal form of one integer matrix.  Both ends
are S_n-invariant even though the halves are not, which is what makes them
countable in closed form.

WHAT IS PROVED HERE VS ASSUMED.  The ranks below are Euler characteristics, and
they equal the Betti numbers only because homology is concentrated in a single
degree.  That is VERIFIED by direct computation for L at n = 5,6,7,8 and for M
at n = 5, and ASSUMED beyond.  `--verify` re-runs the direct computation.

CONVENTIONS.  chi~ = -sum_{F in K} (-1)^{|F|}, the sum including the empty face,
so chi~ = sum_i (-1)^i b~_i.  A complex with homology only in degree d has
rank b~_d = |chi~|.

Usage:
    python3 chiral_mv.py --verify         regression: direct homology, n <= 7
    python3 chiral_mv.py --table 20       the closed-form ranks
"""
import argparse, itertools, math, sys
from fractions import Fraction as F
from collections import Counter

# --------------------------------------------------------------- power series
def _mul(a, b, N):
    c = [F(0)] * (N + 1)
    for i, ai in enumerate(a):
        if not ai:
            continue
        for j, bj in enumerate(b):
            if i + j > N:
                break
            if bj:
                c[i + j] += ai * bj
    return c


def _exp(a, N):
    """exp of a series with zero constant term."""
    term = [F(0)] * (N + 1); term[0] = F(1)
    tot = [F(0)] * (N + 1); tot[0] = F(1)
    for m in range(1, N + 1):
        term = _mul(term, a, N)
        term = [v / m for v in term]
        for i in range(N + 1):
            tot[i] += term[i]
    return tot


def _path_egf(N, sizes=None, weight=F(1)):
    """EGF for ONE undirected path, restricted to component sizes in `sizes`.

    A path on j labelled vertices: 1 arrangement for j = 1 (a single vertex),
    and j!/2 for j >= 2 (orderings up to reversal).  As an EGF coefficient of
    x^j/j! that is 1 and 1/2 respectively.  `weight` multiplies every term and
    is used to mark components for the alternating sum.
    """
    p = [F(0)] * (N + 1)
    for j in range(1, N + 1):
        if sizes is not None and j not in sizes:
            continue
        p[j] = weight * (F(1) if j == 1 else F(1, 2))
    return p


# ------------------------------------------------------- the counts we need
def alt_sum_linear_forests(n, N=None, sizes=None):
    """sum over linear forests F on [n] of (-1)^{|F|}, |F| = n - (#components).

    Marking each component with -1 and factoring out (-1)^n turns the sum into
    a coefficient of exp(-P).  Restricting `sizes` restricts which component
    sizes are allowed, which is how the chiral forests are counted.
    """
    N = N or n
    P = _path_egf(N, sizes)
    negP = [-v for v in P]
    e = _exp(negP, N)
    return ((-1) ** n) * int(math.factorial(n) * e[n])


def alt_sum_chiral_forests(n, N=None):
    """sum of (-1)^{|F|} over the CHIRAL linear forests.

    A linear forest lies in only ONE of the two A_n-orbits exactly when no
    rearrangement of its completion flips the sign invariant.  Sign is a
    homomorphism, so it suffices that no GENERATOR flips it, and the completions
    of a forest are generated from any one by (a) transposing two components in
    the cyclic order, which changes the sign by (-1)^{ab} for component sizes
    a, b, and (b) reversing one component of size l, which changes it by
    (-1)^{l(l-1)/2}.  So the sign is constant over the completions iff

        no two components have odd size   (else (a) flips), and
        every component has size = 0 or 1 (mod 4)  (else (b) flips).

    With n = 1 (mod 4) that forces EXACTLY ONE component of size = 1 (mod 4)
    and all others = 0 (mod 4).
    """
    N = N or n
    zero = {j for j in range(1, N + 1) if j % 4 == 0}
    one = {j for j in range(1, N + 1) if j % 4 == 1}
    A = _path_egf(N, zero, weight=F(-1))     # components marked with -1
    B = _path_egf(N, one, weight=F(-1))      # the single = 1 (mod 4) component
    ser = _mul(B, _exp(A, N), N)
    return ((-1) ** n) * int(math.factorial(n) * ser[n])


def ranks(n):
    """(rank H~(L), rank H~(M)) from Euler characteristics.

    faces(L) = linear forests + Hamiltonian cycles
    faces(M) = faces(L) - chiral forests - Hamiltonian cycles
    """
    cycles = math.factorial(n - 1) // 2
    sL = alt_sum_linear_forests(n) + ((-1) ** n) * cycles
    sChi = alt_sum_chiral_forests(n)
    sM = alt_sum_linear_forests(n) - sChi          # cycles are all chiral
    return abs(sL), abs(sM), sChi, cycles


# ------------------------------------------------------------ direct homology
def _rank_f2(rows):
    piv = {}; r = 0
    for row in rows:
        while row:
            b = row.bit_length() - 1
            if b in piv:
                row ^= piv[b]
            else:
                piv[b] = row; r += 1; break
    return r


def _homology_f2(faces):
    """Reduced Betti numbers over F_2.  Faces are frozensets of INTEGER edge
    indices -- sorting integers is a total order, whereas sorting frozensets
    uses subset containment (a PARTIAL order) and silently gives d.d != 0 and
    negative Betti numbers.  That bug cost a session; do not reintroduce it."""
    lvl = {}
    for f in faces:
        lvl.setdefault(len(f), []).append(f)
    idx = {d: {f: i for i, f in enumerate(fs)} for d, fs in lvl.items()}
    rk = {}
    for d in sorted(lvl):
        if d == 0 or (d - 1) not in idx:
            continue
        rows = []
        for f in lvl[d]:
            m = 0
            for e in f:
                m |= 1 << idx[d - 1][frozenset(f - {e})]
            rows.append(m)
        rk[d] = _rank_f2(rows)
    b = {d - 1: len(lvl[d]) - rk.get(d, 0) - rk.get(d + 1, 0)
         for d in sorted(lvl) if d >= 1}
    assert all(v >= 0 for v in b.values()), "negative Betti number: boundary bug"
    return b


def _sgn(p):
    n = len(p); s = 1; seen = [False] * n
    for i in range(n):
        if seen[i]:
            continue
        l = 0; j = i
        while not seen[j]:
            seen[j] = True; j = p[j]; l += 1
        if l % 2 == 0:
            s = -s
    return s


def build(n):
    """Return (L, P0, P1, M) as sets of frozensets of edge indices."""
    E = [frozenset(x) for x in itertools.combinations(range(n), 2)]
    eidx = {e: i for i, e in enumerate(E)}
    cyc = set()
    for perm in itertools.permutations(range(1, n)):
        v = (0,) + perm
        cyc.add(frozenset(eidx[frozenset({v[i], v[(i + 1) % n]})] for i in range(n)))
    An = [p for p in itertools.permutations(range(n)) if _sgn(p) == 1]

    def act(p, c):
        return frozenset(eidx[frozenset({p[a] for a in E[e]})] for e in c)

    seen = set(); orbs = []
    for c in sorted(cyc, key=sorted):
        if c in seen:
            continue
        o = {act(p, c) for p in An}
        seen |= o; orbs.append(o)

    def down(gens):
        P = set()
        for g in gens:
            g = sorted(g)
            for r in range(len(g) + 1):
                for s in itertools.combinations(g, r):
                    P.add(frozenset(s))
        return P

    L = down(cyc)
    if len(orbs) == 1:                       # no split: n != 1 (mod 4)
        return L, None, None, None
    P0, P1 = down(orbs[0]), down(orbs[1])
    return L, P0, P1, P0 & P1


def verify(nmax=7):
    print("REGRESSION: closed-form ranks against direct F_2 homology")
    print("  n | split |    |L| |    |M| | rank H~(L) pred/dir | rank H~(M) pred/dir")
    ok = True
    for n in range(5, nmax + 1):
        L, P0, P1, M = build(n)
        rL, rM, _, _ = ranks(n)
        hL = _homology_f2(L); dL = {d: v for d, v in hL.items() if v}
        sL = sum(dL.values()); okL = (sL == rL and len(dL) == 1)
        ok &= okL
        if M is None:
            print("  %d |  no   | %6d |      - | %8d/%-8d | -" % (n, len(L), rL, sL))
            continue
        hM = _homology_f2(M); dM = {d: v for d, v in hM.items() if v}
        sM = sum(dM.values()); okM = (sM == rM and len(dM) == 1)
        ok &= okM
        hP = _homology_f2(P0)
        print("  %d |  yes  | %6d | %6d | %8d/%-8d | %8d/%-8d"
              % (n, len(L), len(M), rL, sL, rM, sM))
        print("      H~(L) = %s   H~(M) = %s   H~(P0;F2) = %s"
              % (dL, dM, {d: v for d, v in hP.items() if v}))
    print("REGRESSION", "PASSED" if ok else "*** FAILED ***")
    return ok


def chi_half(n):
    """chi~(P0), computed WITHOUT assuming homology is concentrated in one degree.

    Euler characteristics are additive over P0 u P1 = L with P0 n P1 = M, and
    chi~(P0) = chi~(P1) by the outer symmetry, so

        2 chi~(P0) = chi~(L) + chi~(M),

    which is a statement about face counts alone.  chi~(P0) != 0 therefore
    PROVES P0 is not Q-acyclic, hence not Z-acyclic, with no assumption about
    where the homology sits.
    """
    cycles = math.factorial(n - 1) // 2
    sL = alt_sum_linear_forests(n) + ((-1) ** n) * cycles      # sum (-1)^|F| over L
    sM = alt_sum_linear_forests(n) - alt_sum_chiral_forests(n)  # over M
    chiL, chiM = -sL, -sM
    assert (chiL + chiM) % 2 == 0, "chi~(L) + chi~(M) must be even"
    return (chiL + chiM) // 2, chiL, chiM


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--verify", action="store_true")
    ap.add_argument("--table", type=int, default=0, metavar="NMAX")
    A = ap.parse_args()
    if A.verify:
        sys.exit(0 if verify() else 1)
    if A.table:
        print("  n | n%4 | rank H~(L) | rank H~(M) | #chiral alt | #cycles")
        for n in range(5, A.table + 1):
            rL, rM, sChi, cyc = ranks(n)
            mark = " *" if n % 4 == 1 else ""
            print("%3d |  %d%s | %10d | %10d | %11d | %d"
                  % (n, n % 4, mark, rL, rM if n % 4 == 1 else 0, sChi, cyc))
        print("\n  * = n = 1 (mod 4): the orbit splits and M is defined.")
        print("\n  n | chi~(L) | chi~(M) | chi~(P0) = (chi~L + chi~M)/2 | Z-acyclic?")
        for n in range(5, A.table + 1, 4):
            if n % 4 != 1:
                continue
            c0, cL, cM = chi_half(n)
            verdict = ("NO -- chi~ != 0, so not even Q-acyclic" if c0
                       else "not excluded by chi~; decided by torsion")
            print("%3d | %s | %s | %s | %s" % (n, cL, cM, c0, verdict))
