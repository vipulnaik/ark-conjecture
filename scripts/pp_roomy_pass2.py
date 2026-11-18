#!/usr/bin/env python3
"""pp_roomy_pass2.py -- second pass on what pp_roomy_close.py left open: a disjoint union of a weight-threshold
complex Delta_W on the prime-power block (value y) and a complex on the prime block with chi = 1 - y exactly
(pure pieces / digits with target 1 - y, then Lemma R).  usage: python3 pp_roomy_pass2.py -> ../outputs/pp_roomy_pass2.txt"""
import ast, sys, io, contextlib
sys.argv = ['x']
with contextlib.redirect_stdout(io.StringIO()):
    src = open('ws_budget_pp.py').read(); exec(src[:src.index('if __name__')])
    from roomy_close import chi1_ok
    from pp_roomy_close import threshold_chis
lines = open('../outputs/pp_roomy_close.txt').read().strip().split('\n')[1:]
out = []; closed = 0
for l in lines:
    n, T, a, ca, b, cb, exact, qs = ast.literal_eval(l)
    P, cP = (a, ca) if isprime(a) else (b, cb); X, cX = (b, cb) if isprime(a) else (a, ca)
    if not isprime(P) or isprime(X): out.append((n, a, ca, b, cb, 'not prime + prime-power')); continue
    k = cP[3]; c = min(T // weights(P, cP)[0], k - 1)
    ys = sorted(threshold_chis(weights(X, cX), T), key=abs)[:60]
    hit = None
    for y in ys:
        ok, why = chi1_ok(k, c, target=1 - y)
        if ok: hit = (y, 1 - y); break
    closed += hit is not None; out.append((n, a, ca, b, cb, exact, hit)); print(out[-1], flush=True)
with open('../outputs/pp_roomy_pass2.txt', 'w') as fh:
    fh.write(f"configurations {len(out)}; closed {closed}\n")
    for o in out: fh.write(f"{o}\n")
print(open('../outputs/pp_roomy_pass2.txt').read()[:3000])
