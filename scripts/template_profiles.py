"""Template profiles at n = 6 (orbital-evasiveness-notes.md section 7.9).

Templates = graph classes occurring as unions of orbitals of Oliver groups with t <= 3 orbitals (K_6 excluded).
A property's profile = the templates it contains; every t <= 3 condition depends only on the profile.
Enumerates realisable profiles, keeps those passing every t <= 3 condition, enumerates every monotone property
with a passing profile, and places each on the metaproperty ladder. Writes the survivors to template_survivors6.json
(each property as the list of its classes' representative edge masks; edge i is the i-th pair of
itertools.combinations(range(6), 2)).
USAGE   python3 template_profiles.py
"""
import sys, json
sys.argv = ["metaproperty_ladder_check.py", "6", "sample", "1", "tom6.txt"]
exec(open("metaproperty_ladder_check.py").read().split('NAMES=["OR"')[0])
from collections import Counter
small = [g for g in G if len(g['single']) <= 3]
T = sorted({int(c) for g in small for c in g['uc']} - {full}, key=lambda i: ecount[i]); Tset = set(T)
def chi_of(g, D): return sum(int(sg) for sg, u in zip(g['sign'], g['uc']) if int(u) in D)
def ok(g, c): return (c == 1) if g['exact'] else all((c - 1) % q == 0 for q in g['qs'])
profiles = []
def rec(k, S):
    if k == len(T): profiles.append(frozenset(S)); return
    i = T[k]; rec(k + 1, S)
    if (below[i] & Tset) - {i} <= S: rec(k + 1, S | {i})
rec(0, frozenset())
good = [S for S in profiles if all(ok(g, chi_of(g, S)) for g in small)]
props = []
for S in good:
    L = set().union(*(below[s] for s in S)) | {empty}; bad = Tset - S
    free = [c for c in range(K) if c not in L and not (below[c] & bad)]
    order = sorted(free, key=lambda i: ecount[i])
    def r(k, D):
        if k == len(order): props.append(D); return
        i = order[k]; r(k + 1, D)
        if below[i] - {i} <= D: r(k + 1, D | {i})
    r(0, frozenset(L))
print(f"{len(small)} Oliver classes with t <= 3; {len(T)} templates; {len(profiles)} realisable profiles; "
      f"{len(good)} pass every t <= 3 condition; {len(props)} monotone properties survive")
cnt = Counter(); combos = Counter(); out = []
for D in props:
    M = meta(D)
    for k in ("OR", "OCR", "NTR", "GR", "SGR"): cnt[k] += M[k]
    combos[(M["OCR"], M["NTR"], M["GR"])] += 1
    out.append(dict(classes=len(D), OCR=bool(M["OCR"]), NTR=bool(M["NTR"]), GR=bool(M["GR"]),
                    reps=sorted(int(rep[c]) for c in D)))
print("rung counts among survivors:", dict(cnt))
print("(OCR, NTR, GR) combinations:", dict(combos))
json.dump(out, open("template_survivors6.json", "w"))
