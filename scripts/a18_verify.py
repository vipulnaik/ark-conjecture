#!/usr/bin/env python3
"""
a18_verify.py -- three verifications for Lemma D2 of enumeration-proof.md
(Part D2, the fused-outside domination theorem), in one file.

  PASS 1  THE WITNESS.  Builds the n = 85 group -- five fused outside 17-blocks
          with a diagonal translation, a diagonal order-16 twist, and AGL(1,5)
          permuting the blocks -- and computes every pair-orbit exhaustively.
          Expected: classes 170 / 680 / 2720, so m* = 170 = 2|O|, falsifying
          Lemma D2's m* <= |O|/2.

  PASS 2  THE CHAIN.  Machine-checks that the witness satisfies Oliver's
          condition: Gamma_1 = <tau, c5> is cyclic of order 85 and normal, the
          quotient has order 64 (a 2-group), and the action is transitive.
          Nothing here is taken from the construction on faith.

  PASS 3  THE RANGE.  For every row of mu_table_safe_v4.csv, checks that the
          domination bound of Lemma D2 --
              some class <= F*C(r,2) always, and <= C(F,2)*r when F < r --
          maximised over all (F >= 2, r prime, F*r <= n), stays strictly below
          B(n).  The bound is deliberately generous (it grants the largest
          class a 2-transitive permuter could produce), so a pass here means
          no fused-outside configuration can attain B(n) in range even under
          worst-case structure.  Also prints the theorem threshold: with the
          ladder's delta >= 0.02516 on n <= 1e6, exclusion is a theorem for
          n >= 1582, overlapping the table's reach.

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
check("witness m* = 170 > |O|/2 = 42.5 (D2 falsified)", sizes[0] == 170 > n85 / 2)
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
