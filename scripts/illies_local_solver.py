# illies_local_solver.py -- exact non-evasiveness of the a x b cycle-grid family using locality (see header comment).
# USAGE  python3 illies_local_solver.py a b [seconds].  3x4 NON-EVASIVE; 5x6 EVASIVE at once (the link fails).
# Exact non-evasiveness for the a x b torus family F = {} u {S inside one row or column, connected there},
# rows = cycles C_b, columns = cycles C_a.  Uses locality:
#  * once a 1 has been found, only the line(s) through the 1s matter, and every other unqueried point is an
#    interchangeable "kill switch" (a 1 there forces NO); so the state is (local pattern, #kill switches);
#  * while all answers are 0 the tree follows one path, so the all-zero phase is a search over query orders.
# NE(state) := f is constant on the subcube with >= 1 point unqueried, or some query has both children NE.
import sys, itertools, time
from functools import lru_cache
sys.setrecursionlimit(100000)
a, b = int(sys.argv[1]), int(sys.argv[2]); LIMIT = float(sys.argv[3]) if len(sys.argv) > 3 else 3600
n = a * b; FULL = (1 << n) - 1
pc = lambda m: bin(m).count('1')
def conn(pts, m):
    pts = sorted(set(pts))
    if len(pts) <= 1 or len(pts) == m: return True
    gaps = [((pts[(i + 1) % len(pts)] - pts[i]) % m) for i in range(len(pts))]
    return sum(1 for g in gaps if g > 1) <= 1

# ---- local states ----
# ('P', rowpat, colpat, k): one 1 at the pivot; rowpat[j-1] = status of row position j (1..b-1), colpat likewise (1..a-1)
# ('L', m, pat, k): >= 2 ones on one line of length m; pat over positions 0..m-1
def canonP(rp, cp, k):
    return ('P', min(rp, rp[::-1]), min(cp, cp[::-1]), k)
def canonL(m, pat, k):
    best = min(tuple(pat[(s * i + t) % m] for i in range(m)) for t in range(m) for s in (1, -1))
    return ('L', m, best, k)
def completions_values(st):
    vals = set()
    if st[0] == 'P':
        _, rp, cp, k = st
        U = [('r', j + 1) for j, s in enumerate(rp) if s == 'u'] + [('c', j + 1) for j, s in enumerate(cp) if s == 'u']
        for bits in range(1 << len(U)):
            W = [U[i] for i in range(len(U)) if bits >> i & 1]
            wr = [p for l, p in W if l == 'r']; wc = [p for l, p in W if l == 'c']
            if wr and wc: v = False
            elif wr: v = conn([0] + wr, b)
            elif wc: v = conn([0] + wc, a)
            else: v = True
            vals.add(v)
            if len(vals) == 2: break
        return vals, len(U)
    _, m, pat, k = st
    U = [j for j, s in enumerate(pat) if s == 'u']; O = [j for j, s in enumerate(pat) if s == 'o']
    for bits in range(1 << len(U)):
        vals.add(conn(O + [U[i] for i in range(len(U)) if bits >> i & 1], m))
        if len(vals) == 2: break
    return vals, len(U)
@lru_cache(maxsize=None)
def NE(st):
    vals, ul = completions_values(st)
    k = st[-1]; u = ul + k
    if vals == {False} or (vals == {True} and k == 0): return u >= 1
    if u <= 1: return False
    if k >= 1 and NE(st[:-1] + (k - 1,)): return True          # query a kill switch: 1 -> NO with u-1 >= 1 left
    if st[0] == 'P':
        _, rp, cp, k = st
        for j, s in enumerate(rp):
            if s != 'u': continue
            z = canonP(rp[:j] + ('z',) + rp[j+1:], cp, k)
            o_pat = ('o',) + rp[:j] + ('o',) + rp[j+1:]          # row line, pivot at position 0
            o = canonL(b, o_pat, k + sum(1 for t in cp if t == 'u'))
            if NE(z) and NE(o): return True
        for j, s in enumerate(cp):
            if s != 'u': continue
            z = canonP(rp, cp[:j] + ('z',) + cp[j+1:], k)
            o_pat = ('o',) + cp[:j] + ('o',) + cp[j+1:]
            o = canonL(a, o_pat, k + sum(1 for t in rp if t == 'u'))
            if NE(z) and NE(o): return True
        return False
    _, m, pat, k = st
    for j, s in enumerate(pat):
        if s != 'u': continue
        if NE(canonL(m, pat[:j] + ('z',) + pat[j+1:], k)) and NE(canonL(m, pat[:j] + ('o',) + pat[j+1:], k)): return True
    return False

# ---- zero phase ----
def one_branch(x, Z):
    r, c = x // b, x % b
    rp = tuple('z' if Z >> (r * b + (c + j) % b) & 1 else 'u' for j in range(1, b))
    cp = tuple('z' if Z >> (((r + j) % a) * b + c) & 1 else 'u' for j in range(1, a))
    lines = sum(1 << (r * b + cc) for cc in range(b)) | sum(1 << (rr * b + c) for rr in range(a))
    return NE(canonP(rp, cp, pc(FULL & ~lines & ~Z)))
def inF(pts):
    if not pts: return True
    rows = {p // b for p in pts}; cols = {p % b for p in pts}
    if len(rows) == 1: return conn([p % b for p in pts], b)
    if len(cols) == 1: return conn([p // b for p in pts], a)
    return False
def zero_const(Z):
    pts = [i for i in range(n) if not Z >> i & 1]
    if len(pts) > 6: return False
    return all(inF(list(S)) for kk in range(len(pts) + 1) for S in itertools.combinations(pts, kk))
def dih(m): return [lambda x, s=s, t=t: (s * x + t) % m for t in range(m) for s in (1, -1)]
perms = [[f(i // b) * b + g(i % b) for i in range(n)] for f in dih(a) for g in dih(b)]
def canon(Z): return min(sum(1 << p[i] for i in range(n) if Z >> i & 1) for p in perms)
memo = {}; t0 = time.time(); last = [t0]
def NE_zero(Z):
    key = canon(Z)
    if key in memo: return memo[key]
    if time.time() - t0 > LIMIT: raise TimeoutError
    if time.time() - last[0] > 60:
        print(f"  {time.time()-t0:.0f}s zero-states={len(memo)} |Z|={pc(Z)} local={NE.cache_info().currsize}", flush=True); last[0] = time.time()
    u = n - pc(Z)
    if zero_const(Z): res = u >= 1
    elif u <= 1: res = False
    else:
        res = False; tried = set()
        for x in range(n):
            if Z >> x & 1: continue
            kz = canon(Z | 1 << x)
            if kz in tried: continue
            tried.add(kz)
            if one_branch(x, Z) and NE_zero(Z | 1 << x): res = True; break
    memo[key] = res
    return res
if __name__ == '__main__':
    print(f"{a}x{b} (cycles): n = {n}", flush=True)
    try:
        r = NE_zero(0)
        print("NON-EVASIVE" if r else "EVASIVE", f"  zero-states {len(memo)}, local states {NE.cache_info().currsize}, {time.time()-t0:.0f}s")
    except TimeoutError:
        print("undecided", len(memo))
