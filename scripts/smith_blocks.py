#!/usr/bin/env python3
"""smith_blocks.py -- the Smith bound s_Q for Q = (Z/p)^k, the translations of k blocks of p
points (n = kp, p an odd prime), via the class complex (threshold-beyond-mu.md section 7).

Q's orbitals are the (p - 1)/2 = h difference classes in each block, of p pairs each, and
one cross orbital of p^2 pairs per pair of blocks.  N*(Q) acts on the kh intra classes
as C_h^k x| S_k: within a block, the multipliers Z_p^*/{+-1} act regularly on the h
classes (N(D_p) = AGL(1, p)); the blocks are permuted freely.  Below budget p^2 no face
can hold a cross orbital, so for B < p^2
    s_Q <= B  iff  some (C_h^k x| S_k)-invariant complex on the kh classes, every face of
                   at most floor(B/p) classes, has chi = 1 (mod p),
and s_Q = p * j, j the least face size that works.  (If no j with jp < p^2 works, s_Q >= p^2.)

Checks: --compare reruns pgroup_levels.level() on the orbitals themselves for small (k, p).

--construct checks Proposition B' (threshold-beyond-mu.md section 7): for p >= 37 and
p not dividing k, the complex with every class, every within-block pair of classes and t
generic within-block triangle families (each of size kh) has chi = kh - k C(h,2) + t kh,
and some t <= G(h) = the number of generic families makes it 1 mod p.  It checks the
arithmetic for all such p < 400 and k < min(p, 61), counts G(h) by enumeration, and builds
the complex explicitly and counts its faces for a few (k, p).

usage: python3 smith_blocks.py [KMAX=4] [PMAX=43] [JMAX=4] [--compare] [--construct]
"""
import sys, itertools
from ortools.sat.python import cp_model

args = [a for a in sys.argv[1:] if not a.startswith('--')]
KMAX = int(args[0]) if len(args) > 0 else 4
PMAX = int(args[1]) if len(args) > 1 else 43
JMAX = int(args[2]) if len(args) > 2 else 4


def primes(a, b):
    return [p for p in range(a, b + 1) if all(p % d for d in range(2, int(p ** .5) + 1))]


def least_j(k, p, JMAX):
    h = (p - 1) // 2
    V = [(b, c) for b in range(k) for c in range(h)]
    vid = {v: i for i, v in enumerate(V)}
    gens = []
    for b in range(k):                                   # rotate the classes of block b
        gens.append([vid[(bb, (c + 1) % h if bb == b else c)] for bb, c in V])
    for b in range(k - 1):                               # swap blocks b, b + 1
        sw = {b: b + 1, b + 1: b}
        gens.append([vid[(sw.get(bb, bb), c)] for bb, c in V])
    for J in range(1, JMAX + 1):
        if J * p >= p * p:
            return None
        faces = [F for r in range(1, J + 1) for F in itertools.combinations(range(len(V)), r)]
        rep = {}
        for F in faces:
            if F in rep: continue
            orb = {F}; st = [F]
            while st:
                x = st.pop()
                for g in gens:
                    y = tuple(sorted(g[i] for i in x))
                    if y not in orb: orb.add(y); st.append(y)
            for y in orb: rep[y] = F
        reps = sorted(set(rep.values()))
        size = {}
        for F in rep: size[rep[F]] = size.get(rep[F], 0) + 1
        M = cp_model.CpModel(); X = {F: M.NewBoolVar('') for F in reps}
        for F in reps:
            if len(F) > 1:
                for i in range(len(F)):
                    M.AddImplication(X[F], X[rep[F[:i] + F[i + 1:]]])
        z = M.NewIntVar(-10 ** 9, 10 ** 9, '')
        M.Add(sum((1 if len(F) % 2 else -1) * size[F] * X[F] for F in reps) == 1 + p * z)
        S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 120
        r = S.Solve(M)
        if r in (cp_model.OPTIMAL, cp_model.FEASIBLE):
            return J
        if r != cp_model.INFEASIBLE:
            return 'unknown'
    return f'>{JMAX}'


def generic_families(h):
    """within-block triples of classes up to translation in C_h with trivial stabiliser"""
    seen = set(); g = 0
    for T in itertools.combinations(range(h), 3):
        if T in seen: continue
        orb = {tuple(sorted((x + i) % h for x in T)) for i in range(h)}
        seen |= orb
        g += len(orb) == h
    return g, sorted(seen)


