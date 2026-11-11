#!/usr/bin/env python3
"""type_levels6.py -- the per-group quantities of `threshold-beyond-mu.md` at n = 6.

For each of the 50 Oliver subgroup classes of S_6 (outputs/tom6.txt) compute
  m*      the smallest orbital;
  m*_typ  the smallest total of an N*-orbit of orbitals (a "type"), N* being the
          permutations of [6] that carry every orbital onto an orbital;
  m*_N    the least budget B at which some N*-invariant family of sets of
          orbitals, closed under subsets, not containing the set of all
          orbitals, every member of union size <= B, has Euler characteristic
          meeting the group's condition (level 1);
  m*_chi  the same with the family closed under ISOMORPHISM AND EMBEDDING of the
          union graphs -- exactly the fixed complexes of graph properties
          (level 2).
The condition is chi = 1 for a group with a trivial-top reading, and chi = 1
modulo each listed top prime otherwise.  Feasibility by CP-SAT (needs ortools).

Usage: python3 type_levels6.py          (run from scripts/; about a minute)
"""
import itertools, json, sys
from ortools.sat.python import cp_model

N = 6
PAIRS = list(itertools.combinations(range(1, N + 1), 2)); IDX = {p: i for i, p in enumerate(PAIRS)}
PERMS = []
for s in itertools.permutations(range(1, N + 1)):
    PERMS.append([IDX[tuple(sorted((s[a - 1], s[b - 1])))] for a, b in PAIRS])
def ap(q, m):
    x = 0
    while m:
        b = m & -m; x |= 1 << q[b.bit_length() - 1]; m ^= b
    return x
_canon = {}
def canon(m):
    if m not in _canon:
        _canon[m] = min(ap(q, m) for q in PERMS)
    return _canon[m]
_emb = {}
def embeds(a, b):          # canonical forms; a embeds in b
    if (a, b) not in _emb:
        _emb[(a, b)] = any(ap(q, a) & ~b == 0 for q in PERMS)
    return _emb[(a, b)]

def solve(classes, below, cond, must_exclude):
    """classes: list of (sign_sum, key); below[i]: indices that must be in if i is."""
    M = cp_model.CpModel(); X = [M.NewBoolVar(str(i)) for i in range(len(classes))]
    for i in range(len(classes)):
        for j in below[i]: M.AddImplication(X[i], X[j])
    for i in must_exclude: M.Add(X[i] == 0)
    chi = sum(c[0] * X[i] for i, c in enumerate(classes))
    exact, qs = cond
    if exact: M.Add(chi == 1)
    else:
        for q in qs:
            z = M.NewIntVar(-10**6, 10**6, f"z{q}"); M.Add(chi == 1 + q * z)
    S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 120
    return S.Solve(M) in (cp_model.OPTIMAL, cp_model.FEASIBLE)

def analyse(orbitals, cond, BMAX=15):
    t = len(orbitals); full = (1 << t) - 1
    size = [bin(o).count("1") for o in orbitals]
    # N*: permutations carrying each orbital to an orbital, as permutations of orbital indices
    oset = {o: i for i, o in enumerate(orbitals)}
    nstar = set()
    for q in PERMS:
        img = [oset.get(ap(q, o)) for o in orbitals]
        if None not in img: nstar.add(tuple(img))
    # types
    typ = list(range(t))
    for g in nstar:
        for i in range(t):
            a, b = typ[i], typ[g[i]]
            if a != b: typ = [a if x == b else x for x in typ]
    tot = {}
    for i in range(t): tot[typ[i]] = tot.get(typ[i], 0) + size[i]
    m_star, m_typ = min(size), min(tot.values())
    subsets = [(F, sum(size[i] for i in range(t) if F >> i & 1)) for F in range(1, full + 1)]
    def union(F):
        u = 0
        for i in range(t):
            if F >> i & 1: u |= orbitals[i]
        return u
    def actF(g, F):
        x = 0
        for i in range(t):
            if F >> i & 1: x |= 1 << g[i]
        return x
    out = {}
    for level in (1, 2):
        ans = None
        for B in range(m_star, BMAX + 1):
            faces = [F for F, s in subsets if s <= B]
            if level == 1:
                key = {F: min(actF(g, F) for g in nstar) for F in faces}
            else:
                key = {F: canon(union(F)) for F in faces}
            keys = sorted(set(key.values())); kid = {k: i for i, k in enumerate(keys)}
            sgn = [0] * len(keys)
            for F in faces: sgn[kid[key[F]]] += 1 if bin(F).count("1") % 2 else -1
            below = [set() for _ in keys]
            if level == 1:
                for F in faces:
                    for i in range(t):
                        if F >> i & 1 and F ^ (1 << i): below[kid[key[F]]].add(kid[key[F ^ (1 << i)]])
            else:
                for a in keys:
                    for b in keys:
                        if a != b and bin(a).count("1") <= bin(b).count("1") and embeds(a, b):
                            below[kid[b]].add(kid[a])
            excl = [kid[key[full]]] if full in key else []
            if solve([(sgn[i], keys[i]) for i in range(len(keys))], below, cond, excl):
                ans = B; break
        out[level] = ans
    return t, len(set(typ)), m_star, m_typ, out[1], out[2]

if __name__ == "__main__":
    rows = []
    for line in open("../outputs/tom6.txt"):
        p = line.strip().split("|")
        if len(p) < 6: continue
        exact = p[2] == "true"; qs = json.loads(p[3])
        orbs = [sum(1 << IDX[tuple(e)] for e in o) for o in json.loads(p[5])]
        rows.append((int(p[0]), p[1] == "true", exact, qs, orbs))
    print("order trans exact  t types  m*  m*_typ  m*_N  m*_chi")
    best = {}
    for order, tr, exact, qs, orbs in sorted(rows, key=lambda r: len(r[4])):
        t, nt, a, b, c, d = analyse(orbs, (exact, [] if exact else qs))
        print(f"{order:5d} {str(tr):5s} {str(exact):5s} {t:2d} {nt:5d} {a:4d} {b:6d} {str(c):>5s} {str(d):>6s}", flush=True)
        for k, v in (("mu*", a), ("mu*_typ", b), ("mu*_N", c), ("mu*_chi", d)):
            if v is not None: best[k] = max(best.get(k, 0), v)
    print("maxima over the 50 classes:", best)
