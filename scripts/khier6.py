#!/usr/bin/env python3
"""khier6.py -- the k-ladder between mu*_chi and M*_OCR at n = 6.
M_k(n) = max over sets of at most k trivial-top Oliver classes of the least e_max of a
graph property meeting chi = 1 at every class in the set.  M_1 = mu*_chi, and M_k = M*_OCR
once k reaches the number of classes.  Reuses burnside_ocr.py's model (marks from
/tmp/marks_6.txt).  Also lists every minimal infeasible set at each budget below M*_OCR."""
import sys, itertools
sys.argv = ['x', '6']
src = open('burnside_ocr.py').read()
exec(src[:src.index("tt = [g for g in groups")])
exec(src[src.index("def feasible"):src.index("ocr = least_B")])
tt = [g for g in groups if g[1]]
gi = [i + 1 for i, g in enumerate(groups) if g[1]]
lab = lambda j: f"{tt[j][0]}{'T' if tt[j][2] else ''}#{gi[j]}"
T = range(len(tt))
out = []
for B in range(5, 9):
    bad1 = [j for j in T if not feasible([tt[j][3]], B)]
    ok = [j for j in T if j not in bad1]
    bad2 = [(a, b) for a, b in itertools.combinations(ok, 2) if not feasible([tt[a][3], tt[b][3]], B)]
    s2 = set(bad2)
    bad3 = [t for t in itertools.combinations(ok, 3)
            if not any(p in s2 for p in itertools.combinations(t, 2))
            and not feasible([tt[j][3] for j in t], B)]
    allf = feasible([tt[j][3] for j in ok], B)
    out.append(f"B = {B}: infeasible singles {len(bad1)}; minimal infeasible pairs {len(bad2)}; "
               f"minimal infeasible triples {len(bad3)}; all {len(ok)} remaining classes together: "
               + ('feasible' if allf else 'INFEASIBLE'))
    if bad2: out.append("   pairs: " + ', '.join(f"({lab(a)}, {lab(b)})" for a, b in bad2))
    if bad3: out.append("   triples: " + ', '.join('(' + ', '.join(lab(j) for j in t) + ')' for t in bad3))
out.append("labels: order, T if transitive, GAP subgroup-class index of S_6")
open('../outputs/khier6.txt', 'w').write('\n'.join(out) + '\n'); print('\n'.join(out))
