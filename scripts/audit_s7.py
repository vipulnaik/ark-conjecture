#!/usr/bin/env python3
"""Audit: does ladder_verify.py's unguarded S7 loop (no r | c-1 guard) ever
credit an invalid twist that CHANGES a reported per-n value, for n <= 10^6?

Method: enumerate every S7 candidate (F, c, r) with r | c-1 (the only place
guarded and unguarded scores can differ), compute both scores, and where the
unguarded one is larger, compare it against the guarded achieved(n).  If
v_bad/C <= guarded achieved(n), the invalid credit was never the branch that
set the reported number and the log's figures stand.
"""
import sys, time, bisect
from math import comb

N = 10**6
t = time.time()
sieve = bytearray([1]) * (N + 1)
sieve[0] = sieve[1] = 0
for i in range(2, int(N ** 0.5) + 1):
    if sieve[i]:
        sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
ispp = bytearray(N + 1)
base = [0] * (N + 1)
for p in range(2, N + 1):
    if sieve[p]:
        q = p
        while q <= N:
            ispp[q] = 1
            base[q] = p
            q *= p

# smallest prime factor for factoring c-1
spf = list(range(N + 1))
for i in range(2, int(N ** 0.5) + 1):
    if spf[i] == i:
        for j in range(i * i, N + 1, i):
            if spf[j] == j:
                spf[j] = i

def pdivs(m):
    out = set()
    while m > 1:
        p = spf[m]
        out.add(p)
        while m % p == 0:
            m //= p
    return out

EFF = [0.0] * (N + 1)
for r in range(3, N + 1, 2):
    if not sieve[r]:
        continue
    m = r - 1
    a, x = 0, m
    while x % 2 == 0:
        x //= 2; a += 1
    best, y, d = 1, x, 3
    while d * d <= y:
        if y % d == 0:
            e = 1
            while y % d == 0:
                y //= d; e += 1
            best = max(best, d ** (e - 1))
        d += 2
    if y > 1:
        best = max(best, y)
    EFF[r] = max((2 ** a) / m, 2 * best / m)

_EFF_EX_CACHE = {}
def eff_excluding(excl):
    key = frozenset(excl)
    if key in _EFF_EX_CACHE:
        return _EFF_EX_CACHE[key]
    arr = [0.0] * (N + 1)
    for r in range(3, N + 1, 2):
        if not sieve[r]:
            continue
        m = r - 1
        best_e = 0.0
        a_, x_ = 0, m
        while x_ % 2 == 0:
            x_ //= 2; a_ += 1
        if 2 not in key:
            best_e = max(best_e, (2 ** a_) / m)
        y, d = x_, 3
        while d * d <= y:
            if y % d == 0:
                e2 = 1
                while y % d == 0:
                    y //= d; e2 += 1
                if d not in key:
                    best_e = max(best_e, 2 * (d ** (e2 - 1)) / m)
            d += 2
        if y > 1 and y not in key:
            best_e = max(best_e, 2 * y / m)
        arr[r] = best_e
    _EFF_EX_CACHE[key] = arr
    return arr

_EFF_AT_CACHE = {}
def eff_at(q0):
    if q0 in _EFF_AT_CACHE:
        return _EFF_AT_CACHE[q0]
    arr = [0.0] * (N + 1)
    for r in range(3, N + 1, 2):
        if not sieve[r]:
            continue
        m = r - 1
        tq, x = 1, m
        while x % q0 == 0:
            x //= q0; tq *= q0
        if tq == 1:
            continue
        pm = tq if tq % 2 == 0 else 2 * tq
        arr[r] = min(pm, m) / m
    _EFF_AT_CACHE[q0] = arr
    return arr

EFF_ODD = [0.0] * (N + 1)
for r in range(3, N + 1, 2):
    if not sieve[r]:
        continue
    m = r - 1
    y, d, best_e = m, 3, 0.0
    while y % 2 == 0:
        y //= 2
    while d * d <= y:
        if y % d == 0:
            e2 = 1
            while y % d == 0:
                y //= d; e2 += 1
            best_e = max(best_e, 2 * (d ** (e2 - 1)) / m)
        d += 2
    if y > 1:
        best_e = max(best_e, 2 * y / m)
    EFF_ODD[r] = best_e

EFF2 = [0.0] * (N + 1)
for r in range(3, N + 1, 2):
    if sieve[r]:
        m = r - 1
        a2 = 1
        while m % (2 * a2) == 0:
            a2 *= 2
        EFF2[r] = a2 / m

def orb_ld(c, t, char2):
    raw = c * t // 2 if (char2 or t % 2 == 0) else c * t
    return min(raw, comb(c, 2))

FSET = tuple(range(3, 13)) + (16, 25)
PPs = [c for c in range(2, N + 1) if ispp[c]]

S7_BRANCHES = []
for _F in FSET:
    _pr = pdivs(_F)
    S7_BRANCHES.append((_F, _pr, eff_excluding(_pr)))
    for _q in sorted(_pr):
        _mid = _F
        while _mid % _q == 0:
            _mid //= _q
        _excl = pdivs(_mid) if _mid > 1 else set()
        S7_BRANCHES.append((_F, _excl, eff_at(_q)))

def strip(m, excl):
    for qq in excl:
        while m % qq == 0:
            m //= qq
    return m

print(f"setup {time.time()-t:.1f}s, branches {len(S7_BRANCHES)}", flush=True)

