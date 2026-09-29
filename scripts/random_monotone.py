"""Uniform random nontrivial monotone graph properties, by Markov chain (oen section 7.14).

State: a down-set D of graph classes containing the empty graph and not K_n.  Step: pick a class c
uniformly; add it if all its immediate subgraphs are in D (and c != K_n), remove it if no immediate
supergraph is in D (and c != empty).  Symmetric proposals on a connected state space, so the stationary
distribution is uniform.  Reports per-class membership frequencies grouped by edge count, the duality
check Pr[G] + Pr[complement G] = 1, and the fraction of samples with global chi = 1.
USAGE   python3 random_monotone.py N STEPS THIN [SEED]      e.g.  python3 random_monotone.py 6 3000000 300
"""
import sys, random, itertools
from collections import defaultdict
n, STEPS, THIN = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
seed = int(sys.argv[4]) if len(sys.argv) > 4 else 1
sys.argv = ["metaproperty_ladder_check.py", str(n), "sample", "1", f"tom{n}.txt"]
exec(open("metaproperty_ladder_check.py").read().split('NAMES=["OR"')[0])
down = [set() for _ in range(K)]; up = [set() for _ in range(K)]
for c in range(K):
    for d in below[c]:
        if d != c and ecount[d] == ecount[c] - 1:
            down[c].add(d); up[d].add(c)
rng = random.Random(seed)
D = {c for c in range(K) if ecount[c] <= 1}          # start: all graphs with at most one edge
lab = [int(labeled[c]) * (-1) ** (int(ecount[c]) - 1) if ecount[c] > 0 else 0 for c in range(K)]
chi = sum(lab[c] for c in D)
freq = [0] * K; samples = 0; chi1 = 0
METASTEP = int(__import__('os').environ.get('METASTEP', '10')); nmeta = 0; rung = defaultdict(int)
for step in range(STEPS):
    c = rng.randrange(K)
    if c in D:
        if c != empty and not (up[c] & D):
            D.discard(c); chi -= lab[c]
    else:
        if c != full and down[c] <= D:
            D.add(c); chi += lab[c]
    if step >= STEPS // 10 and step % THIN == 0:          # 10% burn-in
        samples += 1; chi1 += (chi == 1)
        for x in D: freq[x] += 1
        if METASTEP and samples % METASTEP == 0:
            M = meta(frozenset(D)); Md = meta(dual(frozenset(D))); nmeta += 1
            for k in ("OR", "OCR", "NTR", "GR", "SGR", "VTOR"): rung[k] += bool(M[k])
            rung["BI"] += bool(M["OR"] and Md["OR"])
Nn = int(max(ecount))
print(f"n = {n}: {K} classes, N = {Nn}; {samples} samples (seed {seed}); global chi = 1 in {chi1} ({100*chi1/samples:.2f}%)")
E = list(itertools.combinations(range(n), 2))
def degs(c):
    r = int(rep[c]); dg = [0] * n
    for i, (u, v) in enumerate(E):
        if r >> i & 1: dg[u] += 1; dg[v] += 1
    return "".join(map(str, sorted(dg, reverse=True)))
byE = defaultdict(list)
for c in range(K): byE[int(ecount[c])].append((freq[c] / samples, c))
for e in sorted(byE):
    ps = sorted(p for p, _ in byE[e])
    print(f"  {e:2d} edges ({len(ps):2d} classes): min {ps[0]:.3f}  median {ps[len(ps)//2]:.3f}  max {ps[-1]:.3f}")
dev = max(abs(freq[c] / samples + freq[comp[c]] / samples - 1) for c in range(K))
print(f"duality check: max |Pr[G] + Pr[complement G] - 1| = {dev:.3f} (exact value 0; this measures sampling error)")
print(f"ladder rungs on {nmeta} of the samples: " + ", ".join(f"{k} {rung[k]} ({100*rung[k]/max(nmeta,1):.1f}%)" for k in ("OR","VTOR","BI","SGR","NTR","GR","OCR")))
def gmask(edges): return sum(1 << E.index(tuple(sorted(e))) for e in edges)
named = {"K_{3,3}": gmask([(a, b) for a in range(3) for b in range(3, 6)]),
         "K_{2,4}": gmask([(a, b) for a in range(2) for b in range(2, 6)]),
         "K_{1,5}": gmask([(0, b) for b in range(1, 6)]),
         "2K_3":    gmask([(0,1),(1,2),(0,2),(3,4),(4,5),(3,5)]),
         "C_6":     gmask([(i, (i+1) % 6) for i in range(6)])}
if n == 6:
    for name, mk in named.items():
        c = int(cls[mk]); print(f"  {name}: {int(ecount[c])} edges, Pr[in P] = {freq[c]/samples:.3f}")
