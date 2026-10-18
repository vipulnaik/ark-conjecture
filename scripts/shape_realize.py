#!/usr/bin/env python3
"""
shape_realize.py -- check the SCORING FUNCTION, not the argmax.

Every existing check validates the winner: verify_witness.g builds the recorded
witness and confirms its minimum orbital, validate_table re-derives B from that
witness, the small-degree computations confirm nothing exceeds m*.  None of them
looks at a shape that LOSES.  An error that mis-scores a losing shape is
therefore invisible everywhere until that shape becomes a winner at some larger
n -- which is exactly how the F_mid twist strip survived: it under-scored the
cyclic-layer fused class by a factor of 2 at n = 10, where the same m* was
reachable by a top-layer reading, and did not change any argmax until n = 78.

This script closes that gap for the matching class, which is where the scoring
does its non-trivial work.  For each (F, c = p^a, d) it CONSTRUCTS a group
realising the fused class and compares its actual pair-orbitals against the
scored terms.

    intra  = F * orb(c, d)          orb(c,d) = min(c*d / (2 if -1 in T else 1), C(c,2))
    cross  = (F//2) * c^2   (F even)   or   F * c^2   (F odd)

The fused class is realised by an ENTANGLED generator
    z : (i, x) |-> (i+1, a_i x),   prod a_i = A of order d,
so that z^F is the full diagonal twist of order d.  This is the construction of
`arithmetic-of-density.md` 3.2.3; a block permutation plus a separate twist is a
DIFFERENT group (at n = 10 both have order 200 and neither contains the other)
which happens to share the orbital partition, and it is the reading that made
the strip look harmless.

Two failure directions, and they are not symmetric:

  UNDER-SCORE  (score < realised)  -- the dangerous one.  B(n) is an upper-bound
                                     claim, so a shape scored below what it can
                                     actually achieve makes B too small and can
                                     break mu(n) <= B(n).  A restriction that
                                     "looks conservative" fails this way.
  OVER-SCORE   (score > realised)  -- unsound in the other direction: the cap
                                     credits an orbital no group delivers.

This is the enumerator-side mirror of `small-degree-computation.md` 1.2's
asymmetry for the CSP side ("dropping constraints turns a real UNSAT into a
spurious SAT").  The lesson was written down there and not applied here.

Usage:
    python3 shape_realize.py            # regression cases + sweep to n <= 40
    python3 shape_realize.py --nmax 60  # wider sweep (cost grows like n^2 per shape)
    python3 shape_realize.py --strip    # score with the RETIRED F_mid strip, to
                                        # confirm this test would have caught it
    python3 shape_realize.py --foreign --nmax 200   # FOREIGN block: C_r : C_t vs the enumerator's own orb(r, t)
    python3 shape_realize.py --foreign --strip      # control: halving removed, OVER-SCORE at even t < r - 1
    python3 shape_realize.py --interclass --nmax 40 # matching class + foreign block, one diagonal chain element
Exits nonzero on any mismatch.
"""
import argparse
import sys
from collections import Counter
from math import comb


# ---------------------------------------------------------------- group tools
def orbitals(npts, gens, block_of=None):
    """Sorted orbit sizes on unordered pairs.

    With `block_of` supplied, returns (intra, cross): the orbits all of whose
    pairs lie inside one block, and the rest.  The scored terms count different
    populations -- intra = F*orb(c,d) is about pairs within a block, cross is
    about pairs between blocks -- so comparing a single overall minimum against
    min(intra, cross) conflates them and misreports whenever the smallest orbit
    is of the other kind.
    """
    pairs = [(i, j) for i in range(npts) for j in range(i + 1, npts)]
    pidx = {p: k for k, p in enumerate(pairs)}
    par = list(range(len(pairs)))

    def find(x):
        while par[x] != x:
            par[x] = par[par[x]]
            x = par[x]
        return x

    changed = True
    while changed:
        changed = False
        for g in gens:
            for k, (a, b) in enumerate(pairs):
                u, v = g[a], g[b]
                ra, rb = find(k), find(pidx[(min(u, v), max(u, v))])
                if ra != rb:
                    par[ra] = rb
                    changed = True
    groups = {}
    for k in range(len(pairs)):
        groups.setdefault(find(k), []).append(pairs[k])
    if block_of is None:
        return sorted(len(v) for v in groups.values())
    intra, cross = [], []
    for v in groups.values():
        (intra if all(block_of[a] == block_of[b] for a, b in v) else cross).append(len(v))
    return sorted(intra), sorted(cross)


