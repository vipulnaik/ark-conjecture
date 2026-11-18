#!/usr/bin/env python3
"""mu_cyc_bounds.py -- two-sided bounds for mu*_cyc(n) over the framework's shape
space (`threshold-beyond-mu.md`, "Cost of computing each quantity", and Part 8 of
`session-log-17.md`).

mu*_cyc(n): the largest, over Oliver groups on [n], of the smallest orbital, or of
M = min(C(r,2), least orbital outside R's pairs) for ONE orbit R of prime size r
whose k = C(r,2)/orb(r,t) cyclotomic classes form a GOOD type for the top prime:
no C_k-invariant proper complex has chi = 1 (mod q), or chi = 1 if the top is
trivial (`threshold-beyond-mu.md` §4).

THE SHAPE SPACE.  Every Oliver group meeting the density floor lies in the
framework's shape space (enumeration-proof.md Part 0): one matching class F*c
(two classes of the same prime merge into a dominating one, ladder-completeness
Prop. 1's merge step, which uses only matching-class scores) and foreign primes
sharing one top prime q.  A part whose own pairs are worth less than the running
best cannot be in a winner, so with best >= 0.0887*C(n,2) (true at every
n <= 10^6) a winner has at most three parts.  Enumerated here:
    A   F*c                      (one fused class)
    B   F*c + r                  (r foreign; F = 1 includes c prime)
    C   r1 + r2                  (common q)
    D   F*c + r1 + r2            (common q)
    E   r1 + r2 + r3             (common q)
Matching classes are credited flat F*C(c,2) (their cap, whatever twist the chain
allows) -- so the reading "R = a prime matching block with a partial twist" is
subsumed: rescoring it gives C(c,2), which the flat credit already gives.

GOODNESS.  status(k, q) in {GOOD, BAD, UNKNOWN}:
  k = 1                                    GOOD
  k <= 7                                   exact (cyclic_chi_values.py value sets)
  q = None (trivial top, chi = 1 exactly):
      k a prime power                      GOOD  (every proper invariant complex
                                                  has chi = 0 mod the prime)
      k <= 13                              GOOD except k = 12 (BAD)
      otherwise                            UNKNOWN
  q prime:
      q | C(k-1, s) for some 1 <= s <= k-2 BAD   (the s-skeleton has
                                                  chi = 1 - (-1)^s C(k-1, s))
      k in 8..11, 13 and q > 2^k           GOOD  (chi = 1 unattainable, |chi-1| < 2^k)
      otherwise                            UNKNOWN

THE TWO BOUNDS.
  L'(n)  lower: only GOOD types rescored; a configuration counts only if its
         chain is realisable by the scan's rules (gcd(F(c-1), r) = 1 for every
         foreign r, foreign twists q-powers of their r - 1).  max with the old L.
  B^(n)  upper: GOOD or UNKNOWN rescored; no gcd condition (matching classes at
         their flat cap, every foreign twist at its best q-power).
If L'(n) = B^(n), mu*_cyc(n) = L'(n), relative to the classification only.

Usage: python3 mu_cyc_bounds.py N [out.csv]     (run from scripts/)
"""
import sys, csv
from math import comb, gcd
from collections import defaultdict
from sympy import factorint, primerange

GOOD, BAD, UNK = 2, 0, 1
VALS = {2: {0, 2}, 3: {0, 3}, 4: {-2, 0, 2, 4}, 5: {-5, 0, 5},
        6: {-9, -7, -6, -4, -3, -1, 0, 2, 3, 5, 6, 8, 9, 11}, 7: {-14, -7, 0, 7, 14, 21}}
_st = {}


def is_pp(k):
    return k > 1 and len(factorint(k)) == 1


V8 = set(range(-34, 37, 2))
V9 = {-69, -60, -54, -51, -45, -42, -36, -33, -27, -24, -18, -15, -9, -6, 0, 3, 9, 12, 18, 21, 27,
      30, 36, 39, 45, 48, 54, 57}
VALS[8], VALS[9] = V8, V9            # exact, by exhaustive enumeration (session-log-17 Part 9)
VALS[1] = {0}                        # one point: the empty complex only
ATT1 = {12, 30, 56, 63, 99, 105, 153, 176, 198, 200, 209, 230, 231, 261, 306, 315, 410, 414, 429, 440, 470, 473, 495, 530, 561, 590, 638, 774, 803, 1190, 1199, 1265, 1463, 1925}
# chi = 1 attained on k points: 12 by cyclic_chi_values.py, 30 by cyclic_chi_small.py, the rest by cyclic_chi_product.py


try:                                 # certificates of cyclic_chi_recursive.py
    for _l in open(__import__('os').path.join(__import__('os').path.dirname(__import__('os').path.abspath(__file__)),
                                              '..', 'outputs', 'cyclic_chi_certified.txt')):
        if _l.strip() and not _l.startswith('#'):
            ATT1.add(int(_l.split()[0]))
