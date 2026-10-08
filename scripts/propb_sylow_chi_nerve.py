# chi(Delta^Q) via the nerve of the maximal faces: chi = sum over nonempty families of maximal faces with
# nonempty common intersection of (-1)^(|family|+1).  For lines with many orbits but few maximal faces.
import sys, itertools
from propb_sylow_chi import good_masks
def nerve_chi(maxi):
    tot = 0
    def rec(i, inter, k):
        nonlocal tot
        for j in range(i, len(maxi)):
            x = inter & maxi[j]
            if x:
                tot += 1 if (k + 1) % 2 else -1
                rec(j + 1, x, k + 1)
    rec(0, -1, 0)
    return tot
want = [tuple(map(int, a.split(':'))) for a in sys.argv[2:]]
for line in open(sys.argv[1]):
    n, p, q, o = line.strip().split('|'); n = int(n); p = int(p); orbs = eval(o)
    if (n, p) not in want: continue
    good = sorted(good_masks(n, orbs), key=lambda x: -bin(x).count('1'))
    maxi = []
    for g in good:
        if not any(g & ~h == 0 for h in maxi): maxi.append(g)
    print(f"n={n} p={p}: {len(orbs)} orbits, {len(maxi)} maximal faces", flush=True)
    if len(maxi) <= 40:
        c = nerve_chi(maxi); print(f"   chi(fixed) = {c}, mod p = {c % p}", flush=True)