def field(p, a):
    """(elements, add, mul, generator) for F_{p^a}; a = 1 uses Z_p directly"""
    if a == 1:
        els = list(range(p))
        add = lambda u, v: (u + v) % p
        mul = lambda u, v: (u * v) % p
        one = 1
    else:
        # F_p[x]/(f) with f the first irreducible monic of degree a found
        def polymul(u, v, f):
            r = [0] * (len(u) + len(v) - 1)
            for i, ui in enumerate(u):
                for j, vj in enumerate(v):
                    r[i + j] = (r[i + j] + ui * vj) % p
            while len(r) >= len(f):
                if r[-1]:
                    sh = len(r) - len(f)
                    c = r[-1]
                    for i, fi in enumerate(f):
                        r[i + sh] = (r[i + sh] - c * fi) % p
                r.pop()
            return tuple(r + [0] * (a - len(r)))

        import itertools
        f = None
        for tail in itertools.product(range(p), repeat=a):
            cand = list(tail) + [1]
            # irreducible iff no root-free factorisation; brute: no divisor of deg<=a/2
            ok = True
            for d in range(1, a // 2 + 1):
                for g in itertools.product(range(p), repeat=d):
                    gg = list(g) + [1]
                    # trial division
                    rem = cand[:]
                    while len(rem) >= len(gg) and any(rem):
                        if rem[-1] == 0:
                            rem.pop(); continue
                        sh = len(rem) - len(gg)
                        cf = rem[-1] * pow(gg[-1], -1, p) % p
                        for i, gi in enumerate(gg):
                            rem[i + sh] = (rem[i + sh] - cf * gi) % p
                        rem.pop()
                    if not any(rem):
                        ok = False
                        break
                if not ok:
                    break
            if ok:
                f = cand
                break
        els = [tuple(t) for t in itertools.product(range(p), repeat=a)]
        add = lambda u, v: tuple((ui + vi) % p for ui, vi in zip(u, v))
        mul = lambda u, v: polymul(list(u), list(v), f)
        one = tuple([1] + [0] * (a - 1))
    # multiplicative generator
    c = p ** a
    gen = None
    for u in els:
        if u == (els[0] if a > 1 else 0) or (a == 1 and u == 0):
            continue
        o, v = 1, u
        while v != one:
            v = mul(v, u)
            o += 1
            if o > c:
                break
        if o == c - 1:
            gen = u
            break
    return els, add, mul, one, gen


def power(mul, u, k, one):
    r = one
    for _ in range(k):
        r = mul(r, u)
    return r


def fused_class_group(p, a, F, d):
    """<translations on each block, entangled z> on F * p^a points; z^F = twist of order d"""
    els, add, mul, one, gen = field(p, a)
    c = p ** a
    assert (c - 1) % d == 0
    A = power(mul, gen, (c - 1) // d, one)          # element of order exactly d
    pts = [(i, x) for i in range(F) for x in els]
    idx = {q: k for k, q in enumerate(pts)}
    # Translations must generate the WHOLE additive group of F_c, which for
    # a > 1 needs a basis, not just 1 -- translation by 1 alone generates only
    # Z_p and silently under-builds the block group.
    basis = [one] if a == 1 else [
        tuple(1 if j == i else 0 for j in range(a)) for i in range(a)]
    gens = []
    for b in range(F):
        for e in basis:
            gens.append(tuple(idx[(i, add(x, e) if i == b else x)] for (i, x) in pts))
    # entangled generator: all multiplier on the last step, so z^F = mult by A
    gens.append(tuple(idx[((i + 1) % F, mul(A, x) if i == F - 1 else x)] for (i, x) in pts))
    return len(pts), gens, [i for (i, _) in pts]


# ------------------------------------------------------------------- scoring
def orb(c, d, char2):
    """Within-block orbital size for AGL(1,c) with twist subgroup T of order d.

    The orbital of a pair is indexed by its difference up to T and up to sign,
    so its size is c*|T u -T|/2: that is c*d/2 when -1 lies in T, and c*d
    otherwise.  In characteristic 2, -1 = 1 lies in every T, so the halving
    always applies -- which is the `char2` flag.  Capped at C(c,2).
    """
    minus_one_in_T = char2 or (d % 2 == 0)
    v = c * d // 2 if minus_one_in_T else c * d
    return min(v, comb(c, 2))


def score_terms(p, a, F, d, use_strip):
    """the scored intra and cross for a fused matching class"""
    c = p ** a
    dd = d
    if use_strip:                                   # the RETIRED F_mid coprimality strip
        fm = F
        while fm % 2 == 0 and dd % 2 == 0:
            dd //= 2
        g = dd
        while True:
            import math
            k = math.gcd(g, fm)
            if k == 1:
                break
            g //= k
        dd = g
    intra = F * orb(c, dd, p == 2)
    cross = (F // 2) * c * c if F % 2 == 0 else F * c * c
    return intra, cross, dd


# --------------------------------------------------------------------- driver
def check(p, a, F, d, use_strip, verbose=False):
    c = p ** a
    npts, gens, blk = fused_class_group(p, a, F, d)
    r_intra, r_cross = orbitals(npts, gens, blk)
    s_intra, s_cross, dd = score_terms(p, a, F, d, use_strip)
    ri, rc = (min(r_intra) if r_intra else None), (min(r_cross) if r_cross else None)
    bad = []
    if ri is not None and s_intra != ri:
        bad.append(("intra", s_intra, ri))
    if rc is not None and s_cross != rc:
        bad.append(("cross", s_cross, rc))
    status = "ok"
    for what, sc, re_ in bad:
        status = "UNDER-SCORE" if sc < re_ else "OVER-SCORE"
    if verbose or bad:
        strip = f"  [strip: d {d} -> {dd}]" if use_strip and dd != d else ""
        detail = "" if not bad else "  " + "; ".join(
            f"{w}: scored {sc} vs realised {r}" for w, sc, r in bad)
        print(f"  {F}x{c:<4} (n={npts:>3}) d={d:<4} intra {s_intra:>5}/{ri if ri else '-':>5} "
              f"cross {s_cross:>6}/{rc if rc else '-':>6}  {status}{detail}{strip}")
    return status


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--nmax", type=int, default=40)
    ap.add_argument("--strip", action="store_true",
                    help="score with the retired F_mid strip (expect UNDER-SCOREs)")
    ap.add_argument("--verbose", action="store_true")
    ap.add_argument("--foreign", action="store_true",
                    help="check the FOREIGN block's score (pending-checks R6 item 1): realise C_r : C_t for prime r and every "
                         "prime-power twist t | r-1, and compare its minimum orbital with mu_enumerate_v3.orb(r, t, False). "
                         "With --strip, score with the halving removed (control: expect OVER-SCORE exactly at even t)")
    ap.add_argument("--interclass", action="store_true",
                    help="check the INTER-CLASS term F*c*r (pending-checks R6 item 2): a fused matching class plus a foreign "
                         "block, linked by ONE diagonal cyclic generator (z on the matching class, translation on the foreign "
                         "block), with the foreign twist on top.  Admissible (gcd(F*d, r) = 1) shapes must realise exactly F*c*r; "
                         "non-admissible ones are run as the control")
    args = ap.parse_args()
    if args.interclass:
        return interclass_main(args)
    if args.foreign:
        return foreign_main(args)

    mode = "RETIRED F_mid strip" if args.strip else "current (full twist)"
    print(f"shape_realize.py -- scoring mode: {mode}\n")

    # --- named regression: the case that would have caught the strip at n = 10
    print("Regression: the fused cyclic-layer class at n = 10 (F = 2, c = 5).")
    print("  Under the strip this scores 10; the group realises 20.  The v4 table")
    print("  was nonetheless correct at n = 10, because a top-layer reading (q = 2,")
    print("  c - 1 = 4 a 2-power) reaches the same m* -- which is why the max hid it.")
    bad = 0
    if check(5, 1, 2, 4, args.strip, verbose=True) != "ok":
        bad += 1
    print()

    # --- sweep
    print(f"Sweep over fused matching classes with F*c <= {args.nmax}:")
    prime_powers = []
    for q in range(3, args.nmax + 1):
        m, pp, dd = q, None, 2
        while dd * dd <= m:
            if m % dd == 0:
                e = 0
                while m % dd == 0:
                    m //= dd
                    e += 1
                pp = (dd, e) if m == 1 else None
                break
            dd += 1
        if m == q:
            pp = (q, 1)
        if pp:
            prime_powers.append(pp)

    tested = 0
    for (p, a) in prime_powers:
        c = p ** a
        for F in range(2, args.nmax // c + 1):
            for d in [x for x in range(1, c) if (c - 1) % x == 0]:
                if F * c > args.nmax or F * c < 6:
                    continue
                st = check(p, a, F, d, args.strip, verbose=args.verbose)
                tested += 1
                if st != "ok":
                    bad += 1
    print(f"\n{tested} shapes tested, {bad} mismatches.")
    if args.strip and bad:
        print("The strip is detected exactly as expected -- this is the control.")
    return 1 if (bad and not args.strip) else 0


def interclass_main(args):
    """R6 item 2.  Points: the fused matching class (F blocks of c = p^a) plus a foreign block Z_r.  Generators:
    matching translations (identity on the foreign block); the DIAGONAL chain element g = (z, tau), z the entangled
    generator of the matching class and tau : y -> y + 1 on the foreign block; the top element w : y -> omega*y on the
    foreign block (omega of order t), identity on the matching class.  The cyclic layer is cyclic and w normalises it
    exactly when gcd(ord z, r) = gcd(F*d, r) = 1 (CRT), which is Lemma C's condition.  Scored terms: matching intra
    F*orb(c, d), cross-block, foreign intra orb(r, t), and the inter-class F*c*r."""
    from math import gcd
    def isprime(m):
        return m > 1 and all(m % k for k in range(2, int(m ** 0.5) + 1))
    def prime_power(m):
        for q in range(2, m + 1):
            if m % q == 0:
                while m % q == 0:
                    m //= q
                return m == 1
        return False
    print("shape_realize.py --interclass -- matching class + foreign block, one diagonal chain element\n")
    tested = bad = ctrl = ctrl_low = 0
    for p, a in [(2, 2), (3, 1), (5, 1), (7, 1), (2, 3), (3, 2), (11, 1)]:
        c = p ** a
        for F in (1, 2, 3):
            for d in [x for x in range(1, c) if (c - 1) % x == 0]:
                for r in [x for x in range(3, 14) if isprime(x) and x != p]:
                    for t in [x for x in range(2, r) if (r - 1) % x == 0 and prime_power(x)]:
                        if F * c + r > args.nmax:
                            continue
                        npts, gens, blk = fused_class_group(p, a, F, d)
                        N = npts + r
                        ext = [tuple(list(gg) + list(range(npts, N))) for gg in gens[:-1]]          # translations
                        z = gens[-1]
                        g = tuple(list(z) + [npts + (y + 1) % r for y in range(r)])                    # diagonal (z, tau)
                        om = next(x for x in range(2, r) if pow(x, t, r) == 1 and all(pow(x, t // q, r) != 1 for q in range(2, t + 1) if t % q == 0 and isprime(q)))
                        w = tuple(list(range(npts)) + [npts + (om * y) % r for y in range(r)])
                        orbs = {}
                        G = ext + [g, w]
                        # orbit classification by representative pair
                        pairs = [(i, j) for i in range(N) for j in range(i + 1, N)]
                        pidx = {q: k for k, q in enumerate(pairs)}; par = list(range(len(pairs)))
                        def find(x):
                            while par[x] != x:
                                par[x] = par[par[x]]; x = par[x]
                            return x
                        ch = True
                        while ch:
                            ch = False
                            for gg in G:
                                for k, (u, v) in enumerate(pairs):
                                    a1, b1 = gg[u], gg[v]
                                    ra, rb = find(k), find(pidx[(min(a1, b1), max(a1, b1))])
                                    if ra != rb: par[ra] = rb; ch = True
                        sizes = {}
                        for k, (u, v) in enumerate(pairs):
                            kind = ("inter" if (u < npts) != (v < npts) else "foreign" if u >= npts else
                                    "intra" if blk[u] == blk[v] else "cross")
                            sizes.setdefault((kind, find(k)), 0); sizes[(kind, find(k))] += 1
                        mins = {}
                        for (kd, _), v in sizes.items():
                            mins[kd] = min(mins.get(kd, v), v)
                        inter = mins["inter"]
                        s_intra, s_cross, _ = score_terms(p, a, F, d, False)
                        want = {"inter": F * c * r, "intra": s_intra, "foreign": orb(r, t, False)}
                        if F > 1:
                            want["cross"] = s_cross
                        admissible = gcd(F * d, r) == 1
                        if admissible:
                            tested += 1
                            miss = [(k, want[k], mins.get(k)) for k in want if mins.get(k) != want[k]]
                            if miss:
                                bad += 1
                                print(f"  ADMISSIBLE MISMATCH F={F} c={c} d={d} r={r} t={t}: " + "; ".join(f"{k} scored {w} realised {m}" for k, w, m in miss))
                        else:
                            ctrl += 1
                            if inter < F * c * r:
                                ctrl_low += 1
                                if args.verbose:
                                    print(f"  control F={F} c={c} d={d} r={r} t={t}: inter {inter} < F*c*r {F*c*r}")
    print(f"admissible shapes: {tested}, inter-class mismatches: {bad}")
    print(f"non-admissible (r | F*d): {ctrl}, of which inter-class < F*c*r: {ctrl_low}  -- the gcd condition governs whether the "
          "group is Oliver (cyclic layer normalised by the top), not the size of this orbital, so 0 here is expected")
    return 1 if bad else 0


def foreign_main(args):
    """R6 item 1: a foreign block is a prime block r carrying C_r : C_t, t a prime power dividing r - 1 (Lemma B').
    Its scored intra term is orb(r, t) from the ENUMERATOR ITSELF (imported, so the live code is what is tested); the
    realised term is the minimum pair-orbital of the actual group.  The efficiency eta = orb(r, t) / C(r, 2) is
    2t/(r-1) for odd t and t/(r-1) for even t."""
    import importlib.util, os
    spec = importlib.util.spec_from_file_location("mue", os.path.join(os.path.dirname(os.path.abspath(__file__)), "mu_enumerate_v3.py"))
    mue = importlib.util.module_from_spec(spec)
    sys.argv = [sys.argv[0]]                        # the enumerator parses argv at import time in some versions
    spec.loader.exec_module(mue)
    def isprime(m):
        return m > 1 and all(m % k for k in range(2, int(m ** 0.5) + 1))
    def prime_power(m):
        for q in range(2, m + 1):
            if m % q == 0:
                while m % q == 0:
                    m //= q
                return m == 1
        return False
    mode = "CONTROL: halving removed (expect OVER-SCORE exactly at even t)" if args.strip else "enumerator's orb(r, t, False)"
    print(f"shape_realize.py --foreign -- scoring: {mode}\n")
    tested = bad = 0
    for r in range(3, args.nmax + 1):
        if not isprime(r):
            continue
        g = next(x for x in range(2, r) if all(pow(x, (r - 1) // q, r) != 1 for q in range(2, r) if (r - 1) % q == 0 and isprime(q)))
        for t in [x for x in range(1, r) if (r - 1) % x == 0 and prime_power(x)] + [1]:
            w = pow(g, (r - 1) // t, r)
            gens = [tuple((x + 1) % r for x in range(r)), tuple((w * x) % r for x in range(r))]
            real = min(orbitals(r, gens))
            score = min(r * t, comb(r, 2)) if args.strip else mue.orb(r, t, False)
            tested += 1
            if score != real:
                bad += 1
                print(f"  r={r:<4} t={t:<4} scored {score:>6} realised {real:>6}  {'UNDER' if score < real else 'OVER'}-SCORE")
            elif args.verbose:
                print(f"  r={r:<4} t={t:<4} {score:>6} ok   eta = {score / comb(r, 2):.4f}")
    print(f"\n{tested} (r, t) foreign blocks tested, {bad} mismatches.")
    if args.strip:
        print("Control run: mismatches are expected exactly at even t." if bad else "CONTROL FAILED TO FIRE")
        return 0 if bad else 1
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
