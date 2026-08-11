#!/usr/bin/env python3
"""
a18_rq_verify.py -- verifications for Lemma D2q of enumeration-proof.md Part D2
(fused outside blocks whose prime size equals the top prime).

The theorem being tested: if an Oliver group has an
orbit of F >= 2 fused outside q-blocks with 2 <= F < q, then every element acts
with trivial linear part on every block, the translation group is the diagonal
C_q, and m* <= F*q = |O|.  Equivalently: the twist is dead and the class
structure is the C_{Fq}-regular one.  (F >= q is covered by the within-block
class F*C(q,2), which needs only the block system.)

  PASS 1  EXHAUSTIVE AT (F,q) = (2,5).  Enumerates ALL subgroups (252) of
          M = (C5 x C5) x (C4 x C2)  -- translations, diagonal multiplier,
          block swap -- on 10 points.  For every transitive subgroup H and
          every Oliver chain reading (top prime 5 with Gamma_2 not a 5-group;
          top prime 2 or 3 likewise):
            - chain with q = 5  =>  m*(H) <= F*q = 10   (r = q theorem)
            - chain with q != 5 =>  m*(H) <= C(F,2)*r = 5  (r != q theorem)
          Also asserts the three rank-2 translation groups (|H| = 50, 100, 200)
          admit NO chain for any top prime: independent translations are
          inadmissible outright, not merely dominated.

  PASS 2  THE EIGENVECTOR ESCAPE AT (F,q) = (3,7).  The one shape of rank-2
          translation group the general argument has to work hardest to kill:
          T* = <diag, w> with w = (1,2,4) a genuine eigenvector of a block
          3-cycle at common multiplier 4 (possible since 3 | q-1).  Conjugation
          closes (checked), the group has order 147 -- and it admits no Oliver
          chain with top prime 7.  The commutator-in-the-cyclic-layer
          obstruction is real, not an artefact of small F.

  PASS 3  TIGHTNESS AND CONTROLS AT (3,7).  Untwisted C21 has a chain and
          m* = 21 = F*q exactly (the bound is attained); adding a multiplier of
          order 3 (a q'-element, hence forced into the cyclic layer with the
          diagonal translation) destroys the chain, exactly as the twist-killing
          step predicts.

Usage: python3 a18_rq_verify.py     Exits nonzero on any failure.
"""
import sys
from sympy import primefactors

ok = True


def check(name, cond):
    global ok
    print(("PASS  " if cond else "FAIL  ") + name)
    ok = ok and cond


def make_tools(npts):
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


def all_subgroups(G, ident, mul, closure):
    subs = {frozenset([ident])}
    fr = [frozenset([ident])]
    while fr:
        nf = []
        for S in fr:
            for g in G:
                if g not in S:
                    T = closure(list(S) + [g])
                    if T not in subs:
                        subs.add(T)
                        nf.append(T)
        fr = nf
    return subs


def qgrp(n, q):
    while n % q == 0:
        n //= q
    return n == 1


def pgrp(n, banned):
    if n == 1:
        return True
    pf = primefactors(n)
    return len(pf) == 1 and pf[0] not in banned


