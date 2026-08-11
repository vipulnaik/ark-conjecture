#!/usr/bin/env python3
"""
t5_verify.py -- verifications for Lemma C (the twist-foreign coupling) and
Corollary C' of enumeration-proof.md Part D.

The old form of Lemma C -- gcd(d, r) = 1 -- is FALSE -- cyclic-layer twists CAN share a prime
with a foreign block, at a > 1 and even at a = 1 -- and what is true instead is
a COUPLING: if r | d_i (the cyclic-layer twist of a p-characteristic part with
block c = p^a) for a foreign part of prime size r, then every multiplier induced
on the foreign part lies in <p mod r>, so the foreign twist order t divides
ord_r(p), which divides a.  Hence the foreign intra class is at most
min(r * ord_r(p), C(r,2)) <= n * log2(n), and every sharing configuration is
dominated.  The strip in fb_common.py's condition (4) is thereby NECESSARY AMONG
CONFIGURATIONS SCORING ABOVE n*log2(n) -- at every a, not only a = 1.

  PASS 1  THE WITNESS AT a = 2.  n = 28 = 25 + 3: an Oliver group of order 150
          (Gamma_2 = C_5^2, layer C_3, top C_2) whose cyclic-layer element acts
          as a multiplier of order 3 on the 5^2-block AND as +1 on the foreign
          3-block, with the top element acting as Frobenius there and negation
          here.  gcd(d, r) = 3.  Lemma C's conclusion fails.

  PASS 2  THE COUPLING IS TIGHT.  n = 21 = 16 + 5: ord_5(2) = 4, and the share
          is realised with foreign twist of order exactly 4 (|G| = 320, layer
          C_5, top C_4).  The mismatched pairing -- Frobenius of order 2 with a
          foreign multiplier of order 4 -- fails to close: its closure contains
          the pure matching twist and the pure foreign translation separately,
          so Sylow-5 is C_5 x C_5, non-cyclic, and no chain exists for q != 5
          (q = 5 makes the foreign part r = q, dead by Lemma D2q).

  PASS 3  THE a = 1 BOUNDARY.  n = 10 = 7 + 3: the share exists at a PRIME
          block too, with the foreign part untwisted (order-21 Oliver group,
          top trivial).  What the old a = 1 proof established is
          "share => foreign twist trivial", which is the a = 1 instance of the
          coupling (t | ord_r(p) | 1); its stated conclusion gcd = 1 was too
          strong even there.

  PASS 5  THE THRESHOLD PRECONDITIONS.  Corollary C' makes condition (4)'s
          foreign-prime strip necessary only ABOVE the sharing bound, so that
          bound must clear B(n) before the strip is licensed at all.  Checks
          both forms -- B(n) > n for the a = 1 strip, B(n) > n log2 n for the
          general-a strip -- and reports where each holds.  These are the gates
          on lifting the a = 1 scoping in fb_common.py, and the general-a one
          does NOT hold at 34 small n.

  PASS 4  DOMINATION IN RANGE.  For every v4 row, the largest class any sharing
          configuration can offer -- max over p^a + r <= n of
          min(r*ord_r(p), C(r,2)) -- stays strictly below B(n).
          Plus the theorem threshold: the bound is <= n*log2(n), excluded
          wherever delta(n)*C(n,2) exceeds that; with the ladder's
          delta >= 0.02516 this holds from n >= 763, overlapping the table.

Usage: python3 t5_verify.py [path/to/mu_table_safe_v4.csv]
Exits nonzero on any failure.
"""
import csv
import sys
from math import comb, isqrt, log2

TABLE = sys.argv[1] if len(sys.argv) > 1 else "mu_table_safe_v4.csv"
ok = True


def check(name, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + name)
    ok = ok and cond


def perm_tools(npts):
    ident = tuple(range(npts))

    def mul(a, b):
        return tuple(a[v] for v in b)

    def inv(a):
        o = [0] * npts
        for i, v in enumerate(a):
            o[v] = i
        return tuple(o)

    def closure(gens):
        G = {ident}
        fr = [ident]
        while fr:
            nf = []
            for x in fr:
                for g in gens:
                    y = mul(g, x)
                    if y not in G:
                        G.add(y)
                        nf.append(y)
            fr = nf
        return frozenset(G)

    return ident, mul, inv, closure


# ---------------------------------------------------------------- pass 1
p = 5


