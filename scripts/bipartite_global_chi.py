#!/usr/bin/env python3
"""
bipartite_global_chi.py -- the global Euler characteristic of the bipartiteness complex.

Summing (-1)^edges over pairs (graph, proper 2-colouring) of [n] gives 2 for every n >= 1,
since edges across the two colour classes cancel unless one class is empty.  A graph with k
components has 2^k proper colourings, so by the exponential formula the signed count of
labelled bipartite graphs,

    B(n) = sum over bipartite graphs on [n] of (-1)^(number of edges),

has e.g.f. sqrt(2 e^x - 1), and chi(Delta_bip) = 1 - B(n).  A non-evasive property needs
chi = 1 (this is Oliver's condition for the trivial group), so B(n) != 0 proves bipartiteness
evasive -- and B(n) != 0 for EVERY n >= 3, by an ODE argument:  put f(y) = sqrt(2e^(-y) - 1) = 1 - u(y).
Then f^2 = 2e^(-y) - 1 gives 2ff' = -(f^2 + 1), i.e.  u' = 1 + (1/2) u^2/(1 - u) = 1 + (1/2)(u^2 + u^3 + ...),
whose right side has nonnegative coefficients; by induction every coefficient of u is >= 0, and u^m
contributes u_1^m = 1 to y^m, so u_(m+1) > 0 for m >= 2.  Since B(n) = (-1)^(n+1) n! u_n, B(n) != 0 for n >= 3,
with sign (-1)^(n+1).  (u_2 = 0: bipartiteness is trivial at n = 2.)  main() checks this identity too.

USAGE   python3 bipartite_global_chi.py [NMAX]      (default 30; brute-force check to n = 5)
"""
import sys
from fractions import Fraction as Fr
from math import factorial
from itertools import combinations


def B_values(N):
    g = [Fr(0)] + [Fr(2, factorial(k)) for k in range(1, N + 1)]   # 2e^x - 1 = 1 + g

    def mul(a, b):
        c = [Fr(0)] * (N + 1)
        for i, x in enumerate(a):
            if x:
                for j, y in enumerate(b[:N + 1 - i]):
                    c[i + j] += x * y
        return c
    res = [Fr(1)] + [Fr(0)] * N
    gk = [Fr(1)] + [Fr(0)] * N
    binom = Fr(1)
    for k in range(1, N + 1):                                        # sqrt(1+g) = sum binom(1/2,k) g^k
        binom = binom * (Fr(1, 2) - (k - 1)) / k
        gk = mul(gk, g)
        for i in range(N + 1):
            res[i] += binom * gk[i]
    out = [res[n] * factorial(n) for n in range(N + 1)]
    assert all(b.denominator == 1 for b in out)
    return [int(b) for b in out]


def brute(n):
    E = list(combinations(range(n), 2))
    tot = 0
    for m in range(1 << len(E)):
        col = {}
        adj = {v: [] for v in range(n)}
        for i, (u, v) in enumerate(E):
            if m >> i & 1:
                adj[u].append(v); adj[v].append(u)
        ok = True
        for s in range(n):
            if s in col:
                continue
            col[s] = 0; st = [s]
            while st and ok:
                x = st.pop()
                for y in adj[x]:
                    if y not in col:
                        col[y] = 1 - col[x]; st.append(y)
                    elif col[y] == col[x]:
                        ok = False
        if ok:
            tot += (-1) ** bin(m).count("1")
    return tot


def main():
    N = int(sys.argv[1]) if len(sys.argv) > 1 else 30
    B = B_values(N)
    for n in range(1, 6):
        assert B[n] == brute(n), n
    print("brute force agrees for n = 1..5")
    u = [Fr(0)] * (N + 2); u[1] = Fr(1)

    def mulu(a, c):
        out = [Fr(0)] * (N + 2)
        for i, x in enumerate(a):
            if x:
                for j, y in enumerate(c[:N + 2 - i]):
                    out[i + j] += x * y
        return out
    for d in range(1, N):
        rhs = Fr(0); pw = mulu(u, u); k = 2
        while k <= d:
            rhs += pw[d] / 2; pw = mulu(pw, u); k += 1
        u[d + 1] = rhs / (d + 1)
    assert all(B[n] == (-1) ** (n + 1) * factorial(n) * u[n] for n in range(1, N + 1))
    assert all(u[n] > 0 for n in range(3, N + 1))
    print("ODE identity B(n) = (-1)^(n+1) n! u_n and u_n > 0 (n >= 3) confirmed to n =", N)
    for n in range(2, N + 1):
        print(f"{n:3d}  B(n) = {B[n]:>40d}   chi = {1 - B[n]:>40d}   "
              f"{'EVASIVE' if B[n] != 0 else 'chi = 1'}")


if __name__ == "__main__":
    main()
