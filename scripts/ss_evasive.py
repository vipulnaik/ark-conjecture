"""ss_evasive.py -- A42(3): the conjecture "secret-shuffler evasive <=> certificate-evasive" at n = 5 (oen section 7.11).

Same search as ss_evasive_n4.py (imported definitions re-stated for general n), with two changes that make n = 5 feasible:
  * monotone properties are enumerated as down-sets of the 34 isomorphism classes by recursion, not by 2^K masks;
  * the two certificate-evasive properties ({empty}, not-K_n) are evasive by the certificate argument (oen 7.11), so they
    are only re-confirmed at n = 4; at n = 5 the search looks for a WITNESS tree for every other property, and the
    conjecture's n = 5 case is exactly "every one is found".
Control: --check4 reproduces the n = 4 result (22 properties, exactly the two trivial ones evasive).
Result at n = 5 (2026-10-19): 860 nontrivial monotone properties; all 858 non-trivial ones are secret-shuffler non-evasive --
613 by the exact search (2 shards, --budget 600) and the remaining 245 by --heuristic, which is sound for non-evasiveness
(any tree it finds is a real tree).  The exact search is too slow on the last ~25%: a few properties take > 10 min each.
Usage: python3 ss_evasive.py [--n 5] [--check4] [--budget S] [--shard i/k] [--skip FILE] [--heuristic]
  e.g. python3 ss_evasive.py --n 5 --budget 600 --shard 0/2, then the leftovers with --heuristic --skip decided.txt"""
import itertools, sys, argparse, time
from functools import lru_cache
sys.setrecursionlimit(100000)
ap = argparse.ArgumentParser(); ap.add_argument("--n", type=int, default=5); ap.add_argument("--check4", action="store_true"); ap.add_argument("--budget", type=int, default=0, help="seconds per property; 0 = none")
ap.add_argument("--shard", default="0/1", help="i/k: search only properties with index = i mod k (for parallel runs)")
ap.add_argument("--skip", default="", help="file of property indices already decided, one per line")
ap.add_argument("--heuristic", action="store_true", help="try only 3 splits of the free classes per query: SOUND for nonevasive (any tree found is a real tree), says nothing when it fails")
args = ap.parse_args()
n = 4 if args.check4 else args.n
E = list(itertools.combinations(range(n), 2)); N = len(E)
pm = [[E.index(tuple(sorted((p[a], p[b])))) for a, b in E] for p in itertools.permutations(range(n))]
def canon(g): return min(sum(1 << q[i] for i in range(N) if g >> i & 1) for q in pm)
cl_of_g = [0] * (1 << N); classes = {}
for g in range(1 << N):
    c = canon(g)
    if c not in classes: classes[c] = len(classes)
    cl_of_g[g] = classes[c]
K = len(classes); crep = {v: k for k, v in classes.items()}
below = [{cl_of_g[crep[k] & ~(1 << i)] for i in range(N) if crep[k] >> i & 1} for k in range(K)]
empty = cl_of_g[0]; full = cl_of_g[(1 << N) - 1]
order = sorted(range(K), key=lambda k: bin(crep[k]).count("1"))
props = []
def rec(i, D):
    if i == K:
        if empty in D and full not in D: props.append(frozenset(D))
        return
    k = order[i]
    rec(i + 1, D)                                   # k not in P
    if below[k] <= D: D.add(k); rec(i + 1, D); D.discard(k)
rec(0, set())
print(f"n = {n}: {K} isomorphism classes, {len(props)} nontrivial monotone properties", flush=True)
masks_by = None
def shuffler_nonevasive(P):
    inP = [cl_of_g[g] in P for g in range(1 << N)]
    @lru_cache(None)
    def cert(q, a): return len({inP[g] for g in range(1 << N) if g & q == a}) == 1
    @lru_cache(None)
    def reps(q, a): return frozenset(cl_of_g[g] for g in range(1 << N) if g & q == a)
    @lru_cache(None)
    def f(q, a, C):
        if not C: return True
        d = bin(q).count("1")
        if cert(q, a): return d < N
        if d >= N - 1: return False
        for i in range(N):
            if q >> i & 1: continue
            q2 = q | 1 << i; r0 = reps(q2, a); r1 = reps(q2, a | 1 << i); Cl = sorted(C)
            if any(c not in r0 and c not in r1 for c in Cl): continue
            f0 = [c for c in Cl if c not in r1]; f1 = [c for c in Cl if c not in r0]; free = [c for c in Cl if c in r0 and c in r1]
            splits = range(1 << len(free)) if not args.heuristic else sorted({0, (1 << len(free)) - 1, sum(1 << j for j in range(0, len(free), 2))})
            for bits in splits:
                C0 = set(f0); C1 = set(f1)
                for j, c in enumerate(free): (C1 if bits >> j & 1 else C0).add(c)
                if f(q2, a, frozenset(C0)) and f(q2, a | 1 << i, frozenset(C1)): return True
        return False
    return f(0, 0, frozenset(range(K)))
trivial = lambda P: P == frozenset([empty]) or len(P) == K - 1
import signal
class Budget(Exception): pass
def _alarm(*a): raise Budget()
signal.signal(signal.SIGALRM, _alarm)
t0 = time.time(); bad = []; done = 0; slow = []
si, sk = map(int, args.shard.split("/"))
skip = set(int(x) for x in open(args.skip)) if args.skip else set()
for idx, P in enumerate(props):
    if trivial(P) and not args.check4: continue
    if idx % sk != si or idx in skip: continue
    signal.alarm(args.budget)
    try:
        ok = shuffler_nonevasive(P)
    except Budget:
        slow.append(sorted(P)); done += 1; print(f"  RESULT {idx} undecided", flush=True); continue
    finally:
        signal.alarm(0)
    done += 1
    print(f"  RESULT {idx} {'nonevasive' if ok else 'EVASIVE'}", flush=True)
    if not ok: bad.append(sorted(P))
    if done % 50 == 0: print(f"  {done} searched, {len(bad)} evasive so far, {time.time()-t0:.0f}s", flush=True)
print(f"searched {done}; secret-shuffler EVASIVE among them: {len(bad)}" + ("" if args.check4 else "  (the two trivial properties excluded, evasive by the certificate argument)"))
for b in bad[:10]: print("  evasive:", b)
print(f"over budget (undecided): {len(slow)}")
for s in slow: print("  undecided:", s, f"({len(s)} classes in P)")
