#!/usr/bin/env python3
"""join_close.py -- configurations with readings mod q1 q2 (one prime from each side's twist), closed by a join:
1 - chi(X * Y) = (1 - chi X)(1 - chi Y).  X on block A's classes (Z_kA, faces <= sA classes), Y on block B's
(Z_kB, faces <= sB), join faces of weight <= sA wA + sB wB <= T.  Search: chi X = 1 (mod qA) and chi Y = 1 (mod qB)
for some split of the primes of Q, by CP-SAT on each side (lemma_c_data.model).
usage: python3 join_close.py -> ../outputs/join_close.txt"""
import ast, sys
from ortools.sat.python import cp_model
sys.path.insert(0, '.')
from lemma_c_data import model
def hit(k, cap, q):
    if cap < 1: return q == 1
    M, psi = model(k, min(cap, k - 1)); z = M.NewIntVar(-10**6, 10**6, 'z'); M.Add(psi[1] - 1 == q * z)
    S = cp_model.CpSolver(); S.parameters.num_workers = 2; S.parameters.max_time_in_seconds = 120
    return S.Solve(M) in (cp_model.OPTIMAL, cp_model.FEASIBLE)
out = []
for l in open('../outputs/ws_budget_scan.txt').read().strip().split('\n')[2:]:
    n, T, a, dA, kA, wA, cA, b, dB, kB, wB, cB, ex, R = ast.literal_eval(l)
    if n not in (2412, 3586) or ex or len(R) != 2: continue
    q1, q2 = R; found = None
    for qa, qb in ((q1, q2), (q2, q1)):
        for sA in range(1, min(cA, kA - 1) + 1):
            sB = min((T - sA * wA) // wB, kB - 1)
            if sB < 1: break
            if hit(kA, sA, qa) and hit(kB, sB, qb): found = (qa, sA, qb, sB); break
        if found: break
    out.append((n, a, dA, kA, b, dB, kB, R, found)); print(out[-1], flush=True)
with open('../outputs/join_close.txt', 'w') as fh:
    for o in out: fh.write(f"{o}\n")
