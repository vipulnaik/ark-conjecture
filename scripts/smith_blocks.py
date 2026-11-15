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

usage: python3 smith_blocks.py [KMAX=4] [PMAX=43] [JMAX=4] [--compare]
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


if __name__ == '__main__':
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