# guarded achieved(), untruncated (stop_at=None), same families as the script
LO_X, HI_X = 0.10, 0.55
STRIPS = {}
def strip_map(excl):
    key = frozenset(excl)
    if key not in STRIPS:
        STRIPS[key] = {c: strip(c - 1, key) for c in PPs}
    return STRIPS[key]
BR = [(F_, ex_, ef_, strip_map(ex_)) for F_, ex_, ef_ in S7_BRANCHES]

def achieved_guarded(n, stop_at=None):
    C = n * (n - 1) / 2
    best = 0.0
    F = 2
    while F * F <= n:
        if n % F == 0:
            for FF in (F, n // F):
                c = n // FF
                if ispp[FF] and ispp[c]:
                    q = base[FF]
                    v = min(FF * comb(c, 2), (FF if q % 2 else FF // 2) * c * c)
                    if v > best * C:
                        best = v / C
        F += 1
    if stop_at and best >= stop_at:
        return best
    lo = bisect.bisect_left(PPs, int(LO_X * n))
    hi = bisect.bisect_right(PPs, int(HI_X * n))
    for k in range(lo, hi):
        c = PPs[k]
        bp = base[c]
        r = n - c
        if 3 <= r <= N and sieve[r] and bp != r and (c - 1) % r:
            v = min(comb(c, 2), EFF[r] * comb(r, 2), c * r)
            if v > best * C:
                best = v / C
                if stop_at and best >= stop_at:
                    return best
        r = n - 2 * c
        if 3 <= r <= N and sieve[r] and bp != r and (c - 1) % r:
            v = min(comb(c, 2), EFF[r] * comb(r, 2), c * c, c * r)
            if v > best * C:
                best = v / C
            dodd = c - 1
            while dodd % 2 == 0:
                dodd //= 2
            eB = EFF_ODD[r]
            if eB > 0:
                v = min(2 * orb_ld(c, dodd, bp == 2), eB * comb(r, 2), c * c, 2 * c * r)
                if v > best * C:
                    best = v / C
            if EFF2[r] > 0:
                v = min(2 * comb(c, 2), EFF2[r] * comb(r, 2), c * c, 2 * c * r)
                if v > best * C:
                    best = v / C
        if stop_at and best >= stop_at:
            return best
    for Fp, exclF, EFFx, STR in BR:
        cross_coeff = Fp if Fp % 2 else Fp // 2
        for c in PPs:
            m = Fp * c
            if m >= n:
                break
            r = n - m
            if r < 3 or r > N or not sieve[r]:
                continue
            if base[c] == r or r in exclF:
                continue
            e = EFFx[r]
            if e <= 0:
                continue
            d_tw = STR[c]
            while d_tw % r == 0:      # the guard under audit
                d_tw //= r
            intra = Fp * orb_ld(c, d_tw, base[c] == 2)
            v = min(intra, cross_coeff * c * c, m * r, e * comb(r, 2))
            if v > best * C:
                best = v / C
                if stop_at and best >= stop_at:
                    return best
    return best

# --- enumerate every (branch, c, r) with r | c-1, n <= N ---
t = time.time()
flag = {}   # n -> largest invalid (unguarded) score that exceeds the guarded one for that candidate
cands = 0
for Fp, exclF, EFFx, STR in BR:
    cross_coeff = Fp if Fp % 2 else Fp // 2
    for c in PPs:
        if Fp * c + 3 > N:
            break
        for r in pdivs(c - 1):
            if r < 3:
                continue
            n = Fp * c + r
            if n > N or not sieve[r]:
                continue
            if base[c] == r or r in exclF:
                continue
            e = EFFx[r]
            if e <= 0:
                continue
            cands += 1
            d0 = STR[c]
            d1 = d0
            while d1 % r == 0:
                d1 //= r
            if d1 == d0:
                continue    # strip changes nothing; scores identical
            m = Fp * c
            v_bad = min(Fp * orb_ld(c, d0, base[c] == 2), cross_coeff * c * c,
                        m * r, e * comb(r, 2))
            v_good = min(Fp * orb_ld(c, d1, base[c] == 2), cross_coeff * c * c,
                         m * r, e * comb(r, 2))
            if v_bad > v_good:
                db = v_bad / (n * (n - 1) / 2)
                if db > flag.get(n, 0.0):
                    flag[n] = db
print(f"candidates with r | c-1: {cands}; n with a strictly larger invalid score: {len(flag)} "
      f"({time.time()-t:.1f}s)", flush=True)

# --- for each flagged n, does the invalid score beat the guarded achieved(n)? ---
t = time.time()
hits = []
for i, (n, db) in enumerate(sorted(flag.items())):
    g = achieved_guarded(n, stop_at=db - 1e-12)
    if db > g + 1e-12:
        hits.append((n, db, g))
    if (i + 1) % 200 == 0:
        print(f"  ...{i+1}/{len(flag)} checked, hits so far {len(hits)} ({time.time()-t:.0f}s)", flush=True)
print(f"\nn where the unguarded S7 branch would have RAISED the reported bound: {len(hits)}")
for n, db, g in hits[:40]:
    print(f"  n={n}: invalid {db:.5f} vs guarded {g:.5f}  (mod 24 = {n%24})")
if hits:
    below04 = [h for h in hits if h[2] < 0.04]
    belowASY = [h for h in hits if h[2] < 7 - 4*3**0.5]
    print(f"of these, guarded value < 0.04: {len(below04)}; < asymptotic 0.0718: {len(belowASY)}")
