#!/usr/bin/env python3
"""cyc_density_one.py -- checks for the density-one statement on mu*_cyc
(threshold-beyond-mu.md §4, "Density one").

  delta_cyc(n) = 1/4 at even n,  3 - 2 sqrt 2 at odd n.

(1) --upper N : the exceptional set E of Proposition U, counted to N, and the
    Proposition tested against outputs/mu_cyc_bounds_4000.csv (where mu*_cyc is
    exact relative to the classification): every n <= 4000 outside E must have
    mu*_cyc(n) < delta_cyc(n) C(n,2).
(2) --local : the Local Lemma of bcp-to-floor.md section 3 at the cyc cells
    (k, d) = (1,2), (1,6), (2,2), (2,4), (2,6), (2,12): k p + d Q + 1 = n (mod m)
    solvable with p, Q, dQ+1 in admissible unit classes, for m in 16, 9, 5, 7
    and every residue n in the cell's classes.
(3) --lower X W : for n in (X, X+W], the best Reduction-Lemma representation
    n = k p + r, r = dQ + 1 (p, Q, r prime, gcd(k(p-1), r) = 1, Q not in {2,5,7}),
    scored for mu*_cyc as min{k C(p,2), p^2 [k=2], k p r, C(r,2)}, divided by
    delta_cyc(n) C(n,2).  Reports the worst ratio and how many n fall below
    1 - eps.

usage: python3 cyc_density_one.py --upper 1000000 | --local | --lower 1000000 20000
"""
import sys, math, csv, os
from math import comb, gcd

D_EVEN, D_ODD = 0.25, 3 - 2 * math.sqrt(2)
CELL = {0: (1, 2), 4: (1, 2), 6: (1, 2), 10: (1, 2), 2: (1, 6), 8: (1, 6),
        1: (2, 2), 9: (2, 2), 3: (2, 4), 7: (2, 4), 5: (2, 6), 11: (2, 12)}


def sieve(N):
    s = bytearray([1]) * (N + 1); s[0] = s[1] = 0
    for i in range(2, int(N ** .5) + 1):
        if s[i]:
            s[i * i::i] = bytearray(len(s[i * i::i]))
    return s


def ppow_table(N, P):
    """largest prime-power divisor q(n), and is-prime-power, for n <= N"""
    q = [1] * (N + 1); pp = bytearray(N + 1)
    for p in range(2, N + 1):
        if P[p]:
            pk = p
            while pk <= N:
                pp[pk] = 1
                for m in range(pk, N + 1, pk):
                    # pk exactly divides m iff m/pk not divisible by p
                    if (m // pk) % p and pk > q[m]:
                        q[m] = pk
                pk *= p
    return q, pp


def exceptional(n, q, pp):
    """membership in E (Proposition U); n composite, not a prime power"""
    d0 = D_EVEN if n % 2 == 0 else D_ODD
    if (q[n] - 1) / (n - 1) >= d0:                   # transitive groups (oen 7.2 fact 8)
        return 'transitive'
    if n % 2:
        cn = comb(n, 2); j = 1
        while 2 ** j < n:
            a = 2 ** j; b = n - a
            if b >= 2 and pp[b] and comb(a, 2) > d0 * cn and comb(b, 2) > d0 * cn:
                return 'two orbits 2^j + prime power'
            j += 1
    return None


def upper(N):
    P = sieve(N); q, pp = ppow_table(N, P)
    blocks = [10 ** e for e in range(3, 8) if 10 ** e <= N] + ([N] if N not in [10 ** e for e in range(3, 8)] else [])
    cnt = {'transitive': 0, 'two orbits 2^j + prime power': 0}; tot = 0; bi = 0
    print("N, domain size, |E|, |E| / domain, |E| log N / N")
    for n in range(6, N + 1):
        if pp[n]:
            continue
        tot += 1
        e = exceptional(n, q, pp)
        if e:
            cnt[e] += 1
        if n == blocks[bi]:
            E = sum(cnt.values())
            print(f"{n}, {tot}, {E} ({cnt['transitive']} transitive, {cnt['two orbits 2^j + prime power']} two-orbit), "
                  f"{E / tot:.4f}, {E * math.log(n) / n:.3f}")
            bi += 1
            if bi == len(blocks):
                break
    # against the exact table
    f = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'outputs', 'mu_cyc_bounds_4000.csv')
    bad = []; inE = 0; at = 0
    for row in csv.DictReader(open(f)):
        n = int(row['n']); mu = int(row['L_new']); assert mu == int(row['B_up'])
        d0 = D_EVEN if n % 2 == 0 else D_ODD
        hi = mu >= d0 * comb(n, 2)
        if exceptional(n, q, pp):
            inE += 1; at += hi
        elif hi:
            bad.append(n)
    print(f"table to 4000: {inE} rows in E, {at} of them at or above delta_cyc; "
          f"rows outside E at or above delta_cyc: {bad if bad else 'none'}")


