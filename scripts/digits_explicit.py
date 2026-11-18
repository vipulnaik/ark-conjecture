#!/usr/bin/env python3
"""digits_explicit.py -- the digit construction for a repeated prime l^e || k, carried out explicitly.

Levels n_i = u l^i (u = k / l^e), i = 0..e-1.  Delta_0 = the vertices of Z_u.  At level i the complex is
Delta_i = pullback of Delta_{i-1} (S in it iff S mod n_{i-1} is a face of Delta_{i-1}) plus added orbits; membership is
tested recursively.  To fix digit i (chi = 1 mod l^{i+1}) add j <= l - 1 orbits of free, coset-free minimal non-faces
of size 2 (each -n_i) or of size 3 (each +n_i); candidates are sampled.  Coset-free: no C_{l'}-coset for a prime
l' != l dividing k (at level n_i: a set {x + t n_i / l'}).  Faces stay within cap: a level-i face of s points is
s l^{e-1-i} points at the top level Z_{k/l}.  Returns the list of moves, or None.
usage: python3 digits_explicit.py k l cap"""
import random, sys
from sympy import factorint
def digits(k, l, cap, seed=1, samples=20000, target=1):
    rng = random.Random(seed); f = factorint(k); e = f[l]; u = k // l ** e
    others = [p for p in f if p != l]
    levels = [u * l ** i for i in range(e)]
    added = []          # per level: set of frozensets (whole orbits) of added faces
    def member(S, i):
        S = frozenset(S)
        if i < 0: return False
        n = levels[i]
        if len(S) == 1 and i == 0: return True
        if S in added[i]: return True
        if any(S < A for A in added[i]): return True
        if i == 0: return False
        return member({x % levels[i - 1] for x in S}, i - 1)
    def coset_free(S, n):
        T = set(S)
        for p in others:
            if n % p: continue
            st = n // p
            if any(all((x + st * t) % n in T for t in range(p)) for x in S): return False
        return True
    def free(S, n):
        T = frozenset(S)
        return all(frozenset((x + d) % n for x in S) != T for d in range(1, n) if n % d == 0)
    chi = u; moves = []
    for i, n in enumerate(levels):
        added.append(set())
        scale = l ** (e - 1 - i)
        need = (target - chi) % l ** (i + 1)              # chi + delta = 1 mod l^{i+1}; delta a multiple of n
        assert need % l ** i == 0 or i == 0
        unit = (n // l ** i) % l                     # n = u l^i
        t = (need // l ** i) * pow(unit, -1, l) % l  # need delta = t * n (mod l^{i+1})
        options = [(-1, 2, (-t) % l), (1, 3, t), ('E+T', None, None)]
        for sign, size, j in options:
            if sign == 'E+T':
                # add every available free coset-free edge orbit (E of them), then j' triangles, j' = t + E (mod l)
                if 3 * scale > cap: continue
                E = []
                for x in range(1, n // 2 + 1):
                    S = (0, x)
                    if member(S, i) or not free(S, n) or not coset_free(S, n): continue
                    orb = frozenset(frozenset((y + d) % n for y in S) for d in range(n))
                    if orb not in E: E.append(orb)
                for orb in E: added[i] |= set(orb)
                jp = (t + len(E)) % l; got = []
                for _ in range(samples):
                    if len(got) >= jp: break
                    S = tuple(sorted(rng.sample(range(n), 3)))
                    if member(S, i) or not free(S, n) or not coset_free(S, n): continue
                    if not all(member([x for x in S if x != y], i) for y in S): continue
                    orb = frozenset(frozenset((x + d) % n for x in S) for d in range(n))
                    if any(orb == g for g in got): continue
                    got.append(orb)
                if len(got) < jp:
                    for orb in E: added[i] -= set(orb)
                    continue
                for orb in got: added[i] |= set(orb)
                chi += (jp - len(E)) * n; moves.append((n, 'E+T', len(E), jp)); break
            if size * scale > cap: continue
            got = []
            for _ in range(samples):
                if len(got) >= j: break
                S = tuple(sorted(rng.sample(range(n), size)))
                if member(S, i) or not free(S, n) or not coset_free(S, n): continue
                if not all(member([x for x in S if x != y], i) for y in S): continue
                orb = frozenset(frozenset((x + d) % n for x in S) for d in range(n))
                if any(o in added[i] for o in orb) or any(orb == g for g in got): continue
                got.append(orb)
            if len(got) >= j:
                for orb in got[:j]: added[i] |= set(orb)
                chi += sign * j * n; moves.append((n, size, j)); break
        else:
            return None
        assert (chi - target) % l ** (i + 1) == 0, (chi, i)
    return chi, moves
if __name__ == "__main__":
    k, l, cap = map(int, sys.argv[1:4]); print(digits(k, l, cap))
