"""Explicit witnesses for the cyclic chi claims, checked by naive face enumeration.

Two kinds of claim rest on value bookkeeping rather than on an exhibited complex:

  (1) a BAD (k, q) pair in outputs/cyclic_chi_modq.txt: some C_k-invariant proper
      complex on Z/k has chi = 1 (mod q);
  (2) a certificate (a, b, a1, a2, b1, b2) in outputs/cyclic_chi_certified.txt:
      nested invariant complexes A1 <= A2 on Z/a with chi (a1, a2) and B1 <= B2 on
      Z/b with chi (b1, b2), A1 and B1 proper, A2 and B2 not both full.

For each, CP-SAT looks for an explicit witness using only faces of at most S
vertices (S raised until found or the orbit count gets too large).  Every witness
found is then checked by code that shares nothing with the search: it lists every
face, and checks closure under deletion of a vertex, invariance under x -> x + 1,
properness, and chi = sum (-1)^(|F|-1).  A claim with no small-face witness is
reported as unwitnessed, not as false.

The product step itself (chi(P(A, B)) = chi(A) chi(B) and the union formula) is
tested separately by --product, on random small invariant complexes with every
face of the product complex listed.

usage: python3 cyclic_chi_witness_check.py [--modq] [--cert] [--product] [--pullback]
"""
import ast, itertools, os, random, sys
from ortools.sat.python import cp_model

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, '..', 'outputs')
MAXORB = 60000
SECS = 30                 # CP-SAT time per small-face search in derive (--secs N)


# ---------------------------------------------------------------- search side
def orbit_reps(m, s):
    """canonical reps (sorted tuples) of the C_m-orbits of subsets of size 1..s,
    with orbit sizes"""
    reps = []
    for t in range(1, s + 1):
        if t >= m:
            break
        for c in itertools.combinations(range(m), t):
            if c[0] != 0:
                break
            rots = [tuple(sorted((x + i) % m for x in c)) for i in range(m)]
            if c == min(rots):
                reps.append((c, len(set(rots))))
    return reps


def canon(f, m):
    return min(tuple(sorted((x + i) % m for x in f)) for i in range(m))


def search(m, s, want, nested, q=None, allow_full2=False, secs=60):
    """want = x (single) or (x, y) (nested).  q given: single, chi = 1 mod q.
    Returns ([reps of A1], [reps of A2], full2) or None."""
    reps = orbit_reps(m, s)
    if len(reps) > MAXORB:
        return 'too-big'
    idx = {c: i for i, (c, _) in enumerate(reps)}
    w = [(sz if len(c) % 2 else -sz) for c, sz in reps]
    M = cp_model.CpModel()
    X1 = [M.NewBoolVar('') for _ in reps]
    X2 = [M.NewBoolVar('') for _ in reps] if nested else X1
    for i, (c, _) in enumerate(reps):
        if len(c) > 1:
            for j in range(len(c)):
                sub = idx[canon(c[:j] + c[j + 1:], m)]
                M.AddImplication(X1[i], X1[sub])
                if nested:
                    M.AddImplication(X2[i], X2[sub])
        if nested:
            M.AddImplication(X1[i], X2[i])
    chi1 = sum(w[i] * X1[i] for i in range(len(reps)))
    if q is not None:
        z = M.NewIntVar(-10**7, 10**7, '')
        M.Add(chi1 == 1 + q * z)
    elif nested:
        M.Add(chi1 == want[0])
        M.Add(sum(w[i] * X2[i] for i in range(len(reps))) == want[1])
    else:
        M.Add(chi1 == want)
    S = cp_model.CpSolver()
    S.parameters.max_time_in_seconds = secs
    S.parameters.num_workers = 2
    st = S.Solve(M)
    if st not in (cp_model.OPTIMAL, cp_model.FEASIBLE):
        return None
    A1 = [reps[i][0] for i in range(len(reps)) if S.Value(X1[i])]
    A2 = [reps[i][0] for i in range(len(reps)) if S.Value(X2[i])]
    return A1, A2, False


def realise(m, want, nested, q=None, allow_full2=False, via=True):
    """a witness (A1 reps, A2 reps or None, A2 full?, d): reps are on Z/d, d | m,
    and the complexes on Z/m are their pull-backs (d = m: no pull-back)"""
    if nested and allow_full2 and want[1] == 1:      # A2 = the full simplex
        r = realise(m, want[0], False, via=via)
        return None if r is None else (r[0], None, True, r[3])
    for s in range(2, min(m, 4)):
        r = search(m, s, want, nested, q, secs=20)
        if r == 'too-big':
            break
        if r is not None:
            return r + (m,)
    if via:      # pull-back from a proper divisor (fullness and nesting are preserved)
        for d in sorted((d for d in range(2, m) if m % d == 0), reverse=True):
            r = realise(d, want, nested, q, allow_full2, via=False)
            if r is not None:
                return r
    for s in range(4, m):
        r = search(m, s, want, nested, q, secs=20)
        if r == 'too-big':
            return None
        if r is not None:
            return r + (m,)
    return None


