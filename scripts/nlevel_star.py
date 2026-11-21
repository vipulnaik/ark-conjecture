#!/usr/bin/env python3
"""nlevel_star.py -- N-level coupling through one subgroup H (a 'star').

Every overgroup K of H has its fixed complex inside H's: K-invariant graphs are
H-invariant, and Delta^K = (Delta^H) restricted to K-invariant faces.  So a coupled
N-level system for H and any set of overgroups K lives on the 2^t(H) H-invariant
labelled graphs, however large n is.  Constraints, for H and each chosen K:
  - down-closure inside the complex (remove one K-orbit of edges),
  - invariance under the elements of N(H) that normalise K (dropping normaliser
    elements only weakens the system, so infeasibility stays sound),
  - chi = 1 (all groups p-by-cyclic: exact readings).
K_n excluded; faces of at most B edges.  Infeasibility at B is a necessary-condition
proof that M*_OCR(n) > B (every real property restricts to such a system).
input: a GAP export (lines 'N order [gens]' for N(H), then 'K order transitive [reading] [gens]'
for the overgroups, the first of which is H itself; reading 'e' = chi = 1, 'q2,3' = chi = 1 mod 2 and mod 3,
absent = 'e').
usage: python3 nlevel_star.py FILE n B [B ...]   [--core]"""
import sys, itertools
from ortools.sat.python import cp_model
args = [a for a in sys.argv[1:] if not a.startswith('--')]
F, n, Bs = args[0], int(args[1]), [int(b) for b in args[2:]]
E = list(itertools.combinations(range(n), 2)); m = len(E); EI = {e: i for i, e in enumerate(E)}
def comp(a, b): return tuple(a[b[i]] for i in range(n))
def inv(p):
    q = [0] * n
    for i, x in enumerate(p): q[x] = i
    return tuple(q)
def gclose(gens):
    G = {tuple(range(n))}; fr = list(G)
    while fr:
        x = fr.pop()
        for g in gens:
            y = comp(g, x)
            if y not in G: G.add(y); fr.append(y)
    return frozenset(G)
def emask(p, g):
    r = 0
    for i, (a, b) in enumerate(E):
        if g >> i & 1: r |= 1 << EI[tuple(sorted((p[a], p[b])))]
    return r
def orbits(G):
    seen = 0; out = []
    for i in range(m):
        if seen >> i & 1: continue
        o = 0
        for h in G: o |= emask(h, 1 << i)
        seen |= o; out.append(o)
    return out
NG, Ks = None, []
for l in open(F):
    tag, rest = l.split(' ', 1)
    if tag == 'N':
        o, gens = rest.split(' ', 1); NGgens = [tuple(x - 1 for x in g) for g in eval(gens)]; NG = gclose(NGgens)
    else:
        o, tr, gens = rest.split(' ', 2)
        rd = 'e'
        if gens[0] in 'eq':                      # optional reading field: 'e' exact, or 'q2,3' (chi = 1 mod 2 and mod 3)
            rd, gens = gens.split(' ', 1)
        Ks.append((int(o), tr == 'true', gclose([tuple(x - 1 for x in g) for g in eval(gens)]), rd))
info = []
for o, tr, K, rd in Ks:
    if all(comp(comp(p, k), inv(p)) in K for p in NGgens for k in K):
        gens = NGgens                            # K is normal in N(H): its normaliser there is all of it
    else:
        nk = [p for p in NG if frozenset(comp(comp(p, k), inv(p)) for k in K) == K]
        gens, cl = [], gclose([])
        for p in nk:
            if p not in cl: gens.append(p); cl = gclose(gens)
    info.append((o, tr, orbits(K), gens, rd))

def feasible(sel, B):
    M = cp_model.CpModel(); X = {}
    def x(g):
        if g not in X:
            X[g] = M.NewBoolVar('')
            if bin(g).count('1') > B or g == (1 << m) - 1: M.Add(X[g] == 0)
        return X[g]
    for j in sel:
        o, tr, orbs, gens, rd = info[j]; t = len(orbs); terms = []
        for k in range(1, 1 << t):
            g = 0
            for i in range(t):
                if k >> i & 1: g |= orbs[i]
            if bin(g).count('1') > B: continue
            terms.append((1 if bin(k).count('1') % 2 else -1, x(g)))
            for i in range(t):
                if k >> i & 1 and k != 1 << i: M.AddImplication(x(g), x(g & ~orbs[i]))
            for p in gens: M.Add(x(g) == x(emask(p, g)))
        chi = sum(s * v for s, v in terms)
        if rd == 'e': M.Add(chi == 1)
        else:
            for q in map(int, rd[1:].split(',')):
                z = M.NewIntVar(-10**6, 10**6, ''); M.Add(chi == 1 + q * z)
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 300; S.parameters.num_workers = 2
    st = S.Solve(M)
    return {cp_model.OPTIMAL: True, cp_model.FEASIBLE: True, cp_model.INFEASIBLE: False}.get(st, None)

lab = lambda j: f"{info[j][0]}{'T' if info[j][1] else ''}{'' if info[j][4] == 'e' else '/' + info[j][4]}"
ALL = list(range(len(info)))
print(f"# {F}: H of order {info[0][0]} with {len(info[0][2])} orbitals; {len(info)} groups (H and the p-by-cyclic overgroups supplied)")
if "--noalone" not in sys.argv: print("# alone, least B: " + ', '.join(f"{lab(j)}:{next((B for B in range(1, m + 1) if feasible([j], B)), None)}" for j in ALL), flush=True)
for B in Bs:
    r = feasible(ALL, B); print(f"B = {B}: all together -> {'feasible' if r else 'INFEASIBLE' if r is False else 'unknown'}", flush=True)
    if r is False and '--core' in sys.argv:
        keep = list(ALL)
        for j in list(keep):
            tr = [i for i in keep if i != j]
            if feasible(tr, B) is False: keep = tr
        print(f"   minimal infeasible set: {[lab(j) for j in keep]}", flush=True)
