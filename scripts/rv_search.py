# rv_search.py -- drive rv_search.c over every transitive group of degree NN with at most MAXO subset orbits:
#   echo 'NN := 6; MAXO := 16;' > p.g; gap -q p.g rv_orbits.g > orbs6.txt; gcc -O2 -o wsearch rv_search.c; python3 rv_search.py 6 orbs6.txt
# Degree 6: only T(6,4) = A4 on the edges of K4 gives non-evasive f with f(0) != f(1) (8 of them, D = 5).  Degree 10,
# groups with <= 26 orbits: none.
import sys, subprocess
NN = int(sys.argv[1]); lines = open(sys.argv[2]).read().replace('\n', ' ').split('G ')[1:]
for ln in lines:
    k, order, rest = ln.split(' ', 2); orbs = eval(rest.replace(' ', ''))
    inp = f"{NN} {len(orbs)}\n" + "\n".join(f"{len(o)} " + " ".join(map(str, o)) for o in orbs)
    out = subprocess.run(['./wsearch'], input=inp, capture_output=True, text=True).stdout.strip().split('\n')
    print(f"{NN}T{k} (order {order}, {len(orbs)} orbits): {out[-1]}" + (f"  e.g. {out[0]}" if len(out) > 1 else ""), flush=True)
