#!/usr/bin/env python3
"""
verify_emission.py -- integrity checks on `ark_gap.g`'s emission files, and the
containment check between two batteries at the same degree.

WHY THIS EXISTS.  Every downstream stage reads the emission file and trusts it.
The failure modes are all silent: a file of the wrong degree parses fine and
produces a well-formed but meaningless catalog; a truncated file looks like a
smaller battery; a stale file differs from a current one ONLY IN THE TAG COLUMN,
which no check comparing orbital partitions can see (that one has already cost
two rounds -- see `small-degree-verification.md` item 6).  None of these raise
an exception anywhere in the pipeline.  Run this before committing hours to a
CSP run, and after any `ark_gap.g` change.

Degree is inferred from the map length unless --degree is given, since that is
the one field that pins it: 45 entries at n = 10, 66 at n = 12.

CHECKS
  format      four pipe-separated fields per line, map parses as integers
  length      map length equals C(n,2) for a single consistent n
  dense ids   orbital ids are exactly 1..t with no gaps (consume_gap.py
              subtracts one and indexes by them, so a gap silently shifts
              every class above it)
  duplicates  no key emitted twice -- would mean a resume wrote a done KEY
              without its data line, or two runs appended to one file
  tags        tag is `0`, a `+`-separated list of primes, or `P<prime>`;
              a malformed tag is read as a group name downstream, not rejected
  partition   each orbital is non-empty and the sizes sum to C(n,2)

CONTAINMENT (--contains OTHER)
  Checks that every orbital partition in OTHER appears in the main file, up to
  relabelling of points, via an isomorphism-invariant signature per orbital
  (size, sorted degree sequence, component count, triangle count).  This is how
  the TOM battery was shown to subsume the hand-built stages at n = 10 -- 186
  partitions to 131, 55 new, 0 lost.  Run it at n = 12 once the TOM emission
  finishes; a NON-empty "only in OTHER" list would mean TOM is NOT exhaustive
  there and wants investigating before the hand-built file is retired.

  The signature is invariant but not complete: two non-isomorphic partitions
  could in principle collide, which would make containment look better than it
  is.  It has not happened at n = 10 (the counts match a full comparison), and
  the direction of the risk is worth knowing rather than assuming away.

Usage:
    python3 verify_emission.py groups_out_12_tom.txt
    python3 verify_emission.py groups_out_12_tom.txt --contains groups_out_12.txt
    python3 verify_emission.py FILE --degree 12      # pin instead of infer

Exit status 1 if any check fails.
"""
import argparse
import re
import sys
from collections import Counter, defaultdict
from itertools import combinations

TAG_RE = re.compile(r'^(0|P\d+|\d+(\+\d+)*)$')


def load(path):
    rows = []
    problems = []
    for ln, line in enumerate(open(path), 1):
        line = line.rstrip('\n')
        if not line.strip():
            continue
        f = line.split('|')
        if len(f) != 4:
            problems.append(f'line {ln}: {len(f)} fields, expected 4')
            continue
        try:
            m = [int(x) for x in f[3].split(',')]
        except ValueError:
            problems.append(f'line {ln}: non-integer in orbital map')
            continue
        rows.append({'ln': ln, 'key': f[0], 'desc': f[1], 'tag': f[2], 'map': m})
    return rows, problems


def infer_degree(rows):
    """Degree from map length; also reports disagreement, which is a mixed file."""
    lens = Counter(len(r['map']) for r in rows)
    out = {}
    for L in lens:
        n = 3
        while n * (n - 1) // 2 < L:
            n += 1
        out[L] = n if n * (n - 1) // 2 == L else None
    return lens, out


def signature(m, n):
    """Isomorphism-invariant signature of the orbital partition."""
    pairs = list(combinations(range(n), 2))
    cls = defaultdict(list)
    for idx, v in enumerate(m):
        cls[v].append(pairs[idx])
    sig = []
    for es in cls.values():
        deg = Counter()
        adj = defaultdict(set)
        for a, b in es:
            deg[a] += 1
            deg[b] += 1
            adj[a].add(b)
            adj[b].add(a)
        tri = sum(1 for a, b in es for c in adj[a] & adj[b] if c > b)
        seen, comps = set(), 0
        for v in list(adj):
            if v in seen:
                continue
            comps += 1
            stack = [v]
            while stack:
                x = stack.pop()
                if x in seen:
                    continue
                seen.add(x)
                stack.extend(adj[x] - seen)
        sig.append((len(es), tuple(sorted(deg[v] for v in range(n))), comps, tri))
    return tuple(sorted(sig))