def divisors_pm(x):
    x = abs(x)
    return sorted({d for d in range(1, x + 1) if x % d == 0} | {-d for d in range(1, x + 1) if x % d == 0}) if x else []


def factor_pairs(x):
    """(u, v) with u * v = x; for x = 0 only (0, v) and (u, 0) with |u|, |v| <= 3"""
    if x == 0:
        return [(0, v) for v in range(-3, 4)] + [(u, 0) for u in range(-3, 4) if u]
    return [(u, x // u) for u in divisors_pm(x)]


def derive(m, x, y, full_ok, depth=3, memo={}):
    """a derivation tree for a nested pair A1 <= A2 on Z/m with chi (x, y), A1 proper,
    A2 full only if full_ok.  Nodes:
      ('leaf', m, reps1, reps2)   explicit small-face witness (verified by check_tree);
      ('full', m, sub)            A2 = the full simplex, A1 = A1 of sub (chi(full) = 1);
      ('pull', m, d, sub)         pull-back of sub on Z/d (chi and inclusion preserved,
                                  fullness preserved: tested by --pullback);
      ('prod', m, c, d, s1, s2)   P(A1, B1) <= P(A2, B2) over Z/c x Z/d = Z/m (chi
                                  multiplies, tested by --product; full iff both are).
    Returns (tree, top_is_full) or None."""
    from math import gcd
    key = (m, x, y, full_ok, depth)
    if key in memo:
        return memo[key]
    memo[key] = None
    res = None
    if full_ok and y == 1:
        sub = derive(m, x, x, False, depth, memo)
        if sub is not None:
            res = (('full', m, sub[0]), True)
    if res is None:
        for s_ in range(1, min(m, 5)):
            r = search(m, s_, (x, y), True, secs=SECS)
            if r == 'too-big':
                break
            if r is not None:
                res = (('leaf', m, r[0], r[1]), False)
                break
    if res is None and depth > 0:
        for d in sorted((d for d in range(2, m) if m % d == 0), reverse=True):
            sub = derive(d, x, y, full_ok, depth - 1, memo)
            if sub is not None:
                res = (('pull', m, d, sub[0]), sub[1]); break
    if res is None and depth > 0:
        for c in range(2, m):
            d = m // c
            if m % c or gcd(c, d) != 1 or c > d:
                continue
            for u, v in factor_pairs(x):
                for s1, t in factor_pairs(y):
                    A = derive(c, u, s1, True, depth - 1, memo)
                    if A is None:
                        continue
                    B = derive(d, v, t, True, depth - 1, memo)
                    if B is None:
                        continue
                    if A[1] and B[1] and not full_ok:
                        B = derive(d, v, t, False, depth - 1, memo)
                        if B is None:
                            continue
                    res = (('prod', m, c, d, A[0], B[0]), A[1] and B[1])
                    break
                if res: break
            if res: break
    memo[key] = res
    return res


def check_tree(T):
    """recompute (chi(A1), chi(A2), A2 full?) of a derivation tree; every leaf is
    checked by face enumeration"""
    kind, m = T[0], T[1]
    if kind == 'leaf':
        F1, F2 = expand(T[2], m), expand(T[3], m)
        g1, c1 = verify(F1, m); g2, c2 = verify(F2, m)
        assert g1 and g2 and F1 <= F2
        return c1, c2, False
    if kind == 'full':
        x, _, _ = check_tree(T[2])
        return x, 1, True
    if kind == 'pull':
        assert m % T[2] == 0
        return check_tree(T[3])
    c, d = T[2], T[3]
    from math import gcd
    assert c * d == m and gcd(c, d) == 1
    a1, a2, fa = check_tree(T[4]); b1, b2, fb = check_tree(T[5])
    return a1 * b1, a2 * b2, fa and fb


def tree_str(T):
    k = T[0]
    if k == 'leaf': return f'leaf(Z/{T[1]})'
    if k == 'full': return f'full(Z/{T[1]}; {tree_str(T[2])})'
    if k == 'pull': return f'pull(Z/{T[1]} <- {tree_str(T[3])})'
    return f'prod(Z/{T[2]} x Z/{T[3]}: {tree_str(T[4])}, {tree_str(T[5])})'


# ------------------------------------------------------------ checking side
def expand(reps, m):
    faces = set()
    for c in reps:
        for i in range(m):
            faces.add(frozenset((x + i) % m for x in c))
    return faces


def verify(faces, m, full_ok=False):
    """closed, invariant, (proper), and its chi"""
    for f in faces:
        if len(f) > 1:
            for v in f:
                if f - {v} not in faces:
                    return False, 'not closed'
        if frozenset((x + 1) % m for x in f) not in faces:
            return False, 'not invariant'
        if len(f) == m and not full_ok:
            return False, 'not proper'
    return True, sum((-1) ** (len(f) - 1) for f in faces)


def chi_full(m):
    return 1


# ------------------------------------------------------------------ runs
def run_modq():
    lines = [l.split() for l in open(os.path.join(OUT, 'cyclic_chi_modq.txt'))
             if l.strip() and not l.startswith('#')]
    ok = no = 0
    for k, q, v, *_ in lines:
        k, q = int(k), int(q)
        if v != 'BAD':
            continue
        r = realise(k, None, False, q=q)
        if r is None:
            print(f'modq {k} {q}: no witness found'); no += 1; continue
        d = r[3]
        good, chi = verify(expand(r[0], d), d)
        assert good and (chi - 1) % q == 0, (k, q, chi)
        ok += 1
        how = '' if d == k else f' on Z/{d}, pulled back'
        print(f'modq {k} {q}: witness chi = {chi}, max face {max(map(len, r[0]))}{how}', flush=True)
    print(f'modq: {ok} BAD pairs witnessed and verified, {no} unwitnessed')


def run_cert(only=None):
    C = [(int(l.split()[0]), ast.literal_eval(l.split(None, 1)[1]))
         for l in open(os.path.join(OUT, 'cyclic_chi_certified.txt'))
         if l.strip() and not l.startswith('#')]
    if only:
        C = [c for c in C if c[0] in only]
    cache = {}
    ok = no = 0
    for k, (a, b, a1, a2, b1, b2) in C:
        assert a * b == k and (a2 - a1) * (b2 - b1) == (a1 - 1) * (b1 - 1)
        res = []
        for m, x, y, other_full_ok in ((a, a1, a2, True), (b, b1, b2, True)):
            key = (m, x, y)
            if key not in cache:
                cache[key] = realise(m, (x, y), True, allow_full2=True)
            res.append(cache[key])
        if None in res:
            # fall back to derivation trees: explicit leaves, lemma-tested steps
            D = [derive(m, x, y, True) for m, x, y in ((a, a1, a2), (b, b1, b2))]
            if None not in D:
                got = [check_tree(t) for t, _ in D]
                assert got[0][:2] == (a1, a2) and got[1][:2] == (b1, b2)
                if not (got[0][2] and got[1][2]):
                    ok += 1
                    print(f'cert {k}: derived and checked: A = {tree_str(D[0][0])}; '
                          f'B = {tree_str(D[1][0])}', flush=True)
                    continue
            print(f'cert {k}: unwitnessed side(s) '
                  f'{[s for s, r in zip(("A", "B"), res) if r is None]}', flush=True)
            no += 1; continue
        (A1, A2, fa, da), (B1, B2, fb, db) = res
        if fa and fb:
            print(f'cert {k}: both tops full'); no += 1; continue
        pulled = []
        for m, R1, R2, f, x, y in ((da, A1, A2, fa, a1, a2), (db, B1, B2, fb, b1, b2)):
            F1 = expand(R1, m)
            g1, c1 = verify(F1, m)
            assert g1 and c1 == x, (k, m, c1, x)
            if f:
                assert y == 1
            else:
                F2 = expand(R2, m)
                g2, c2 = verify(F2, m)
                assert g2 and c2 == y and F1 <= F2, (k, m, c2, y)
        ok += 1
        via = [f'{s}: Z/{d} pulled back' for s, d, m in (('A', da, a), ('B', db, b)) if d != m]
        print(f'cert {k}: both sides witnessed and verified' + (f" ({'; '.join(via)})" if via else ''), flush=True)
    print(f'cert: {ok} of {len(C)} certificates have explicit verified sides, {no} not')


def product_faces(FA, FB):
    """P(A, B): subsets of A-vertex x B-vertex whose projections are faces"""
    out = set()
    for fa in FA:
        for fb in FB:
            cells = [(x, y) for x in fa for y in fb]
            for t in range(1, len(cells) + 1):
                for S in itertools.combinations(cells, t):
                    if {x for x, _ in S} == fa and {y for _, y in S} == fb:
                        out.add(frozenset(S))
    return out


def run_product(trials=200, seed=1):
    rnd = random.Random(seed)
    seen = set(); nf = []
    for _ in range(trials):
        a, b = rnd.choice([(2, 3), (3, 2), (2, 5), (3, 4), (4, 3)])
        def rand_nested(m):
            reps = orbit_reps(m, m - 1)
            F2 = set()
            for c, _ in reps:
                if rnd.random() < .5:
                    F2 |= expand([c], m)
            F2 = {f for f in F2 if all(g in F2 for t in range(1, len(f))
                                       for g in map(frozenset, itertools.combinations(f, t)))}
            F1 = {f for f in F2 if rnd.random() < .6}
            F1 = {f for f in F1 if all(g in F1 for t in range(1, len(f))
                                       for g in map(frozenset, itertools.combinations(f, t)))}
            if rnd.random() < .2:
                F2 = {frozenset(c) for t in range(1, m + 1)
                      for c in itertools.combinations(range(m), t)}
            # restore invariance (orbit closure of a closed set stays closed)
            F1 = expand([tuple(sorted(f)) for f in F1], m)
            F2 = expand([tuple(sorted(f)) for f in F2], m) | F1
            return F1, F2
        A1, A2 = rand_nested(a)
        B1, B2 = rand_nested(b)
        D_a = {frozenset(c) for t in range(1, a + 1) for c in itertools.combinations(range(a), t)}
        D_b = {frozenset(c) for t in range(1, b + 1) for c in itertools.combinations(range(b), t)}
        if A2 == D_a and B2 == D_b:
            continue                      # X would be the full simplex
        X = product_faces(A1, D_b) | product_faces(D_a, B1) | product_faces(A2, B2)
        chi = lambda F: sum((-1) ** (len(f) - 1) for f in F)
        x1, x2, y1, y2 = chi(A1), chi(A2), chi(B1), chi(B2)
        # inclusion-exclusion: P(A1,D) & P(D,B1) = P(A1,B1); they meet P(A2,B2) in
        # P(A1,B2) and P(A2,B1); the triple intersection is P(A1,B1) again
        pred = x1 + y1 + x2 * y2 - x1 * y2 - x2 * y1
        got = chi(X)
        # invariance under the diagonal generator (1, 1) of Z/a x Z/b
        assert frozenset((x, y) for x in range(a) for y in range(b)) not in X
        inv = all(frozenset(((x + 1) % a, (y + 1) % b) for x, y in f) in X for f in X)
        closed = all(f - {v} in X for f in X if len(f) > 1 for v in f)
        assert inv and closed and got == pred, (a, b, got, pred)
        assert (chi(product_faces(A2, B2)) == x2 * y2)
        seen.add((x1, x2, y1, y2)); nf.append(len(X))
    print(f'  distinct (x1, x2, y1, y2): {len(seen)}; faces of X from {min(nf)} to {max(nf)}')
    print(f'product: {len(nf)} random cases, chi(P(A,B)) = chi(A)chi(B) and the union formula hold; '
          f'closed and invariant')


def run_pullback(trials=300, seed=2):
    """X = {S : pi(S) in Y} for pi: Z/k -> Z/m: closed, invariant, proper, chi(X) = chi(Y)"""
    rnd = random.Random(seed)
    cnt = 0; vals = set(); big = 0
    for _ in range(trials):
        m, t = rnd.choice([(2, 2), (2, 3), (3, 2), (2, 4), (3, 3), (4, 2), (5, 2), (2, 5), (3, 4), (4, 3), (6, 2)])
        k = m * t
        reps = orbit_reps(m, m - 1)
        Y = expand([c for c, _ in reps if rnd.random() < .5], m)
        Y = {f for f in Y if all(frozenset(g) in Y for u in range(1, len(f))
                                 for g in itertools.combinations(f, u))}
        Y = expand([tuple(sorted(f)) for f in Y], m)
        X = {frozenset(c) for u in range(1, k + 1) for c in itertools.combinations(range(k), u)
             if frozenset(x % m for x in c) in Y}
        good, cx = verify(X, k)
        _, cy = verify(Y, m)
        assert good and cx == cy, (m, t, cx, cy)
        cnt += 1; vals.add(cx); big = max(big, len(X))
    print(f'pullback: {cnt} random cases ({len(vals)} distinct chi, up to {big} faces), closed, invariant, proper and chi preserved')


if __name__ == '__main__':
    if '--secs' in sys.argv:
        i = sys.argv.index('--secs'); SECS = int(sys.argv[i + 1]); del sys.argv[i:i + 2]
    args = {x for x in sys.argv[1:] if not x.isdigit()} or {'--modq', '--cert', '--product', '--pullback'}
    if '--product' in args:
        run_product()
    if '--pullback' in args:
        run_pullback()
    if '--modq' in args:
        run_modq()
    if '--cert' in args:
        only = {int(x) for x in sys.argv[1:] if x.isdigit()}
        run_cert(only)