def local():
    """bcp-to-floor's Local Lemma at the cyc cells"""
    ok = True
    for cls, (k, d) in sorted(CELL.items()):
        for m in (16, 9, 5, 7, 11, 13):
            for n in range(m):
                # n mod m must be compatible with n mod 12 for the 2- and 3-parts
                if m == 16 and n % 4 != cls % 4: continue
                if m == 9 and n % 3 != cls % 3: continue
                sol = False
                for p in range(m):
                    if gcd(p, m) != 1: continue
                    for Q in range(m):
                        if gcd(Q, m) != 1: continue
                        r = (d * Q + 1) % m
                        if gcd(r, m) != 1: continue
                        if (k * p + r - n) % m == 0:
                            sol = True; break
                    if sol: break
                if not sol:
                    ok = False; print(f"class {cls} (k,d)=({k},{d}): no solution mod {m} at n = {n}")
    print("local lemma at the cyc cells:", "solvable at every class and modulus checked" if ok else "FAILS")


def lower(X, W, eps=0.05):
    N = X + W
    P = sieve(N)
    worst = (9, None); below = 0; hist = {}
    for n in range(X + 1, N + 1):
        k, d = CELL[n % 12]
        d0 = D_EVEN if n % 2 == 0 else D_ODD
        cn = comb(n, 2); best = 0
        # r = dQ + 1 over the band where it can matter: C(r,2) >= best
        # only r within 0.15 n of the balance share 1/(1 + sqrt k) can come near delta_cyc
        a0 = 1 / (1 + math.sqrt(k))
        for Q in range(max(3, int((a0 - .15) * n / d)), int((a0 + .15) * n / d) + 1):
            r = d * Q + 1
            if r >= n: break
            if not (P[Q] and P[r]) or Q in (5, 7):
                continue
            if (n - r) % k: continue
            p = (n - r) // k
            if p < 3 or not P[p] or p == r or gcd(k * (p - 1), r) != 1:
                continue
            v = min(k * comb(p, 2), p * p if k == 2 else 10 ** 30, k * p * r, comb(r, 2))
            best = max(best, v)
        ratio = best / (d0 * cn)
        if ratio < worst[0]:
            worst = (ratio, n)
        if ratio < 1 - eps:
            below += 1
        b = round(ratio, 2); hist[b] = hist.get(b, 0) + 1
    print(f"n in ({X}, {N}]: worst best/delta_cyc = {worst[0]:.4f} at n = {worst[1]}; "
          f"{below} n below {1 - eps}")


if __name__ == '__main__':
    a = sys.argv[1:]
    if '--upper' in a: upper(int(a[a.index('--upper') + 1]))
    if '--local' in a: local()
    if '--lower' in a:
        i = a.index('--lower'); lower(int(a[i + 1]), int(a[i + 2]))
