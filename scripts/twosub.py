#!/usr/bin/env python3
"""
twosub.py -- the two-subgroup face family: vertex-homogeneous complexes whose
facets are G-orbits of sets H1.x  union  H2.y.

WHY THIS FAMILY.  `orbitsearch.py` / `psl27_orbit.py` searched ORBIT COMPLEXES,
whose facets are single subgroup orbits.  That family is now exhausted at k <= 4
on every transitive set of A_5 (456,847 unions) and of PSL(2,7) (129,758): not
one complex is Z-acyclic, and the two groups fail differently -- on A_5 the 238
survivors of both Euler tests all carry 2-torsion, on PSL(2,7) the link test
kills all 121 chi = 1 complexes before homology is even reached.

The diagnosis for why orbit complexes fail is that their facet sizes ARE
subgroup-orbit sizes, so "balance" (chi = 1, a Diophantine condition on those
sizes) and "an acyclic vertex link" compete for the same few degrees of freedom.
Two-subgroup faces decouple them: |H1.x u H2.y| ranges over sums of orbit sizes
minus overlaps, a much finer set of values, while the local structure at a vertex
gains the freedom of which pair of orbits meet there.  Orbit complexes are the
special case H2 = H1, y = x, so this strictly generalises the exhausted family.

WHAT IS AND IS NOT NEW HERE.  The complexes are still vertex-homogeneous by
construction and their faces still have large stabilisers, so the same fixed-
complex conditions apply and the same filters are meaningful.  Nothing about the
trusted base changes: these are candidate counterexamples to be tested, not
constructions claimed to work.

FILTERS, in the order applied (cheap first), with a count reported at each stage:
    chi(Delta) = 1        -- necessary: non-evasive => Z-acyclic => chi = 1
    chi(link v) = 1       -- ditto for the link, which is a link of a non-evasive
                             complex by vertex-transitivity
    F_p-acyclic           -- for each p | |G|; this is the ONLY non-counting test
                             and on A_5 it did 100% of the work beyond counting
    exact non-evasiveness -- decision-tree recursion, memoised, with a time cap

A run reporting `chi1: 0` has tested NOTHING homological -- that is a statement
about orbit-size arithmetic on that set, not evidence the family is ruled out.
The stage counters exist so this cannot be misread.

Usage:
    python3 twosub.py --group a5 --korder 4 --maxk 2 --limit 600
    python3 twosub.py --group a5 --korder 2 --maxk 2 --limit 1800 --maxface 12
    python3 twosub.py --group psl27 --korder 6 --maxk 2 --limit 1800
    python3 twosub.py --group a5 --korder 4 --maxk 3 --limit 3600   # 1.3M unions
"""
import argparse
import itertools
import sys
import time
from collections import defaultdict


# ---------------------------------------------------------------- groups
def build_a5():
    import orbitcx as O
    return O.Glist, O.allsubs, O.mul, O.ident


def build_psl27():
    ns = {}
    exec(open("psl27.py").read().split("# ---- the involution-quotient")[0], ns)
    return ns["G"], sorted(ns["subs"], key=len), ns["mul"], ns["ident7"]


def coset_space(Glist, K, mul):
    """(points, action) for the transitive G-set G/K, points = left cosets."""
    cos, pts = {}, []
    for g in Glist:
        c = frozenset(mul(g, k) for k in K)
        if c not in cos:
            cos[c] = len(pts)
            pts.append(c)
    act = {x: tuple(cos[frozenset(mul(x, g) for g in c)] for c in pts)
           for x in Glist}
    return pts, act


# ---------------------------------------------------------------- face types
def two_subgroup_types(Glist, subs, act, n, maxface, cap=None):
    """G-orbits of sets H1.p u H2.q, deduplicated.

    Includes the one-subgroup types (H2 = H1, q = p), so this family contains
    the one already searched.  Orbits are keyed by the frozenset of their
    members, which is exact -- no invariant proxy, so no risk of two distinct
    orbits colliding.
    """
    seen = {}
    inner = [H for H in subs if 1 < len(H) < len(Glist)]
    for i, H1 in enumerate(inner):
        for H2 in inner[i:]:
            for p in range(n):
                o1 = frozenset(act[h][p] for h in H1)
                for q in range(n):
                    f = o1 | frozenset(act[h][q] for h in H2)
                    if len(f) <= 1 or len(f) >= n or len(f) > maxface:
                        continue
                    orb = frozenset(frozenset(act[x][v] for v in f)
                                    for x in Glist)
                    if orb not in seen:
                        seen[orb] = (len(H1), len(H2), len(f), len(orb))
                        if cap and len(seen) >= cap:
                            return seen
    return seen


