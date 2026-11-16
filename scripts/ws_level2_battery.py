#!/usr/bin/env python3
"""ws_level2_battery.py -- level 2 and the full Oliver battery for the two degree-14 groups that the
weakly-symmetric scan leaves open, 14T10 = PSL(3,2) and 14T30 = PSL(2,13) (threshold-beyond-mu.md
section 13).  Input /tmp/ws/g14.txt from ws_level2_battery.g.

The unknown is the G-invariant monotone property P itself: one variable per G-orbit on subsets of
the 14 coordinates, closed downward, empty set in, full set out.  For an Oliver subgroup H, the
fixed complex Delta_P^H is the H-invariant members of P, and chi(Delta_P^H) is linear in the
variables.  So
  level 2, one group H:  is there a P meeting H's condition?   (no -> G settled by H alone)
  the battery:           is there a P meeting every Oliver H's condition at once?
                          (no -> no G-invariant property is Oliver-chi-resistant: G settled)
and when the battery is feasible, the least e_max (largest member size) is M*_OCR for G.
"""
import json, itertools
from ortools.sat.python import cp_model
N = 14; FULL = (1 << N) - 1
lines = [l.strip().split('|') for l in open('/tmp/ws/g14.txt')]
for k in (10, 30):
    gens = [[x - 1 for x in g] for t, kk, g in [l for l in lines if l[0] == 'G' and l[1] == str(k)] for g in json.loads(g)]
    act = lambda g, S: sum(1 << g[i] for i in range(N) if S >> i & 1)
    orb = {}; reps = []
    for S in range(FULL + 1):
        if S in orb: continue
        o = {S}; st = [S]
        while st:
            x = st.pop()
            for g in gens:
                y = act(g, x)
                if y not in o: o.add(y); st.append(y)
        for y in o: orb[y] = len(reps)
        reps.append(S)
    nv = len(reps); size = [bin(S).count('1') for S in reps]
    Hs = [(int(l[2]), l[3] == 'true', json.loads(l[4]), [[x - 1 for x in o] for o in json.loads(l[5])])
          for l in lines if l[0] == 'H' and l[1] == str(k)]
    def model(which, emax=None):
        M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in range(nv)]
        M.Add(X[orb[0]] == 1); M.Add(X[orb[FULL]] == 0)
        for v, S in enumerate(reps):
            for i in range(N):
                if S >> i & 1: M.AddImplication(X[v], X[orb[S ^ (1 << i)]])
            if emax is not None and size[v] > emax: M.Add(X[v] == 0)
        for order, exact, qs, orbs in which:
            t = len(orbs); masks = [sum(1 << x for x in o) for o in orbs]
            terms = {}
            for F in range(1, 1 << t):
                S = sum(masks[j] for j in range(t) if F >> j & 1)
                terms[orb[S]] = terms.get(orb[S], 0) + (1 if bin(F).count('1') % 2 else -1)
            chi = sum(c * X[v] for v, c in terms.items())
            if exact: M.Add(chi == 1)
            for q in qs:
                z = M.NewIntVar(-10 ** 6, 10 ** 6, ''); M.Add(chi == 1 + q * z)
        S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 300; S.parameters.num_workers = 2
        r = S.Solve(M)
        return {cp_model.OPTIMAL: 'feasible', cp_model.FEASIBLE: 'feasible', cp_model.INFEASIBLE: 'INFEASIBLE'}.get(r, 'unknown')
    print(f"14T{k}: {nv} G-orbits on subsets, {len(Hs)} Oliver subgroup classes")
    single = [model([H]) for H in Hs]
    print(f"  level 2, one group at a time: settled by {sum(r == 'INFEASIBLE' for r in single)} classes "
          f"({[(H[0], len(H[3])) for H, r in zip(Hs, single) if r == 'INFEASIBLE']})")
    bat = model(Hs)
    print(f"  battery of all {len(Hs)} classes at once: {bat}")
    if bat == 'feasible':
        lo = next(e for e in range(N) if model(Hs, e) == 'feasible')
        print(f"  least e_max of an Oliver-chi-resistant 14T{k}-invariant property (M*_OCR): {lo} of {N}")
