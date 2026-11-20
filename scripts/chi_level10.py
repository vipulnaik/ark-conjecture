#!/usr/bin/env python3
"""chi_level10.py -- level 2 (m*_chi) at n = 10, at the budget B = mu*(10) = 20.

threshold-beyond-mu.md §1.4 defines, per Oliver group, the level-2 value m*_chi:
the least budget B at which some family of Gamma-invariant graphs, every one with at
most B edges, closed under isomorphism and EMBEDDING (a graph property's fixed
complex), meets the group's Euler-characteristic condition (chi = 1 for a trivial-top
reading, chi = 1 mod each listed top prime otherwise).  type_levels6.py computes it
at n = 6 by brute force over S_6; here nauty canonical forms (pynauty) and
networkx monomorphism tests replace that.

Feasibility is monotone in B, so one CP-SAT call at B = 20 decides whether
m*_chi(Gamma) <= 20.  A class with no feasible family at B = 20 has m*_chi > 20 =
mu*(10) and would make mu*_chi(10) > mu*_N(10).

Classes whose invariant graphs with at most 20 edges number more than CAP are
skipped and listed.

Second mode, --ladder LINE...: for the given lines of tom10.txt, try budgets
b = 4, 6, ..., B in turn (each with the CAP on invariant graphs) and stop at the
first feasible one.  Feasibility at b <= B already gives m*_chi <= b <= B, and the
small budgets keep the class count down for groups with many small orbitals.

usage: python3 chi_level10.py [CAP] [B]     (defaults 1000000, 20)
       python3 chi_level10.py --ladder LINE ... [--cap CAP]
"""
import sys, json, itertools, time
import pynauty, networkx as nx
from ortools.sat.python import cp_model

n = int(__import__('os').environ.get('CHI_N', 10))      # CHI_N=6 reruns the n = 6 check against type_levels6.py
TOM = f'../outputs/tom{n}.txt'
LADDER = '--ladder' in sys.argv
STEP = int(__import__('os').environ.get('CHI_STEP', 2))
if LADDER:
    _a = sys.argv[sys.argv.index('--ladder') + 1:]
    CAP = int(_a[_a.index('--cap') + 1]) if '--cap' in _a else 10**6
    LINES = [int(x) for x in _a if x.isdigit() and (('--cap' not in _a) or x != _a[_a.index('--cap') + 1])]
    B = 20
else:
    CAP = int(sys.argv[1]) if len(sys.argv) > 1 else 10**6
    B = int(sys.argv[2]) if len(sys.argv) > 2 else 20


def cert(edges):
    adj = {v: [] for v in range(n)}
    for a, b in edges:
        adj[a].append(b)
    return pynauty.certificate(pynauty.Graph(n, adjacency_dict=adj))


def subsets(sizes, B):
    """index tuples of orbital sets with total size <= B (DFS)"""
    t = len(sizes); out = []
    def rec(i, tot, cur):
        if i == t:
            if cur: out.append(tuple(cur))
            return
        rec(i + 1, tot, cur)
        if tot + sizes[i] <= B:
            cur.append(i); rec(i + 1, tot + sizes[i], cur); cur.pop()
    rec(0, 0, [])
    return out


def count(sizes, B):
    dp = [0] * (B + 1); dp[0] = 1
    for s in sizes:
        for v in range(B, s - 1, -1): dp[v] += dp[v - s]
    return sum(dp) - 1


# embedding test: emb.c (this directory), built once as a shared library
import ctypes, os, subprocess
_EN = 10 if n <= 10 else 16                  # emb.c's vertex count (16-bit rows): 10, or 16 for n = 11..16
_LIB = f'/tmp/libemb{_EN}.so'
if not os.path.exists(_LIB):
    subprocess.check_call(['gcc', '-O2', '-shared', '-fPIC', f'-DN={_EN}', '-o', _LIB,
                           os.path.join(os.path.dirname(os.path.abspath(__file__)), 'emb.c')])
_DLL = ctypes.CDLL(_LIB)
_emb = _DLL.embeds
_emb.argtypes = [ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort)]
_emb_lim = _DLL.embeds_lim
_emb_lim.argtypes = [ctypes.POINTER(ctypes.c_ushort), ctypes.POINTER(ctypes.c_ushort), ctypes.c_long]
_Arr = ctypes.c_ushort * _EN                 # smaller n is padded with isolated vertices


def adj_arr(g):
    return _Arr(*([sum(1 << u for u in g[v]) for v in range(n)] + [0] * (_EN - n)))


def embeds(ga, gb):
    """ga embeds in gb (an injective vertex map carrying edges to edges); emb.c"""
    return bool(_emb(adj_arr(ga), adj_arr(gb)))


