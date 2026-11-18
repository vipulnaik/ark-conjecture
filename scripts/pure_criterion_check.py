#!/usr/bin/env python3
"""pure_criterion_check.py -- the pure-piece sufficient condition for chi = 1, on the regular prime blocks of the
29 formerly-open pp+pp rows (threshold-beyond-mu.md §6.5, "Pure pieces").

Sufficient condition (proved): for each prime power l^e || k, a complex Z_l on Z_{k/l} within cap floor(c/l),
no face of which contains a C_{l'}-coset (l' != l a prime dividing k), with chi(Z_l) = 1 (mod l^e).
  e >= 2: the digit construction (levels Z_{u l^i}, u = k / l^e; start from the vertices of Z_u; at each level add
          j <= l - 1 free edge orbits, then pull back), checked for cap (2 l^(e-1) <= floor(c/l)) and room;
  e = 1:  if Z_m (m = k/l) has >= l - 1 free edge orbits and cap >= 2: the vertices of Z_m and then j <= l - 1
          free edge orbits (m is a unit mod l); otherwise CP-SAT on Z_m, m = k/l, over orbits of coset-free subsets of size <= min(cap, 6), chi = 1 (mod l).
If the pure condition fails and k is square-free, the split condition with q the largest prime is tried
(Lemma S: 1 - chi = (1 - x)(1 - y) for pull-backs from coprime Z_m and Z_q).  Then Lemma R (cap >= 3) gives chi = 1 exactly.  usage: python3 pure_criterion_check.py -> ../outputs/pure_criterion_check.txt"""
import itertools, sys
from sympy import factorint, divisors
from ortools.sat.python import cp_model
sys.path.insert(0, '.')
import io, contextlib
with contextlib.redirect_stdout(io.StringIO()):
    import room_check as RC
def coset_free(S, m, primes):
    T = set(S)
    for p in primes:
        if m % p: continue
        step = m // p
        for x in S:
            if all((x + step * i) % m in T for i in range(p)): return False
    return True
def eq1_check(m, cap, l, other, target=1):
    cap = min(cap, m - 1, 6)
    seen = set(); orbs = []
    for r in range(1, cap + 1):
        for f in itertools.combinations(range(m), r):
            if f in seen: continue
            o = {tuple(sorted((x + i) % m for x in f)) for i in range(m)}; seen |= o
            if coset_free(f, m, other): orbs.append((r, f, len(o), o))
    idx = {}
    for i, (r, f, sz, o) in enumerate(orbs):
        for g in o: idx[g] = i
    M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in orbs]
    for i, (r, f, sz, o) in enumerate(orbs):
        if r > 1:
            for g in itertools.combinations(f, r - 1): M.AddImplication(X[i], X[idx[g]])
    chi = sum((-1) ** (r - 1) * sz * X[i] for i, (r, f, sz, o) in enumerate(orbs))
    z = M.NewIntVar(-10**7, 10**7, 'z'); M.Add(chi - target == l * z)
    S = cp_model.CpSolver(); S.parameters.num_workers = 2; S.parameters.max_time_in_seconds = 120
    st = S.Solve(M)
    return {cp_model.OPTIMAL: True, cp_model.FEASIBLE: True, cp_model.INFEASIBLE: False}.get(st, None)
def digit_check(k, l, e, cap):
    """levels n_i = u l^i, i = 0..e-1: at most l - 1 free edge orbits added per level; edge orbits present at level i
    are bounded by E_i <= l E_{i-1} + floor(l/2) + (l - 1) (lifts of the level below, edges inside fibres, the new ones)"""
    u = k // l ** e
    if 2 * l ** (e - 1) > cap: return False, f'cap {cap} < 2 l^(e-1) = {2 * l ** (e - 1)}'
    E = 0
    for i in range(e):
        n = u * l ** i
        if i: E = l * E + l // 2
        if (n - 1) // 2 - E < l - 1: return False, f'level Z_{n}: {(n - 1) // 2} free edge orbits, {E} possibly used'
        E += l - 1
    return True, f'digits over Z_{u}..Z_{k // l}'
def any_complex_mod(m, cap, q, target=1):
    """CP-SAT: some C_m-complex on Z_m (faces <= min(cap, 6) points) with chi = target (mod q)"""
    return eq1_check(m, cap, q, [], target)
def split_check(k, q, c):
    """k = m q, gcd(m, q) = 1: X on Z_m (cap floor(c/q)) with chi = 1 (mod q), Y on Z_q (cap floor(c/m)) with
    chi = 1 (mod m) from vertices and edges (values q(1 - j), 0 <= j <= (q-1)/2); then 1 - chi = (1 - x)(1 - y) = 0 mod k"""
    m = k // q
    ys = [q * (1 - j) for j in range(0, (q - 1) // 2 + 1)] if c // m >= 2 else [q]
    if not any((y - 1) % m == 0 for y in ys): return False, 'no Y'
    g = any_complex_mod(m, c // q, q)
    return bool(g), f'split Z_{m} x Z_{q}: X on Z_{m} with chi = 1 mod {q} ({g}), Y from edges'
out = []; seen = set()
for (n, T, P, k, c, f, ok, notes) in RC.res:
    if (k, c) in seen: continue
    seen.add((k, c)); ps = list(factorint(k)); verdict = True; detail = []
    for l, e in factorint(k).items():
        other = [p for p in ps if p != l]; capl = c // l
        if e >= 2:
            g, why = digit_check(k, l, e, capl)
        elif (k // l - 1) // 2 >= l - 1 and capl >= 2:
            g, why = True, f'edges on Z_{k // l}: vertices, then j <= {l - 1} free edge orbits'
        else:
            g = eq1_check(k // l, capl, l, other); why = f'CP-SAT on Z_{k // l} (cap {min(capl, 6)})'
        detail.append((l, e, g, why)); verdict = verdict and bool(g)
    if not verdict and all(e == 1 for e in factorint(k).values()):
        q = max(ps); g, why = split_check(k, q, c); detail.append(('split', q, g, why)); verdict = g
    out.append((n, P, k, c, verdict, detail)); print(out[-1], flush=True)
with open('../outputs/pure_criterion_check.txt', 'w') as fh:
    fh.write(f"distinct (k, cap) among the regular prime blocks: {len(out)}; condition met: {sum(o[4] for o in out)}\n")
    for o in out: fh.write(f"{o}\n")