def f25_mul(u, v):
    a, b = u
    c, d = v
    return ((a * c + 3 * b * d) % p, (a * d + b * c) % p)   # x^2 = 3 in F_5


def f25_pow(u, k):
    r = (1, 0)
    for _ in range(k):
        r = f25_mul(r, u)
    return r


els = [(a, b) for a in range(p) for b in range(p)]
gen = None
for u in els:
    if u == (0, 0):
        continue
    o, v = 1, u
    while v != (1, 0):
        v = f25_mul(v, u)
        o += 1
    if o == 24:
        gen = u
        break
omega = f25_pow(gen, 8)
pts = [('m', u) for u in els] + [('f', x) for x in range(3)]
idx = {pt: k for k, pt in enumerate(pts)}
ident, mul, inv, closure = perm_tools(28)


def mk28(fm, ff):
    return tuple(idx[('m', fm(v))] if t == 'm' else idx[('f', ff(v))]
                 for (t, v) in pts)


ta = mk28(lambda u: ((u[0] + 1) % p, u[1]), lambda x: x)
tb = mk28(lambda u: (u[0], (u[1] + 1) % p), lambda x: x)
z28 = mk28(lambda u: f25_mul(omega, u), lambda x: (x + 1) % 3)
g28 = mk28(lambda u: f25_pow(u, 5), lambda x: (-x) % 3)
G = closure([ta, tb, z28, g28])
G1 = closure([ta, tb, z28])
G2 = closure([ta, tb])
check("n=28 witness: |G|=150, Gamma_2=C_5^2, layer C_3, top C_2",
      (len(G), len(G1), len(G2)) == (150, 75, 25))
check("n=28 witness: both subgroups normal, conjugation closes as z -> z^-1",
      all(mul(mul(h, s), inv(h)) in G2 for h in [ta, tb, z28, g28] for s in [ta, tb])
      and all(mul(mul(h, s), inv(h)) in G1 for h in [ta, tb, z28, g28] for s in [ta, tb, z28])
      and mul(mul(g28, z28), inv(g28)) == inv(z28))
check("n=28 witness: cyclic-layer twist of order 3 on the 5^2-block shares the "
      "foreign prime 3 -- Lemma C's gcd(d,r)=1 is FALSE at a=2",
      f25_pow(omega, 3) == (1, 0) and omega != (1, 0))

# ---------------------------------------------------------------- pass 2
POLY = 0b10011


def gmul(a, b):
    r = 0
    for i in range(4):
        if (b >> i) & 1:
            r ^= a << i
    for i in (7, 6, 5, 4):
        if (r >> i) & 1:
            r ^= POLY << (i - 4)
    return r & 15


def gpow(a, k):
    r = 1
    for _ in range(k):
        r = gmul(r, a)
    return r


zeta = gpow(2, 3)
pts2 = [('m', u) for u in range(16)] + [('f', x) for x in range(5)]
idx2 = {pt: k for k, pt in enumerate(pts2)}
ident, mul, inv, closure = perm_tools(21)


def mk21(fm, ff):
    return tuple(idx2[('m', fm(v))] if t == 'm' else idx2[('f', ff(v))]
                 for (t, v) in pts2)


trans = [mk21(lambda u, e=e: u ^ e, lambda x: x) for e in (1, 2, 4, 8)]
z21 = mk21(lambda u: gmul(zeta, u), lambda x: (x + 1) % 5)
gG = mk21(lambda u: gmul(u, u), lambda x: (2 * x) % 5)
gB = mk21(lambda u: gpow(u, 4), lambda x: (2 * x) % 5)
GG = closure(trans + [z21, gG])
GG1 = closure(trans + [z21])
check("n=21 coupling: share realised with foreign twist 4 = ord_5(2) "
      "(|G|=320, layer C_5, top C_4)",
      (len(GG), len(GG1)) == (320, 80)
      and mul(mul(gG, z21), inv(gG)) == mul(z21, z21))
GB = closure(trans + [z21, gB])
pure_twist = mk21(lambda u: gmul(zeta, u), lambda x: x)
pure_trans = mk21(lambda u: u, lambda x: (x + 1) % 5)
check("n=21 mismatched pairing (Frob^2 with mult of order 4) fails to close: "
      "closure of order 1600 contains BOTH pure 5-elements, so Sylow-5 = C_5 x C_5, chainless",
      len(GB) == 1600 and pure_twist in GB and pure_trans in GB)