def embeds_lim(ga, gb, limit):
    """as embeds, but False also when the search exceeds `limit` steps (sound only where a missed embedding is safe)"""
    return bool(_emb_lim(adj_arr(ga), adj_arr(gb), limit))


def degseq_ok(da, db):
    return all(x <= y for x, y in zip(da, db))


def analyse(orbs, exact, qs, B=None):
    B = B if B is not None else globals()['B']
    sizes = [len(o) for o in orbs]
    cls = {}                                  # certificate -> [sign sum, edges]
    for F in subsets(sizes, B):
        edges = [(a - 1, b - 1) for i in F for a, b in orbs[i]]
        c = cert(edges)
        s = 1 if len(F) % 2 else -1
        if c in cls: cls[c][0] += s
        else: cls[c] = [s, edges]
    keys = list(cls)
    G = []
    for k in keys:
        g = nx.Graph(); g.add_nodes_from(range(n)); g.add_edges_from(cls[k][1]); G.append(g)
    E = [g.number_of_edges() for g in G]
    D = [sorted((d for _, d in g.degree()), reverse=True) for g in G]
    # embedding poset, built upward with transitivity: candidates are tested largest
    # first, and everything below an embedded class is taken without a test
    order = sorted(range(len(keys)), key=lambda i: E[i])
    down = [0] * len(keys)                    # bitset of classes embedding in each
    below = [[] for _ in keys]
    for j in order:
        got = 0
        for i in sorted((i for i in range(len(keys)) if E[i] < E[j]), key=lambda i: -E[i]):
            if got >> i & 1:
                continue
            if degseq_ok(D[i], D[j]) and embeds(G[i], G[j]):
                got |= (1 << i) | down[i]
        down[j] = got
        below[j] = [i for i in range(len(keys)) if got >> i & 1]
    M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in keys]
    for j in range(len(keys)):
        for i in below[j]: M.AddImplication(X[j], X[i])
    chi = sum(cls[k][0] * X[i] for i, k in enumerate(keys))
    if exact: M.Add(chi == 1)
    else:
        for q in qs:
            z = M.NewIntVar(-10**6, 10**6, ''); M.Add(chi == 1 + q * z)
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 600; S.parameters.num_workers = 2
    st = S.Solve(M)
    return len(keys), {cp_model.OPTIMAL: 'feasible', cp_model.FEASIBLE: 'feasible',
                       cp_model.INFEASIBLE: 'INFEASIBLE'}.get(st, 'unknown')


if __name__ == '__main__':
    rows = []
    for idx, line in enumerate(open(TOM)):
        p = line.strip().split('|')
        if len(p) < 6: continue
        orbs = json.loads(p[5])
        fixed = sum(1 for x in range(1, n + 1)
                    if all(all(x in e for e in o) for o in orbs if any(x in e for e in o)))
        rows.append((idx, int(p[0]), p[2] == 'true', json.loads(p[3]), orbs, fixed))
    print(f"# n = 10, budget B = {B}, CAP = {CAP}; columns: line, order, fixed points, orbitals, "
          f"min orbital, invariant graphs <= B, iso classes, level-2 feasibility at B", flush=True)
    if LADDER:
        for idx, order, exact, qs, orbs, fixed in rows:
            if idx not in LINES: continue
            sizes = [len(o) for o in orbs]; found = None; t0 = time.time()
            for b in range(min(sizes), B + 1, STEP):
                c = count(sizes, b)
                if c > CAP: break
                k, res = analyse(orbs, exact, [] if exact else qs, b)
                if res == 'feasible': found = (b, c, k); break
            print(f"{idx} {order} {fixed} {len(orbs)} {min(sizes)} ladder: "
                  + (f"feasible at b = {found[0]} ({found[1]} graphs, {found[2]} classes)" if found
                     else f"not settled up to the cap (last b tried, {c} graphs)") + f" {time.time() - t0:.1f}s", flush=True)
        sys.exit()
    tally = {}; skipped = []
    rows.sort(key=lambda r: count([len(o) for o in r[4]], B))      # cheapest first
    for idx, order, exact, qs, orbs, fixed in rows:
        sizes = [len(o) for o in orbs]
        c = count(sizes, B)
        if c > CAP:
            skipped.append((idx, order, fixed, c)); continue
        t0 = time.time()
        k, res = analyse(orbs, exact, [] if exact else qs)
        tally[res] = tally.get(res, 0) + 1
        print(f"{idx} {order} {fixed} {len(orbs)} {min(sizes)} {c} {k} {res} {time.time() - t0:.1f}s", flush=True)
    print(f"# done: {tally}; skipped (more than CAP invariant graphs): {len(skipped)}")
    for s in skipped: print(f"# skipped line {s[0]}: order {s[1]}, {s[2]} fixed points, {s[3]} graphs")
