#!/usr/bin/env python3
# nlevel_coupled6_core.py -- minimal infeasible set at B = 8 and the pair ladder for nlevel_coupled6.py (one representative per class).
import itertools, sys
sys.argv=['x']
exec(open('nlevel_coupled6.py').read().split("if __name__")[0])
nt=[c for c in classes if c[2] and c[1]>1]
lab=lambda c: f"{c[1]}#{c[0]}"
for allc in (False,):
    keep=list(nt)
    for c in list(keep):
        tr=[d for d in keep if d is not c]
        if not feasible([d[3] for d in tr],8,allc): keep=tr
    print('minimal infeasible at B = 8 (one rep each):',[lab(c) for c in keep],flush=True)
    for c in keep:
        print('  ', lab(c), 'alone least B', next(B for B in range(1,15) if feasible([c[3]],B)), flush=True)
for B in (6,7,8):
    bad=[(lab(a),lab(b)) for a,b in itertools.combinations(nt,2) if not feasible([a[3],b[3]],B)]
    print('B',B,'infeasible pairs (one rep each):',len(bad),bad[:20],flush=True)
