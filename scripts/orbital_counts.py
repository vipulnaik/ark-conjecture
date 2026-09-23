#!/usr/bin/env python3
"""
orbital_counts.py -- the number of orbitals t of each recorded witness group, and
the number of ISOMORPHISM TYPES t_eff among them.

t is computed from the witness by the full orbital decomposition of
`enumeration-proof.md` G.3a (= the count formula of `orbital-evasiveness-notes.md`
section 9.7):

    t = sum over parts [ intra classes + floor(F/2) within-class cross ] + C(k,2)

with intra classes = 1 for a matching block at full twist, and (r-1)/h for a
foreign block r with twist t_r, h = t_r if t_r is even else 2*t_r.

t_eff counts orbitals up to the permutations of [n] that map each orbital onto an
orbital.  Since a graph property is S_n-invariant, isomorphic orbitals are either
all in the property or all out, so t_eff -- not t -- is what the fixed-complex
criterion actually has to case-split over.  The identifications made here:

  * within-class cross distance classes s, s' with gcd(s,F) = gcd(s',F)
    (a block multiplier b -> kb maps one onto the other), so a fused class of F
    blocks has tau(F) - 1 cross TYPES instead of floor(F/2) orbitals;
  * all (r-1)/h cyclotomic classes of a foreign block (a multiplier x -> gx on
    that block cycles them).

Between-part orbitals are counted one per pair of parts; two between-orbitals can
also coincide (two equal parts), which this does not detect, so t_eff is an upper
bound on the true number of types.

USAGE
    python3 orbital_counts.py mu_table_ladder.csv
"""
import csv
import re
import sys
from collections import Counter

PART = re.compile(r"(\d+)x(\d+)(\*?)")


def tau(F):
    return sum(1 for d in range(1, F + 1) if F % d == 0)


def counts(witness):
    q = int(re.search(r"q=(\d+)", witness).group(1))
    parts = PART.findall(witness)
    t = te = 0
    for f, c, star in parts:
        F, c = int(f), int(c)
        if star:
            tt, m = 1, c - 1
            while m % q == 0:
                m //= q
                tt *= q
            h = tt if tt % 2 == 0 else 2 * tt
            t += (c - 1) // h
            te += 1
        else:
            t += 1 + F // 2
            te += 1 + (tau(F) - 1)
    k = len(parts)
    t += k * (k - 1) // 2
    te += k * (k - 1) // 2
    return t, te


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "mu_table_ladder.csv"
    T, TE = Counter(), Counter()
    N = 0
    lo = hi = None
    for r in csv.DictReader(open(path)):
        n = int(r["n"])
        lo = n if lo is None else min(lo, n)
        hi = n if hi is None else max(hi, n)
        t, te = counts(r["witness"])
        T[t] += 1
        TE[te] += 1
        N += 1

    def show(C):
        return ", ".join(f"{k}: {100 * v / N:.1f}%" for k, v in sorted(C.items())
                         if 100 * v / N >= 0.05)

    def cum(C, x):
        return 100 * sum(v for k, v in C.items() if k <= x) / N

    def mean(C):
        return sum(k * v for k, v in C.items()) / N

    print(f"{path}: {N} rows, n in [{lo}, {hi}]")
    print(f"t     : {show(T)}; max {max(T)}, mean {mean(T):.2f}; "
          f"t <= 4 {cum(T, 4):.1f}%, t <= 5 {cum(T, 5):.1f}%")
    print(f"t_eff : {show(TE)}; max {max(TE)}, mean {mean(TE):.2f}; "
          f"t_eff <= 4 {cum(TE, 4):.1f}%, t_eff <= 5 {cum(TE, 5):.1f}%")


if __name__ == "__main__":
    main()
