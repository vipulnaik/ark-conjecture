"""Enumerate EVERY fallback configuration at each n <= N (a p-class (F,c) with
c a prime power, a foreign prime r | c-1, top prime q | r-1 (or trivial
twist), leftover L = n - F*c - r made of 0, 1 or 2 admissible parts) and record
the maximum SAFE score.  Compare with C(n,2)/25 and with the bare pair."""
import sys
from math import comb
sys.path.insert(0, '/home/claude')
import fb_common as fb
N = int(sys.argv[1]) if len(sys.argv) > 1 else 3000
A = fb.Arith(N + 2)
PP = [c for c in range(3, N) if A.prime_power(c)]
PR = [r for r in range(3, N) if A.is_prime(r)]
def fcap(r, q):      # foreign block value at top prime q ('*' = trivial twist)
    return r if q == '*' else fb.orb(r, fb.qpart(r - 1, q))
def leftover_best(L, p, q, r, c, Fc, cur):
    """max over leftover readings (0,1,2 parts) of min(intra, cross terms); returns
    the best min-term contribution, or None if L cannot be composed."""
    if L == 0:
        return cur
    best = None
    # one part
    cands = []
    for F2 in range(1, L + 1):
        if L % F2: continue
        c2 = L // F2; pp = A.prime_power(c2)
        if not pp: continue
        if pp[0] == p:
            cands.append(('p', F2, c2, F2 * comb(c2, 2)))
        elif pp[1] == 1 and F2 == 1 and c2 != r:
            cands.append(('f', 1, c2, fcap(c2, q)))
    for kind, F2, c2, intra in cands:
        v = min(cur, intra, F2 * c2 * r, F2 * c2 * Fc)
        best = v if best is None else max(best, v)
    # two parts (foreign+foreign, foreign+p, p+p), sizes s1 <= s2
    lo = fb.intra_floor(int(cur * 0.97))
    for s1 in range(max(3, lo), L // 2 + 1):
        s2 = L - s1
        if s2 < lo: break
        opts1, opts2 = [], []
        for s, opts in ((s1, opts1), (s2, opts2)):
            pp = A.prime_power(s)
            if pp and pp[1] == 1 and s != r:
                opts.append(('f', 1, s, fcap(s, q)))
            for F2 in range(1, s + 1):
                if s % F2: continue
                pq = A.prime_power(s // F2)
                if pq and pq[0] == p:
                    opts.append(('p', F2, s // F2, F2 * comb(s // F2, 2)))
        for k1, F1, c1, i1 in opts1:
            for k2, F2, c2, i2 in opts2:
                if k1 == 'f' and k2 == 'f' and c1 == c2: continue
                v = min(cur, i1, i2, s1 * s2, s1 * r, s2 * r, s1 * Fc, s2 * Fc)
                best = v if best is None else max(best, v)
    return best
out = {}
for c in PP:
    p, a = A.prime_power(c)
    for r in A.prime_divisors(c - 1):
        if r == p: continue
        s = (c - 1) // r
        qopts = list(set(A.prime_divisors(r - 1))) + ['*']
        for q in qopts:
            fr = fcap(r, q)
            for F in range(1, (N - r) // c + 1):
                base = min(F * comb(c, 2), (F if F % 2 else F // 2) * c * c if F > 1 else 10**18,
                           fr, F * c * r)
                for L in range(0, N - F * c - r + 1):
                    n = F * c + r + L
                    if base * 25 < comb(n, 2) * 0.97:      # cannot reach the threshold (keep near-misses)
                        break
                    v = leftover_best(L, p, q, r, c, F * c, base)
                    if v is None: continue
                    bare = (F == 1 and L == 0 and s == 2 and a == 1)
                    key = (n, bare)
                    tag = (v, c, r, F, L, q, s, a)
                    if key not in out or v > out[key][0]:
                        out[key] = tag
viol = []
for (n, bare), t in sorted(out.items()):
    if bare: continue
    if t[0] * 25 >= comb(n, 2):
        viol.append((n,) + t)
print(f"non-bare fallback configurations with SAFE >= C(n,2)/25, n <= {N}:")
for v in viol: print("  n=%d SAFE=%d c=%d r=%d F=%d L=%d q=%s s=%d a=%d" % v)
print("count:", len(viol), " largest n:", max(v[0] for v in viol) if viol else None)
# and the near-misses: best ratio SAFE/(C(n,2)/25) among non-bare, a = 1, s = 2
nm = sorted(((25*t[0]/comb(n,2), n) + t for (n,b),t in out.items() if not b and t[7]==1 and t[6]==2), reverse=True)[:8]
print("closest a=1,s=2 non-bare approaches to 1/25 (ratio, n, SAFE, c, r, F, L, q, s, a):")
for x in nm: print("  %.5f" % x[0], x[1:])
