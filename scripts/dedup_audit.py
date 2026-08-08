"""dedup_audit.py -- item 7: how many distinct (orbital partition, prime)
conditions a groups_out.txt actually imposes.  Reimplements consume_gap.py's
_orbital_canon independently."""
import sys, collections, itertools, pynauty
path = sys.argv[1]
MAXT = int(sys.argv[2]) if len(sys.argv)>2 else 99
lines = [l.strip() for l in open(path) if l.strip()]
NP = len(lines[0].split('|')[3].split(','))
N = (1 + int((1 + 8 * NP) ** 0.5)) // 2
PAIRS = list(itertools.combinations(range(N), 2))
assert len(PAIRS) == NP, (N, NP)

def canon(omap, t):
    adj = {i: [] for i in range(N)}
    stats = []
    for o in range(t):
        mem = [i for i in range(NP) if omap[i] == o]
        val = tuple(sorted(sum(1 for i in mem if u in PAIRS[i]) for u in range(N)))
        stats.append((len(mem), val))
    for idx, (u, v) in enumerate(PAIRS):
        adj[N + idx] = [u, v, N + NP + omap[idx]]
    for o in range(t):
        adj[N + NP + o] = []
    grp = {}
    for o in range(t):
        grp.setdefault(stats[o], []).append(N + NP + o)
    cols = ([set(range(N)), set(range(N, N + NP))] + [set(grp[k]) for k in sorted(grp)])
    G = pynauty.Graph(N + NP + t, adjacency_dict=adj, vertex_coloring=cols)
    return (pynauty.certificate(G), t, tuple(sorted(stats)))

seen = {}
bytag = collections.Counter(); parts = collections.Counter()
kept = 0
for ln in lines:
    kept += 1
    key, desc, tag, om = ln.split('|')
    omap = [int(x) - 1 for x in om.split(',')]
    t = max(omap) + 1
    if t > MAXT:
        kept -= 1
        continue
    sig = (canon(omap, t), tag)
    parts[canon(omap, t)] += 1
    if sig not in seen:
        seen[sig] = (key, tag, t)
        bytag[tag] += 1
n = kept
print(f"{path}: n = {N}, {n} groups")
print(f"  distinct (orbital partition, prime) conditions: {len(seen)}")
print(f"  redundant groups (condition already present):  {n - len(seen)}  ({(n-len(seen))/n:.1%})")
print(f"  distinct orbital partitions ignoring the prime: {len(parts)}")
print(f"  conditions by tag: {dict(sorted(bytag.items(), key=str))}")
ol = sum(v for k, v in bytag.items() if not k.startswith('P'))
print(f"  distinct Oliver conditions: {ol}; distinct p-group conditions: {len(seen)-ol}")
multi = {p: c for p, c in parts.items() if c > 1}
print(f"  orbital partitions carried by >1 group: {len(multi)}; "
      f"largest multiplicity {max(parts.values())}")
