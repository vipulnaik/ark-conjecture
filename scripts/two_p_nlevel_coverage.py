#!/usr/bin/env python3
"""two_p_nlevel_coverage.py -- which primes p = 3 (mod 4) the N-level proof of burnside-ring-view.md §7.6 covers.
L(k), k = (p-1)/2: no C_k-invariant complex on k points (regular action) with all faces of at most (k-1)/2 points
has chi = 1.  Proved when k is a prime power (chi = 0 mod l), and when some l^a || k has m = k/l^a with no element of
V(m) = 1 (mod l), V(m) the set of chi of such complexes on m points (Smith: chi(X) = chi(X^P) mod l, P the Sylow
l-subgroup, and X^P is such a complex on the m cosets).  V(m) from cyclic_small_face_chis.py, m <= 11 (V(11) taken
as all multiples of 11 in its range, a superset, so the test is conservative)."""
from sympy import factorint, primerange
V = {1: [0], 3: [0, 3], 5: [-5, 0, 5], 7: [-14, -7, 0, 7, 14, 21],
     9: [-69, -60, -54, -51, -45, -42, -36, -33, -27, -24, -18, -15, -9, -6, 0, 3, 9, 12, 18, 21, 27, 30, 36, 39, 45, 48, 54, 57],
     11: list(range(-209, 254, 11))}
LIM = 5000
cov, unc = [], []
for p in primerange(3, LIM):
    if p % 4 != 3: continue
    k = (p - 1) // 2; f = factorint(k) if k > 1 else {}
    how = 'prime power' if len(f) <= 1 else next((f'l = {l}, m = {k // l**a}' for l, a in f.items()
               if k // l**a in V and all((v - 1) % l for v in V[k // l**a])), None)
    (cov if how else unc).append((p, k, how))
print(f"p = 3 (mod 4), p < {LIM}: {len(cov) + len(unc)} primes; L((p-1)/2) proved at {len(cov)}; open at {len(unc)}")
print("first open:", [(p, k) for p, k, _ in unc[:12]])
print("covered below the first open p:", [p for p, k, h in cov if p < unc[0][0]])
