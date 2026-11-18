#!/usr/bin/env python3
"""roomy_close.py -- the 147 prime+prime configurations that ws_budget_scan.py's families left open, closed by the
chi = 1 criterion (pure pieces / digits / Lemma S, then Lemma R; threshold-beyond-mu.md §6.5).

A block of k classes (cyclic action of Z_p^* / (+-M)), each of weight w, gets cap c = floor(T / w) classes per face.
chi = 1 on one block meets every reading (exact or mod q).  chi1_ok(k, c) tests the criterion for any k:
for each l^e || k a coset-free piece on Z_{k/l} with chi = 1 mod l^e (digits when e >= 2, built explicitly by digits_explicit.py, vertices + edges or
CP-SAT when e = 1), else Lemma S for square-free k; c >= 3 for Lemma R.  Prime-power k cannot reach chi = 1.
usage: python3 roomy_close.py -> ../outputs/roomy_close.txt"""
import ast, sys, io, contextlib
from sympy import factorint
sys.path.insert(0, '.')
with contextlib.redirect_stdout(io.StringIO()):
    import pure_criterion_check as PC
from digits_explicit import digits
def chi1_ok(k, c, target=1):
    f = factorint(k)
    if len(f) < 2 or c < 3: return False, 'prime power or cap < 3'
    ps = list(f); why = []
    ok = True
    for l, e in f.items():
        other = [p for p in ps if p != l]; capl = c // l
        if e >= 2:
            r = digits(k, l, capl, target=target); g = r is not None; w = f'digits {r}'
        elif (k // l - 1) // 2 >= l - 1 and capl >= 2 and target == 1: g, w = True, 'edges'
        elif capl >= 3 and digits(k, l, capl, target=target) is not None: g, w = True, 'edges and triangles'
        else:
            g = PC.eq1_check(k // l, capl, l, other, target) if capl >= 1 else False; w = f'CP-SAT on Z_{k // l}'
        why.append((l, e, g, w)); ok = ok and bool(g)
    if not ok and target == 1 and all(e == 1 for e in f.values()):
        q = max(ps); g, w = PC.split_check(k, q, c); why.append(('split', g, w)); ok = bool(g)
    return ok, why
lines = open('../outputs/ws_budget_scan.txt').read().strip().split('\n')[2:]
res = []; closed = 0
for l in lines:
    n, T, a, dA, kA, wA, cA, b, dB, kB, wB, cB, ex, R = ast.literal_eval(l)
    okA, whyA = chi1_ok(kA, T // wA); okB, whyB = chi1_ok(kB, T // wB)
    ok = okA or okB; closed += ok
    res.append((n, a, dA, kA, T // wA, b, dB, kB, T // wB, ex, R, ok, 'A' if okA else ('B' if okB else '-')))
with open('../outputs/roomy_close.txt', 'w') as fh:
    fh.write(f"configurations {len(res)}; closed by chi = 1 on one block {closed}\n")
    for r in res: fh.write(f"{r}\n")
print(open('../outputs/roomy_close.txt').read()[:200]); print([r for r in res if not r[11]][:20])
