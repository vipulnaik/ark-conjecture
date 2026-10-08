# rv6_a4.py -- a 6-variable counterexample to Rivest--Vuillemin's original (non-monotone) conjecture, found by rv_search:
# points = edges of K4 (pairs {1,4},{2,5},{3,6} opposite), invariant under A4 = T(6,4); f(empty) = 1, f(X) = 0, D(f) = 5.
# F = {} + singletons + 2-sets other than the 3 opposite pairs + the 4 triangles + (an opposite pair with any point of the
# cyclically previous pair, 6 sets) + the 3 unions of two opposite pairs = 32 sets.  Also checks compositions (n = 12).
import itertools
from functools import lru_cache
F6 = [(), (1,), (2,), (3,), (4,), (5,), (6,), (1, 2), (1, 3), (1, 5), (1, 6), (2, 3), (2, 4), (2, 6), (3, 4), (3, 5), (4, 5),
      (4, 6), (5, 6), (1, 2, 4), (1, 2, 6), (1, 3, 5), (1, 3, 6), (1, 4, 5), (2, 3, 4), (2, 3, 5), (2, 5, 6), (3, 4, 6), (4, 5, 6),
      (1, 2, 4, 5), (1, 3, 4, 6), (2, 3, 5, 6)]
F = {frozenset(s) for s in F6}; n = 6
gens = [{1: 4, 4: 1, 2: 5, 5: 2, 3: 3, 6: 6}, {1: 3, 3: 5, 5: 1, 2: 4, 4: 6, 6: 2}]
print("A4-invariant:", all({frozenset(g[x] for x in S) for S in F} == F for g in gens))
print("f(empty) =", frozenset() in F, " f(X) =", frozenset(range(1, 7)) in F, " monotone:",
      all(S - {x} in F for S in F for x in S), " signed count:", sum((-1) ** len(S) for S in F))
@lru_cache(None)
def D(fixed, vals):
    free = [i for i in range(1, n + 1) if i not in fixed]
    v = {(vals | frozenset(W)) in F for k in range(len(free) + 1) for W in itertools.combinations(free, k)}
    if len(v) == 1: return 0
    return min(1 + max(D(fixed | {i}, vals), D(fixed | {i}, vals | {i})) for i in free)
print("D(f) =", D(frozenset(), frozenset()), "(evasive would be 6)")
