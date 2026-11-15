#!/usr/bin/env python3
"""smith_pgroups.py FILE -- s_Q (pgroup_levels.level()) for every p-group listed in FILE (from smith_pgroups.g),
printed with mu*(n) for comparison.  threshold-beyond-mu.md section 7, "Other p-subgroups"."""
import sys, json, csv
mu={int(r['n']):int(r['mu_bound']) for r in csv.DictReader(open('../outputs/mu_table_exact.csv'))}
src=open('pgroup_levels.py').read().split('\nif TWO:\n    (pp')[0]
for l in open(''+sys.argv[1]+''):
    h,o=l.split('|'); n,p,order=map(int,h.split()); o=[[tuple(e) for e in x] for x in json.loads(o)]
    if len(o)>22: print(n,p,'skip'); continue
    g={}; sys.argv=['x',str(n)]; exec(src,g)
    B=g['level'](o,p)
    print(f"n={n} p={p} |P|={order} t={len(o)} sizes={sorted(len(x) for x in o)} s_Q={B}  (n={n}, mu*={mu.get(n)})",flush=True)
