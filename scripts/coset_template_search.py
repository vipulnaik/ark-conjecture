"""coset_template_search.py -- non-evasive left-invariant set systems of the coset template on small groups.
For each SmallGroup of non-prime-power order NN (6, 10, 12, 14, 15) and KIND in {cyclic, all}, take the G-orbits from
coset_template_orbits.g (members lie in left cosets of proper [cyclic] subgroups, plus the empty set and G) and run
rv_search.c (compiled as ./wsearch): every union with exactly one of empty/G, parity-filtered, exact D.
Usage: python3 coset_template_search.py MAXO   (run in scripts/, needs gap and ./wsearch)"""
import sys, subprocess
MAXO = int(sys.argv[1])
for NN in [6, 10, 12, 14, 15]:
    for KIND in ['cyclic', 'all']:
        open('/tmp/ct_p.g', 'w').write(f'NN := {NN}; MAXO := {MAXO}; KIND := "{KIND}";')
        out = subprocess.run(['gap', '-q', '/tmp/ct_p.g', 'coset_template_orbits.g'], capture_output=True, text=True).stdout
        for ln in out.split('\n'):
            if ln.startswith('# '): print(f"{NN} {KIND}: {ln[2:]}", flush=True); continue
            if not ln.startswith('G '): continue
            _, k, name, m, rest = ln.split(' ', 4); orbs = eval(rest.replace(' ', ''))
            inp = f"{NN} {len(orbs)}\n" + "\n".join(f"{len(o)} " + " ".join(map(str, o)) for o in orbs)
            res = subprocess.run(['./wsearch'], input=inp, capture_output=True, text=True).stdout.strip().split('\n')
            print(f"{NN} {KIND}: SmallGroup({NN},{k}) = {name}, {m} orbits: {res[-1]}" + (f"  e.g. {res[0]}" if len(res) > 1 else ""), flush=True)
