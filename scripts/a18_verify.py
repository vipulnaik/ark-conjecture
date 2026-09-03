#!/usr/bin/env python3
"""
a18_verify.py -- three verifications for Lemma D2 of enumeration-proof.md
(Part D2, the fused-outside domination theorem), in one file.

  PASS 1  THE WITNESS.  Builds the n = 85 group -- five fused outside 17-blocks
          with a diagonal translation, a diagonal order-16 twist, and AGL(1,5)
          permuting the blocks -- and computes every pair-orbit exhaustively.
          Expected: classes 170 / 680 / 2720, so m* = 170 = 2|O|.  What that
          falsifies is the SUPERSEDED linear form m* <= |O|/2, which assumed a
          small block-permuter's pair-orbital; the lemma as it stands bounds the
          same-position class by C(F,2)*r, which 170 attains exactly.  So this
          pass exhibits the witness the current bound is tight on rather than a
          counterexample to anything claimed.

  PASS 2  THE CHAIN.  Machine-checks that the witness satisfies Oliver's
          condition: Gamma_1 = <tau, c5> is cyclic of order 85 and normal, the
          quotient has order 64 (a 2-group), and the action is transitive.
          Nothing here is taken from the construction on faith.

  PASS 2b THE SHARPER WITNESS.  The same failure via a permuter that is
          2-HOMOGENEOUS but not 2-transitive -- C_7 : C_3 on 7 blocks, which
          fits a chain (q = 3) where the full AGL(1,7) does not.  Seven fused
          13-blocks give an Oliver group at n = 91 with m* = 3|O|.  What the
          same-position class costs is set by the permuter's minimum orbital on
          UNORDERED pairs, so 2-homogeneity is the property to ask for; a
          2-transitivity-based argument misses this family entirely.

  PASS 3  THE RANGE.  For every row of mu_table_safe_v4.csv, checks that the
          domination bound of Lemma D2 --
              some class <= F*C(r,2) always, and <= C(F,2)*r when F < r --
          maximised over all (F >= 2, r prime, F*r <= n), stays strictly below
          B(n).  The bound is deliberately generous (it grants the largest
          class a 2-transitive permuter could produce), so a pass here means
          no fused-outside configuration can attain B(n) in range even under
          worst-case structure.  Also prints the theorem threshold, computed from a
          deliberately weak delta: at delta >= 0.02516 the exclusion is a
          theorem for n >= 1582, which overlaps the table's reach with room.
          That is an UPPER bound on where the theorem starts -- a higher
          verified floor lowers it -- and the pass does not depend on which
          floor is fed in.

Usage:  python3 a18_verify.py [path/to/mu_table_safe_v4.csv]
Exits nonzero on any failure.
"""
import csv, sys
from collections import deque
from math import comb, isqrt

TABLE = sys.argv[1] if len(sys.argv) > 1 else "mu_table_safe_v4.csv"
ok = True


def check(name, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + name)
    ok = ok and cond


# ---------------------------------------------------------------- pass 1 + 2
F, r = 5, 17
pts = [(i, x) for i in range(F) for x in range(r)]
idx = {p: k for k, p in enumerate(pts)}


def perm(f):
    return tuple(idx[f(p)] for p in pts)


tau = perm(lambda p: (p[0], (p[1] + 1) % r))       # diagonal translation
mu = perm(lambda p: (p[0], (3 * p[1]) % r))        # diagonal twist, ord(3 mod 17) = 16
c5 = perm(lambda p: ((p[0] + 1) % F, p[1]))        # 5-cycle on blocks
iota = perm(lambda p: ((2 * p[0]) % F, p[1]))      # AGL(1,5)'s C_4 on blocks
gens = [tau, mu, c5, iota]
ident = tuple(range(len(pts)))


def mul(a, b):
    return tuple(a[v] for v in b)


def inv(a):
    o = [0] * len(a)
    for i, v in enumerate(a):
        o[v] = i
    return tuple(o)


