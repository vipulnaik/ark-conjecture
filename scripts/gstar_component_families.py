#!/usr/bin/env python3
"""gstar_component_families.py -- upper bounds on G*(a) from component-closed graph properties
(threshold-beyond-mu.md §6.1, the link mu*_N^fpf <= mu*_N).

Let C(r, E) be the connected graphs with at most r vertices and at most E edges, optionally together with the stars
K_{1,s} for r <= s <= S and the paths on r < v <= Pl vertices; it is closed under taking components
of subgraphs, so P(r, E) = "every component lies in C(r, E)" is a graph property (a simplicial complex on edges).
Labelled exponential formula: sum over graphs G in P on [a] of (-1)^{e(G)} = a! [x^a] exp(W(x)),
W(x) = sum_v w_v x^v / v!, w_v = sum over connected graphs in C(r, E) on [v] of (-1)^e  (w_1 = 1).
chi(Delta_P) = 1 - a! [x^a] exp(W), so chi = 1 iff that coefficient is 0.  e_max(P) <= max over component splittings,
at most floor(a / v*) * E-ish; computed exactly here as the largest total edge count of a graph in P on a vertices
(a knapsack over component sizes v with best edge count min(E, C(v, 2)) for connected v-vertex graphs, needing
E >= v - 1).  Connected labelled graphs by edges c(v, e) come from the standard recurrence.
usage: python3 gstar_component_families.py [AMAX=60] [RMAX=7] -> ../outputs/gstar_component_families.txt"""
import sys
from math import comb, factorial
from fractions import Fraction
from functools import lru_cache
AMAX = int(sys.argv[1]) if len(sys.argv) > 1 else 60
RMAX = int(sys.argv[2]) if len(sys.argv) > 2 else 7
@lru_cache(maxsize=None)
def conn(v, e):
    """connected labelled graphs on v vertices with e edges"""
    if v == 1: return 1 if e == 0 else 0
    tot = comb(comb(v, 2), e)
    # subtract disconnected: the component of vertex 1 has k < v vertices and j edges
    for k in range(1, v):
        for j in range(0, min(e, comb(k, 2)) + 1):
            c = conn(k, j)
            if c: tot -= comb(v - 1, k - 1) * c * comb(comb(v - k, 2), e - j)
    return tot
def coeffs(w, a):
    """a! [x^a] exp(W) via the set-partition recurrence: f(n) = sum_k C(n-1, k-1) w_k f(n-k)"""
    f = [1] + [0] * a
    for n in range(1, a + 1):
        f[n] = sum(comb(n - 1, k - 1) * w[k] * f[n - k] for k in range(1, n + 1) if k < len(w) and w[k])
    return f
res = {}
def emax_for(r, E, S, Pl, a):
    best = [0] * (a + 1)
    for n in range(1, a + 1):
        cands = [best[n - v] + min(E, comb(v, 2)) for v in range(1, min(r, n) + 1)]
        cands += [best[n - v] + v - 1 for v in range(r + 1, min(max(S + 1, Pl), n) + 1)]
        best[n] = max(cands)
    return best[a]
for r in range(2, RMAX + 1):
    for E in range(r - 1, comb(r, 2) + 1):
        base = [0, 1] + [sum((-1) ** e * conn(v, e) for e in range(v - 1, min(E, comb(v, 2)) + 1)) for v in range(2, r + 1)]
        for S in [0] + list(range(r, AMAX)):            # stars K_{1,s}, r <= s <= S (v = s + 1 > r)
            for Pl in [0] + list(range(r + 1, AMAX + 1)):   # paths on up to Pl vertices (v > r)
                vmax = max(S + 1, Pl, r)
                w = base + [0] * (vmax - r)
                for v in range(r + 1, vmax + 1):
                    star = v if v <= S + 1 else 0
                    path = factorial(v) // 2 if v <= Pl else 0
                    both = v if (v <= S + 1 and v <= Pl and v == 3) else 0   # P3 = K_{1,2} (only v = 3, already <= r)
                    w[v] = (-1) ** (v - 1) * (star + path - both)
                f = coeffs(w, AMAX)
                for a in range(max(r + 1, 2), AMAX + 1):
                    if f[a] == 0:
                        em = emax_for(r, E, S, Pl, a)
                        if em < comb(a, 2) and (a not in res or em < res[a][0]): res[a] = (em, r, E, S, Pl)
from sympy import factorint
lines = []
for a in range(2, AMAX + 1):
    pp = len(factorint(a)) == 1
    lines.append(f"a={a}{' (prime power)' if pp else ''}: " + (f"chi = 1 with e_max {res[a][0]} (r={res[a][1]}, E={res[a][2]}, stars to K_1,{res[a][3]}, paths to {res[a][4]} vertices); C(a,2) = {comb(a,2)}" if a in res else "none found (r <= %d)" % RMAX))
open('../outputs/gstar_component_families.txt', 'w').write('\n'.join(lines) + '\n')
print('\n'.join(lines))