# ---------------------------------------------------------------- topology
def closure_masks(orbits):
    F = set()
    for orb in orbits:
        for f in orb:
            m = 0
            for v in f:
                m |= 1 << v
            sub = m
            while True:
                F.add(sub)
                if sub == 0:
                    break
                sub = (sub - 1) & m
    F.discard(0)
    return F


def chi(F):
    return sum((-1) ** (bin(f).count("1") - 1) for f in F)


def chi_link(F, v=0):
    return sum((-1) ** (bin(f).count("1") - 2)
               for f in F if (f >> v & 1) and bin(f).count("1") >= 2)


def betti_f2(F, n):
    """Reduced F_2 Betti numbers, via bitset elimination.

    p = 2 gets its own routine because it is the filter that actually fires --
    every one of the 830 complexes that has cleared both Euler tests in this
    programme, across two families and two groups, has failed here -- and
    because over F_2 a matrix row is a Python int and elimination is XOR, which
    is 30-60x faster than the generic mod-p path (measured: 15.4 s -> 0.3 s on a
    10,623-face complex).  Run this BEFORE the odd primes.
    """
    by = defaultdict(list)
    for f in F:
        by[bin(f).count("1") - 1].append(f)
    idx = {d: {f: i for i, f in enumerate(sorted(v))} for d, v in by.items()}
    top = max(by)

    def rank(d):
        rows, cols = idx.get(d - 1, {}), sorted(by[d])
        if not rows or not cols:
            return 0
        # one int per column of the boundary map; bit i set iff row i is 1
        vecs = []
        for f in cols:
            v = 0
            for b in (i for i in range(n) if f >> i & 1):
                g = f & ~(1 << b)
                if g in rows:
                    v |= 1 << rows[g]
            if v:
                vecs.append(v)
        piv = {}
        r = 0
        for v in vecs:
            while v:
                h = v.bit_length() - 1
                if h not in piv:
                    piv[h] = v
                    r += 1
                    break
                v ^= piv[h]
        return r

    rk = {d: rank(d) for d in range(1, top + 1)}
    out = []
    for d in range(top + 1):
        nd = len(by[d])
        ker = nd - rk.get(d, 0) if d >= 1 else nd
        out.append(ker - rk.get(d + 1, 0) - (1 if d == 0 else 0))
    return out


def betti_mod(F, n, p):
    by = defaultdict(list)
    for f in F:
        by[bin(f).count("1") - 1].append(f)
    idx = {d: {f: i for i, f in enumerate(sorted(v))} for d, v in by.items()}
    top = max(by)

    def rank(d):
        rows, cols = idx.get(d - 1, {}), sorted(by[d])
        if not rows or not cols:
            return 0
        M = [[0] * len(rows) for _ in cols]
        for j, f in enumerate(cols):
            bits = [i for i in range(n) if f >> i & 1]
            for k, b in enumerate(bits):
                g = f & ~(1 << b)
                if g in rows:
                    M[j][rows[g]] = (-1) ** k % p
        r = 0
        for c in range(len(rows)):
            piv = next((i for i in range(r, len(M)) if M[i][c] % p), None)
            if piv is None:
                continue
            M[r], M[piv] = M[piv], M[r]
            iv = pow(M[r][c], -1, p)
            M[r] = [(x * iv) % p for x in M[r]]
            for i in range(len(M)):
                if i != r and M[i][c] % p:
                    fct = M[i][c]
                    M[i] = [(a - fct * b) % p for a, b in zip(M[i], M[r])]
            r += 1
        return r

    rk = {d: rank(d) for d in range(1, top + 1)}
    out = []
    for d in range(top + 1):
        nd = len(by[d])
        ker = nd - rk.get(d, 0) if d >= 1 else nd
        out.append(ker - rk.get(d + 1, 0) - (1 if d == 0 else 0))
    return out


def nonevasive(F, n, deadline):
    """Exact, by the decision-tree recursion.

    BASE CASE: a complex on ONE vertex is non-evasive; the EMPTY complex is not.
    Getting that backwards reports every complex non-evasive -- see the trap box
    in monotone-transitive-note.md section 6, which this programme has walked
    into once already.
    """
    memo = {}

    def NE(S):
        S = frozenset(S)
        if S in memo:
            return memo[S]
        if time.time() > deadline:
            raise TimeoutError
        vm = 0
        for f in S:
            vm |= f
        nv = bin(vm).count("1")
        if nv == 1:
            return True
        if not S:
            return False
        if chi(S) != 1:
            memo[S] = False
            return False
        res = False
        for v in (i for i in range(n) if vm >> i & 1):
            lk = {f & ~(1 << v) for f in S if (f >> v & 1) and f != (1 << v)}
            if not lk:
                continue
            dl = {f for f in S if not (f >> v & 1)}
            if NE(lk) and NE(dl):
                res = True
                break
        memo[S] = res
        return res

    return NE(F)


