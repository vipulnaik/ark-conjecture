import sys,os,ast,time
exec(open('chi12_fix9.py').read().split("if __name__")[0])
from networkx.algorithms import isomorphism as iso
cls=classes(9); keys=list(cls)
line=[l for l in open('/tmp/fix9.log') if l.startswith('  family')][0]
fam=[ast.literal_eval(x) for x in line.split(': ',1)[1].strip().split('; ')]
fk=set(cl.cert(e) for e in fam)
print(len(fam), 'chi =', sum(cls[k][0] for k in fk), flush=True)
def gr(e):
    g=nx.Graph(); g.add_nodes_from(range(12)); g.add_edges_from(e); return g
def mono(big,small):
    return big.number_of_edges()>small.number_of_edges() and iso.GraphMatcher(big,small).subgraph_is_monomorphic()
F=[gr(cls[k][1]) for k in fk]
Mx=[f for f in F if not any(mono(h,f) for h in F)]
print('maximal', len(Mx), [sorted(f.edges()) for f in Mx], flush=True)
bad=0
for k in keys:
    if k in fk: continue
    g=gr(cls[k][1])
    if any(mono(f,g) for f in Mx): bad+=1
print('closure violations (networkx)', bad, flush=True)
