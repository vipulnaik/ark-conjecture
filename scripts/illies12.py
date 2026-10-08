# illies12.py -- Illies (1978): a weakly symmetric, NON-monotone, non-evasive set system on 12 points, the counterexample to
# Rivest--Vuillemin's original (non-monotone) conjecture.  Source: arXiv:1409.7890, Prop. 3.15.  Checks D(f) = 11, the 3x4-torus
# description, the symmetry group S3 x D4 (= T(12,28), which contains the 12-cycle), and prints the top of an optimal tree.  ~5 s.
import itertools, sys
from functools import lru_cache
n = 12
def orbit(S): return {frozenset((s + k) % n for s in S) for k in range(n)}
gens = [[], [0], [0, 3], [0, 4], [0, 3, 6], [0, 4, 8], [0, 3, 6, 9]]
F = set()
for g in gens: F |= orbit(g)
print("sizes:", sorted({len(S) for S in F}), " counts by size:", [sum(1 for S in F if len(S) == k) for k in range(5)])
inF = [0] * (1 << n)
for S in F: inF[sum(1 << i for i in S)] = 1
print("f(empty) =", inF[0], " f(X) =", inF[(1 << n) - 1])
print("monotone?", all(not inF[m] or all(inF[m & ~(1 << i)] for i in range(n) if m >> i & 1) for m in range(1 << n)))
print("parity weight sum (-1)^|S| over F =", sum((-1) ** len(S) for S in F), " (must be 0 for non-evasive)")
# exact decision-tree depth: D(c) for a subcube c = (fixed mask, fixed values); non-evasive iff D(full cube) < n
sys.setrecursionlimit(10000)
@lru_cache(maxsize=None)
def D(fixed, vals):
    free = [i for i in range(n) if not fixed >> i & 1]
    # constant on subcube?
    first = None; const = True
    for bits in range(1 << len(free)):
        m = vals
        for j, i in enumerate(free):
            if bits >> j & 1: m |= 1 << i
        v = inF[m]
        if first is None: first = v
        elif v != first: const = False; break
    if const: return 0
    best = len(free)
    for i in free:
        d = 1 + max(D(fixed | 1 << i, vals), D(fixed | 1 << i, vals | 1 << i))
        if d < best:
            best = d
            if best == 1: break
    return best
d = D(0, 0)
print("decision-tree complexity D(f) =", d, "(evasive would be 12)")

# The 3 x 4 torus picture: x -> (x mod 3, x mod 4).  Rows: fixed x mod 3 (4 points, cyclically adjacent when they differ by 3);
# columns: fixed x mod 4 (3 points, all pairwise adjacent).  Claim: F = {empty} u {S : S inside one row or one column, connected there}.
def connected_in_line(S):
    S = sorted(S)
    if len(S) <= 1: return True
    rows = {s % 3 for s in S}; cols = {s % 4 for s in S}
    if len(cols) == 1: return True                      # column = K3: every subset connected
    if len(rows) == 1:                                  # row = C4 on the residues mod 4
        b = {s % 4 for s in S}
        return not (len(b) == 2 and (max(b) - min(b)) == 2)   # only the opposite pair is disconnected
    return False
G = {frozenset(S) for k in range(13) for S in itertools.combinations(range(n), k) if connected_in_line(S)}
print("grid description matches F:", G == F)

# Symmetry: S3 on the row index (x mod 3) times D4 on the column index (x mod 4), via CRT.
def crt(a, b): return next(x for x in range(n) if x % 3 == a and x % 4 == b)
S3 = list(itertools.permutations(range(3)))
D4 = [lambda b, r=r, s=s: (s * b + r) % 4 for r in range(4) for s in (1, -1)]
group = [[crt(p[x % 3], d(x % 4)) for x in range(n)] for p in S3 for d in D4]
print("|S3 x D4| =", len({tuple(g) for g in group}),
      " preserves F:", all({frozenset(g[s] for s in S) for S in F} == F for g in group),
      " transitive:", len({g[0] for g in group}) == n)

# Reconstruct an optimal tree; print the top levels with the grid coordinates of each queried point.
def lab(i): return f"x{i+1}(r{i%3},c{i%4})"
def best_var(fixed, vals):
    free = [i for i in range(n) if not fixed >> i & 1]
    tgt = D(fixed, vals)
    for i in free:
        if 1 + max(D(fixed | 1 << i, vals), D(fixed | 1 << i, vals | 1 << i)) == tgt: return i
def show(fixed, vals, depth, maxdepth, path):
    d = D(fixed, vals)
    if d == 0:
        print("  " * depth + f"{path}-> leaf ({'YES' if inF[vals] else 'NO'} on this subcube, {12-bin(fixed).count('1')} unqueried)"); return
    i = best_var(fixed, vals)
    print("  " * depth + f"{path}query {lab(i)}   [remaining depth {d}]")
    if depth < maxdepth:
        show(fixed | 1 << i, vals, depth + 1, maxdepth, "0: ")
        show(fixed | 1 << i, vals | 1 << i, depth + 1, maxdepth, "1: ")
show(0, 0, 0, 3, "")
# worst-case path lengths: count leaves by number of queries
from collections import Counter
cnt = Counter()
def leaves(fixed, vals, q):
    if D(fixed, vals) == 0: cnt[q] += 1; return
    i = best_var(fixed, vals)
    leaves(fixed | 1 << i, vals, q + 1); leaves(fixed | 1 << i, vals | 1 << i, q + 1)
leaves(0, 0, 0)
print("leaves by depth:", dict(sorted(cnt.items())))