def main():
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('file')
    ap.add_argument('--degree', type=int, default=None,
                    help='pin the degree instead of inferring it from map length')
    ap.add_argument('--contains', metavar='OTHER',
                    help='check that every orbital partition of OTHER appears here')
    a = ap.parse_args()

    rows, problems = load(a.file)
    if not rows:
        print(f'{a.file}: no parseable rows'); return 2
    bad = len(problems)

    lens, degmap = infer_degree(rows)
    if len(lens) > 1:
        bad += 1
        print(f'*** map lengths disagree: {dict(lens)} -- MIXED-DEGREE FILE')
    L = max(lens, key=lens.get)
    n = a.degree or degmap.get(L)
    if n is None:
        bad += 1
        print(f'*** map length {L} is not C(n,2) for any n'); return 1
    exp = n * (n - 1) // 2
    print(f'{a.file}: {len(rows)} rows, degree {n} '
          f'({"pinned" if a.degree else "inferred"}), expect map length {exp}')

    wrong = [(r['ln'], r['key'], len(r['map'])) for r in rows if len(r['map']) != exp]
    gaps, badtag, empty = [], [], []
    for r in rows:
        s = set(r['map'])
        if s != set(range(1, max(r['map']) + 1)):
            gaps.append((r['ln'], r['key']))
        if not TAG_RE.match(r['tag']):
            badtag.append((r['ln'], r['key'], r['tag']))
        if len(s) == 0:
            empty.append(r['key'])
    keys = Counter(r['key'] for r in rows)
    dup = [k for k, c in keys.items() if c > 1]

    for label, items in (('format problems', problems),
                         ('wrong map length', wrong),
                         ('non-dense orbital ids', gaps),
                         ('malformed tags', badtag),
                         ('duplicate keys', dup),
                         ('empty partitions', empty)):
        status = 'ok  ' if not items else 'FAIL'
        print(f'  [{status}] {label}: {len(items)}'
              + (f'  {items[:4]}' if items else ''))
        bad += len(items)

    t = Counter(len(set(r['map'])) for r in rows)
    tags = Counter(r['tag'] for r in rows)
    print(f'  t range {min(t)}..{max(t)};  tags {dict(tags)}')
    plus = [r['key'] for r in rows if '+' in r['tag']]
    if plus:
        print(f'  multi-prime tags: {len(plus)}  {plus[:6]}')
        print('     (these carry a JUSTIFIED lcm condition -- verify the solver '
              'takes it;\n      see small-degree-verification.md item 6)')
    else:
        print('  multi-prime tags: 0 -- if this file was emitted by a current '
              'ark_gap.g\n     that is a real absence; if archived, it may '
              'predate the tag collection')

    if a.contains:
        other, oprob = load(a.contains)
        bad += len(oprob)
        olens, _ = infer_degree(other)
        if set(olens) != {exp}:
            print(f'\n*** {a.contains}: map lengths {dict(olens)}, expected {exp}'
                  f' -- different degree, not comparing')
            bad += 1
        else:
            mine = {signature(r['map'], n) for r in rows}
            theirs = {signature(r['map'], n) for r in other}
            only = theirs - mine
            print(f'\ncontainment: {a.file} has {len(mine)} distinct orbital '
                  f'partitions, {a.contains} has {len(theirs)}')
            print(f'  new here: {len(mine - theirs)}')
            if only:
                bad += len(only)
                print(f'  [FAIL] only in {a.contains}: {len(only)}'
                      f' -- the main file is NOT a superset')
                for s in list(only)[:3]:
                    print(f'      sizes {sorted(x[0] for x in s)}')
            else:
                print(f'  [ok  ] every partition of {a.contains} appears here')

    print()
    print('ALL CHECKS PASSED' if not bad else f'*** {bad} problem(s) ***')
    return 1 if bad else 0


if __name__ == '__main__':
    sys.exit(main())
