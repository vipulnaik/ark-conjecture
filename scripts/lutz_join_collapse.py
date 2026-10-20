"""lutz_join_collapse.py -- A43(4).  Usage: python3 lutz_join_collapse.py SEEDS.  Result 2026-10-20: 3 seeds stuck at 214k-217k of 868k faces (inconclusive).
   Random greedy collapse of K = A * A' (Lutz's 60-vertex contractible complex): faces are pairs (s, t) of faces of A
(including the empty face), minus (empty, empty).  Success = collapsed to a single vertex => K collapsible."""
import itertools, random, sys
src = open(__import__("os").path.join(__import__("os").path.dirname(__import__("os").path.abspath(__file__)), "lutz30.py")).read()
L = eval(src[src.index("L=[[1"):].split("\nL=")[0][2:])
fa = {()}
for f in L:
    for k in range(1, len(f) + 1): fa.update(itertools.combinations(sorted(f), k))
fa = sorted(fa, key=lambda x: (len(x), x)); idx = {f: i for i, f in enumerate(fa)}
bnd = [[idx[tuple(x for x in f if x != v)] for v in f] for f in fa]       # facets of each face of A
cob = [[] for _ in fa]
for i, b in enumerate(bnd):
    for j in b: cob[j].append(i)
M = len(fa)
def run(seed):
    rng = random.Random(seed)
    alive = bytearray(M * M); alive[:] = b"\x01" * (M * M); alive[0] = 0     # (empty, empty) is not a face
    cnt = [0] * (M * M)          # number of alive cofaces of codim 1
    for s in range(M):
        for t in range(M):
            if s == 0 and t == 0: continue
            cnt[s * M + t] = len(cob[s]) + len(cob[t])
    free = [k for k in range(1, M * M) if cnt[k] == 1]
    nalive = M * M - 1
    while free:
        j = rng.randrange(len(free)); k = free[j]; free[j] = free[-1]; free.pop()
        if not alive[k] or cnt[k] != 1: continue
        s, t = divmod(k, M)
        co = next(c for c in ([c * M + t for c in cob[s]] + [s * M + c for c in cob[t]]) if alive[c])
        for x in (co, k):
            alive[x] = 0; nalive -= 1
            a, b = divmod(x, M)
            for y in [f * M + b for f in bnd[a]] + [a * M + f for f in bnd[b]]:
                if y and alive[y]:
                    cnt[y] -= 1
                    if cnt[y] == 1: free.append(y)
    return nalive
for seed in range(int(sys.argv[1])):
    r = run(seed); print("seed", seed, "residue", r, flush=True)
    if r == 1: print("K COLLAPSIBLE"); break