def construct():
    bad = 0; worst = 0
    for p in primes(37, 400):
        h = (p - 1) // 2; G = (h * (h - 1) * (h - 2) // 6 - (h // 3 if h % 3 == 0 else 0)) // h
        for k in range(2, min(p, 61)):
            base = k * h - k * h * (h - 1) // 2
            t = ((1 - base) * pow(k * h, -1, p)) % p
            ok = t <= G and (base + t * k * h - 1) % p == 0
            bad += not ok; worst = max(worst, t)
    print(f"Proposition B' arithmetic: p in [37, 400), 2 <= k < min(p, 61): failures {bad}; "
          f"largest t needed {worst}")
    for h in (18, 20, 21, 30):
        g, _ = generic_families(h)
        G = (h * (h - 1) * (h - 2) // 6 - (h // 3 if h % 3 == 0 else 0)) // h
        print(f"  G(h) by enumeration at h = {h}: {g} (formula {G})")
    for k, p in [(2, 37), (3, 41), (5, 43), (7, 53)]:
        h = (p - 1) // 2
        fams = [T for T in generic_families(h)[1] if T[0] == 0]
        # one representative per generic family: the triples through class 0 of block 0
        reps, seen = [], set()
        for T in itertools.combinations(range(h), 3):
            orb = frozenset(tuple(sorted((x + i) % h for x in T)) for i in range(h))
            if len(orb) == h and orb not in seen:
                seen.add(orb); reps.append(orb)
        base = k * h - k * h * (h - 1) // 2
        t = ((1 - base) * pow(k * h, -1, p)) % p
        V = [(b, c) for b in range(k) for c in range(h)]
        E = [((b, x), (b, y)) for b in range(k) for x, y in itertools.combinations(range(h), 2)]
        T = [tuple((b, x) for x in tri) for b in range(k) for orb in reps[:t] for tri in orb]
        Tset = {frozenset(x) for x in T}; Eset = {frozenset(e) for e in E}
        closed = all(frozenset(pr) in Eset for tri in T for pr in itertools.combinations(tri, 2))
        # invariance: rotate classes of block 0, and swap blocks 0 and 1
        rot = lambda v: (v[0], (v[1] + 1) % h) if v[0] == 0 else v
        sw = lambda v: ((1 - v[0]) if v[0] < 2 else v[0], v[1])
        inv = all(frozenset(map(f, x)) in Tset for x in Tset for f in (rot, sw))
        chi = len(V) - len(E) + len(T)
        print(f"  explicit k = {k}, p = {p}: t = {t}, faces {len(V)} + {len(E)} + {len(T)}, chi = {chi} "
              f"= {chi % p} mod p, closed {closed}, invariant {inv}")


if __name__ == '__main__':
    if '--construct' in sys.argv:
        construct(); sys.exit()
    print(f"least j (s_Q = p*j) for k blocks of p, k <= {KMAX}, 3 <= p <= {PMAX}, j <= {JMAX}")
    for k in range(2, KMAX + 1):
        row = {p: least_j(k, p, JMAX) for p in primes(3, PMAX)}
        print(f"k = {k}: " + ", ".join(f"p={p}: {j}" for p, j in row.items()), flush=True)
    if '--compare' in sys.argv:
        # against pgroup_levels.level() on the orbitals themselves
        src = open('pgroup_levels.py').read().split('\nif TWO:\n    (pp')[0]
        for k, p in [(2, 3), (2, 5), (2, 7), (2, 11), (3, 5), (3, 7), (3, 11)]:
            n = k * p
            g = {'n': n, 'sys': sys}
            sys_argv = sys.argv; sys.argv = ['x', str(n)]
            exec(src, g); sys.argv = sys_argv
            orbs = []
            for b in range(k):
                for d in range(1, (p - 1) // 2 + 1):
                    orbs.append(sorted(tuple(sorted((b * p + x + 1, b * p + (x + d) % p + 1))) for x in range(p)))
            for b1 in range(k):
                for b2 in range(b1 + 1, k):
                    orbs.append([(b1 * p + x + 1, b2 * p + y + 1) for x in range(p) for y in range(p)])
            B = g['level'](orbs, p)
            print(f"compare k = {k}, p = {p}: level() on the orbitals gives {B}; class complex gives "
                  f"p*j = {p * least_j(k, p, JMAX) if isinstance(least_j(k, p, JMAX), int) else least_j(k, p, JMAX)}", flush=True)