except OSError:
    pass


MODQ = {}                            # decided (k, q) pairs, outputs/cyclic_chi_modq.txt
try:
    for _l in open(__import__('os').path.join(__import__('os').path.dirname(__import__('os').path.abspath(__file__)),
                                              '..', 'outputs', 'cyclic_chi_modq.txt')):
        if _l.strip() and not _l.startswith('#'):
            _k, _q, _v = _l.split()[:3]
            MODQ[(int(_k), int(_q))] = _v
except OSError:
    pass


def _divs(k):
    return [d for d in range(1, k + 1) if k % d == 0]


def status(k, q):
    """GOOD / BAD / UNKNOWN for the cyclic type on k classes under top prime q.

    Three facts are used, each proved in session-log-17 Part 9:
      (pull-back)  a value attained on m points is attained on every multiple k
                   of m (inflate each point to its fibre; dominated vertices
                   collapse strongly, so chi is unchanged and properness kept);
      (reduction)  for a prime p | k with Sylow subgroup S of C_k and
                   k' = k / p^v_p(k): chi(X) = chi(Y) mod p for p odd, Y the
                   complex of S-coset unions viewed on k' points; for p = 2,
                   chi(X) = -#faces(Y) mod 2;
      (skeleta)    the s-skeleton of the simplex on k points is invariant and
                   proper for s <= k - 2, with chi = 1 - (-1)^s C(k-1, s).
    """
    key = (k, q)
    if key in _st:
        return _st[key]
    s = None
    if q is not None and (k, q) in MODQ:
        s = GOOD if MODQ[(k, q)] == 'GOOD' else BAD
    elif q == 2 and k > 1 and k & (k - 1) == 0:
        s = GOOD                       # every proper invariant face set has even orbits: chi even
    if s is not None:
        pass
    elif k == 1:
        s = GOOD
    elif q is None and is_pp(k):
        s = GOOD
    elif k in VALS:
        tgt = (lambda v: v == 1) if q is None else (lambda v: (v - 1) % q == 0)
        s = BAD if any(tgt(v) for v in VALS[k]) else GOOD
    if s is None:
        # BAD by pull-back from a divisor with a known value set
        for m in _divs(k):
            if m <= k and ((m in VALS and any((v == 1) if q is None else ((v - 1) % q == 0) for v in VALS[m]))
                          or (q is None and m in ATT1) or (q is not None and m in ATT1)):
                s = BAD; break
    if s is None and q is not None:
        b = 1
        for j in range(1, k - 1):            # skeleta
            b = b * (k - j) // j
            if b % q == 0:
                s = BAD; break
    if s is None:
        # GOOD by reduction at an odd prime p | k (p = q when the top is nontrivial)
        f = factorint(k)
        ps = [p for p in f if p != 2] if q is None else ([q] if q in f and q != 2 else [])
        for p in ps:
            kp = k // p ** f[p]
            if kp in VALS and not any((v - 1) % p == 0 for v in VALS[kp]):
                s = GOOD; break
    if s is None and q is not None and k in (10, 11, 13) and q > 2 ** k:
        s = GOOD
    if s is None:
        s = UNK
    _st[key] = s
    return s


