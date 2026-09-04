#!/usr/bin/env python3
"""
a5_on_15.py -- the monotone weakly-symmetric evasiveness conjecture at its
smallest open degree: A_5 acting on 15 points.

WHY THIS GROUP AND DEGREE.  The conjecture is verified in the literature for
n <= 14 (`monotone-transitive-note.md` section 4).  At degree 15 every transitive
group either contains a transitive Oliver subgroup -- and is then settled by
Proposition 1 of that note -- or contains a transitive copy of A_5 in its unique
action on 15 points (cosets of C_2^2, equivalently the pairs of the 6-point
PSL(2,5) action).  Since a G-invariant family is invariant under every subgroup,
it suffices to settle A_5.  So this one group is the whole of degree 15.

WHAT THE SCRIPT DOES.  Every PROPER subgroup of A_5 is an Oliver group (the
p-groups; A_4 = 2^2:3; D_10 = 5:2; S_3 = 3:2; the cyclics), so the fixed-point
machinery of the small-degree pipeline applies subgroup by subgroup even though
A_5 itself is not Oliver:

  * for a p-subgroup P, the fixed complex Delta^P must be F_p-acyclic (Smith);
  * for S_3, D_10, A_4 with top primes 2, 2, 3, chi(Delta^H) == 1 mod q;
  * globally chi(Delta) = 1, and chi(link of any vertex) = 1 (a nonevasive
    complex has a vertex whose link and deletion are nonevasive; by transitivity
    every vertex qualifies, and nonevasive => Z-acyclic => chi = 1).

The variables are the A_5-orbits on subsets of the 15 points.  Stage 1 builds the
orbit poset; stage 2 runs a DFS over the orbits that some subgroup condition
touches, with monotone propagation and subgroup checks fired as soon as each
subgroup's lattice is decided; stage 3 tests survivors for nonevasiveness
EXACTLY, by the decision-tree recursion on 2^15 subsets.

WHAT AN OUTCOME MEANS.
  UNSAT at stage 2   => every nontrivial monotone A_5-invariant family on 15
                        points is evasive, hence the conjecture holds at n = 15
                        (modulo the census claim that A_5 is the only minimal
                        transitive non-Oliver group of that degree).
  SAT at stage 2     => the acyclicity-level constraints do not decide the
                        degree.  Stage 3 then tests completions; a nonevasive one
                        is a counterexample, and none is the n = 10 situation of
                        `small-degree-computation.md` section 7 over again.

Usage:
    python3 a5_on_15.py                 # build, report orbit counts, run CSP
    python3 a5_on_15.py --limit 600     # cap CSP seconds (default 300)
    python3 a5_on_15.py --exhaustive    # stage 3 over every stage-2 solution
"""
import argparse, itertools, sys, time
from collections import defaultdict

# ---------------------------------------------------------------- the group
def psl25():
    """A_5 = PSL(2,5) on P^1(F_5) = {0,1,2,3,4,inf}, as permutations of 0..5."""
    INF = 5
    def mobius(a, b, c, d):
        def f(x):
            if x == INF:
                return INF if c == 0 else (a * pow(c, -1, 5)) % 5
            den = (c * x + d) % 5
            if den == 0:
                return INF
            return ((a * x + b) * pow(den, -1, 5)) % 5
        return tuple(f(x) for x in range(6))
    g1 = mobius(1, 1, 0, 1)          # x -> x+1
    g2 = mobius(0, -1 % 5, 1, 0)     # x -> -1/x
    G = {tuple(range(6))}
    frontier = [tuple(range(6))]
    while frontier:
        nf = []
        for g in frontier:
            for h in (g1, g2):
                k = tuple(h[g[i]] for i in range(6))
                if k not in G:
                    G.add(k); nf.append(k)
        frontier = nf
    return sorted(G)

PTS = list(itertools.combinations(range(6), 2))      # the 15 points
PIDX = {p: i for i, p in enumerate(PTS)}
N = 15

def induced(g):
    """permutation of the 15 pairs induced by g on 6 points."""
    out = [0] * N
    for i, (a, b) in enumerate(PTS):
        x, y = g[a], g[b]
        out[i] = PIDX[(x, y) if x < y else (y, x)]
    return tuple(out)

def act(perm, mask):
    m = 0
    i = 0
    while mask:
        if mask & 1:
            m |= 1 << perm[i]
        mask >>= 1; i += 1
    return m

def closure(gens, ident):
    G = {ident}; fr = [ident]
    while fr:
        nf = []
        for g in fr:
            for h in gens:
                k = tuple(h[g[i]] for i in range(len(ident)))
                if k not in G:
                    G.add(k); nf.append(k)
        fr = nf
    return frozenset(G)