# ---------------------------------------------------------------- pass 3
pts3 = [('m', u) for u in range(7)] + [('f', x) for x in range(3)]
idx3 = {pt: k for k, pt in enumerate(pts3)}
ident, mul, inv, closure = perm_tools(10)


def mk10(fm, ff):
    return tuple(idx3[('m', fm(v))] if t == 'm' else idx3[('f', ff(v))]
                 for (t, v) in pts3)


t7 = mk10(lambda u: (u + 1) % 7, lambda x: x)
z10 = mk10(lambda u: (2 * u) % 7, lambda x: (x + 1) % 3)
G10 = closure([t7, z10])
check("n=10 boundary: the share exists at a PRIME block with untwisted foreign part "
      "(|G|=21, Gamma_2=C_7, layer C_3) -- Lemma C over-claimed at a=1 too",
      len(G10) == 21 and len(closure([t7])) == 7)

# ---------------------------------------------------------------- pass 4
N = 2484
sieve = bytearray([1]) * (N + 1)
sieve[0] = sieve[1] = 0
for i in range(2, isqrt(N) + 1):
    if sieve[i]:
        sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
primes = [x for x in range(2, N + 1) if sieve[x]]
tab = {int(r["n"]): int(r["mu_bound"]) for r in csv.DictReader(open(TABLE))}


def ordr(pp, r):
    o, v = 1, pp % r
    while v != 1:
        v = v * pp % r
        o += 1
    return o


events = []
for pp in primes:
    pa = pp
    while pa <= N - 2:
        for r in primes:
            if r > pa - 1:
                break
            if (pa - 1) % r == 0:
                events.append((pa + r, min(r * ordr(pp, r), comb(r, 2))))
        pa *= pp
events.sort()
best, i, viol, worst = 0, 0, [], (0.0, 0)
for n in sorted(tab):
    while i < len(events) and events[i][0] <= n:
        best = max(best, events[i][1])
        i += 1
    if best >= tab[n]:
        viol.append(n)
    if tab[n] and best / tab[n] > worst[0]:
        worst = (best / tab[n], n)
check("no sharing configuration reaches B(n) at any of %d rows "
      "(worst ratio %.4f at n=%d)" % (len(tab), worst[0], worst[1]), not viol)
d = 0.02516
t = 6
while not (t * log2(t) < d * t * (t - 1) / 2):
    t += 1
check("theorem threshold n >= %d at delta >= 0.02516 overlaps the table" % t,
      t <= max(tab))

# ---- pass 5: the threshold preconditions for condition (4)'s strip -----------
# Corollary C' makes the foreign-prime strip NECESSARY only among configurations
# scoring above the sharing bound.  Two bounds, because the coupling is sharper
# at a = 1:
#   a = 1 general:  t | ord_r(p) | 1, so the foreign part is untwisted and worth
#                   orb(r,1) = r < n            -> precondition  B(n) > n
#   any a:          foreign class <= r*ord_r(p) <= r*a <= n*log2(n)
#                                               -> precondition  B(n) > n log2 n
# A strip applied where its precondition fails is NOT justified by the corollary
# and could discard a real candidate, so these are the gates on lifting the
# a = 1 scoping in fb_common.py -- not decoration.
viol_n = [n for n in tab if tab[n] <= n]
viol_nlog = [n for n in tab if tab[n] <= n * log2(n)]
check("B(n) > n at every tabulated n except n = 6 (a = 1 strip precondition)",
      viol_n == [6])
check("B(n) > n log2 n fails at %d small n, all <= %d (general-a precondition)"
      % (len(viol_nlog), max(viol_nlog)), max(viol_nlog) < 118)
safe = min(n for n in sorted(tab)
           if all(tab[m] > m * log2(m) for m in tab if m >= n))
check("B(n) > n log2 n holds for EVERY tabulated n >= %d" % safe, safe == 118)
print("      -> lifting the strip to all a is licensed from n = %d up; below it the"
      % safe)
print("         a = 1 form is licensed everywhere but n = 6, where B(n) = n = 6.")
print("      -> asymptotically the gate is automatic: delta*C(n,2) > n log2 n from")
print("         n >= 763 at the ladder floor 0.02516, and from n >= 998 at 1/50.")

sys.exit(0 if ok else 1)
