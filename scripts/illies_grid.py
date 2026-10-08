# illies_grid.py -- Illies-type families on an a x b torus grid: parity and exact D(f) (via ./dtree, built from dtree.c:
#   gcc -O2 -o dtree dtree.c).  Only 3x4 with cycle rows is non-evasive among all grids with n <= 15.  ~5 s.
# rowg / colg: 'C' = cycle, 'K' = complete graph on the line.  F = {} u {S inside one row or column, connected in that line}.
import itertools, subprocess, sys
def conn(points, kind, m):
    pts = sorted(set(points))
    if len(pts) <= 1 or kind == 'K': return True
    # cycle C_m: connected iff the gaps leave at most one gap > 1, i.e. the points form a cyclic interval
    gaps = [((pts[(i + 1) % len(pts)] - pts[i]) % m) for i in range(len(pts))]
    return sum(1 for g in gaps if g > 1) <= 1 or len(pts) == m
def family(a, b, rowg, colg):
    n = a * b; tt = []
    for mask in range(1 << n):
        S = [i for i in range(n) if mask >> i & 1]
        if not S: tt.append('1'); continue
        rows = {s // b for s in S}; cols = {s % b for s in S}
        if len(rows) == 1: v = conn([s % b for s in S], rowg, b)
        elif len(cols) == 1: v = conn([s // b for s in S], colg, a)
        else: v = False
        tt.append('1' if v else '0')
    return n, ''.join(tt)
def parity(n, tt): return sum((-1) ** bin(m).count('1') for m in range(1 << n) if tt[m] == '1')
def D(n, tt): return int(subprocess.run(['./dtree'], input=f"{n}\n{tt}\n", capture_output=True, text=True).stdout)
if __name__ == '__main__':
    for a, b in [(2, 2), (2, 3), (2, 4), (3, 3), (2, 5), (3, 4), (2, 6), (3, 5), (2, 7), (4, 4)]:
        for rowg in 'CK':
            for colg in 'CK':
                if (rowg == 'C' and b <= 3 and colg == 'K') or (colg == 'C' and a <= 3 and rowg == 'K'):
                    pass
                n, tt = family(a, b, rowg, colg)
                p = parity(n, tt); d = D(n, tt) if n <= 15 else None
                print(f"{a}x{b} rows={rowg}{b} cols={colg}{a}: n={n} f(X)={tt[-1]} parity={p:+d} D={d}{'  NON-EVASIVE' if d is not None and d < n else ''}", flush=True)
