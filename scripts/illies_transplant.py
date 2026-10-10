"""illies_transplant.py -- Illies's construction on every group of order 12.
For G = SmallGroup(12,k) acting on itself by left multiplication, an order-4 subgroup K with a 4-cycle Cayley
structure (K = <y> with generators y^{+-1}, or K = V4 with two of its three involutions), and an order-3 subgroup T
with K & T = 1, let F = {empty} + every subset of a left coset gT + every connected arc of a left coset gK in its
4-cycle.  Prints exact D (dtree.c, compiled as ./dtree) for every choice.  Parity: 1 - |G| + |G:K|*1 + |G:T|*2 = 0
forces |G| = 12 for these pieces.  Needs gap."""
import subprocess, itertools
gp = 'SizeScreen([4096,24]); for k in [1..5] do G := SmallGroup(12,k); el := Elements(G); ' \
     'Print(ReplacedString(StructureDescription(G)," ",""), "|", List(el, g -> List(el, h -> Position(el, g*h))), "\\n"); od; QUIT;'
open('/tmp/it.g', 'w').write(gp)
for ln in subprocess.run(['gap', '-q', '/tmp/it.g'], capture_output=True, text=True).stdout.strip().split('\n'):
    name, tab = ln.split('|'); M = [[x - 1 for x in r] for r in eval(tab)]; n = 12
    e = next(i for i in range(n) if all(M[i][j] == j for j in range(n)))
    def order(g):
        k, x = 1, g
        while x != e: x, k = M[x][g], k + 1
        return k
    def cyc(y):
        c = [e]
        while M[c[-1]][y] != e: c.append(M[c[-1]][y])
        return c
    fours = []                                    # (K as a 4-cycle list e, a, ab, b) up to reversal
    for y in range(n):
        if order(y) == 4: fours.append(tuple(cyc(y)))
    invs = [g for g in range(n) if order(g) == 2]
    for a, b in itertools.combinations(invs, 2):
        if M[a][b] == M[b][a] and order(M[a][b]) == 2: fours.append((e, a, M[a][b], b))
    Ts = {frozenset(cyc(t)) for t in range(n) if order(t) == 3}
    seen, res = set(), []
    for K in fours:
        if frozenset(K) == frozenset() : continue
        for T in Ts:
            if set(K) & T != {e}: continue
            key = (frozenset(frozenset((K[i], K[(i + 1) % 4])) for i in range(4)), T)
            if key in seen: continue
            seen.add(key); F = {0}
            for g in range(n):
                co = [M[g][h] for h in T]
                for k in range(1, 8): F.add(sum(1 << co[i] for i in range(3) if k >> i & 1))
                cy = [M[g][h] for h in K]
                for st in range(4):
                    for L in range(1, 5): F.add(sum(1 << cy[(st + i) % 4] for i in range(L)))
            tt = ''.join('1' if x in F else '0' for x in range(1 << n))
            D = int(subprocess.run(['./dtree'], input=f"{n}\n{tt}\n", capture_output=True, text=True).stdout)
            res.append(D)
    print(f"{name}: {len(res)} choices of (4-cycle K, T), D values {sorted(set(res))} ({res.count(11)} non-evasive)")