def closure(gs):
    G = {ident}
    frontier = [ident]
    while frontier:
        nf = []
        for x in frontier:
            for g in gs:
                y = mul(g, x)
                if y not in G:
                    G.add(y)
                    nf.append(y)
        frontier = nf
    return G


def order_of(g):
    cur, o = g, 1
    while cur != ident:
        cur = mul(g, cur)
        o += 1
    return o


n85 = len(pts)
pairs = [(a, b) for a in range(n85) for b in range(a + 1, n85)]
pidx = {p: k for k, p in enumerate(pairs)}
seen = [False] * len(pairs)
sizes = []
for k in range(len(pairs)):
    if seen[k]:
        continue
    seen[k] = True
    comp = 1
    dq = deque([pairs[k]])
    while dq:
        pr = dq.popleft()
        for g in gens:
            a, b = g[pr[0]], g[pr[1]]
            q = (a, b) if a < b else (b, a)
            j = pidx[q]
            if not seen[j]:
                seen[j] = True
                comp += 1
                dq.append(q)
    sizes.append(comp)
sizes.sort()
check("witness orbitals are [170, 680, 2720]", sizes == [170, 680, 2720])
check("witness m* = 170 > |O|/2 = 42.5 (the superseded linear form fails here)",
      sizes[0] == 170 > n85 / 2)
check("offset-zero class = C(5,2)*17 (bound tight)", sizes[0] == comb(5, 2) * 17)

G = closure(gens)
G1 = closure([tau, c5])
check("|Gamma| = 5440", len(G) == 5440)
check("Gamma_1 cyclic of order 85", len(G1) == 85 and any(order_of(g) == 85 for g in G1))
check("Gamma_1 normal in Gamma",
      all(mul(mul(g, h), inv(g)) in G1 for g in gens for h in [tau, c5]))
q_ = len(G) // len(G1)
check("quotient order 64, a 2-group", q_ == 64 and q_ & (q_ - 1) == 0)
orb = {0}
fr = [0]
while fr:
    nf = []
    for v in fr:
        for g in gens:
            if g[v] not in orb:
                orb.add(g[v])
                nf.append(g[v])
    fr = nf
check("transitive on 85 points", len(orb) == n85)

# ---- pass 2b: the sharper witness, via a 2-HOMOGENEOUS (not 2-transitive) permuter
# F = 7 blocks of r = 13; permuter C_7 : C_3, which is 2-homogeneous on 7 points
# but not 2-transitive, and unlike AGL(1,7) = C_7 : C_6 it fits a chain (q = 3).
F2, r2 = 7, 13
pts2 = [(i, x) for i in range(F2) for x in range(r2)]
idx2 = {p: k for k, p in enumerate(pts2)}
n91 = F2 * r2
ident2 = tuple(range(n91))


def perm2(f):
    return tuple(idx2[f(p)] for p in pts2)


def mul2(a, b):
    return tuple(a[v] for v in b)


def inv2(a):
    o = [0] * n91
    for i, v in enumerate(a):
        o[v] = i
    return tuple(o)


def closure2(gens):
    G = {ident2}
    fr = [ident2]
    while fr:
        nf = []
        for x in fr:
            for g in gens:
                y = mul2(g, x)
                if y not in G:
                    G.add(y)
                    nf.append(y)
        fr = nf
    return frozenset(G)


tau2 = perm2(lambda p: (p[0], (p[1] + 1) % r2))
mu2 = perm2(lambda p: (p[0], (3 * p[1]) % r2))          # ord(3 mod 13) = 3
c72 = perm2(lambda p: ((p[0] + 1) % F2, p[1]))
io2 = perm2(lambda p: ((2 * p[0]) % F2, p[1]))          # ord(2 mod 7) = 3
gens2 = [tau2, mu2, c72, io2]
G91 = closure2(gens2)
G91_1 = closure2([tau2, c72])


