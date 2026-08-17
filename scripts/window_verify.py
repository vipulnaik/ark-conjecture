"""Verifies aod section 3.4's balanced-window table, and the width identity.

delta(x) = min(F x^2, 2F x(1-Fx), eta (1-Fx)^2),  x = c/n.

Claim proved in section 3.4 and checked here: for delta >= lambda*cap the
window has width exactly (1 - sqrt(lambda))/F, independent of eta and of x*.
Consequence: F*width is the same for every row, and requiring delta within
eps of the cap costs Theta(eps), not Theta(sqrt(eps)) -- the maximum is a
kink, not a smooth turning point.
"""
from math import sqrt

ROWS = [("0, 4, 6, 10", 1, 1.0), ("2, 8", 1, 1/3), ("1, 9", 2, 1.0),
        ("3, 7", 2, 0.5), ("5", 2, 1/3), ("11", 4, 1/3)]

def delta(x, F, eta):
    return min(F*x*x, 2*F*x*(1-F*x), eta*(1-F*x)**2)

def scan(F, eta, lam, N=4_000_000):
    cap = max(delta(i/N, F, eta) for i in range(1, int(N/F)))
    xstar = max((delta(i/N, F, eta), i/N) for i in range(1, int(N/F)))[1]
    thr = lam*cap
    xs = [i/N for i in range(1, int(N/F)) if delta(i/N, F, eta) >= thr]
    return cap, xstar, xs[0], xs[-1], xs[-1]-xs[0]

def closed_xstar(F, eta): return sqrt(eta)/(sqrt(F)*(1+sqrt(F*eta)))

fails = 0
for lam in (0.9, 0.99, 0.999):
    print(f"\nlambda = {lam}   predicted F*width = 1 - sqrt(lambda) = {1-sqrt(lam):.7f}")
    print(f"{'class (mod 12)':<16}{'F':>2}{'cap':>10}{'x*':>9}{'x* closed':>11}{'width':>10}{'F*width':>10}")
    for lab, F, eta in ROWS:
        cap, xs, lo, hi, w = scan(F, eta, lam)
        xc = closed_xstar(F, eta)
        ok = abs(F*w - (1-sqrt(lam))) < 2e-6 and abs(xs - xc) < 1e-3
        fails += not ok
        print(f"{lab:<16}{F:>2}{cap:10.5f}{xs:9.4f}{xc:11.4f}{w:10.4f}{F*w:10.7f}"
              + ("" if ok else "   <-- MISMATCH"))
print(f"\n{'FAIL' if fails else 'PASS'}: {fails} mismatches")
