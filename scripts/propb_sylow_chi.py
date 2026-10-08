# propb_sylow_chi.py -- chi(Delta^Q) mod p for property B, Q a Sylow p-subgroup of S_n (orbits from propb_sylow_orbits.g:
#   echo "NS := [n];" > ns.g; gap -q ns.g propb_sylow_orbits.g > orbs_n.txt, then join the wrapped lines).  chi(Delta) = chi(Delta^Q) mod p.
# USAGE  python3 propb_sylow_chi.py orbs_<n>.txt ...
# As sylchi.py, vectorised over colourings with numpy; only lines with at most MAXM orbits.
import sys, numpy as np
MAXM = 26
def good_masks(n, orbs):
    N = 1 << (n - 1)
    idx = np.arange(N, dtype=np.int64)
    col = np.zeros((n, N), dtype=np.uint8)
    for v in range(1, n): col[v] = (idx >> (v - 1)) & 1
    g = np.zeros(N, dtype=np.int64)
    for j, o in enumerate(orbs):
        ok = np.ones(N, dtype=bool)
        for a, b, c in o:
            ok &= ~((col[a] == col[b]) & (col[b] == col[c]))
        g |= ok.astype(np.int64) << j
    return set(np.unique(g).tolist())
def chi_fixed(n, orbs):
    m = len(orbs)
    good = sorted(good_masks(n, orbs), key=lambda x: -bin(x).count('1'))
    maxi = []
    for g in good:
        if not any(g & ~h == 0 for h in maxi): maxi.append(g)
    D = np.zeros(1 << m, dtype=bool)
    for g in maxi: D[g] = True
    for i in range(m):
        v = D.reshape(-1, 2, 1 << i); v[:, 0, :] |= v[:, 1, :]
    pc = np.zeros(1 << m, dtype=np.int8)
    for i in range(m):
        v = pc.reshape(-1, 2, 1 << i); v[:, 1, :] += 1
    odd = (pc % 2 == 1)
    return int(D[odd].sum()) - int(D[~odd].sum()) + int(D[0])
if __name__ == "__main__":
  for path in sys.argv[1:]:
      hits = []
      for line in open(path):
          n, p, q, o = line.strip().split('|'); n = int(n); p = int(p); orbs = eval(o)
          if len(orbs) > MAXM: continue
          c = chi_fixed(n, orbs)
          hits.append(f"p={p}: chi(fixed)={c}, mod p {c % p}{' *' if c % p != 1 % p else ''}")
      print(f"n={n}: " + "; ".join(hits), flush=True)
  