def order_of(g, ident):
    k, o = g, 1
    while k != ident:
        k = tuple(g[k[i]] for i in range(len(ident))); o += 1
    return o

# ---------------------------------------------------------------- homology
def reduced_homology_zero(faces, p):
    """Is the simplicial complex with the given face set (as frozensets,
    including the empty face) F_p-acyclic, i.e. all reduced homology zero?
    Brute-force ranks of boundary matrices over F_p; complexes here are tiny."""
    by_dim = defaultdict(list)
    for f in faces:
        by_dim[len(f) - 1].append(f)
    if not by_dim.get(0):
        return False                      # only the empty face: H~_{-1} != 0
    idx = {d: {f: i for i, f in enumerate(sorted(by_dim[d], key=sorted))}
           for d in by_dim}
    def rank(d):
        # boundary from dim d to dim d-1 (d >= 0; dim -1 is the empty face)
        rows = idx.get(d - 1, {}); cols = by_dim.get(d, [])
        if not cols or not rows:
            return 0
        M = []
        for f in cols:
            v = [0] * len(rows)
            fs = sorted(f)
            for j, x in enumerate(fs):
                g = frozenset(fs[:j] + fs[j + 1:])
                v[rows[g]] = (v[rows[g]] + (-1) ** j) % p
            M.append(v)
        # rank over F_p
        r = 0; ncol = len(rows); M = [row[:] for row in M]
        for c in range(ncol):
            piv = next((i for i in range(r, len(M)) if M[i][c] % p), None)
            if piv is None:
                continue
            M[r], M[piv] = M[piv], M[r]
            inv = pow(M[r][c], -1, p)
            M[r] = [(x * inv) % p for x in M[r]]
            for i in range(len(M)):
                if i != r and M[i][c] % p:
                    f = M[i][c]
                    M[i] = [(a - f * b) % p for a, b in zip(M[i], M[r])]
            r += 1
        return r
    top = max(by_dim)
    ranks = {d: rank(d) for d in range(0, top + 2)}
    for d in range(-1, top + 1):
        n_d = len(by_dim.get(d, []))
        ker = n_d - ranks.get(d, 0) if d >= 0 else n_d   # dim -1: boundary is zero
        if d == -1:
            ker = n_d
        im = ranks.get(d + 1, 0)
        if ker - im != 0:
            return False
    return True

def euler(faces):
    """chi of a complex given as face set including the empty face."""
    return sum((-1) ** (len(f) - 1) for f in faces if f)

