#!/usr/bin/env python3
"""crt_pure_check.py -- property (S) behind the CRT-product structure of chi residues.

Gluing lemma (proved in threshold-beyond-mu.md §6.5): for a C_k-complex X and a prime power q^b || k,
chi(X) = chi(X^{C_q}) (mod q^b).  So if, for each prime p | k, A_p is "p-pure" (no face is a union of
C_q-cosets for a prime q != p dividing k), then Delta = union of the A_p has chi(Delta) = chi(A_p) (mod p^a)
for every p, and the residues mod k realised are the full CRT product of the residues mod p^a of p-pure complexes.
Property (S): for every p | k, the residues mod p^a of p-pure complexes (within cap c) are ALL residues mod p^a
of complexes within cap c.  (S) for all p gives the CRT-product property.
usage: python3 crt_pure_check.py KMIN KMAX  -> ../outputs/crt_pure_check.txt"""
import sys
from sympy import factorint
from ortools.sat.python import cp_model
sys.path.insert(0, '.')
from lemma_c_data import orbits, model
def residues(k, c, p, pure):
    a = factorint(k)[p]; P = p ** a; out = set()
    qs = [q for q in factorint(k) if q != p]
    for r in range(P):
        M, psi = model(k, c)
        if pure:
            X = [v for v in M.Proto().variables]   # orbit variables are the first len(orbits) bool vars
            orbs = orbits(k, c)
            for i, (rr, f, sz, st) in enumerate(orbs):
                if any(st % q == 0 for q in qs): M.Add(M.GetBoolVarFromProtoIndex(i) == 0)
        z = M.NewIntVar(-10**6, 10**6, 'z'); M.Add(psi[1] - r == P * z)
        S = cp_model.CpSolver(); S.parameters.num_workers = 2; S.parameters.max_time_in_seconds = 60
        st = S.Solve(M)
        if st in (cp_model.OPTIMAL, cp_model.FEASIBLE): out.add(r)
        elif st != cp_model.INFEASIBLE: out.add(('?', r))
    return out
if __name__ == "__main__":
    for k in range(int(sys.argv[1]), int(sys.argv[2]) + 1):
        if len(factorint(k)) < 2: continue
        for c in range(2, k):
            for p in factorint(k):
                A = residues(k, c, p, False); Pu = residues(k, c, p, True)
                line = f"k={k} c={c} p={p}: all mod p^a {sorted(A, key=str)} ; p-pure {sorted(Pu, key=str)} ; (S) {'holds' if A == Pu else 'FAILS'}"
                print(line, flush=True)
                with open('../outputs/crt_pure_check.txt', 'a') as fh: fh.write(line + '\n')