def orb(r, t):
    return min(r * t if t % 2 else r * t // 2, comb(r, 2))


def coeff(F):
    return F if F % 2 else F // 2


def main():
    N = int(sys.argv[1]); OUT = sys.argv[2] if len(sys.argv) > 2 else None
    T = {int(r['n']): int(r['mu_bound']) for r in csv.DictReader(open('../outputs/mu_table_ladder.csv'))
         if int(r['n']) <= N}
    Lold = {}
    try:
        for r in csv.DictReader(open('../outputs/threshold_scan_4000.csv')):
            if int(r['n']) <= N:
                Lold[int(r['n'])] = int(r['cyc_lower'])
    except OSError:
        pass
    primes = list(primerange(3, N + 1)); P = set(primes)
    pp = {}
    for p in primerange(2, N + 1):
        x = p
        while x <= N:
            pp[x] = p; x *= p
    # per foreign prime r and top q (None = trivial top): plain credit, and the
    # rescored credit under the lower and upper rules
    cred = {}          # r -> {q: (plain, low, up)}
    for r in primes:
        d = {}
        o = orb(r, 1); k = comb(r, 2) // o
        st = status(k, None)
        d[None] = (o, comb(r, 2) if st == GOOD else o, comb(r, 2) if st != BAD else o)
        for q, e in factorint(r - 1).items():
            plain = orb(r, q ** e); lo = up = plain
            for j in range(1, e + 1):
                o = orb(r, q ** j); k = comb(r, 2) // o
                s = status(k, q)
                if s == GOOD:
                    lo = max(lo, comb(r, 2))
                if s != BAD:
                    up = max(up, comb(r, 2))
            d[q] = (plain, lo, up)
        cred[r] = d
    byq = defaultdict(list)                      # q -> primes r with q | r - 1
    for r in primes:
        for q in cred[r]:
            if q is not None:
                byq[q].append(r)
    res = {}
    for n in sorted(T):
        base = max(T[n], Lold.get(n, 0))
        low, up, wl, wu = base, base, None, None

        def upd(v_lo, v_up, w):
            nonlocal low, up, wl, wu
            if v_lo is not None and v_lo > low:
                low, wl = v_lo, w
            if v_up > up:
                up, wu = v_up, w
        # A
        for F in range(2, n + 1):
            if n % F == 0 and (n // F) in pp:
                c = n // F; v = min(F * comb(c, 2), coeff(F) * c * c); upd(v, v, ('A', F, c))
        # B: F*c + r
        for r in primes:
            if r >= n - 1:
                break
            if comb(r, 2) <= low and comb(r, 2) <= up:
                continue
            m = n - r
            for F in range(1, m // 2 + 1):
                if m % F:
                    continue
                c = m // F
                if c not in pp or pp[c] == r:
                    continue
                base_terms = [F * comb(c, 2), F * c * r] + ([coeff(F) * c * c] if F > 1 else [])
                bt = min(base_terms)
                if bt <= low and bt <= up:
                    continue
                ok = gcd(F * (c - 1), r) == 1
                for q, (plain, lo, upc) in cred[r].items():
                    vlo = min(bt, max(plain, lo)) if ok else None
                    upd(vlo, min(bt, max(plain, upc)), ('B', F, c, r, q))
            # F = m (c = 1) is not a shape
        # C, D, E: two or three foreign primes at a common q, exactly one
        # rescored.  Every non-rescored foreign part keeps its plain credit, which
        # must clear `base` to matter -- so those come from short efficient lists.
        for q, lst in byq.items():
            eff = [r for r in lst if r < n and cred[r][q][0] > base]
            if not eff:
                continue
            Q = [r for r in lst if r < n]
            for rp in eff:                               # the plain one
                pp_, _, _ = cred[rp][q]
                for rr in Q:                             # the rescored one
                    if rr == rp or rp + rr > n:
                        continue
                    _, lr, ur = cred[rr][q]
                    cr = rp * rr
                    lo2, up2 = min(lr, pp_), min(ur, pp_)
                    if min(cr, up2) <= base:
                        continue
                    rest = n - rp - rr
                    if rest == 0:
                        upd(min(cr, lo2), min(cr, up2), ('C', rr, rp, q)); continue
                    for F in range(1, rest // 2 + 1):    # D: rest = F*c
                        if rest % F:
                            continue
                        c = rest // F
                        if c not in pp or pp[c] in (rp, rr):
                            continue
                        terms = [F * comb(c, 2), F * c * rp, F * c * rr, cr] + ([coeff(F) * c * c] if F > 1 else [])
                        bt = min(terms)
                        ok = gcd(F * (c - 1), rp * rr) == 1
                        upd(min(bt, lo2) if ok else None, min(bt, up2), ('D', F, c, rr, rp, q))
                    # E: rest = a second plain foreign prime
                    if rest > rp and rest in P and rest != rr and q in cred[rest] and cred[rest][q][0] > base:
                        p3 = cred[rest][q][0]
                        x = min(rp * rest, rr * rest, cr)
                        upd(min(x, lo2, p3), min(x, up2, p3), ('E', rr, rp, rest, q))
        res[n] = (T[n], Lold.get(n), low, up, wl, wu)
    eq = sum(1 for v in res.values() if v[2] == v[3])
    rise = sum(1 for v in res.values() if v[1] is not None and v[2] > v[1])
    print(f"n <= {N}: {len(res)} rows; L' = B^ (mu*_cyc exact, relative to the classification) at {eq}; "
          f"L' above the old L at {rise}")
    gap = [(n,) + v[:4] for n, v in res.items() if v[2] < v[3]]
    print("first rows with L' < B^ (n, mu*, L_old, L', B^):", gap[:12])
    fl = min((v[2] / comb(n, 2), n) for n, v in res.items()); fu = min((v[3] / comb(n, 2), n) for n, v in res.items())
    print(f"floor of L'/C(n,2): {fl[0]:.5f} at {fl[1]};  floor of B^/C(n,2): {fu[0]:.5f} at {fu[1]}")
    if OUT:
        with open(OUT, 'w') as fh:
            fh.write("n,mu,L_old,L_new,B_up,wit_low,wit_up\n")
            for n, v in sorted(res.items()):
                fh.write(f"{n},{v[0]},{v[1] if v[1] is not None else ''},{v[2]},{v[3]},\"{v[4]}\",\"{v[5]}\"\n")


if __name__ == "__main__":
    main()
