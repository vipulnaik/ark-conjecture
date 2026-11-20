#!/usr/bin/env python3
# two_p_pairs.py -- for a cyclic-star export (star_export.g with h a 2p-cycle): checks every group has an all-odd-distance
# orbital (the Sub(K_{p,p}) Proposition of burnside-ring-view.md §7.5), and lists N-level infeasible pairs at p(p-1) and p^2-1.
# usage: python3 two_p_pairs.py ../outputs/star_zN.txt N
import sys, itertools
F, n = sys.argv[1], int(sys.argv[2]); PP = n // 2
sys.argv = ['x', F, str(n)]
src = open('nlevel_star.py').read(); exec(src[:src.index("lab = lambda")])
def dist(i):
    a, b = E[i]; d = (b - a) % n; return min(d, n - d)
bad = 0
for j, (o, tr, orbs, gens) in enumerate(info):
    S = [ob for ob in orbs if all(dist(i) % 2 == 1 for i in range(m) if ob >> i & 1)]
    if not S: bad += 1; print('  group', o, tr, 'has no odd-distance orbital')
print(F, 'groups', len(info), 'with no all-odd orbital:', bad)
# pairs at B = p(p-1) and at p^2 - 1
for B in (PP*(PP-1), PP*PP-1):
    ip = [(a, b) for a, b in itertools.combinations(range(len(info)), 2) if feasible([a, b], B) is False]
    print('  B =', B, 'infeasible pairs:', len(ip))
