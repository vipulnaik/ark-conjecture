#!/usr/bin/env python3
"""core_gluing_check.py -- the core-based gluing for the CRT-product property.

Facts used (threshold-beyond-mu.md section 7):
 (i)  chi(Delta) = chi(Delta^{C_p}) (mod p^a), and Delta^{C_p} is a complex on Z_{k/p} (cap floor(c/p));
      every complex Y on Z_{k/p} arises, as pi_p^{-1}(Y)^{C_p} = Y.  So R(k, c) mod p^a = { chi(Y) mod p^a }.
 (ii) For Delta = union over primes p of pi_p^{-1}(Y_p):  Delta^{C_p} = Y_p  union  W_p, where W_p is the union
      over p' != p of pi_p^{-1}(Y_p')^{C_p}, a complex on Z_{k/p}.  If W_p is contained in Y_p for every p, then
      chi(Delta) = chi(Y_p) (mod p^a) for every p.
Test: for every tuple of residues (r_p) with r_p in R(k, c) mod p^a, is there a family (Y_p) with W_p in Y_p and
chi(Y_p) = r_p (mod p^a)?  W_p is computed explicitly (faces of Delta^{C_p} as sets of C_p-cosets).
usage: python3 core_gluing_check.py k [k ...]  -> ../outputs/core_gluing_check.txt"""
import sys, itertools
from sympy import factorint
sys.path.insert(0, '.')
from gluing_check import all_complexes, pullback
def fixed_on_cosets(faces, k, p):
    """the C_p-invariant faces of a complex on Z_k, as sets of C_p-cosets = points of Z_{k/p} (coset of x: x mod k/p)"""
    m = k // p; out = set()
    for S in faces:
        T = frozenset(S)
        if all(frozenset((x + m) % k for x in S) == T for _ in [0]):
            out.add(frozenset(x % m for x in S))
    return out
def chi(faces): return sum((-1) ** (len(S) - 1) for S in faces)
if __name__ == "__main__":
    for k in map(int, sys.argv[1:]):
        f = factorint(k); ps = list(f)
        if len(ps) < 2: continue
        for c in range(2, k):
            C = {p: all_complexes(k // p, c // p) for p in ps}
            R = {p: {chi(Y) % p ** f[p] for Y in C[p]} for p in ps}
            PB = {p: [pullback(Y, k, k // p) for Y in C[p]] for p in ps}
            realised = set()
            for idx in itertools.product(*[range(len(C[p])) for p in ps]):
                ok = True
                for i, p in enumerate(ps):
                    Yp = {frozenset(F) for F in C[p][idx[i]]}
                    W = set()
                    for j, q in enumerate(ps):
                        if q != p: W |= fixed_on_cosets(PB[q][idx[j]], k, p)
                    if not W <= Yp: ok = False; break
                if ok:
                    realised.add(tuple(chi(C[p][idx[i]]) % p ** f[p] for i, p in enumerate(ps)))
            target = set(itertools.product(*[sorted(R[p]) for p in ps]))
            miss = sorted(target - realised)
            line = f"k={k} c={c} per-prime residues {[sorted(R[p]) for p in ps]} ; core gluing reaches {len(realised & target)} of {len(target)} ; missing {miss}"
            print(line, flush=True)
            with open('../outputs/core_gluing_check.txt', 'a') as fh: fh.write(line + '\n')
