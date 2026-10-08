# propb_global_chi.py -- exact chi of the complex of 2-colourable 3-graphs (property B) on n vertices.  n = 5, 6, 7 give 2, -9, 273 (n = 7: ~1 min, 11.6M states); n = 8 is out of reach this way.
# USAGE  python3 propb_global_chi.py 5 6 7
# chi of the complex of 2-colourable 3-graphs on n vertices.
# DP over triples; state = set of nontrivial bipartitions still proper for the triples included so far.
# S = sum over 2-colourable Y of (-1)^|Y|  (including Y = empty); chi = 1 - S.  Non-evasive => chi = 1.
import itertools, sys, time
def run(n):
    T = list(itertools.combinations(range(n), 3))
    parts = []                                   # nontrivial bipartitions: subsets A containing vertex 0, A != [n]
    for bits in range(2 ** (n - 1) - 1):
        A = {0} | {i + 1 for i in range(n - 1) if (bits >> i) & 1}
        parts.append(A)
    P = len(parts)
    # mask of partitions under which triple t is bichromatic
    bich = []
    for t in T:
        m = 0
        for j, A in enumerate(parts):
            k = sum(v in A for v in t)
            if 0 < k < 3: m |= 1 << j
        bich.append(m)
    dp = {(1 << P) - 1: 1}
    t0 = time.time()
    for i, m in enumerate(bich):
        new = {}
        for s, w in dp.items():
            new[s] = new.get(s, 0) + w
            s2 = s & m
            if s2:
                new[s2] = new.get(s2, 0) - w
        dp = {s: w for s, w in new.items() if w}
        print(f"  n={n} triple {i+1}/{len(T)} states {len(dp)} ({time.time()-t0:.0f}s)", file=sys.stderr, flush=True)
    S = sum(dp.values())
    return 1 - S
for n in map(int, sys.argv[1:]):
    print(f"n={n}: chi = {run(n)}", flush=True)