def order2(g):
    cur, o = g, 1
    while cur != ident2:
        cur = mul2(g, cur)
        o += 1
    return o


sizes91 = []
pairs2 = [(a, b) for a in range(n91) for b in range(a + 1, n91)]
pidx2 = {p: k for k, p in enumerate(pairs2)}
seen2 = [False] * len(pairs2)
for k in range(len(pairs2)):
    if seen2[k]:
        continue
    seen2[k] = True
    comp = 1
    st = [pairs2[k]]
    while st:
        pr = st.pop()
        for g in gens2:
            a, b = g[pr[0]], g[pr[1]]
            qq = (a, b) if a < b else (b, a)
            j = pidx2[qq]
            if not seen2[j]:
                seen2[j] = True
                comp += 1
                st.append(qq)
    sizes91.append(comp)
sizes91.sort()
check("n=91 witness: chain (|G|=819, Gamma_1 = C_91 normal, quotient 9)",
      len(G91) == 819 and len(G91_1) == 91
      and any(order2(g) == 91 for g in G91_1)
      and all(mul2(mul2(g, h), inv2(g)) in G91_1 for g in gens2 for h in [tau2, c72])
      and len(G91) // len(G91_1) == 9)
check("n=91 witness: m* = C(7,2)*13 = 273 = 3|O|, sharper than the n=85 case",
      sizes91[0] == comb(7, 2) * 13 == 273 and sizes91[0] == 3 * n91)
# the permuter C_7 : C_3 is 2-homogeneous but NOT 2-transitive
blk = [(i, j) for i in range(F2) for j in range(F2) if i != j]
sig = [lambda i: (i + 1) % F2, lambda i: (2 * i) % F2]
unord, ordp = set(), set()
for (i, j) in blk:
    cu, co = {frozenset((i, j))}, {(i, j)}
    ch = True
    while ch:
        ch = False
        for s in sig:
            for (a, b) in list(co):
                if (s(a), s(b)) not in co:
                    co.add((s(a), s(b)))
                    ch = True
            for e in list(cu):
                a, b = tuple(e)
                if frozenset((s(a), s(b))) not in cu:
                    cu.add(frozenset((s(a), s(b))))
                    ch = True
    unord.add(len(cu))
    ordp.add(len(co))
check("permuter C_7:C_3 is 2-homogeneous (one unordered class of 21) but not 2-transitive",
      unord == {21} and ordp == {21})

# ------------------------------------------------------------------- pass 3
rows = {}
for row in csv.DictReader(open(TABLE)):
    rows[int(row["n"])] = int(row["mu_bound"])
N = max(rows)
sieve = bytearray([1]) * (N + 1)
sieve[0] = sieve[1] = 0
for i in range(2, isqrt(N) + 1):
    if sieve[i]:
        sieve[i * i::i] = bytearray(len(sieve[i * i::i]))
primes = [p for p in range(2, N + 1) if sieve[p]]


def ub(n):
    """Largest class the domination bound permits any fused-outside orbit at n."""
    best = 0
    for rr in primes:
        if 2 * rr > n:
            break
        for FF in range(2, n // rr + 1):
            u = FF * comb(rr, 2) if FF >= rr else min(FF * comb(rr, 2), comb(FF, 2) * rr)
            if u > best:
                best = u
    return best


viol = [(n, ub(n), rows[n]) for n in sorted(rows) if ub(n) >= rows[n]]
worst = max((ub(n) / rows[n], n) for n in rows)
check("no fused-outside bound reaches B(n) over %d rows" % len(rows), not viol)
print("      worst UB/B ratio %.4f at n = %d" % worst)
d = 0.02516
t = 2
while not (t ** 0.5 < d * (t - 1)):
    t += 1
print("      theorem threshold at delta >= 0.02516: n >= %d (table reaches %d)" % (t, N))
check("theorem threshold overlaps table range", t <= N)

sys.exit(0 if ok else 1)
