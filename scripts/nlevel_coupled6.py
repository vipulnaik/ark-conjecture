#!/usr/bin/env python3
"""nlevel_coupled6.py -- a coupled hierarchy at the N level (n = 6).

Level 1 (mu*_N) gives each Oliver group Gamma its own complex: an N(Gamma)-invariant
simplicial complex on the Gamma-orbits of edges, faces of at most B edges, meeting
Gamma's chi condition.  Coupling at the N level: variables are LABELLED graphs, so a
graph invariant under two of the chosen groups is one variable for both.  For each
chosen group H (all its conjugates, or one representative):
  - down-closure inside H's complex (remove one H-orbit of edges),
  - N(H)-invariance,
  - chi of H's complex = 1 (all chosen classes are p-by-cyclic: exact readings).
No isomorphism-closure beyond normalisers and no embedding through non-invariant
graphs: that is what separates this from the chi level (M*_OCR).  K_6 is excluded.
The trivial group is special: its complex is a whole graph property, so including it
collapses the system onto M*_OCR; it is reported separately.

usage: python3 nlevel_coupled6.py      (reads /tmp/gens_6.txt from GAP; see khier6 notes)
"""
import itertools, sys
from ortools.sat.python import cp_model
n = 6
E = list(itertools.combinations(range(n), 2)); m = len(E); EI = {e: i for i, e in enumerate(E)}
P = list(itertools.permutations(range(n)))
def comp(a, b): return tuple(a[b[i]] for i in range(n))
def gclose(gens):
    G = {tuple(range(n))}; fr = list(G)
    while fr:
        x = fr.pop(); 
        for g in gens:
            y = comp(g, x)
            if y not in G: G.add(y); fr.append(y)
    return frozenset(G)
def emask(p, g):        # image of edge mask g under vertex perm p
    r = 0
    for i, (a, b) in enumerate(E):
        if g >> i & 1: r |= 1 << EI[tuple(sorted((p[a], p[b])))]
    return r
classes = []
for l in open('/tmp/gens_6.txt'):
    idx, order, tt, gens = l.split(' ', 3)
    gens = [tuple(x - 1 for x in g) for g in eval(gens)]
    classes.append((int(idx), int(order), tt == 'true', gclose(gens)))
def inv(p):
    q = [0] * n
    for i, x in enumerate(p): q[x] = i
    return tuple(q)
def conjugates(G):
    out = set()
    for p in P:
        pi = inv(p); out.add(frozenset(comp(comp(p, g), pi) for g in G))
    return list(out)
cache = {}
def data(H):
    if H in cache: return cache[H]
    seen = 0; orbs = []
    for i in range(m):
        if seen >> i & 1: continue
        o = 0
        for h in H: o |= emask(h, 1 << i)
        seen |= o; orbs.append(o)
    NHall = [p for p in P if frozenset(comp(comp(p, h), inv(p)) for h in H) == H]
    NH, cl = [], gclose([])                      # a generating set of N(H) suffices
    for p in NHall:
        if p not in cl: NH.append(p); cl = gclose(NH)
    cache[H] = (orbs, NH); return cache[H]

def feasible(groups, B, allconj=True):
    M = cp_model.CpModel(); X = {}
    def x(g):
        if g not in X:
            X[g] = M.NewBoolVar('')
            if bin(g).count('1') > B or g == (1 << m) - 1: M.Add(X[g] == 0)
        return X[g]
    Hs = []
    for G in groups:
        Hs += conjugates(G) if allconj else [G]
    for H in set(Hs):
        orbs, NH = data(H); t = len(orbs); terms = []
        for k in range(1, 1 << t):
            g = 0
            for j in range(t):
                if k >> j & 1: g |= orbs[j]
            if bin(g).count('1') > B: continue
            terms.append((1 if bin(k).count('1') % 2 else -1, x(g)))
            for j in range(t):
                if k >> j & 1 and k != 1 << j:
                    h = g & ~orbs[j]
                    M.AddImplication(x(g), x(h))
            for p in NH:
                M.Add(x(g) == x(emask(p, g)))
        M.Add(sum(s * v for s, v in terms) == 1)
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 300; S.parameters.num_workers = 2
    st = S.Solve(M)
    return {cp_model.OPTIMAL: True, cp_model.FEASIBLE: True, cp_model.INFEASIBLE: False}.get(st, None)

if __name__ == '__main__':
    tt = [c for c in classes if c[2]]
    lab = lambda c: f"{c[1]}{'' }#{c[0]}"
    out = []
    per = []
    for c in tt:
        if c[1] == 1: per.append((6, '1#1 (G*(6))')); continue
        b = next(B for B in range(1, m) if feasible([c[3]], B))
        per.append((b, lab(c)))
    out.append("per class (least B, k = 1; max is mu*_N(6)): " + str(sorted(per, reverse=True)))
    nt = [c for c in tt if c[1] > 1]
    for allc in (False, True):
        b = next(B for B in range(1, m + 1) if feasible([c[3] for c in nt], B, allc))
        out.append(f"all {len(nt)} nontrivial p-by-cyclic classes coupled ({'all conjugates' if allc else 'one representative each'}): least B = {b}")
    print('\n'.join(out)); open('../outputs/nlevel_coupled6.txt', 'w').write('\n'.join(out) + '\n')