# ---------------------------------------------------------------- driver
def main():
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--group", choices=["a5", "psl27"], default="a5")
    ap.add_argument("--korder", type=int, required=True,
                    help="order of the point stabiliser K, selecting the "
                         "transitive set G/K")
    ap.add_argument("--maxk", type=int, default=2,
                    help="unions of at most this many face-orbit types")
    ap.add_argument("--limit", type=float, default=900, help="seconds")
    ap.add_argument("--maxface", type=int, default=12,
                    help="skip face-orbit types with faces larger than this; "
                         "large faces make the closure and the rank "
                         "computations expensive and are rarely balanced")
    ap.add_argument("--maxtypes", type=int, default=None,
                    help="cap the number of face-orbit types (they are "
                         "generated in a fixed order, so this is a prefix, "
                         "not a sample -- a capped run is NOT exhaustive)")
    ap.add_argument("--netimeout", type=float, default=30,
                    help="seconds for the exact non-evasiveness recursion "
                         "per survivor")
    a = ap.parse_args()

    Glist, subs, mul, ident = (build_a5() if a.group == "a5" else build_psl27())
    order = len(Glist)
    K = next((H for H in subs if len(H) == a.korder), None)
    if K is None:
        sys.exit(f"no subgroup of order {a.korder} in a group of order {order}")
    pts, act = coset_space(Glist, K, mul)
    n = len(pts)
    t0 = time.time()
    types = two_subgroup_types(Glist, subs, act, n, a.maxface, a.maxtypes)
    T = list(types)
    summ = defaultdict(int)
    for t in T:
        summ[types[t]] += 1
    print(f"{a.group} |G| = {order}, K order {a.korder}: |G/K| = {n}")
    print(f"  {len(T)} two-subgroup face-orbit types with faces <= {a.maxface} "
          f"({time.time() - t0:.0f}s to enumerate)")
    print(f"  [(|H1|, |H2|, face size, orbit size): count] "
          f"{dict(sorted(summ.items()))}")
    if a.maxtypes and len(T) >= a.maxtypes:
        print("  *** --maxtypes reached: this run is a PREFIX, not exhaustive")

    primes = sorted({p for p in (2, 3, 5, 7, 11, 13) if order % p == 0})
    full = (1 << n) - 1
    st = defaultdict(int)
    t0 = time.time()
    hit_limit = False
    for k in range(1, a.maxk + 1):
        for combo in itertools.combinations(range(len(T)), k):
            if time.time() - t0 > a.limit:
                hit_limit = True
                print(f"  time limit at k = {k}")
                break
            F = closure_masks([T[i] for i in combo])
            if full in F:
                continue
            st["tried"] += 1
            if chi(F) != 1:
                continue
            st["chi1"] += 1
            if chi_link(F) != 1:
                continue
            st["link1"] += 1
            # p = 2 first, by the fast path: it is the only filter that has
            # ever fired here, and it is 30-60x cheaper than the generic one.
            if any(betti_f2(F, n)):
                st["F2fail"] += 1
                continue
            bad = next((p for p in primes if p != 2 and any(betti_mod(F, n, p))),
                       None)
            if bad is not None:
                st[f"F{bad}fail"] += 1
                continue
            st["acyclic_all_p"] += 1
            desc = [types[T[i]] for i in combo]
            try:
                ne = nonevasive(F, n, time.time() + a.netimeout)
                st["NONEVASIVE" if ne else "evasive"] += 1
                print(f"  {desc}: {len(F)} faces, acyclic mod {primes} -> "
                      f"{'NONEVASIVE  <== COUNTEREXAMPLE' if ne else 'EVASIVE'}")
            except TimeoutError:
                st["NE_timeout"] += 1
                print(f"  {desc}: {len(F)} faces, acyclic mod {primes} -> "
                      f"NE recursion TIMEOUT (candidate -- rerun with a "
                      f"larger --netimeout)")
        if hit_limit:
            break
    print(f"  up to {a.maxk} types: {dict(st)}  ({time.time() - t0:.0f}s)"
          + ("  [INCOMPLETE]" if hit_limit else ""))
    if st["chi1"] == 0 and st["tried"]:
        print("  NOTE: no complex reached chi = 1, so NOTHING homological was "
              "tested here.  That is a fact about orbit-size arithmetic on "
              "this set, not evidence about acyclicity.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
