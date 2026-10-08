# illies_link.py -- the link of a point in the a x (a+1) torus family: non-evasive (D = 4 of 5) at 3x4, evasive at
# 5x6, 7x8, 9x10 -- and an evasive link at the first query makes the whole family evasive.  USAGE  python3 illies_link.py [a,b ...]
# The "link" of a point: T over the other points of its row (C_b) and column (C_a);
# g(T) = 1 iff T lies in the row part with {pivot} u T connected in C_b, or in the column part, connected in C_a.
import subprocess, sys
from illies_grid import conn, D
def link(a, b):
    nr, nc = b - 1, a - 1; n = nr + nc; tt = []
    for m in range(1 << n):
        wr = [j + 1 for j in range(nr) if m >> j & 1]; wc = [j + 1 for j in range(nc) if m >> (nr + j) & 1]
        if wr and wc: v = False
        elif wr: v = conn([0] + wr, 'C', b)
        elif wc: v = conn([0] + wc, 'C', a)
        else: v = True
        tt.append('1' if v else '0')
    return n, ''.join(tt)
for a, b in [(int(x.split(",")[0]), int(x.split(",")[1])) for x in (sys.argv[1:] or ["3,4","5,6","7,8","3,5","5,4"])]:
    n, tt = link(a, b)
    par = sum((-1) ** bin(m).count('1') for m in range(1 << n) if tt[m] == '1')
    print(f"{a}x{b}: link on {n} vars (row {b-1} + col {a-1}): parity {par:+d}, D = {D(n, tt)}")
