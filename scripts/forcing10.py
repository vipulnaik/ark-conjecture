#!/usr/bin/env python3
"""forcing10.py -- lower bounds on M*_OCR(10) from coupled fixed-complex conditions (burnside-ring-view.md §3).

For a budget B, take every Oliver class of S_10 (outputs/tom10.txt) whose invariant graphs with at most B edges
number at most CAP.  Variables: one per isomorphism class (nauty certificate) of such invariant graphs.  Constraints:
  - embedding closure among these classes (class A embeds in class C: x_C -> x_A);
  - each group's condition on its fixed complex: chi = sum of (-1)^(orbits - 1) over its invariant graphs in P,
    = 1 for an exact reading, = 1 mod each top prime otherwise.
These are necessary conditions on any property with e_max <= B, so INFEASIBLE at B proves M*_OCR(10) > B.
With --core, an infeasible run also extracts a minimal infeasible set of groups (CP-SAT assumption core, then
deletion), reported as (order, condition, sorted orbit sizes).
(Feasible proves nothing: the solution need not extend to a property.)  Reuses chi_level10.py's nauty certificates
and embedding test.  usage: [FORCING_N=6] python3 forcing10.py B [CAP=3000] [--core] -> appends to ../outputs/forcing<N>.txt
(FORCING_N=6 is the check against M*_OCR(6) = 9.)"""
import sys, os, json, time
N = int(os.environ.get('FORCING_N', 10)); os.environ['CHI_N'] = str(N)
sys.argv = [sys.argv[0]] + sys.argv[1:]
B = int(sys.argv[1]); CAP = int(sys.argv[2]) if len(sys.argv) > 2 else 3000
sys_argv = sys.argv; sys.argv = ['x']
import chi_level10 as C
sys.argv = sys_argv
import networkx as nx
from ortools.sat.python import cp_model
rows = []
for line in open(f'../outputs/tom{N}.txt'):
    p = line.strip().split('|')
    if len(p) < 6: continue
    orbs = json.loads(p[5]); sizes = [len(o) for o in orbs]
    if C.count(sizes, B) > CAP: continue
    rows.append((int(p[0]), p[2] == 'true', json.loads(p[3]), orbs))
cls = {}                       # cert -> index; graphs for embedding
graphs = []; E = []; D = []
conds = []
for order, exact, qs, orbs in rows:
    sizes = [len(o) for o in orbs]; terms = {}
    for F in C.subsets(sizes, B):
        edges = [(a - 1, b - 1) for i in F for a, b in orbs[i]]
        c = C.cert(edges)
        if c not in cls:
            cls[c] = len(graphs); g = nx.Graph(); g.add_nodes_from(range(N)); g.add_edges_from(edges)
            graphs.append(g); E.append(g.number_of_edges()); D.append(sorted((d for _, d in g.degree()), reverse=True))
        k = cls[c]; terms[k] = terms.get(k, 0) + (1 if len(F) % 2 else -1)
    conds.append((exact, qs, terms))
K = len(graphs)
M = cp_model.CpModel(); X = [M.NewBoolVar('') for _ in range(K)]
order_ = sorted(range(K), key=lambda i: E[i]); nrel = 0
for j in order_:
    for i in range(K):
        if E[i] < E[j] and C.degseq_ok(D[i], D[j]) and C.embeds(graphs[i], graphs[j]):
            M.AddImplication(X[j], X[i]); nrel += 1
CORE = '--core' in sys_argv
A = []
for exact, qs, terms in conds:
    a = M.NewBoolVar(''); A.append(a)
    chi = sum(v * X[k] for k, v in terms.items())
    if exact: M.Add(chi == 1).OnlyEnforceIf(a)
    else:
        for q in qs:
            z = M.NewIntVar(-10**6, 10**6, ''); M.Add(chi == 1 + q * z).OnlyEnforceIf(a)
    if not CORE: M.Add(a == 1)
if CORE: M.AddAssumptions(A)
S = cp_model.CpSolver(); S.parameters.max_time_in_seconds = 1800; S.parameters.num_workers = 2
t0 = time.time(); st = S.Solve(M)
res = {cp_model.OPTIMAL: 'feasible', cp_model.FEASIBLE: 'feasible', cp_model.INFEASIBLE: 'INFEASIBLE'}.get(st, 'unknown')
line = f"B={B} CAP={CAP}: {len(rows)} groups, {K} graph classes, {nrel} embedding relations -> {res} ({time.time()-t0:.0f}s)"
if CORE and res == 'INFEASIBLE':
    core = [A.index(l) if isinstance(l, int) is False else l for l in []]
    idx = [i for i, a in enumerate(A) if a.Index() in set(S.SufficientAssumptionsForInfeasibility())]
    def feas(sub):
        M.ClearAssumptions(); M.AddAssumptions([A[i] for i in sub])
        S2 = cp_model.CpSolver(); S2.parameters.max_time_in_seconds = 300; S2.parameters.num_workers = 2
        return S2.Solve(M) != cp_model.INFEASIBLE
    keep = list(idx)
    for i in list(keep):
        t = [j for j in keep if j != i]
        if not feas(t): keep = t
    line += f"; minimal infeasible set of {len(keep)} groups: " + str([(rows[i][0], 'exact' if rows[i][1] else 'mod ' + str(rows[i][2]), sorted(len(o) for o in rows[i][3])) for i in keep])
open(f'../outputs/forcing{N}.txt', 'a').write(line + '\n'); print(line)
