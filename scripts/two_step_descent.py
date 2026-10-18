"""two_step_descent.py -- the two-step descent of restriction-game.md section 6a, at any degree with group data.
For Oliver groups G1, G2 on n points (from an oliver_tom.g export) with orbitals O1 of G1 and O2 of G2: if the
complement K_n - O1 (a union of G1-orbitals) embeds in O2, every nontrivial monotone graph property f has
D(f) >= min(|O1|, |O2|): f(K_n - O1) = 0 gives the interval (K_n - O1, K_n) with free set O1, and f(K_n - O1) = 1
gives f(O2) = 1, hence the interval (empty, O2).  Prints the best such bound.
Usage: python3 two_step_descent.py N ../outputs/transN.txt [../outputs/tomN.txt ...]"""
import sys, json, itertools
import networkx as nx
from networkx.algorithms.isomorphism import GraphMatcher
n = int(sys.argv[1]); orbs = []
for path in sys.argv[2:]:
    for line in open(path):
        f = line.rstrip("\n").split("|")
        for o in json.loads(f[5]):
            orbs.append(frozenset(tuple(sorted((a - 1, b - 1))) for a, b in o))
KN = frozenset(itertools.combinations(range(n), 2)); M = len(KN)
orbs = sorted(set(orbs), key=len, reverse=True)
def g(E):
    G = nx.Graph(); G.add_nodes_from(range(n)); G.add_edges_from(E); return G
def embeds(X, W):
    if len(X) > len(W): return False
    dw = sorted((d for _, d in g(W).degree()), reverse=True); dx = sorted((d for _, d in g(X).degree()), reverse=True)
    if any(a < b for a, b in zip(dw, dx)): return False
    return GraphMatcher(g(W), g(X)).subgraph_is_monomorphic()
best = (0, None)
for O1 in orbs:
    if len(O1) <= best[0]: break
    R = KN - O1
    for O2 in orbs:
        v = min(len(O1), len(O2))
        if v <= best[0]: break
        if embeds(R, O2): best = (v, (len(O1), len(O2), len(R))); break
print(f"n = {n}: {len(orbs)} distinct orbitals; best two-step bound D >= {best[0]} of {M}"
      + (f"  (|O1| = {best[1][0]}, |O2| = {best[1][1]}, complement {best[1][2]} edges)" if best[1] else ""))
