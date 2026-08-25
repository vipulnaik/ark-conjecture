#!/usr/bin/env python3
r"""
sync_note.py -- check that `mu-theta-n2-note.md` and its LaTeX-markup twin
`mu-theta-n2-note-latex.md` still say the same thing.

The two files are declared identical in content and differ only in markup, so
nothing in either one is authoritative over the other: a divergence is a defect
wherever it sits.  The failure this catches is NOT a markup difference -- it is
a sentence present in one file and absent, truncated or altered in the other.
That is invisible to a visual diff, because every line differs anyway, and it
has happened: the LaTeX twin once read "...provable by current methods.pmod{12}$
-- the only class obstructed at both 2 and 3 --", the words "Two classes are
worth noting.  At $n \equiv 11 \" having been eaten mid-sentence.  The fragment
reads as prose and would have compiled to garbage.

WHAT IT COMPARES.  The multiset of numeric tokens in each file, after stripping
LaTeX control sequences and markup characters.  Numbers are the right probe:
they are what a reader checks, they survive rewording, and a dropped or altered
clause almost always takes one with it.

HOW TO READ THE OUTPUT.  Residual differences are expected and are markup
artefacts of the LaTeX notation, not content:

    only latex: 2, 1, 0, 2/2, 2/24, ...   <- \sqrt2, \tfrac12, \binom, \ldots
    only plain: 24, 9/8, 700, 1/2         <- the same values written as text

So the test is not "empty output".  It is that every token in the report can be
accounted for by the markup, and in particular that no token appears which
names a QUANTITY -- a density, a bound, a range, a residue class, a count.
A 10^5 on one side against 10^6 on the other is the signal; a bare 2 is not.
Run it after any edit to either file, and never edit one without the other.

Usage:
    python3 sync_note.py [plain.md] [latex.md]
"""
import re
import sys
from collections import Counter

PLAIN = sys.argv[1] if len(sys.argv) > 1 else "mu-theta-n2-note.md"
LATEX = sys.argv[2] if len(sys.argv) > 2 else "mu-theta-n2-note-latex.md"

# Strip control sequences first, then markup characters: \sqrt3 must lose the
# backslash-word AND keep the 3, since the plain file writes it as "√3".
STRIP = re.compile(r"\\[a-zA-Z]+|[${}*_`]")
NUM = re.compile(r"\d+\.\d+|\d+/\d+|\d+")


def tokens(path):
    return Counter(NUM.findall(STRIP.sub(" ", open(path).read())))


def main():
    a, b = tokens(PLAIN), tokens(LATEX)
    only_a, only_b = a - b, b - a
    print(f"{PLAIN} vs {LATEX}")
    print(f"  only in plain: {only_a.most_common(25) or 'none'}")
    print(f"  only in latex: {only_b.most_common(25) or 'none'}")
    print()
    print("Residual tokens are expected -- see this file's docstring.  Check that")
    print("each is a markup artefact and that none names a quantity; a quantity on")
    print("one side only means the two files have diverged in CONTENT.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