def chain(H, subs, q, banned_p, mul, inv, closure):
    """Oliver chain: Gamma_2 <= Gamma_1 <= H, both normal in H, Gamma_2 a
    p-group with p not in banned_p, Gamma_1/Gamma_2 cyclic, H/Gamma_1 a
    q-group.  Returns (|Gamma_2|, |Gamma_1|) or None."""
    Hs = frozenset(H)
    INV = {g: inv(g) for g in H}
    ns = [S for S in subs
          if S <= Hs and all(mul(mul(g, s), INV[g]) in S for g in H for s in S)]
    for N1 in ns:
        if not qgrp(len(H) // len(N1), q):
            continue
        for N2 in ns:
            if not (N2 <= N1 and pgrp(len(N2), banned_p)):
                continue
            if any(closure(list(N2) + [g]) == N1 for g in N1):
                return (len(N2), len(N1))
    return None


def transitive(H, npts):
    orb = {0}
    fr = [0]
    while fr:
        nf = []
        for v in fr:
            for g in H:
                if g[v] not in orb:
                    orb.add(g[v])
                    nf.append(g[v])
        fr = nf
    return len(orb) == npts


def mstar(H, npts):
    pairs = [(a, b) for a in range(npts) for b in range(a + 1, npts)]
    pidx = {p: k for k, p in enumerate(pairs)}
    seen = [False] * len(pairs)
    best = 10 ** 9
    for k in range(len(pairs)):
        if seen[k]:
            continue
        seen[k] = True
        comp = 1
        st = [pairs[k]]
        while st:
            pr = st.pop()
            for g in H:
                a, b = g[pr[0]], g[pr[1]]
                qq = (a, b) if a < b else (b, a)
                j = pidx[qq]
                if not seen[j]:
                    seen[j] = True
                    comp += 1
                    st.append(qq)
        best = min(best, comp)
    return best


# ---------------------------------------------------------------- pass 1
F, r = 2, 5
pts = [(i, x) for i in range(F) for x in range(r)]
idx = {p: k for k, p in enumerate(pts)}
ident, mul, inv, closure = make_tools(F * r)


def perm(f):
    return tuple(idx[f(p)] for p in pts)


t0 = perm(lambda p: (p[0], (p[1] + (1 if p[0] == 0 else 0)) % r))
t1 = perm(lambda p: (p[0], (p[1] + (1 if p[0] == 1 else 0)) % r))
m2 = perm(lambda p: (p[0], (2 * p[1]) % r))
sw = perm(lambda p: (1 - p[0], p[1]))
M = closure([t0, t1, m2, sw])
check("(2,5) ambient group has order 200", len(M) == 200)
subs = all_subgroups(M, ident, mul, closure)
check("(2,5) subgroup lattice enumerated (252 subgroups)", len(subs) == 252)

bad_rq, bad_ro, chainless_rank2, n5 = [], [], 0, 0
for H in subs:
    if not transitive(H, 10):
        continue
    c5 = chain(H, subs, 5, {5}, mul, inv, closure)
    ms = mstar(H, 10)
    if c5:
        n5 += 1
        if ms > 10:
            bad_rq.append((len(H), ms))
    for qq in (2, 3):
        if chain(H, subs, qq, {5}, mul, inv, closure) and ms > 5:
            bad_ro.append((len(H), qq, ms))
    if len(H) in (50, 100, 200):
        if all(chain(H, subs, qq, {5}, mul, inv, closure) is None
               for qq in (2, 3, 5)):
            chainless_rank2 += 1
check("every q=5-chained transitive subgroup has m* <= F*q = 10 (%d of them)" % n5,
      not bad_rq and n5 > 0)
check("every q!=5-chained transitive subgroup has m* <= C(F,2)*r = 5", not bad_ro)
check("all 5 rank-2 translation groups (orders 50,100,200) are chainless",
      chainless_rank2 == 5)

# ---------------------------------------------------------------- pass 2 + 3
F, r = 3, 7
pts = [(i, x) for i in range(F) for x in range(r)]
idx = {p: k for k, p in enumerate(pts)}
ident, mul, inv, closure = make_tools(F * r)
tau = perm(lambda p: (p[0], (p[1] + 1) % r))
wtr = perm(lambda p: (p[0], (p[1] + [1, 2, 4][p[0]]) % r))
gg = perm(lambda p: ((p[0] + 1) % F, (4 * p[1]) % r))
cyc = perm(lambda p: ((p[0] + 1) % F, p[1]))
mm2 = perm(lambda p: (p[0], (2 * p[1]) % r))

c = mul(mul(gg, wtr), inv(gg))
vec = []
diagok = True
for i in range(F):
    bi, bx = pts[c[idx[(i, 0)]]]
    diagok = diagok and bi == i
    vec.append(bx)
check("(3,7) eigenvector relation g w g^-1 = w^2 closes rank-2 T*",
      diagok and vec == [2, 4, 1])

Ge = closure([tau, wtr, gg])
subsE = all_subgroups(Ge, ident, mul, closure)
check("(3,7) eigenvector group has order 147 and NO chain with q = 7",
      len(Ge) == 147 and chain(Ge, subsE, 7, {7}, mul, inv, closure) is None)

G0 = closure([tau, cyc])
subs0 = all_subgroups(G0, ident, mul, closure)
c0 = chain(G0, subs0, 7, {7}, mul, inv, closure)
check("untwisted C21 admits a chain and attains m* = F*q = 21 (bound tight)",
      c0 is not None and mstar(G0, 21) == 21)

G1 = closure([tau, cyc, mm2])
subs1 = all_subgroups(G1, ident, mul, closure)
check("adding a q'-twist (order 3) destroys the chain (twist-killing step)",
      len(G1) == 63 and chain(G1, subs1, 7, {7}, mul, inv, closure) is None)

sys.exit(0 if ok else 1)
