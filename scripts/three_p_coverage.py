#!/usr/bin/env python3
"""three_p_coverage.py -- the primes p >= 5 at which the n = 3p theorem of burnside-ring-view.md §7.7 is proved.
Needs L3(p): no complex on k = (p-1)/2 points, invariant under C_k acting regularly, with every face of at most
J = floor((3p(p+1)/2 - 1)/(9p)) points, has chi = 1.  Proved here when
  (a) J = 0 (no faces: chi = 0), or k is a prime power (every face orbit has size divisible by l), or
  (b) some l^a || k has l^a > J (no face is invariant under the Sylow l-subgroup P, so chi = chi(X^P) = 0 mod l), or
  (c) some l^a || k has 2 l^a > J (X^P has vertices only, so chi(X^P) is 0 or m = k/l^a) and m != 1 (mod l), or
  (d) some l^a || k, with m = k/l^a <= MMAX, has no C_m-complex with faces of at most J // l^a points and chi = 1 (mod l)
      (cyclic_face_residue.R; Smith: chi(X) = chi(X^P) mod l, and X^P is such a complex on the m cosets), or
  (e) k <= MMAX and no C_k-complex with faces of at most J points has chi = 1 (directly)."""
import sys
from sympy import factorint, primerange
from cyclic_face_residue import R
MMAX = 21
LIM = 5000
cov, unc = [], []
for p in primerange(5, LIM):
    k = (p - 1) // 2; J = (3 * p * (p + 1) // 2 - 1) // (9 * p); f = factorint(k)
    if J == 0 or len(f) <= 1: how = 'a'
    elif any(l**a > J for l, a in f.items()): how = 'b'
    elif any(2 * l**a > J and (k // l**a - 1) % l for l, a in f.items()): how = 'c'
    elif any(k // l**a <= MMAX and R(k // l**a, J // l**a, l) is False for l, a in f.items()): how = 'd'
    elif k <= MMAX and R(k, J, 0) is False: how = 'e'
    else: how = None
    (cov if how else unc).append((p, k, J, how))
print(f"primes 5 <= p < {LIM}: {len(cov) + len(unc)} primes; L3 proved at {len(cov)}; open at {len(unc)}")
print("by case:", {c: sum(1 for x in cov if x[3] == c) for c in 'abcde'})
print("open:", [(p, k, J) for p, k, J, _ in unc[:20]])