# ---------------------------------------------------------------- main
def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--limit", type=float, default=300)
    ap.add_argument("--exhaustive", action="store_true")
    ap.add_argument("--maxsols", type=int, default=50)
    a = ap.parse_args()
    t0 = time.time()

    G6 = psl25()
    assert len(G6) == 60, len(G6)
    G = [induced(g) for g in G6]
    ident = tuple(range(N))
    assert len(set(G)) == 60
    # transitivity on the 15 points
    orb0 = {g[0] for g in G}
    assert len(orb0) == N
    print(f"A_5 on {N} points: transitive, order 60")

    # ---- orbits on subsets --------------------------------------------
    FULL = (1 << N) - 1
    rep = [-1] * (1 << N)            # canonical (min) representative per mask
    orbits = []                      # list of frozenset(masks)
    for m in range(1 << N):
        if rep[m] != -1:
            continue
        o = {act(g, m) for g in G}
        r = min(o)
        for x in o:
            rep[x] = r
        orbits.append(frozenset(o))
    oid = {min(o): i for i, o in enumerate(orbits)}
    print(f"orbits on subsets: {len(orbits)}  (Burnside lower bound {2**N // 60})")
    size = [bin(min(o)).count('1') for o in orbits]
    from collections import Counter
    print("  by rank:", dict(sorted(Counter(size).items())))

    # ---- subgroups, one per conjugacy class -----------------------------
    subs = {}
    for g in G:
        for h in G:
            H = closure([g, h], ident)
            if 1 < len(H) < 60 and len(H) not in subs:
                subs[len(H)] = H
    print("subgroup orders found:", sorted(subs))
    assert sorted(subs) == [2, 3, 4, 5, 6, 10, 12], sorted(subs)
    COND = {2: ('smith', 2), 3: ('smith', 3), 4: ('smith', 2), 5: ('smith', 5),
            6: ('chi', 2), 10: ('chi', 2), 12: ('chi', 3)}

    # H-invariant subsets = unions of H-orbits on points
    hinfo = {}
    for order, H in subs.items():
        seen = set(); horbs = []
        for x in range(N):
            if x in seen: continue
            o = {h[x] for h in H}; seen |= o; horbs.append(sum(1 << y for y in o))
        inv_masks = []
        for k in range(1 << len(horbs)):
            m = 0
            for i in range(len(horbs)):
                if k >> i & 1: m |= horbs[i]
            inv_masks.append(m)
        hinfo[order] = dict(H=H, horbs=horbs, inv=inv_masks,
                            oids=sorted({oid[rep[m]] for m in inv_masks}))
        print(f"  |H|={order:2d}: {len(horbs):2d} orbits on points -> "
              f"{len(inv_masks):4d} invariant sets in {len(hinfo[order]['oids']):3d} A_5-orbits")
    touched = sorted(set().union(*(set(v['oids']) for v in hinfo.values())))
    print(f"A_5-orbits touched by some subgroup condition: {len(touched)} of {len(orbits)}")

    # ---- fixed-complex condition evaluators ------------------------------
    fc_memo = {}
    fc_stats = defaultdict(lambda: [0, 0])     # order -> [checks, fails]
    def fixed_complex_ok(order, x):
        """x: dict oid -> 0/1 for all touched orbits.  Returns True/False.
        Memoised on the values of this subgroup's own orbits."""
        info = hinfo[order]
        key = (order, tuple(x[o] for o in info['oids']))
        if key in fc_memo:
            return fc_memo[key]
        r = _fixed_complex_ok(order, x)
        fc_memo[key] = r
        fc_stats[order][0] += 1; fc_stats[order][1] += (not r)
        return r
    def _fixed_complex_ok(order, x):
        info = hinfo[order]; horbs = info['horbs']
        faces = set()
        for k in range(1 << len(horbs)):
            m = 0
            for i in range(len(horbs)):
                if k >> i & 1: m |= horbs[i]
            if x[oid[rep[m]]] == 1:
                faces.add(frozenset(i for i in range(len(horbs)) if k >> i & 1))
        kind, p = COND[order]
        if kind == 'smith':
            return reduced_homology_zero(faces, p)
        return euler(faces) % p == 1 % p

    # ---- stage 2: DFS over touched orbits --------------------------------
    T = touched
    pos = {o: i for i, o in enumerate(T)}
    # poset among touched orbits: a <= b if some member of a is a subset of some member of b
    mins = [min(orbits[o]) for o in range(len(orbits))]
    def below(o):   # orbits that are subsets of members of o (restricted to touched)
        out = set()
        for m in orbits[o]:
            sub = m
            while True:
                out.add(oid[rep[sub]])
                if sub == 0: break
                sub = (sub - 1) & m
        return out
    down = {o: below(o) for o in T}
    up = defaultdict(set)
    for o in T:
        for b in down[o]:
            if b in pos: up[b].add(o)
    x = {}
    fixed = {oid[rep[0]]: 1, oid[rep[FULL]]: 0}
    # singletons must be IN (else P = {empty}, which is evasive)
    fixed[oid[rep[1]]] = 1
    # variable ordering: close the SMALLEST subgroup lattices first, so the
    # harshest conditions (Smith at C_5, C_3, C_2^2; chi mod 3 at A_4) prune high
    # in the tree; within a lattice, larger sets first (they force more below).
    order_vars = []; placed = set()
    for order in sorted(hinfo, key=lambda k: len(hinfo[k]['oids'])):
        for o in sorted(hinfo[order]['oids'], key=lambda o: -size[o]):
            if o not in placed:
                placed.add(o); order_vars.append(o)
    grp_vars = {order: [o for o in info['oids']] for order, info in hinfo.items()}
    orders_of = defaultdict(list)          # orbit -> subgroup orders whose lattice it lies in
    for order, vs in grp_vars.items():
        for o in vs: orders_of[o].append(order)
    sols = []; nodes = [0]; deadline = t0 + a.limit
    pend = {order: len(v) for order, v in grp_vars.items()}

    def assign(o, v, changed):
        stack = [(o, v)]
        while stack:
            j, val = stack.pop()
            if j in x:
                if x[j] != val: return False
                continue
            x[j] = val; changed.append(j)
            zeroed = []
            for order in orders_of[j]:
                pend[order] -= 1
                if pend[order] == 0: zeroed.append(order)
            for order in zeroed:              # after the decrement loop, so undo stays in sync
                if not fixed_complex_ok(order, x): return False
            if val == 1:
                for b in down[j]:
                    if b in pos and x.get(b) != 1:
                        if x.get(b) == 0: return False
                        stack.append((b, 1))
            else:
                for b in up[j]:
                    if x.get(b) != 0:
                        if x.get(b) == 1: return False
                        stack.append((b, 0))
        return True

    def undo(changed):
        for j in changed:
            del x[j]
            for order in orders_of[j]:
                pend[order] += 1

    # ---- two congruences the FREE orbits cannot repair ---------------------
    # An orbit untouched by every subgroup condition has trivial set-stabiliser,
    # hence size exactly 60, and contributes +-60 to chi(Delta).  A free orbit of
    # k-sets has 60k/15 = 4k members containing a given vertex v, contributing
    # +-4k to chi(link v).  So whatever the free part does,
    #     chi(Delta)  == chi(minimal completion)        (mod 60)
    #     chi(link v) == chi(link v in min completion)  (mod 4)
    # and a nonevasive Delta needs both equal to 1 (nonevasive => Z-acyclic, and
    # by transitivity every vertex's link is a link of a nonevasive complex).
    # Checked at each stage-2 leaf; this is what lets the CSP say UNSAT without
    # enumerating the 2^(free orbits) completions.
    leaf_stats = {'leaves': 0, 'pass60': 0, 'pass4': 0, 'passboth': 0}
    def min_completion_chis(sol):
        member = bytearray(1 << N)
        for o, v in sol.items():
            if v == 1:
                for m in orbits[o]:
                    sub = m
                    while True:
                        member[sub] = 1
                        if sub == 0: break
                        sub = (sub - 1) & m
        chi = 0; chil = 0
        for m in range(1, 1 << N):
            if member[m]:
                k = bin(m).count('1')
                chi += (-1) ** (k - 1)
                if (m & 1) and k >= 2:
                    chil += (-1) ** (k - 2)
        return chi, chil
    maxdepth = [0]; lastlog = [t0]
    def dfs(k):
        nodes[0] += 1
        if time.time() - lastlog[0] > 30:
            lastlog[0] = time.time()
            print(f"    ... {nodes[0]} nodes, depth<= {maxdepth[0]}/{len(order_vars)}, "
                  f"leaves {leaf_stats['leaves']}, memo {len(fc_memo)}, "
                  f"fails by |H|: {dict((k, v[1]) for k, v in fc_stats.items())}", flush=True)
        if time.time() > deadline or len(sols) >= a.maxsols: return
        while k < len(order_vars) and order_vars[k] in x: k += 1
        maxdepth[0] = max(maxdepth[0], k)
        if k == len(order_vars):
            leaf_stats['leaves'] += 1
            chi, chil = min_completion_chis(x)
            p60 = (chi % 60 == 1); p4 = (chil % 4 == 1)
            leaf_stats['pass60'] += p60; leaf_stats['pass4'] += p4
            if p60 and p4:
                leaf_stats['passboth'] += 1
                sols.append(dict(x))
            return
        o = order_vars[k]
        for v in (1, 0):
            ch = []
            if assign(o, v, ch): dfs(k + 1)
            undo(ch)
            if time.time() > deadline or len(sols) >= a.maxsols: return

    ok = True; ch = []
    for o, v in fixed.items():
        if o in pos and not assign(o, v, ch): ok = False
    if ok:
        dfs(0)
    el = time.time() - t0
    print(f"\nstage 2: {nodes[0]} nodes, {leaf_stats['leaves']} subgroup-consistent "
          f"assignments of the {len(T)} touched orbits; {leaf_stats['pass60']} with "
          f"chi==1 mod 60, {leaf_stats['pass4']} with chi(link)==1 mod 4, "
          f"{leaf_stats['passboth']} both  ({el:.0f}s)"
          + ("  [TIME LIMIT HIT]" if time.time() > deadline else ""))
    if not sols and time.time() <= deadline:
        print("UNSAT: the subgroup conditions plus the two free-orbit congruences exclude")
        print("every nontrivial monotone A_5-invariant family on 15 points")
        print("  => the monotone weakly-symmetric conjecture holds at n = 15 for A_5,")
        print("     hence at degree 15 modulo the census (A_5 the only minimal")
        print("     transitive non-Oliver group there)")
        return 0
    if not sols:
        print("no verdict within the time limit"); return 2

    # ---- stage 3: exact nonevasiveness on completions --------------------
    # Complete each solution by the MINIMAL down-set (IN orbits and everything
    # below them; all other touched orbits as decided; untouched orbits OUT
    # unless forced IN by monotonicity).  Then test nonevasiveness exactly.
    def complete(sol):
        member = bytearray(1 << N)
        for o, v in sol.items():
            if v == 1:
                for m in orbits[o]:
                    sub = m
                    while True:
                        member[sub] = 1
                        if sub == 0: break
                        sub = (sub - 1) & m
        return member

    sys.setrecursionlimit(100000)
    def nonevasive(member):
        """Decision-tree recursion: f (membership) restricted to a subcube
        (ones, zeros) is nonevasive iff it is constant or some free variable
        splits it into two nonevasive halves.  Base: no free variable => D = 0
        which is NOT < 0, so constant-first is only asked when free vars remain."""
        memo = {}
        def rec(ones, zeros):
            key = (ones, zeros)
            if key in memo: return memo[key]
            free = FULL & ~ones & ~zeros
            # BASE CASE FIRST, and it is EVASIVE: with no free variable the
            # depth is 0, which is not < 0.  Getting this backwards returns
            # True at every leaf and reports EVERY function nonevasive -- see
            # monotone-transitive-note.md section 6's trap box, which predicted
            # exactly this bug, and which this file reproduced on its first run
            # (a "counterexample" found in 0.0 s).
            if free == 0:
                memo[key] = False; return False
            # constant on a subcube with >= 1 free variable: depth 0 < |free|
            if member[ones] == member[ones | free]:
                memo[key] = True; return True
            res = False
            f = free
            while f:
                i = (f & -f).bit_length() - 1; f &= f - 1
                if rec(ones | (1 << i), zeros) and rec(ones, zeros | (1 << i)):
                    res = True; break
            memo[key] = res; return res
        return rec(0, 0)

    # ---- stage 3: tune the FREE part to chi = 1 and chi(link) = 1 exactly ----
    # A free orbit whose proper subsets are already all IN can be added without
    # forcing anything else; it shifts chi by +60 (odd k) or -60 (even k) and
    # chi(link v) by +4k (even k) or -4k (odd k).  A small exact search over
    # these "addable" orbits hits the target pair (1, 1) when reachable; the
    # completion is then tested for nonevasiveness by the decision-tree
    # recursion.  This samples the candidate space; it does not exhaust it.
    free_orbits = [o for o in range(len(orbits)) if o not in pos]
    def chis(mem):
        chi = 0; chil = 0
        for m in range(1, 1 << N):
            if mem[m]:
                k = bin(m).count('1'); chi += (-1) ** (k - 1)
                if (m & 1) and k >= 2: chil += (-1) ** (k - 2)
        return chi, chil
    def addable(mem):
        out = []
        for o in free_orbits:
            m = min(orbits[o])
            if mem[m]: continue
            ok = True
            for i in range(N):
                if (m >> i & 1) and not mem[m & ~(1 << i)]:
                    ok = False; break
            if ok: out.append(o)
        return out
    def add_orbit(mem, o):
        for m in orbits[o]: mem[m] = 1
    tested = 0; found = 0; tuned = 0
    for s in sols[: (len(sols) if a.exhaustive else min(len(sols), 12))]:
        mem = complete(s)
        chi, chil = chis(mem)
        # greedy tuning: repeatedly add an addable orbit that reduces the
        # L1 distance to (1,1); up to 40 additions
        for _ in range(40):
            if (chi, chil) == (1, 1): break
            best_o, best_d = None, abs(chi - 1) + abs(chil - 1)
            for o in addable(mem):
                k = size[o]
                dchi = 60 if k % 2 else -60
                dchil = -4 * k if k % 2 else 4 * k
                d = abs(chi + dchi - 1) + abs(chil + dchil - 1)
                if d < best_d: best_d, best_o = d, o
            if best_o is None: break
            add_orbit(mem, best_o)
            k = size[best_o]
            chi += 60 if k % 2 else -60; chil += -4 * k if k % 2 else 4 * k
        tested += 1
        if (chi, chil) != (1, 1):
            print(f"  candidate {tested}: could not tune to (1,1); reached chi={chi} chi(link)={chil}")
            continue
        tuned += 1
        t1 = time.time(); ne = nonevasive(mem); dt = time.time() - t1
        print(f"  candidate {tested}: {sum(mem)} sets, chi=1, chi(link)=1 -> "
              f"{'NONEVASIVE  <== COUNTEREXAMPLE' if ne else 'EVASIVE'}  ({dt:.1f}s)")
        found += ne
    print(f"\nstage 3: {tested} candidates, {tuned} tuned to chi=chi(link)=1 and tested exactly, {found} nonevasive")
    return 1 if found else 0
    found = []
    print(f"\nstage 3: {tested} completions tested, {len(found)} nonevasive")
    return 1 if found else 0

if __name__ == "__main__":
    sys.exit(main())
