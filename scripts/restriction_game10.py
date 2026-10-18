"""restriction_game10.py -- pending-checks A36 / restriction-game.md section 6(a): the weighted restriction game at n.
Catalogue (graph world on n vertices, increasing convention):
  peel     I1 = (empty, K_{n-1} + isolated v)          value C_{n-1}  (given; = C(n-1,2) when n-1 is a prime power)
           I2 = (star K_{1,n-1}, K_n)                    value C_{n-1}
  bipart.  (K_m, K_m join the rest's empty graph), (K_m + K_{n-m}, K_n)   value m(n-m)   (Yao)
  orbital  (U, U + O) for every Oliver class of S_n in outputs/tomN.txt, every orbital O, every union U of the
           other orbitals                                value |O|   (transitive Oliver group on the free set)
By Theorem 1 the game's value is the largest v such that the intervals of value >= v contain a descent, decided by
the forcing closure: K_n is forced; an interval whose top contains a copy of a forced graph forces its bottom;
success iff the empty graph is forced.  Containment is subgraph monomorphism (networkx).  Orbital intervals are only
generated for |O| >= v, which keeps the catalogue finite at the thresholds tested.
Usage: python3 restriction_game10.py N C_{N-1} [VMIN]     e.g.  python3 restriction_game10.py 10 36 20"""
import sys, json, itertools
import networkx as nx
from networkx.algorithms.isomorphism import GraphMatcher
n, Cpeel = int(sys.argv[1]), int(sys.argv[2]); vmin = int(sys.argv[3]) if len(sys.argv) > 3 else 1
V = range(n); KN = frozenset(itertools.combinations(V, 2))
def gr(E):
    g = nx.Graph(); g.add_nodes_from(V); g.add_edges_from(E); return g
def contains(W, X):                      # does W contain a copy of X?
    if len(X) > len(W): return False
    if not X: return True
    dw = sorted((d for _, d in gr(W).degree()), reverse=True); dx = sorted((d for _, d in gr(X).degree()), reverse=True)
    if any(a < b for a, b in zip(dw, dx)): return False
    return GraphMatcher(gr(W), gr(X)).subgraph_is_monomorphic()
groups = []
for line in open(f'../outputs/tom{n}.txt'):
    order, trans, exact, qs, ntq, orbs = line.rstrip("\n").split("|")
    groups.append([frozenset(tuple(sorted((a - 1, b - 1))) for a, b in o) for o in json.loads(orbs)])
def catalogue(v):
    I = []
    if Cpeel >= v:
        I.append((frozenset(), frozenset(e for e in KN if 0 not in e), Cpeel, 'peel I1'))
        I.append((frozenset(e for e in KN if 0 in e), KN, Cpeel, 'peel I2'))
    for m in range(1, n):
        if m * (n - m) >= v:
            A = range(m); Km = frozenset(itertools.combinations(A, 2))
            cross = frozenset((a, b) for a in A for b in range(m, n))
            I.append((Km, Km | cross, m * (n - m), f'bip K{m}'))
            I.append((Km | frozenset(itertools.combinations(range(m, n), 2)), KN, m * (n - m), f'bip 2K'))
    for gi, orbs in enumerate(groups):
        for j, O in enumerate(orbs):
            if len(O) < v: continue
            rest = [orbs[k] for k in range(len(orbs)) if k != j]
            for r in range(len(rest) + 1):
                for S in itertools.combinations(rest, r):
                    U = frozenset().union(*S)
                    I.append((U, U | O, len(O), f'orb g{gi} |O|={len(O)}'))
    return I
def unavoidable(v):
    I = catalogue(v); forced = [KN]; why = {KN: None}; fired = [False] * len(I)
    changed = True
    while changed:
        changed = False
        for k, (U, W, val, tag) in enumerate(I):
            if fired[k]: continue
            src = next((X for X in forced if contains(W, X)), None)
            if src is None: continue
            fired[k] = True
            if any(contains(U, X) for X in forced):    # U already implied (a forced X inside U) -> nothing new
                continue
            forced = [X for X in forced if not contains(X, U)] + [U]   # keep minimal elements
            why[U] = (tag, val, src); changed = True
            if not U:
                chain = []; x = U
                while why.get(x): chain.append(why[x][:2]); x = why[x][2]
                return True, len(I), chain[::-1]
    return False, len(I), None
results = {}
for v in range(vmin, 46):
    ok, size, chain = unavoidable(v)
    print(f"threshold v = {v}: catalogue {size} intervals -> {'DESCENT' if ok else 'no descent'}" + (f"  {chain}" if ok else ''), flush=True)
    if not ok:
        print(f"game value V = {v - 1}"); break
