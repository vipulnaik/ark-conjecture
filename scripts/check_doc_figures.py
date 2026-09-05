#!/usr/bin/env python3
"""
check_doc_figures.py -- catch claims that a table extension has made stale.

Every table extension leaves some subset of the documents behind, and the ways
it does that are not all figures.  Two failure modes a figure sweep cannot see:
an argument whose SCOPE has silently expired (a corollary assuming every
computed value has delta > 1/25, once the floor falls below that), and a status
claim contradicting itself ("the search terminates" / "one value remains").  A
third is invisible even to those: a reference to a section or a named result
that no longer exists, which excising or renumbering a section creates and
which nothing else notices.  So this script runs five passes.

  PASS 1  FIGURES.  Range-dependent quantities the prose quotes.  Every quantity
          is recomputed at each historical checkpoint as well as at the current
          maximum, so a figure is reported as "correct for n <= 2212" rather than
          merely "does not match" -- the difference between an actionable report
          and 67 lines of noise.  This is what v1 got wrong: its suppression test
          compared a matched fragment against str(dict.values()), which almost
          never fires, so nearly everything survived to the report.

  PASS 2  SCOPE.  Arguments that fix a threshold the data can move past.  A claim
          like "delta > 1/25 forces s <= 3, and every computed value has delta >=
          0.0418" is a theorem plus a range assertion, and the range assertion
          expires without any figure changing.  Checked against the current floor.
          This pass also carries two INVARIANTS -- staleness classes that are
          prose rather than figures, so no other pass can see them, and both live
          defects found by a fresh read: (I1) no sentence may prescribe an F_mid
          strip on the SAFE cap, which the entangled-generator repair made
          anti-permissive and which the notes' own pitfall box was still
          teaching; (I2) every quoted count of ceiling constants must match the
          cardinality and modulus of the ceiling table itself, read off the
          table rather than hardcoded -- three mod-24-era counts survived the
          re-keying to six constants mod 12 in sentences that read as true.

  PASS 3  PROSE.  Status markers that drift because they are sentences, not
          numbers.  The signal is CONTRADICTION -- a file asserting both that the
          search is finished and that values remain -- not any single phrase.

  PASS 5  CENSUS.  The configuration census is deliberately duplicated between
          `enumeration-proof.md` (structure: shape, admissibility, which lemma
          applies) and `arithmetic-of-density.md` (behaviour: frequency, delta,
          why it stops winning).  The duplication is a reading convenience, not
          an accident -- a split table would force the reader to join two
          documents mentally, which is worse than the drift risk.  So the drift
          risk is handled here instead: every row keyed by an S-number is
          compared across files, and any S-number present in one census but not
          the other, or carrying a different shape description, is reported.

  PASS 7  TABLES.  Every markdown table's header, separator and body rows are
          checked for a consistent column count.  A mismatched separator makes
          the table render as a paragraph of pipes, which no other pass sees.

  PASS 6  REFS.  Every section reference and every named-result citation is
          resolved against the headings and bolded statements actually present
          in the documents.  Dangling ones are reported with the nearest
          candidates.  This is the pass for the failure mode the other four are
          blind to: excising a section leaves its inbound pointers behind, and
          a reader following one has no way to tell a typo from a move.

  PASS 8  HISTORY.  Dehistoricization.  Sentences describing how a document
          came to say what it says, rather than what is true.  Invisible to
          every other pass, since they are grammatical and accurate; the
          giveaway is that a first-time reader would not need them.  Era
          labels on measurements and the literature's own history are exempt
          by subject, since both look identical to a regex and are load-bearing.

  PASS 4  HYGIENE.  Doubled sentence fragments and doubled bold runs, which
          ad-hoc string replacement produces and which no reader catches.

It does NOT edit.  Several figures sit in sentences whose wording must change
with them, and several are legitimate historical citations.

Usage:
    python3 check_doc_figures.py mu_table_safe_v2.csv *.md
    python3 check_doc_figures.py mu_table_safe_v2.csv *.md --pass scope
    python3 check_doc_figures.py mu_table_safe_v2.csv *.md --quiet
"""
import csv, sys, re, collections, statistics, argparse

ap = argparse.ArgumentParser()
ap.add_argument("table")
ap.add_argument("docs", nargs="+")
ap.add_argument("--pass", dest="only", default="all",
                choices=["all", "figures", "scope", "prose", "hygiene", "census", "refs", "tables", "history", "s2", "witness", "pending"])
ap.add_argument("--quiet", action="store_true", help="findings only")
A = ap.parse_args()
DOCS = [d for d in A.docs if d.endswith(".md")]

# ------------------------------------------------------------------ the table

rows = list(csv.DictReader(open(A.table)))
for r in rows:
    r["n"] = int(r["n"]); r["density"] = float(r["density"])
    r["parts"] = int(r["parts"]); r["certified_K"] = int(r["certified_K"])
NMAX = max(r["n"] for r in rows)   # file maximum; see CONTIG below for the computed frontier

spf = list(range(NMAX + 2)); i = 2
while i * i <= NMAX + 1:
    if spf[i] == i:
        for j in range(i * i, NMAX + 2, i):
            if spf[j] == j: spf[j] = i
    i += 1
def omega(x):
    s = set()
    while x > 1:
        p = spf[x]; s.add(p)
        while x % p == 0: x //= p
    return len(s)
for r in rows:
    r["omega"] = omega(r["n"])

# ---------------------------------------------------- contiguous vs subsampled
#
# THE TABLE IS NOT A SAMPLE OF n; IT IS A CONTIGUOUS PREFIX PLUS A BIASED TAIL.
# Every non-prime-power up to CONTIG has been computed.  Above CONTIG the only
# rows present are ones pulled off `ladder_weak.txt` -- i.e. n selected BECAUSE
# the ladder scored them low -- so the tail is a low-density subsample and every
# aggregate over it is biased downward.  Measured on the v4 file: median density
# 0.199 below the frontier against 0.066 above it, and 0.8% vs 31.9% below 1/16.
#
# So all distributional quantities (medians, shares, tail counts, part-count
# splits) are computed over the CONTIGUOUS prefix only.  Extremal quantities
# that remain valid on any superset -- the floor, and "no value below X" --
# are reported for both, since a worklist row is exactly where a new minimum
# would first appear and discarding it would defeat the purpose of computing it.
def _is_prime_power(x):
    return len({p for p in _factors(x)}) == 1
def _factors(x):
    s = []
    while x > 1:
        p = spf[x]; s.append(p)
        while x % p == 0: x //= p
    return s
_present = {r["n"] for r in rows}
CONTIG = 0
for _n in range(6, NMAX + 1):
    if _is_prime_power(_n) or _n in _present:
        CONTIG = _n
    else:
        break
CONTIG_ROWS = [r for r in rows if r["n"] <= CONTIG]
TAIL_ROWS = [r for r in rows if r["n"] > CONTIG]

# Checkpoints: every n at which the table has been quoted at some point, plus the
# current maximum.  A figure written against an older frontier then reports as
# "correct for n <= C" rather than as unexplained.
#
# APPEND THE OLD MAXIMUM ON EVERY TABLE EXTENSION.  Two minutes, and skipping it
# turns every historical figure in the documents into noise in PASS 1.
CHECKPOINTS = sorted({c for c in [1306, 1428, 1540, 1572, 2000, 2007, 2212,
                                  2298, 2376, 2600, CONTIG, NMAX] if c <= NMAX})

def quantities(sub):
    if not sub:
        return {}
    D = [r["density"] for r in sub]
    n_ = len(sub)
    parts = collections.Counter(r["parts"] for r in sub)
    certK = collections.Counter(r["certified_K"] for r in sub)
    lo = min(sub, key=lambda r: r["density"]); hi = max(sub, key=lambda r: r["density"])
    ev = [r["density"] for r in sub if r["n"] % 2 == 0]
    od = [r["density"] for r in sub if r["n"] % 2 == 1]
    pct = lambda k: round(100.0 * k / n_, 1)
    o2 = sum(1 for r in sub if r["omega"] == 2)
    return {
        "row count":            n_,
        "n max":                max(r["n"] for r in sub),
        "density floor":        round(min(D), 6),
        "density floor at n":   lo["n"],
        "density max":          round(max(D), 6),
        "median density":       round(statistics.median(D), 4),
        "median density even":  round(statistics.median(ev), 4) if ev else None,
        "median density odd":   round(statistics.median(od), 4) if od else None,
        "one-part winners":     parts[1],
        "two-part winners":     parts[2],
        "three-part winners":   parts[3],
        "certified_K":          dict(sorted(certK.items())),
        "count delta >= 1/4":   sum(1 for x in D if x >= .25),
        "pct delta >= 1/4":     pct(sum(1 for x in D if x >= .25)),
        "count delta > 1/9":    sum(1 for x in D if x > 1/9),
        "pct delta > 1/9":      pct(sum(1 for x in D if x > 1/9)),
        "count delta <= 1/16":  sum(1 for x in D if x <= 1/16),
        "pct delta <= 1/16":    pct(sum(1 for x in D if x <= 1/16)),
        "count delta < 1/12":   sum(1 for x in D if x < 1/12),
        "omega(n) = 2":         o2,
        "pct omega(n) = 2":     pct(o2),
        "omega(n) >= 3":        n_ - o2 - sum(1 for r in sub if r["omega"] < 2),
        "max density omega>=3": round(max([r["density"] for r in sub if r["omega"] >= 3] or [0]), 4),
        "pct fused winners":    pct(parts[1]),
        "fallback rows":        sum(1 for r in sub if int(r.get("fallback", 0) or 0)),
    }

BY_RANGE = {c: quantities([r for r in rows if r["n"] <= c]) for c in CHECKPOINTS}
# CUR is the CONTIGUOUS frontier, not the file maximum: above CONTIG the table
# holds only worklist rows, so BY_RANGE[NMAX]'s distributional entries describe
# a low-density subsample rather than the range.  The floor is patched back in
# from the whole file, since a worklist row is precisely where a new minimum
# would appear and it stays valid on any superset.
CUR = dict(BY_RANGE[CONTIG]) if CONTIG in BY_RANGE else dict(quantities(CONTIG_ROWS))
_allq = quantities(rows)
# BOTH floors are current figures, because they answer different questions and a
# document may legitimately quote either.  The CONTIGUOUS floor is the minimum
# over a genuine range; the FILE floor may be lower because a worklist row above
# CONTIG is exactly where a new minimum appears.  Keeping only one of them makes
# the other read as stale -- which it is not -- and that mislabels a correctly
# scoped figure as a defect.  What a document must do is SAY WHICH; that is a
# prose matter this pass cannot check, so it reports both as current and leaves
# the scoping to the reader.
CUR["density floor (contiguous)"] = CUR["density floor"]
CUR["density floor at n (contiguous)"] = CUR["density floor at n"]
if _allq["density floor"] < CUR["density floor"]:
    CUR["density floor"] = _allq["density floor"]
    CUR["density floor at n"] = _allq["density floor at n"]
    CUR["row count (incl. tail)"] = _allq["row count"]

if not A.quiet:
    print(f"{A.table}: {len(rows)} rows, n up to {NMAX}")
    print(f"checkpoints: {', '.join(str(c) for c in CHECKPOINTS)}")
    print(f"contiguous frontier: n <= {CONTIG} ({len(CONTIG_ROWS)} rows) -- "
          f"aggregates below are over THIS range")
    if TAIL_ROWS:
        _td = sorted(r["density"] for r in TAIL_ROWS)
        print(f"plus {len(TAIL_ROWS)} worklist row(s) above it (median density "
              f"{_td[len(_td)//2]:.4f} against {CUR['median density']} contiguous) "
              f"-- a low-density subsample, excluded from every aggregate\n")
    else:
        print()
    for k, v in CUR.items():
        print(f"   {k:24} {v}")
    print()

findings = 0

# --------------------------------------------------------------- PASS 1 figures

def forms(v):
    out = set()
    if v is None or isinstance(v, bool):
        return out
    if isinstance(v, int):
        out |= {str(v), f"{v:,}"}
    elif isinstance(v, float):
        for d in (1, 2, 3, 4, 5, 6):
            out.add(f"{v:.{d}f}")
    elif isinstance(v, dict):
        out.add(str(v))
    return {x for x in out if len(x) >= 3}

INDEX = collections.defaultdict(set)
for c, q in BY_RANGE.items():
    for k, v in q.items():
        for f in forms(v):
            INDEX[f].add((k, c))

# Lines whose numbers are structural, not table figures.  Explicit rather than
# inferred: a silent whitelist is how a real staleness gets suppressed.
IGNORE = re.compile(
    r"(witness|attained at|mod 12|Fermat|Mersenne|repunit|orb\(|§|Theorem|Lemma|"
    r"Part [A-J]|20\d\d|arXiv|= \d+ ?[+·*]|\d+ ?[+·*] ?\d+|http)", re.I)

# Extremal quantities stay valid on any superset of the rows, so for these the
# whole file -- worklist tail included -- is the right population; distributional
# ones must come from the contiguous prefix.  See the staleness test below.
_EXTREMAL_KEYS = ("density floor", "density floor at n", "density max",
                  "row count", "n max")
def _extremal(k):
    return k in _EXTREMAL_KEYS or k.startswith("row count")

FIG = re.compile(r"(?<![\d.,])(\d{1,3},\d{3}|\d\.\d{4,6}|\d{1,3}\.\d(?=%))(?![\d.,])")

if A.only in ("all", "figures"):
    print("=" * 72); print("PASS 1  FIGURES"); print("=" * 72)
    hit_any = False
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        stale = []
        for ln, line in enumerate(txt.split("\n"), 1):
            if IGNORE.search(line):
                continue
            for m in FIG.finditer(line):
                frag = m.group(1)
                hits = INDEX.get(frag)
                # "Current" means the CONTIGUOUS frontier, not the file maximum:
                # a figure agreeing with the aggregate over n <= CONTIG is right,
                # and one agreeing only with the whole-file aggregate is quoting
                # a range contaminated by the worklist tail.
                #
                # EXCEPT for the extremal quantities, where the whole file is the
                # correct population and the prefix is not.  A worklist row above
                # CONTIG is computed precisely because it may be a new minimum, so
                # "the floor is X at n = Y" should quote the file, while "the
                # median is Z" should quote the prefix.  Treating NMAX as stale
                # for everything flags the floor -- a correct, current figure --
                # as a defect, and does so on every run once a tail row exists.
                if not hits or any(c == CONTIG for _, c in hits):
                    continue
                if any(c == NMAX and _extremal(k) for k, c in hits):
                    continue
                where = ", ".join(sorted({f"{k} @ n<={c}" for k, c in hits}))
                stale.append((ln, frag, where))
        if stale:
            hit_any = True; findings += len(stale)
            print(f"\n{d}: {len(stale)} figure(s) matching an OLD checkpoint only")
            for ln, frag, where in stale[:20]:
                print(f"   L{ln:<5} {frag:<10} correct for: {where}")
            if len(stale) > 20:
                print(f"   ... and {len(stale)-20} more")
    if not hit_any:
        print("no figure matches an old checkpoint without also matching the current one.")
    print("\n(A match against an old checkpoint may be a deliberate historical citation.")
    print(" The point is that it is a claim about a past range and should say so.)")

# A line that QUOTES an assertion is discussing it, not making it -- a session
# log records the old wording verbatim, and this repo's own R6 entry lists the
# prose markers.  Strip quoted and code spans before matching, or the checker
# reports itself and every log that describes a past state.
QUOTED = re.compile("[\u201c\"\u2018'`][^\u201d\"\u2019'`]{0,160}[\u201d\"\u2019'`]")
def despan(line):
    return QUOTED.sub(" ", line)

# Files that legitimately describe superseded states.  Prose contradictions and
# expired thresholds inside them are the record, not a defect.
# Files whose CHARTER is to carry history: session logs, run/check lists, and
# small-degree-verification.md, which is state-tracking by its own header
# ("what is outstanding, what has been verified against which artefact") in the
# same way pending-checks.md is for the arithmetic programme.  Edit-history
# phrasing and superseded figures are correct there, not drift.
ARCHIVE = re.compile(r"session-log|pending-checks|verification|README", re.I)

# ----------------------------------------------------------------- PASS 2 scope

SCOPE = [
    (re.compile(r"every computed value has (?:δ|delta) (?:≥|>=|>) ?([\d.]+)"), "abs"),
    (re.compile(r"(?:δ|delta) (?:≥|>=|>) ?([\d.]+)[^.]{0,70}(?:throughout|everywhere|at every computed|all computed)"), "abs"),
    (re.compile(r"(?:δ|delta) (?:>|exceeds) 1/(\d+)\b[^.]{0,40}forces"), "inv"),
    # NOTE: the "1/N" form must be matched FIRST and as "inv"; the bare-decimal
    # pattern below captures the "1" out of "1/25" otherwise and reports every
    # row as expired.  (Found 2026-08; it was firing on two true statements.)
    (re.compile(r"no computed value (?:falls |is |lies )?below 1/(\d+)"), "inv"),
    (re.compile(r"no computed value (?:falls |is |lies )?below (?!1/)([\d.]+)"), "abs"),
    (re.compile(r"the weakest density anywhere[^.]{0,40}is ([\d.]+)"), "abs"),
    # A floor stated as the minimum of the table, in any of the phrasings used.
    (re.compile(r"(?:smallest|minimum|lowest) density is \*\*?([\d.]+)"), "abs"),
    (re.compile(r"density floor[^.]{0,30}(?:is|at) \*\*?([\d.]+)"), "abs"),
    (re.compile(r"floor (?:of|is|at) \*\*?([\d.]+)\*?\*? \(n = \d+\)"), "abs"),
    # The s-ladder and part-count ladders, which are theorems whose SCOPE moves.
    (re.compile(r"s (?:≤|<=) 1/√(?:δ|delta) − 1 = ([\d.]+)"), "sval"),
    (re.compile(r"(?:δ|delta) (?:≤|<=|<) 1/(\d+)[^.]{0,60}(?:set|values|tail)"), "inv"),
    # Counts of the low-density tail, which move with the floor.
    (re.compile(r"(?:δ|delta) (?:≤|<=|<) 1/(\d+) set (?:holds|is) \*\*(\d+)"), "inv"),
    # ---- added 2026-08 after a review found four staleness classes PASS 2 missed.
    # (a) A floor quoted as "the current computed minimum" / "current minimum",
    #     which is the phrasing three documents used for the superseded 0.026117.
    (re.compile(r"(?:current|computed) minimum[^.]{0,30}?([\d.]{6,})"), "abs"),
    (re.compile(r"([\d.]{6,})[^.]{0,40}the current computed minimum"), "abs"),
    # (b) A floor quoted inside a B-vs-B0 comparison ("against B's X").
    (re.compile(r"against B's \*?\*?([\d.]{6,})"), "abs"),
    # (c) "the density floor has fallen to X" -- the Corollary-after-E.3 form.
    (re.compile(r"density floor has fallen to ([\d.]+)"), "abs"),
    # (d) "min mu(n)/C(n,2) >= X over ... n <= 10^6" -- the ladder floor quoted
    #     as an orientation constant, which moves with ladder_verify not the table.
    (re.compile(r"min μ\(n\)/C\(n,2\) (?:≥|>=) \*\*([\d.]+)"), "abs"),
]

if A.only in ("all", "scope"):
    print("\n" + "=" * 72); print("PASS 2  SCOPE"); print("=" * 72)
    floor = CUR["density floor"]
    print(f"current floor {floor} at n = {CUR['density floor at n']}\n")
    seen = False
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            probe = despan(line)
            for pat, kind in SCOPE:
                for m in pat.finditer(probe):
                    raw = m.group(1)
                    if kind == "sval":
                        # "s <= 1/sqrt(delta) - 1 = X" is arithmetic on the floor,
                        # so it is stale the moment the floor moves, whatever the
                        # surrounding theorem says.
                        try: quoted = float(raw)
                        except ValueError: continue
                        actual = 1.0 / floor ** 0.5 - 1
                        seen = True
                        if abs(quoted - actual) > 0.005 and not ARCHIVE.search(d):
                            findings += 1
                            print(f"{d} L{ln}  *** STALE *** s-bound {quoted:.4g} "
                                  f"against {actual:.4g} at the current floor")
                            print(f"   {line.strip()[:150]}\n")
                        elif not A.quiet:
                            print(f"{d} L{ln}  [ok] s-bound {quoted:.4g}")
                        continue
                    try: thr = 1.0 / float(raw) if kind == "inv" else float(raw)
                    except ValueError: continue
                    below = sorted(r["n"] for r in rows if r["density"] < thr)
                    seen = True
                    if kind == "inv":
                        # A theorem ("delta > 1/25 forces s <= 3") never expires.
                        # What matters is how many values now fall outside its
                        # scope, so the surrounding prose can be recounted.
                        if not A.quiet or below:
                            print(f"{d} L{ln}  [theorem] scope 1/{raw}: "
                                  f"{len(below)} computed value(s) below it"
                                  + (f" {below[:8]}" if below else ""))
                            print(f"      -> check the surrounding sentence names exactly these.")
                    elif below and not ARCHIVE.search(d):
                        findings += 1
                        print(f"{d} L{ln}  *** EXPIRED *** threshold {thr:.6g}")
                        print(f"   {line.strip()[:150]}")
                        print(f"   {len(below)} computed value(s) now below it: {below[:6]}\n")
                    elif below:
                        if not A.quiet:
                            print(f"{d} L{ln}  [archive] threshold {thr:.6g}, "
                                  f"{len(below)} below -- superseded state, not a defect")
                    elif not A.quiet:
                        print(f"{d} L{ln}  [ok] threshold {thr:.6g} <= floor {floor}")
    if not seen:
        print("no threshold assertion recognised.")
    print("\nNOTE: these patterns are a WHITELIST. Silence means 'nothing recognised',")
    print("not 'nothing to find'. Add a pattern whenever a new range assertion is written.")

    # ---- INVARIANTS.  Two staleness classes that are PROSE rather than figures,
    # so nothing above sees them.  Both were live defects found by a fresh read in
    # 2026-08 and both are one grep once stated.
    #
    # (I1) THE SAFE CAP MUST NOT BE DESCRIBED WITH AN F_mid STRIP.  The corrected
    #      shape space makes that cut anti-permissive (the block-rotation image is
    #      a quotient of the cyclic layer, not a subgroup; an entangled generator
    #      supplies rotation and full twist together), and the live cap in
    #      `mu_enumerate_v3.py` is the flat F*C(c,2).  The defect this catches is
    #      a sentence PRESCRIBING the strip -- including, as it happened, the very
    #      pitfall box whose job is to warn readers off it.  Sentences that name
    #      the strip in order to reject it are exempt, detected by a negation
    #      marker.  The F*orb(c, dmax) form is legitimate in the CERTIFICATES,
    #      where dmax strips the licensed FOREIGN prime and nothing else, so the
    #      trigger is the co-occurrence of dmax with F_mid, not dmax alone.
    print()
    NEG = re.compile(r"\b(not|never|no |unsound|anti-permissive|invalid|"
                     r"illusory|false|tempting|must not|cannot)\b", re.I)
    i1 = 0
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            if "dmax" not in line:
                continue
            if not re.search(r"F_mid|coprime to F\b|block count", line):
                continue
            if NEG.search(line):
                continue
            findings += 1; i1 += 1
            print(f"{d} L{ln}  *** INVARIANT I1 *** dmax described with an F_mid "
                  f"strip and no negation: the SAFE cap is the flat F*C(c,2)")
            print(f"   {line.strip()[:170]}\n")
    if not i1:
        print("[ok] I1: no sentence prescribes an F_mid strip on the SAFE cap.")

    # (I2) CONSTANT COUNTS MUST MATCH THE CEILING TABLE.  Three mod-24-era counts
    #      ("seven mod-24 ceilings", "eight constants", "seven distinct delta_0")
    #      survived the re-keying to mod 12 with six constants, each in a sentence
    #      that reads as true.  The table is the authority, so read its cardinality
    #      off it rather than hardcoding: aod section 3.3.5's rows are keyed by a
    #      "n mod 12" header and their cap column holds the constants.
    WORDS = {"two": 2, "three": 3, "four": 4, "five": 5, "six": 6, "seven": 7,
             "eight": 8, "nine": 9, "ten": 10, "twelve": 12}
    ncap = nmod = None
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        m = re.search(r"\| *n mod (\d+) *\|.*?\n(?:\|.*\n)+", txt)
        if m:
            nmod = int(m.group(1))
            body = [l for l in m.group(0).split("\n")[2:] if l.startswith("|")]
            caps = set()
            for l in body:
                cells = [c.strip() for c in l.strip("|").split("|")]
                if cells and cells[-1]:
                    caps.add(cells[-1].strip("* "))
            ncap = len(caps)
            break
    if ncap:
        print(f"\n[ceiling table] {ncap} distinct constants, keyed mod {nmod}")
        # The patterns are deliberately NARROW.  A loose "(number) ... constants"
        # form matches half the prose in these files -- "two engines", "the
        # constants die at k >= 3", "keyed mod 12 with six constants" (capturing
        # the 12) -- and a noisy invariant is one nobody reads.  So each pattern
        # below must name the counted object explicitly.
        PATS = [
            # "seven mod-24 ceilings", "six mod-12 ceilings", "six ceilings"
            # The lookbehind matters: "the mod-12 ceilings" is a KEYING and not a
            # count, and without it the modulus is read as the cardinality.
            re.compile(r"(?<!mod )(?<!mod-)\b(" + "|".join(WORDS) + r"|\d+)\b"
                       r"(?: mod[- ](\d+))? (?:class )?ceilings\b", re.I),
            # "seven distinct delta_0", "six distinct constants"
            re.compile(r"\b(" + "|".join(WORDS) + r"|\d+)\b distinct "
                       r"(?:δ₀|delta_0|ceilings|constants)\b", re.I),
            # "the eight constants come from", "the six constants"
            re.compile(r"\bthe (" + "|".join(WORDS) + r"|\d+) constants\b", re.I),
            # "keyed mod 12 with six constants" -- both numbers in one phrase
            re.compile(r"keyed mod (\d+) with (" + "|".join(WORDS) + r"|\d+) "
                       r"constants", re.I),
        ]
        i2 = 0
        for d in DOCS:
            try: txt = open(d).read()
            except OSError: continue
            for ln, line in enumerate(txt.split("\n"), 1):
                probe = despan(line)
                for pi, pat in enumerate(PATS):
                    for m in pat.finditer(probe):
                        if pi == 3:
                            mod, raw = int(m.group(1)), m.group(2).lower()
                        else:
                            raw = m.group(1).lower()
                            mod = int(m.group(2)) if pat.groups > 1 and m.group(2) else None
                        k = WORDS.get(raw)
                        if k is None:
                            try: k = int(raw)
                            except ValueError: continue
                        if re.search(r"collaps|solvable|k = 3|k >= 3|k ≥ 3", line):
                            continue     # a different table's cardinality
                        if pi == 0 and mod is None and k <= 2:
                            continue     # "two ceilings" = the two crude bounds of
                                         # notes section 2, not this table
                        if pi == 2 and not re.search(
                                r"ceiling|δ₀|delta_0|shifted-prime|residue", line):
                            continue     # "the two constants" a script reports
                        if k == ncap and (mod is None or mod == nmod):
                            continue
                        findings += 1; i2 += 1
                        print(f"{d} L{ln}  *** INVARIANT I2 *** quotes {k} "
                              f"constants{f' mod {mod}' if mod else ''} against the "
                              f"table's {ncap} mod {nmod}")
                        print(f"   {line.strip()[:170]}\n")
        if not i2:
            print("[ok] I2: every constant count matches the ceiling table.")

    # (I3) WHICH RESIDUES TAKE F = 4 IS THE CEILING TABLE'S TO SAY.  The rekey
    #      moved classes 7 and 15 off the F = 4 rung and onto F = 2 at eta = 1/2,
    #      but "F = 4 attains the class ceiling at 7, 11, 15, 23" survived in
    #      prose, in a script docstring and in a census expect string -- each
    #      sentence true when written and none of them a figure, a constant count
    #      or a strip prescription, so I1, I2 and PASS 1 are all blind to it.
    #      Read the F assignment off the table's own rung column, reduce every
    #      quoted list mod the table's modulus, and compare as sets.  Residues
    #      mod 24 are accepted since a mod-12 law is legitimately written either
    #      way; it is the SET that must agree.
    if ncap and nmod:
        f4 = set()
        for d in DOCS:
            try: txt = open(d).read()
            except OSError: continue
            m = re.search(r"\| *n mod %d *\|.*?\n(?:\|.*\n)+" % nmod, txt)
            if not m:
                continue
            for l in m.group(0).split("\n")[2:]:
                if not l.startswith("|"):
                    continue
                cells = [c.strip() for c in l.strip("|").split("|")]
                if len(cells) < 2:
                    continue
                if re.search(r"F *= *4", cells[1]):
                    for r_ in re.findall(r"\d+", cells[0].replace("*", "")):
                        f4.add(int(r_) % nmod)
            if f4:
                break
        if f4:
            print(f"[ceiling table] F = 4 attains the cap at n = "
                  f"{sorted(f4)} (mod {nmod})")
            CLAIM = re.compile(
                r"F *= *4[^.|]{0,80}?(?:attains|sets|takes|wins)[^.|]{0,40}?"
                r"(?:class )?ceiling[^.|]{0,40}?at\s+(?:n\s*[=≡]\s*)?"
                r"((?:\d+\s*(?:,|and|or)?\s*)+)"
                r"\(mod\s*(\d+)\)", re.I)
            i3 = 0
            for d in DOCS + [f for f in A.docs if f.endswith(".py")]:
                try: txt = open(d).read()
                except OSError: continue
                # Scan the WHOLE text, not line by line: these claims wrap across
                # lines in prose and are reflowed in docstrings, and a per-line
                # scan silently misses exactly the wrapped ones -- which is how
                # the stale docstring survived. Newlines (and comment/quote
                # furniture at a line start) collapse to a single space, with the
                # line number recovered from the match offset.
                flat = re.sub(r"\n\s*(?:[#>*]\s*)?", " ", txt)
                starts = [m.start() for m in re.finditer(r"\n\s*(?:[#>*]\s*)?", txt)]
                for m in CLAIM.finditer(flat):
                    quoted = {int(x) % nmod
                              for x in re.findall(r"\d+", m.group(1))}
                    if quoted == f4:
                        continue
                    ln = txt.count("\n", 0, m.start()) + 1
                    findings += 1; i3 += 1
                    print(f"{d} L~{ln}  *** INVARIANT I3 *** says F = 4 attains "
                          f"the ceiling at {sorted(quoted)} (mod {nmod} "
                          f"reduced) against the table's {sorted(f4)}")
                    print(f"   {flat[max(0, m.start()-40):m.end()+40].strip()[:170]}\n")
            if not i3:
                print("[ok] I3: every F = 4 residue list matches the ceiling table.")

    # (I4) S2 IS NOT GATED ON omega(n) OR ON F BEING A PRIME POWER.  After the
    # entangled-generator correction the fusion count F is an arbitrary integer
    # carried by the cyclic layer, so the single fused class exists at EVERY
    # non-prime-power n and its density is (Q(n)-1)/(n-1).  The superseded rule
    # -- "F must be a q-power, hence omega(n) <= 2" -- reads as a plausible
    # premise wherever it survives, and it survived in five places across two
    # rounds of repair precisely because it is prose and not a figure.  n = 78
    # = 6*13 is the standing three-prime counterexample.
    # Only a REQUIREMENT trips this.  Statements measuring how the omega(n) = 2
    # population thins, or reporting its share of the table, are legitimate and
    # frequent; an earlier draft of this pass fired on all of them and would
    # have trained the reader to ignore I4 entirely.
    S2GATE = re.compile(
        r"(?:requir\w*|needs?|demands?|only if|available only|exists? only|"
        r"restricted to|confined to|gated on)"
        r"[^.|]{0,60}?(?:omega\(n\)|\u03c9\(n\))\s*[=\u2264<]{1,2}\s*[23]"
        r"|(?:omega\(n\)|\u03c9\(n\))\s*[=\u2264<]{1,2}\s*[23]"
        r"[^.|]{0,40}?(?:is required|is needed|outright)"
        r"|(?:fusion|block)\s+count\s+(?:must\s+be|has to be)\s+(?:a\s+)?"
        r"(?:q-)?(?:prime\s+)?power",
        re.I)
    # Sentences that mention the correction, or that quote the old rule in order
    # to refute it, are the point rather than a regression.
    S2OK = re.compile(r"entangl|supersed|no longer|not\s+(?:even\s+)?true"
                      r"|refut|old\s+(?:rule|form)|counterexample|correct(?:ed|ion)"
                      r"|F_mid|arbitrary integer", re.I)
    i4 = 0
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        flat = re.sub(r"\n\s*(?:[#>*]\s*)?", " ", txt)
        for m in S2GATE.finditer(flat):
            ctx = flat[max(0, m.start() - 300):m.end() + 300]
            if S2OK.search(ctx):
                continue
            ln = txt.count("\n", 0, m.start()) + 1
            findings += 1; i4 += 1
            print(f"{d} L~{ln}  *** INVARIANT I4 *** gates the fused shape on "
                  f"omega(n) or on F being a prime power; after the entangled "
                  f"correction S2 exists at every non-prime-power n")
            print(f"   {ctx[260:-260].strip()[:170]}\n")
    if not i4:
        print("[ok] I4: no surviving omega(n) / prime-power gate on the fused shape.")

    # (I5) THE HYPOTHESIS IS NEVER NAMED BARE.  (BCG) comes in two quantifier
    # strengths with materially different status -- (BCG-AL) is implied by no
    # fixed Bateman-Horn system, (BCG-AA) is -- and the note's fixed-window
    # variant (BCG_{1/5}) is incomparable to both.  A bare "(BCG)" is therefore
    # an error of STATEMENT, not a stylistic matter, and this pass exists to
    # make it catchable.  Generic uses that are about the name itself, or that
    # range over both variants deliberately, are exempted by context.
    # A bare "(BCG)" is fine where the sentence is about the CLAUSES -- d <= 12,
    # the shape, the local analysis -- since both variants share them, and
    # demanding a suffix there would put ~20 suffixes into prose that does not
    # depend on which one is meant.  It is an error only where the sentence
    # turns on the QUANTIFIER: what the hypothesis yields, implies, or buys,
    # and for how many n.  So the trigger is a bare tag in quantifier-sensitive
    # company, which is exactly the class of statement that can be wrong.
    BARE = re.compile(r"\(BCG\)(?!\s*[-\u2013]\s*(?:AL|AA)|_)")
    QUANT = re.compile(r"all (?:sufficiently )?large|almost all|every large"
                       r"|for all but|exceptional set|implies|implied by"
                       r"|yields|buys|delivers|grants?|granting|assuming"
                       r"|conditional on", re.I)
    BAREOK = re.compile(r"both variants|either variant|the name|two quantifier"
                        r"|variant|locally soluble|/\(SP\)|\(BCG\)/"
                        r"|errors of statement", re.I)
    i5 = 0
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        flat = re.sub(r"\n\s*(?:[#>*]\s*)?", " ", txt)
        for m in BARE.finditer(flat):
            ctx = flat[max(0, m.start() - 220):m.end() + 220]
            if BAREOK.search(ctx):
                continue
            # Sentence-local test: the clause the tag sits in, not the paragraph.
            lo = max(flat.rfind(".", 0, m.start()), flat.rfind("**", 0, m.start()))
            hi = flat.find(".", m.end())
            sent = flat[lo + 1: hi if hi > 0 else m.end() + 200]
            if not QUANT.search(sent):
                continue
            ln = txt.count("\n", 0, m.start()) + 1
            findings += 1; i5 += 1
            print(f"{d} L~{ln}  *** INVARIANT I5 *** bare (BCG) in a "
                  f"quantifier-sensitive sentence; name the variant -- "
                  f"(BCG-AL), (BCG-AA), or (BCG_{{1/5}})")
            print(f"   {ctx[190:-190].strip()[:170]}\n")
    if not i5:
        print("[ok] I5: every (BCG) reference names its variant.")

    # (I6) F.4'S COFACTOR CONSTANT IS D(delta_0), NOT 2/delta_0.  The crude form
    #      follows from bounding r <= n; the sharp one uses the fact that a
    #      configuration carrying a foreign part carries a second part too, of
    #      support > sqrt(delta*n*(n-1)), so r <= n - sqrt(delta*n*(n-1)) and
    #      (r-1)/Q <= 2(1-sqrt(delta_0))^2/delta_0.  Both are TRUE, which is why
    #      this needs an invariant rather than a figure check: a sentence quoting
    #      2/delta_0 as "the Proposition's bound" reads as correct and merely
    #      understates the result by a factor of ~1.7 in the constant and ~1.7 in
    #      the reported slack.  Sentences naming 2/delta_0 as the crude form it
    #      implies are exempt, detected by a marker.
    print()
    CRUDE_OK = re.compile(r"\b(crude|implies|weaker|follows|window|earlier)\b", re.I)
    i6 = 0
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            if not re.search(r"2/(?:δ|delta)", line):
                continue
            # Restricted to sentences about F.4's OWN bound.  The same
            # quantity 2/delta appears legitimately elsewhere -- q-pinning's
            # u <= 2/delta is a per-configuration gate with its own derivation
            # -- and firing there would train the reader to ignore this.
            if not re.search(r"\(r ?[-−] ?1\)/Q|F\.4|D\(δ|D\(delta|D = |D ≤ ", line):
                continue
            if CRUDE_OK.search(line):
                continue
            findings += 1; i6 += 1
            print(f"{d} L{ln}  *** INVARIANT I6 *** cofactor bound quoted as "
                  f"2/delta_0; F.4 states D(delta_0) = 2(1-sqrt(delta_0))^2/delta_0")
            print(f"   {line.strip()[:170]}\n")
    if not i6:
        print("[ok] I6: no sentence quotes the crude cofactor bound as F.4's own.")

    # (I7) A DISTRIBUTIONAL FIGURE MUST NAME ITS SCOPE.  The table is a
    #      contiguous prefix plus a worklist-driven tail, and the tail is
    #      selected BY LOW LADDER SCORE, so a count taken over the whole CSV
    #      misreports every share.  The failure is an off-by-a-few that looks
    #      exactly like a stale figure -- the census read 396 where the prefix
    #      holds 395, because one worklist row was included -- so it is invisible
    #      to a figure check, which cannot tell which population was intended.
    #      Trigger: a winner count or share with no scope word anywhere near it.
    print()
    SCOPED = re.compile(r"contiguous|prefix|\[6, ?\d+\]|over the range|to n = \d+|"
                        r"worklist|whole (?:file|CSV)|all \d[\d,]* rows", re.I)
    COUNTY = re.compile(r"\*\*(\d[\d,]{1,5})\*\* (?:winners|of them|rows)|"
                        r"(?:winners|winner count)[^.]{0,20}\*\*\d")
    i7 = 0
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            if not COUNTY.search(line):
                continue
            if SCOPED.search(line):
                continue
            findings += 1; i7 += 1
            print(f"{d} L{ln}  *** INVARIANT I7 *** winner count with no scope "
                  f"named; say whether it is the contiguous prefix or the file")
            print(f"   {line.strip()[:170]}\n")
    if not i7:
        print("[ok] I7: every winner count names the population it was taken over.")

    # (I8) AN ODD-F ESCAPE CLAUSE MUST NAME THE PARITY OF n.  "F*c even forces
    #      c = 2^a" is true only for ODD F at ODD n.  At even n an odd F leaves
    #      c an ordinary odd prime, the supply is a full Hardy-Littlewood
    #      system, and at n = 2, 8 (mod 12) -- where the ell = 3 obstruction
    #      cuts S3 to eta = 1/3 -- cap_3(1) = cap_1(1/3) exactly, so F = 3 TIES
    #      for the class ceiling and co-wins the class.  A sentence that draws
    #      the O(log n)/O(n/log n) escape conclusion while quantifying over all
    #      F >= 3, or over all n, is the third instance of this project's
    #      recurring failure: a case analysis whose proof covers one half of a
    #      partition and whose statement covers both.  It is prose, not a
    #      figure, so nothing else here can see it.
    print()
    ESCAPE = re.compile(
        r"(?:F\s*[·*x]\s*c|Fc)\s+even[^.]{0,80}?(?:forces?|hence|so)\s*"
        r"[^.]{0,40}?(?:c\s*=\s*)?2\^?a"
        r"|odd F[^.]{0,120}?(?:escape|O\(log n\)|O\(n/log n\)|wins nowhere)"
        r"|(?:S7 )?at F (?:>=|\u2265) 3[^.]{0,80}?(?:is an escape|wins nowhere|does vanish)",
        re.I)
    # A clause that says which parity of n it is talking about, or that names
    # the tie, is the corrected form rather than a regression.
    ESCAPE_OK = re.compile(r"odd n|at odd|even n|co-?win|ties?\b|tie for|2, ?8 \(mod 12\)"
                           r"|parity of \*?\*?n|both parities", re.I)
    i8 = 0
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        flat = re.sub(r"\n\s*(?:[#>*]\s*)?", " ", txt)
        for m in ESCAPE.finditer(flat):
            ctx = flat[max(0, m.start() - 200):m.end() + 200]
            if ESCAPE_OK.search(ctx):
                continue
            ln = txt.count("\n", 0, m.start()) + 1
            findings += 1; i8 += 1
            print(f"{d} L~{ln}  *** INVARIANT I8 *** odd-F escape clause with no "
                  f"parity of n named; at even n odd F is a co-winner at "
                  f"2, 8 (mod 12), not an escape")
            print(f"   {ctx[180:-180].strip()[:170]}\n")
    if not i8:
        print("[ok] I8: every odd-F escape clause names the parity of n it covers.")

    # (I9) CONDITION (4) CARRIES NO TWIST STRIP.  The certificates ask whether a
    #      configuration's SAFE score can reach B_safe(n), and SAFE credits a
    #      p-characteristic part the flat F*C(c,2).  A cap of F*orb(c, dmax)
    #      tests a smaller number: anti-permissive, and invisible in the output.
    #      The strip was removed from all three sites in fb_common.py, but the
    #      prose describing it survived in four places across two documents and
    #      in the script's own closing banner -- each one reading as a live
    #      description of the gate.  The consequence is not cosmetic: it inflates
    #      the stated trusted base, since a strip-gated condition (4) would drag
    #      Lemma C, Corollary C-prime and J0a into the per-n proof.
    print()
    STRIP = re.compile(
        r"condition \(4\)[^.]{0,80}?(?:strip|stripping|orb\(c,\s*dmax\))"
        r"|(?:strip|stripping)[^.]{0,80}?condition \(4\)",
        re.I)
    STRIP_OK = re.compile(r"flat|no twist strip|diagnostic|no longer|not\b[^.]{0,20}strip"
                          r"|would|anti-?permissive|unread|supersed|used to|historical"
                          r"|no gate|is gone|survives only|former", re.I)
    i9 = 0
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        flat = re.sub(r"\n\s*(?:[#>*]\s*)?", " ", txt)
        for m in STRIP.finditer(flat):
            ctx = flat[max(0, m.start() - 200):m.end() + 200]
            if STRIP_OK.search(ctx):
                continue
            ln = txt.count("\n", 0, m.start()) + 1
            findings += 1; i9 += 1
            print(f"{d} L~{ln}  *** INVARIANT I9 *** describes condition (4) as "
                  f"applying a twist strip; it is the flat F*C(c,2), and the "
                  f"strip is an unread diagnostic")
            print(f"   {ctx[180:-180].strip()[:170]}\n")
    if not i9:
        print("[ok] I9: no live description of a twist strip inside condition (4).")

    # (I10) TWO RUN OUTPUTS THAT NO OTHER PASS OWNS, both of which have gone
    #       stale in exactly one document at a time.
    #
    #   (a) THE LADDER WORKLIST LENGTH.  It is not derivable from the CSV, so
    #       PASS 1 cannot see it; it is quoted in the identical status banner at
    #       the head of three documents, and a rerun updated two of them
    #       (44,091 against a surviving 45,390).  The check is agreement, not a
    #       value: the majority reading is taken as current and the minority
    #       reported, which is the right shape for a figure whose true value
    #       lives in a file this script does not read.
    #
    #   (b) A THRESHOLD DERIVED FROM A DENSITY FLOOR.  Corollary C-prime's
    #       "n >= 371" and D2-prime's "n >= 471" are functions of the ladder
    #       floor and of nothing else, so they move whenever it does and the
    #       sentence around them stays true-looking.  Any threshold quoted
    #       beside the superseded floor 0.02516 is stale by construction.
    print()
    WL = re.compile(r"\*\*([\d,]{5,7}) worklist entries")
    seen_wl = {}
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            m = WL.search(line)
            if m:
                seen_wl.setdefault(m.group(1), []).append((d, ln))
    i10 = 0
    if len(seen_wl) > 1:
        cur = max(seen_wl, key=lambda k: len(seen_wl[k]))
        for val, where in sorted(seen_wl.items(), key=lambda kv: -len(kv[1])):
            if val == cur:
                continue
            for d, ln in where:
                findings += 1; i10 += 1
                print(f"{d} L{ln}  *** INVARIANT I10a *** worklist length {val} "
                      f"against {cur} in {len(seen_wl[cur])} other place(s); "
                      f"the banner is duplicated verbatim, so requote all of them")
    STALE_FLOOR = re.compile(r"0\.02516")
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            if not STALE_FLOOR.search(line):
                continue
            if re.search(r"supersed|pre-repair|older|was |former|recompute", line, re.I):
                continue
            findings += 1; i10 += 1
            print(f"{d} L{ln}  *** INVARIANT I10b *** quotes the superseded ladder "
                  f"floor 0.02516; any threshold derived from it (C-prime, D2-prime) "
                  f"is stale -- recompute from the current floor")
            print(f"   {line.strip()[:170]}\n")
    if not i10:
        print("[ok] I10: worklist length agrees across documents; no threshold "
              "rests on the superseded floor.")

# --------------------------------------------------------------- PASS 7 tables
#
# A markdown table whose separator row has a different number of columns from
# its header silently renders as plain text -- the whole table collapses into a
# paragraph of pipes.  Nothing else here notices, because the content is still
# present and every figure in it still parses.  This costs one regex and catches
# an edit that adds or removes a column and misses the separator.
#
# Escaped pipes (\|) are literal cell content, not separators, so they must be
# masked before counting or every table containing |Gamma| reports a false
# mismatch.  ASCII-art diagrams drawn with pipes are skipped by requiring the
# header line to start with a pipe.

SEPROW = re.compile(r"^\s*\|[\s:\-\|]+\|\s*$")

def _ncols(line):
    return len(line.replace("\\|", "\x00").strip().strip("|").split("|"))

if A.only in ("all", "tables"):
    print("\n" + "=" * 72); print("PASS 7  TABLES"); print("=" * 72)
    nbad = ntab = 0
    for d in DOCS:
        try: lines = open(d).read().split("\n")
        except OSError: continue
        for i, line in enumerate(lines):
            if not SEPROW.match(line) or i == 0:
                continue
            head = lines[i - 1]
            if not head.strip().startswith("|"):
                continue                       # ASCII art, not a table
            if "+--" in head or "+--" in line:
                continue                       # box-drawing rule, not a separator
            if _ncols(head) < 2:
                continue                       # a one-column "table" is prose
            ntab += 1
            h, sc = _ncols(head), _ncols(line)
            bad_rows, j = [], i + 1
            while j < len(lines) and lines[j].strip().startswith("|"):
                if _ncols(lines[j]) != h:
                    bad_rows.append((j + 1, _ncols(lines[j])))
                j += 1
            if sc == h and not bad_rows:
                continue
            nbad += 1
            print(f"{d} L{i}  *** TABLE *** header has {h} columns")
            if sc != h:
                print(f"   separator row has {sc}")
            for ln, c in bad_rows[:3]:
                print(f"   L{ln} has {c}")
            print(f"   {head.strip()[:110]}\n")
    findings += nbad
    print(f"{ntab} tables checked, {nbad} malformed.")

# ------------------------------------------------------------------ PASS 6 refs
#
# Excising or renumbering a section leaves its inbound pointers behind, and
# nothing else in this script notices: the pointer is not a figure, not a
# threshold and not a status word.  A reader who follows one cannot tell a typo
# from a move, which is worse than a wrong number -- a wrong number at least
# announces itself against the table.
#
# Two kinds of anchor are collected per document.  SECTIONS come from headings
# and are keyed by their dotted number.  RESULTS come from the bolded statement
# openers this project uses ("> **Theorem 3.1 (...)**", "**Lemma B'**") and are
# keyed by kind plus label.  A citation resolves against the document named
# nearest before it on the same line, if any, and against its own document
# otherwise -- which is exactly how the prose reads.

SEC_DEF   = re.compile(r"^#{2,4}\s+(?:Part\s+[IVX]+\s+—\s+)?(\d+(?:\.\d+)*)\.?\s")
APX_DEF   = re.compile(r"^#{2,4}\s+Appendix\s+([A-Z])\b")
PART_DEF  = re.compile(r"^#{2,3}\s+Part\s+([A-Z]\d*(?:['′])?)\b")
RESULT_KINDS = r"Theorem|Lemma|Proposition|Corollary|Conjecture|Hypothesis"
RESULT_DEF = re.compile(r"\*\*(" + RESULT_KINDS + r")\s+([A-Z0-9][\w.'′]*)")
# Subsections in these documents are bolded run-in headings ("**2.4 The coherence
# conditions...**", "**9.5' Formula shape complexity**") rather than markdown
# headings, so they must be collected too or every reference to one dangles.
BOLD_SEC  = re.compile(r"^\*\*(\d+(?:\.\d+)*(?:['′])?)\s+\S")
# Citations.  The section form tolerates the double-section sign and a range.
SEC_CITE  = re.compile(r"§§?\s?(\d+(?:\.\d+)*)")
RES_CITE  = re.compile(r"\b(" + RESULT_KINDS + r")\s+([A-Z0-9][\w.'′]*)")
DOCNAME   = re.compile(r"`([\w-]+\.md)`")
# These documents refer to each other by short alias as well as by filename, and
# by role ("of the notes", "of the companion").  A checker that only knows the
# filename form reports every aliased reference as dangling, which is worse than
# not checking -- it trains the reader to ignore the pass.
ALIAS = {"aod": "arithmetic-of-density.md",
         "notes": "orbital-evasiveness-notes.md",
         "ep": "enumeration-proof.md",
         "the notes": "orbital-evasiveness-notes.md",
         "these notes": "orbital-evasiveness-notes.md",
         "the companion": "enumeration-proof.md"}
ALIAS_CITE = re.compile(r"`(aod|notes|ep)`")
ROLE_AFTER = re.compile(r"^\s*(?:of|in)\s+(the notes|these notes|the companion)")
# Words that follow "Theorem"/"Lemma" without naming one.
NOT_A_LABEL = {"E", "A", "I", "N", "X", "The", "It", "This", "That", "If", "For",
               "In", "Its", "Two", "One", "Three", "Both", "So", "But", "And"}
# Files whose references are not ours to maintain: the logs and the pending list
# describe states and cite items by name, and the literature notes cite other
# people's numbered results, which resolve against their papers and not against
# anything here.  Checking them produces only noise.
NOT_OURS = re.compile(r"session-log|pending-checks|README", re.I)
# `literature-findings.md` is a special case rather than an exclusion.  It cites
# BOTH our documents and other people's papers, in the same notation, and there
# is no way to tell them apart from the number alone -- "section 5.1" is BBKN's
# construction section and also our branch-and-bound section, a few lines apart.
# So the file adopts a convention: every reference to one of OUR documents
# carries an explicit `aod` / `notes` / `ep` prefix, and a bare section number
# belongs to whichever paper the sentence names.  Here we check only the
# prefixed ones and skip the rest, which is the most that can be checked and is
# exactly what the convention was introduced to make possible.
# Documents in which a BARE result name ("Theorem 2", "Lemma 7") is the CITED
# PAPER'S numbering rather than ours, so only an explicitly prefixed reference
# resolves against our anchors.  literature-findings.md states this convention
# in its header; shparlinski-constants.md works inside a single paper, where
# every bare label is that paper's and prefixing all of them would be noise.
PREFIXED_ONLY = re.compile(r"literature-findings|shparlinski-constants", re.I)

# Authors and groups cited in these documents.  A named result immediately
# preceded by one of these is that paper's result under that paper's numbering,
# so it cannot be resolved against our own anchors and must not be reported.
EXTERNAL_ATTR = re.compile(
    r"\b(BBKN|Shparlinski|Oliver|Illies|Angel|Borja|Adamaszek|Baker|Harman|"
    r"Chowla|Bombieri|Vinogradov|Elliott|Halberstam|Kahn|Saks|Sturtevant|Black|"
    r"Jones|Zvonkin|Skorobogatov|Sofos|Montgomery|Vaughan|Pintz|Scheidweiler|"
    r"Triesch|Santha|Yao|Huppert|Smith|Maynard|Lichtman|Friedlander|Iwaniec|"
    r"Mikawa|Fouvry|Li|Bateman|Horn|Schinzel|Brun|Titchmarsh)"
    r"(?:'s|s'|--|\s*\(\d{4}\)|,)?\s*$", re.I)

def norm(label):
    """B', B′ and B’ are the same lemma.  Normalise the prime mark, or every
    citation that picks a different one reports as dangling."""
    return label.replace("′", "'").replace("’", "'")

def collect_anchors(docs):
    secs, ress = collections.defaultdict(set), collections.defaultdict(set)
    for d in docs:
        try: txt = open(d).read()
        except OSError: continue
        for line in txt.split("\n"):
            m = SEC_DEF.match(line)
            if m:
                num = m.group(1)
                secs[d].add(num)
                # A subsection implies its parents are addressable too.
                bits = num.split(".")
                for k in range(1, len(bits)):
                    secs[d].add(".".join(bits[:k]))
            m = APX_DEF.match(line)
            if m: secs[d].add("Appendix " + m.group(1))
            m = PART_DEF.match(line)
            if m: secs[d].add("Part " + m.group(1))
            m = BOLD_SEC.match(line.strip())
            if m:
                num = m.group(1).rstrip("'′")
                secs[d].add(num)
                bits = num.split(".")
                for k in range(1, len(bits)):
                    secs[d].add(".".join(bits[:k]))
            for m in RESULT_DEF.finditer(line):
                ress[d].add((m.group(1), norm(m.group(2).rstrip("."))))
    return secs, ress

def near(label, pool):
    """Candidates worth offering: same kind, or the same number under a
    different kind -- the two ways a citation usually goes wrong."""
    kind, num = label
    same_kind = sorted(n for k, n in pool if k == kind)
    same_num  = sorted(k for k, n in pool if n == num)
    out = []
    if same_num: out.append("exists as " + "/".join(f"{k} {num}" for k in same_num))
    if same_kind:
        close = [n for n in same_kind if n[:1] == num[:1]]
        if close: out.append(f"{kind} " + ", ".join(close[:6]))
    return "; ".join(out)

if A.only in ("all", "refs"):
    print("\n" + "=" * 72); print("PASS 6  REFS"); print("=" * 72)
    SECS, RESS = collect_anchors(DOCS)
    known_docs = set(DOCS)
    print(f"anchors: " + ", ".join(
        f"{d} ({len(SECS[d])} sections, {len(RESS[d])} results)" for d in DOCS) + "\n")
    dangling = 0
    for d in DOCS:
        if NOT_OURS.search(d):
            if not A.quiet:
                print(f"{d}: skipped -- logs cite items by name, not by section")
            continue
        prefixed_only = bool(PREFIXED_ONLY.search(d))
        if prefixed_only and not A.quiet:
            print(f"{d}: checking PREFIXED references only "
                  f"(`aod`/`notes`/`ep`); bare sections belong to cited papers")
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            if line.lstrip().startswith("#"):
                continue                      # a heading defines, it does not cite
            for m in SEC_CITE.finditer(line):
                # Resolve against the last document named before this point.
                # A document name binds a following reference only if it is close
                # by; "`aod.md` §6 ... and §9 of these notes" is a real sentence
                # shape, and a greedy binding mis-attributes the second.
                names = [x for x in DOCNAME.finditer(line)
                         if 0 <= m.start() - x.end() <= 40]
                names += [x for x in ALIAS_CITE.finditer(line)
                          if 0 <= m.start() - x.end() <= 40]
                role = ROLE_AFTER.match(line[m.end():])
                if prefixed_only and not names and not role:
                    continue          # bare section: belongs to a cited paper
                if role:
                    target = ALIAS[role.group(1)]
                elif names:
                    nm = max(names, key=lambda x: x.end()).group(1)
                    target = ALIAS.get(nm, nm)
                else:
                    target = d
                if target not in known_docs:
                    continue                  # not passed in; cannot judge
                if m.group(1) in SECS[target]:
                    continue
                # Resolving to the wrong document is a different defect from
                # citing something that does not exist, and only the second is
                # worth interrupting a read for.
                elsewhere = [x for x in DOCS if m.group(1) in SECS[x]]
                if elsewhere:
                    if not A.quiet:
                        print(f"{d} L{ln}  [elsewhere] §{m.group(1)} is in "
                              f"{', '.join(elsewhere)}, not {target}")
                    continue
                dangling += 1
                cands = sorted(x for x in SECS[target]
                               if x.split(".")[0] == m.group(1).split(".")[0]
                               and "." not in x[:1])
                print(f"{d} L{ln}  *** DANGLING *** §{m.group(1)} "
                      f"not in {target}")
                print(f"   {line.strip()[:140]}")
                if cands:
                    print(f"   {target} has: {', '.join(cands[:12])}")
                print()
            for m in RES_CITE.finditer(line):
                kind, num = m.group(1), m.group(2).rstrip(".")
                # "Theorem 2.3's inequality" cites Theorem 2.3.
                num = norm(num)
                if num.endswith("'s"):
                    num = num[:-2]
                if num in NOT_A_LABEL or not re.match(r"[A-Z0-9]", num):
                    continue
                names = [x for x in DOCNAME.finditer(line)
                         if 0 <= m.start() - x.end() <= 40]
                names += [x for x in ALIAS_CITE.finditer(line)
                          if 0 <= m.start() - x.end() <= 40]
                if prefixed_only and not names:
                    continue          # bare result name: a cited paper's
                # A result attributed to an external author is THEIR numbering,
                # not ours -- "BBKN's Theorem 1.4", "Shparlinski's Theorem 2".
                # Without this, every correctly-cited piece of the literature
                # reports as dangling, which trains the reader to skip the pass.
                # Attribution binds only when it is immediately before the label.
                if EXTERNAL_ATTR.search(line[max(0, m.start() - 30):m.start()]):
                    continue
                nm = names[-1].group(1) if names else d
                target = ALIAS.get(nm, nm)
                if target not in known_docs:
                    continue
                pool = RESS[target] | (RESS[d] if target != d else set())
                if (kind, num) in pool:
                    continue
                # A result may be stated in one document and cited from the other
                # without naming it, which is normal in this project.
                if any((kind, num) in RESS[x] for x in DOCS):
                    if not A.quiet:
                        where = [x for x in DOCS if (kind, num) in RESS[x]]
                        print(f"{d} L{ln}  [elsewhere] {kind} {num} is stated in "
                              f"{', '.join(where)}, not {target}")
                    continue
                dangling += 1
                print(f"{d} L{ln}  *** DANGLING *** {kind} {num} is stated nowhere")
                print(f"   {line.strip()[:140]}")
                hint = near((kind, num), set().union(*RESS.values()) if RESS else set())
                if hint: print(f"   nearest: {hint}")
                print()
    findings += dangling
    print(f"{dangling} dangling reference(s).")
    print("A reference resolving to the wrong document is NOT reported as dangling")
    print("when the target exists somewhere; that case prints as [elsewhere] and is")
    print("shown only without --quiet, since cross-document citation is normal here.")

# ----------------------------------------------------------------- PASS 3 prose

STATUS = {
    "finished": re.compile(r"the search (?:is|was) (?:now )?(?:complete|finished)|search then terminates|is \*\*finished\*\*", re.I),
    "pending":  re.compile(r"one value remains|\d+ (?:survivors|candidates) (?:are|between|remain)|completing (?:these|the) \w+|expected outcome", re.I),
    "all-but":  re.compile(r"all but (?:one|two|three|four|\d+)\b", re.I),
}
# "none exceeds" / "zero exceptions" fire on almost every verification sentence,
# so they are opt-in: informative to re-check by hand, useless as a default.
STATUS_VERBOSE = {
    "no-exc":   re.compile(r"zero exceptions|no exceptions|none exceeds|without exception", re.I),
}



if A.only in ("all", "prose"):
    print("\n" + "=" * 72); print("PASS 3  PROSE"); print("=" * 72)
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        found = collections.defaultdict(list)
        pats = dict(STATUS)
        if not A.quiet:
            pats.update(STATUS_VERBOSE)
        for ln, line in enumerate(txt.split("\n"), 1):
            probe = despan(line)
            for name, pat in pats.items():
                if pat.search(probe):
                    found[name].append((ln, line.strip()[:110]))
        clash = ("finished" in found and "pending" in found
                 and not ARCHIVE.search(d))
        if found and (clash or not A.quiet):
            print(f"\n{d}:")
            if clash:
                findings += 1
                print("   *** CONTRADICTION: 'finished' and 'pending' both present ***")
            for name in sorted(found):
                for ln, frag in found[name][:4]:
                    print(f"   L{ln:<5} [{name}] {frag}")
    print("\n('all but N' and 'no exceptions' are counts written as words, which no")
    print(" numeric sweep will ever catch. Recheck them against the table by hand.)")

# ------------------------------------------------------------------ PASS 9 S2
#
# The single fused class needs only that c be a prime power, and after the
# entangled-generator correction F is an arbitrary integer carried by the cyclic
# layer.  So the shape exists at EVERY non-prime-power n, and taking c = Q(n),
# the largest prime-power divisor, gives an identity rather than a bound:
#
#     delta_S2(n) = (Q(n) - 1) / (n - 1),        F = n/Q(n) > 1.
#
# Every row of the table must therefore clear F*C(Q,2) -- in exact integers, not
# floats, since the two agree to eleven places at the rows that matter.  This is
# worth a pass of its own because it checks the entangled correction from a
# direction that never touches the enumerator: the identity is arithmetic, the
# table is a search output, and a disagreement means one of them is wrong.
#
# Expected: 0 rows on any current-scoring table.  On the v4 BASELINE exactly two
# rows fail -- n = 78 and n = 222 -- which are precisely the two entries of
# entangled_exceedances.txt with no top prime (q=None), i.e. the composite-F,
# top-trivial configurations the superseded shape space could not express.  So a
# baseline run reporting {78, 222} is CORRECT and reporting fewer is the signal.

def largest_prime_power_divisor(n):
    best, m, d = 1, n, 2
    while d * d <= m:
        if m % d == 0:
            e = 1
            while m % d == 0:
                m //= d; e *= d
            best = max(best, e)
        d += 1 if d == 2 else 2
    return max(best, m)


def pass9_s2(rows, quiet=False):
    findings = 0
    viol = []
    for r in rows:
        n = r["n"]
        if n < 6:
            continue
        c = largest_prime_power_divisor(n)
        if c == n:                      # prime power: S1's domain, no F > 1
            continue
        mu = int(r["mu_bound"])
        s2 = (n // c) * (c * (c - 1) // 2)
        if s2 > mu:
            viol.append((n, mu, s2))
    if not viol:
        if not quiet:
            print("[ok] S2: delta_S2(n) = (Q(n)-1)/(n-1) holds at every row.")
        return 0
    baseline = {78, 222}
    ns = {n for n, _, _ in viol}
    print(f"S2 identity exceeded at {len(viol)} row(s): "
          f"{[n for n, _, _ in viol[:12]]}")
    for n, mu, s2 in viol[:6]:
        print(f"   n={n}: recorded {mu}, fused shape {n//largest_prime_power_divisor(n)}"
              f"x{largest_prime_power_divisor(n)} gives {s2}")
    if ns == baseline:
        print("   -- exactly the expected v4 baseline pair (78, 222); "
              "not a defect, see entangled_exceedances.txt")
    else:
        findings += 1
        print("   *** these are NOT the expected baseline pair; either the "
              "table is wrong at these n or the identity's domain is")
    return findings


# ---------------------------------------------------------------- PASS 5 census

# Statements duplicated across documents on purpose are delimited by
#     <!-- DUP:name -->  ...text...  <!-- /DUP -->
# An explicit end marker rather than "up to the next blank line", because a
# blockquoted theorem often runs across blank-looking "> " lines and the two
# copies then capture different extents -- which reports drift that is not there.
# PASS 5 compares every tagged block across files and reports drift.  The tag is
# invisible in rendered markdown, so the duplication costs the reader nothing.
DUP_RE = re.compile(r"<!--\s*DUP:([A-Za-z0-9_.\-]+)\s*-->\n(.*?)<!--\s*/DUP\s*-->", re.S)

def dup_blocks(txt):
    out = {}
    for m in DUP_RE.finditer(txt):
        out[m.group(1)] = " ".join(m.group(2).split())
    return out


# A census row looks like:  | **S7** | middle-layer-fused ... | ... |
CENSUS_ROW = re.compile(r"^\|\s*\*\*(S\d+)\*\*\s*\|([^|]*)\|")

def census_rows(txt):
    out = {}
    for line in txt.split("\n"):
        m = CENSUS_ROW.match(line.strip())
        if m:
            out[m.group(1)] = " ".join(m.group(2).split()).strip()
    return out

def norm(desc):
    """Compare shape descriptions loosely: the two censuses word them for
    different purposes, so only the distinguishing content should have to
    match.  Strip markdown, punctuation and a few synonyms."""
    d = desc.lower()
    for a_, b_ in (("**", ""), ("*", ""), ("`", ""), ("\\", ""), ("—", " "), ("–", " "),
                   ("-", " "), (",", " "), ("(", " "), (")", " "), (".", " "),
                   (":", " "), (";", " "), ("+", " plus ")):
        d = d.replace(a_, b_)
    drop = {"the", "a", "an", "of", "with", "and", "class", "classes", "block",
            "blocks", "one", "n", "layer", "copies", "count", "at", "in", "to"}
    return tuple(sorted(w for w in d.split() if w not in drop))

if A.only in ("all", "s2"):
    print("\n" + "=" * 72); print("PASS 9  S2 IDENTITY"); print("=" * 72)
    findings += pass9_s2(rows, quiet=False)

if A.only in ("all", "census"):
    print("\n" + "=" * 72); print("PASS 5  CENSUS"); print("=" * 72)
    cens = {}
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        r = census_rows(txt)
        if r:
            cens[d] = r
    if len(cens) < 2:
        print(f"only {len(cens)} document(s) carry a census; nothing to cross-check.")
        if cens:
            for d, r in cens.items():
                print(f"   {d}: {len(r)} rows, {', '.join(sorted(r, key=lambda x: int(x[1:])))}")
    else:
        files = list(cens)
        allS = set().union(*(set(r) for r in cens.values()))
        for sid in sorted(allS, key=lambda x: int(x[1:])):
            have = [d for d in files if sid in cens[d]]
            if len(have) != len(files):
                findings += 1
                miss = [d for d in files if d not in have]
                print(f"   {sid}: MISSING from {', '.join(miss)} (present in {', '.join(have)})")
                continue
            descs = {d: norm(cens[d][sid]) for d in files}
            if len(set(descs.values())) > 1:
                findings += 1
                print(f"   {sid}: shape descriptions differ ->")
                for d in files:
                    print(f"        {d}: {cens[d][sid][:70]}")
        print(f"\nchecked {len(allS)} S-numbers across {len(files)} censuses.")

        # MODULUS GUARD on the whole census row, not just the description.
        #
        # Comparing the two censuses against each other cannot catch a claim
        # that is stale in BOTH copies -- and since the censuses are kept in
        # step by copying, that is the likely way for one to go wrong.  The
        # class ceilings are keyed mod 12: every mod-8 condition in the
        # derivation is either absorbed (F = 2, where the two reachable foreign
        # residues agree mod 4) or constant on the mod-12 class (F = 4).  So a
        # census verdict naming a residue mod 24 is asserting a distinction the
        # ceiling table does not make.  Residues 11 and 23 are exempt: they are
        # the two halves of the extremal class and are legitimately named
        # together when the point is that they agree.
        MOD24_OK = {"11", "23"}
        m24 = re.compile(r"\b(\d+)\s*(?:,\s*\d+\s*)*\(mod\s*24\)|\bmod-24\b")
        for d in files:
            try:
                txt = open(d).read()
            except OSError:
                continue
            for line in txt.split("\n"):
                mm = CENSUS_ROW.match(line.strip())
                if not mm:
                    continue
                hits = [x for x in re.findall(r"\b(\d+)(?=[^()]{0,12}\(mod 24\))", line)
                        if x not in MOD24_OK]
                if hits or "mod-24" in line:
                    findings += 1
                    print(f"   {mm.group(1)} in {d}: census row names "
                          f"{'residues ' + ', '.join(sorted(set(hits))) if hits else 'a mod-24 keying'} "
                          f"(mod 24); the ceiling table is keyed mod 12")
                    print(f"        a mod-24 residue other than 11/23 in a census "
                          f"verdict is a distinction the ceilings do not make")
    # tagged duplicate statements
    dups = {}
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for k, v in dup_blocks(txt).items():
            dups.setdefault(k, {})[d] = v
    if dups:
        print(f"\ntagged duplicate statements: {len(dups)}")
        for k, where in sorted(dups.items()):
            if len(where) < 2:
                print(f"   {k}: only in {list(where)[0]} -- tag is pointless with one copy")
                continue
            if len(set(where.values())) > 1:
                findings += 1
                print(f"   {k}: *** COPIES DIFFER ***")
                for d, v in where.items():
                    print(f"        {d}: {v[:90]}")
            else:
                print(f"   {k}: in step across {len(where)} files")
    else:
        print("\nno <!-- DUP:name --> tagged statements found.")

    print("\nThe census is duplicated ON PURPOSE. Keep both copies in step: a new")
    print("shape needs a row in each, and S-numbers are append-only -- never renumber,")
    print("since they are the key the two documents are joined by.")


# ------------------------------------------------------------- PASS 8 history

# Dehistoricization.  These documents are meant to read as descriptions of what
# is true, not as a record of how they came to say it.  Edits made in the frame
# of "what changed" carry that frame into the prose, and the resulting sentences
# are invisible to every other pass: they are grammatical, accurate, and about
# the project's editing history rather than about mathematics.
#
# Two categories are deliberately NOT flagged, because they look identical to a
# regex and are load-bearing:
#   * era labels on measurements -- "v4-era", "v4 baseline", PENDING-REBUILD --
#     which say which artefact a number came from, and matter while a rebuild
#     is outstanding;
#   * history of the LITERATURE ("Baker-Harman's exponent has since been
#     improved"), which is the field's history, not ours.
# The separation is by subject, so the patterns below are tuned to phrases whose
# subject can only be one of our own documents, statements or scripts.

if A.only in ("all", "history"):
    print("\n" + "=" * 72); print("PASS 8  HISTORY"); print("=" * 72)

    HIST = [
        (re.compile(r"\b(previously|formerly|originally)\b(?!\s+(known|published))", re.I),
         "edit-history adverb"),
        (re.compile(r"\b(?:an?|the)\s+(?:older|earlier|previous|old)\s+"
                    r"(?:version|reading|draft|caveat|claim|frontier|space|table|cell|row|wording|statement)\b", re.I),
         "reference to a superseded version of our own text"),
        (re.compile(r"\bused to (?:be|say|read|claim)\b", re.I), "edit-history verb"),
        (re.compile(r"\b(?:was|were) (?:once|earlier) (?:flagged|stated|written|called)\b", re.I),
         "edit-history verb"),
        # NB "fixed" and "dropped" are excluded from this alternation on purpose:
        # "fixed pointwise", "fixed by every Galois element", "a fixed prime" are
        # ordinary mathematics and swamp the report.  A repaired defect is caught
        # by the narrower pattern below, which requires a defect as the subject.
        (re.compile(r"\b(?:is|has been|was) (?:now )?(?:retired|superseded|rewritten|"
                    r"reworded|excised)\b", re.I),
         "status-of-our-text verb"),
        (re.compile(r"\b(?:bug|defect|error|typo|slip|clause|filter)\b[^.]{0,60}?"
                    r"\b(?:has been|was|is now) (?:fixed|corrected|removed|repaired)\b", re.I),
         "repair narrative"),
        (re.compile(r"\bno longer (?:says|reads|claims|holds here)\b", re.I), "status-of-our-text verb"),
        (re.compile(r"\bthis (?:session|pass|rewrite|round|review)\b", re.I), "reference to a work session"),
        (re.compile(r"\bwe (?:found|noticed|corrected|fixed|caught|removed|rewrote|split|discovered)\b", re.I),
         "first-person narrative of our own process"),
        # First-person SINGULAR process narration.  The plural forms above did not
        # catch "I checked this specifically", "an early version of my check",
        # "I went looking for": a reader who was not present has no use for who
        # did what, only for what is true.  Verbs only, so a bare "I" in prose
        # (or a variable named I) does not fire.
        (re.compile(r"\bI (?:checked|found|noticed|went looking|expected|tried|"
                    r"drafted|wrote|imported|built|got|ran|verified|first)\b"),
         "first-person-singular narrative of our own process"),
        (re.compile(r"\b(?:my|our) (?:check|reading|draft|first version|earlier version)\b", re.I),
         "first-person narrative of our own process"),
        # A document narrating its OWN drafting.  Distinct from the superseded-text
        # pattern above, which needs an "older/earlier" adjective; these phrase the
        # same thing as a history of composition and so read as clean.
        (re.compile(r"\bthe first (?:version|draft) of (?:this|the)\b", re.I),
         "narration of this document's own drafting"),
        (re.compile(r"\b(?:this|the) (?:document|note|section|file) was (?:first )?"
                    r"(?:drafted|written|commissioned|composed)\b", re.I),
         "narration of this document's own drafting"),
        (re.compile(r"\b(?:before|until|prior to) this (?:reading|pass|review|note)\b", re.I),
         "edit-history clause"),
        (re.compile(r"\ban? early version of\b", re.I),
         "reference to a superseded version of our own text"),
        (re.compile(r"\b(?:both )?ha(?:s|ve) happened\b", re.I), "incident narrative"),
        (re.compile(r"\buntil (?:it was|recently|this)\b", re.I), "edit-history clause"),
        (re.compile(r"\bwhich is what this (?:pass|section|run) was for\b", re.I), "pass-naming heading"),
        (re.compile(r"\bthe (?:old|former) (?:space|reading|shape space) (?:forbade|allowed|required)\b", re.I),
         "argument framed against a superseded shape space"),
    ]
    # subject-based exemptions: literature history and artefact era labels
    EXEMPT = re.compile(
        r"v\d+[- ](?:era|baseline|count|census)|PENDING-REBUILD|"
        r"Baker.Harman|Shparlinski|BBKN|Elliott|Chowla|Bombieri|Maynard|Lichtman|Oliver's|"
        r"\bin the literature\b|\bof the literature\b|\bhas since been improved\b|"
        # `--baseline`-style references name a prior ARTEFACT (a CSV, a run), which
        # is a legitimate input to a command, not a superseded piece of prose.
        r"--baseline|`--|\.csv\b|\bbaseline\b", re.I)

    hist_hits = 0
    for d in DOCS:
        # Use the shared ARCHIVE list, not a private one: the set of files whose
        # charter is to carry history is the same set for figures and for prose,
        # and keeping two lists meant pending-checks.md and the state-tracking
        # verification files were exempt from stale-figure reports but still
        # reported for the edit-history phrasing that is correct in them.
        if ARCHIVE.search(d) or "journal" in d:
            continue
        try: txt = open(d).read()
        except OSError: continue
        shown = False
        for ln, line in enumerate(txt.split("\n"), 1):
            for pat, what in HIST:
                m = pat.search(line)
                if not m:
                    continue
                # The exemption is checked in the match's OWN CLAUSE, not over the
                # whole line and not in a fixed character window.  Line-wide, a
                # single "Shparlinski" or "BBKN" anywhere in a sentence exempts
                # everything else in it -- which silently disabled this pass for an
                # entire document about one author, where the name appears on
                # nearly every line.  A fixed window has the same failure in
                # miniature: an author named at the end of one sentence exempts the
                # start of the next.  The subject test the exemption encodes is
                # per-clause, so the clause is the right unit.
                lo = max((line.rfind(c, 0, m.start()) for c in ".!?"), default=-1) + 1
                hi = min((h for h in (line.find(c, m.end()) for c in ".!?")
                          if h != -1), default=len(line))
                if EXEMPT.search(line[lo:hi + 1]):
                    continue
                if not shown:
                    print(f"\n{d}:"); shown = True
                hist_hits += 1; findings += 1
                print(f"   L{ln:<6} [{what}] ...{line[max(0, m.start()-45):m.start()+95].strip()}...")
                break
    if not hist_hits:
        print("none found -- the documents describe what is true, not how they came to say it.")
    else:
        print(f"\n{hist_hits} historicizing phrase(s).")
    print("\nNot all are wrong: a claim genuinely ABOUT a superseded state needs to")
    print("say so. The test is whether a first-time reader, with no knowledge of")
    print("this project's editing, would need the phrase. Era labels on measurements")
    print("(v4-era, PENDING-REBUILD) and the literature's own history are exempt by")
    print("subject and are not reported.")

# --------------------------------------------------------------- PASS 4 hygiene

if A.only in ("all", "hygiene"):
    print("\n" + "=" * 72); print("PASS 4  HYGIENE"); print("=" * 72)
    DUP_BOLD = re.compile(r"(\*\*[^*]{8,}?\*\*)\1")
    DUP_SENT = re.compile(r"([A-Z][^.!?]{15,}?[.!?])\s*\1")
    clean = True
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            for pat, what in ((DUP_BOLD, "doubled bold run"), (DUP_SENT, "doubled sentence")):
                for m in pat.finditer(line):
                    findings += 1; clean = False
                    print(f"{d} L{ln}  {what}: {m.group(1)[:90]}")
    if clean:
        print("none found.")

# ------------------------------------------------------- PASS 10 witness-at-n
#
# WHY THIS PASS EXISTS.  Pass 1 checks numbers against the table's AGGREGATES,
# and passes 5-7 check the documents against each other.  Neither reaches the
# commonest kind of drift in these files: prose that names a particular n and
# then says what wins there, or at what density.  A rebuild rewrites witnesses
# row by row, so every such sentence silently becomes a claim about a superseded
# table -- and it reads as perfectly current, because the n is real, the shape is
# real, and only the pairing is stale.  Six such sentences survived four review
# passes before this pass was written; each named an n whose winner had changed.
#
# WHAT IT MATCHES.  Two prose idioms, both anchored on an explicit n:
#   * a backtick-quoted witness fragment near "n = N"  ->  compare against the
#     row's own witness string, ignoring the p=/q= prefix and part order;
#   * a density near "n = N" ("at n = 1817 to 0.0594", "n = 2183 at 0.048039")
#     ->  compare against the row's density at the quoted precision.
# Numbers appearing as part of a range, and n not in the table, are skipped.
#
# WHAT IT DELIBERATELY DOES NOT DO.  It does not judge: a sentence may name an n
# and a shape that is admissible there without winning ("`19x61` is admissible at
# n = 1159"), which is legitimate and common.  So a hit is reported with both
# sides printed and the reader decides -- exactly like pass 1's old-checkpoint
# matches.  Cheap: one regex sweep per document against a dict lookup.
if A.only in ("all", "witness"):
    print("\n" + "=" * 72); print("PASS 10  WITNESS AT N"); print("=" * 72)
    BY_N = {r["n"]: r for r in rows}
    def _shape(w):
        # "p=251 q=13: 6x251 + 1x677*   (* foreign)" -> {"6x251", "1x677*"}
        w = w.split(":")[-1].split("(")[0]
        return {t.strip() for t in w.split("+") if "x" in t}
    # The gap between the n and the claim must be SHORT and must not step over
    # another n: "the floor is 0.048039 at n = 2183 (v4: 0.045742 at n = 1817)"
    # pairs correctly only if the scan stops at the second "n =".  A generous
    # window is what made the first version of this pass unusable, reporting a
    # hit for every (n, number) pair in a sentence naming several of each.
    GAP = r"(?:(?!n\s*=|n\s*[≤<])[^.\n])"
    NW = re.compile(r"n\s*=\s*(\d{2,6})\b" + GAP + r"{0,60}?`([0-9]+x[0-9]+[^`]{0,40})`")
    ND = re.compile(r"n\s*=\s*(\d{2,6})\b" + GAP + r"{0,50}?\b(0\.0\d{3,6})\b")
    # An explicitly labelled historical or cross-artefact citation is exempt:
    # "(v4: 0.045742 at n = 1817)" is a claim ABOUT a superseded table and is
    # what the documents are supposed to say.  So is a LADDER or family-menu
    # score, which is a lower bound and legitimately differs from B(n), and so
    # is a class CEILING quoted beside an n.  The exemptions are deliberately
    # keyword-based and visible: a pairing that wants one must say so in the
    # sentence, which is the same discipline PASS 8 enforces on prose.
    MARK = ("v2", "v3", "v4", "pre-repair", "pre-correction", "previous", "earlier",
            "old", "superseded", "was ", "were ", "ladder", "worklist", "menu",
            "mu_fast", "historic", "cap", "ceiling", "class", "descent", "b_lo",
            "lower bound", "rises", "rose", "lifts", "lifted", "under the corrected")
    RIGHT = ("cap", "ceiling", "class")     # "0.08579 for the classes they sit in"
    def _exempt(line, lo, hi):
        # The label must come BEFORE the figure, in the clause that introduces
        # it -- looking rightwards for it lets an unrelated "(v4: ...)" later in
        # the sentence exempt a current, wrong pairing, which is exactly the
        # kind of near-miss this pass exists to catch.
        left = line[max(0, lo - 70):lo].lower()
        right = line[hi:hi + 25].lower()
        return (any(k in left for k in MARK) or any(k in right for k in RIGHT)
                or any(k in line.lower() for k in
                       ("mu_fast", "ladder_verify", "worklist", "menu")))
    hits = 0
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        shown = False
        for ln, line in enumerate(txt.split("\n"), 1):
            for m in NW.finditer(line):
                n = int(m.group(1)); frag = m.group(2)
                if n not in BY_N or "x" not in frag: continue
                claimed = _shape(frag)
                if not claimed: continue
                actual = _shape(BY_N[n]["witness"])
                if claimed <= actual: continue
                if _exempt(line, m.start(), m.end()): continue
                if not shown: print(f"\n{d}:"); shown = True
                hits += 1; findings += 1
                print(f"   L{ln:<6} n = {n}: prose says `{frag}`,"
                      f" table has `{BY_N[n]['witness'].split(':')[-1].split('(')[0].strip()}`")
            for m in ND.finditer(line):
                n = int(m.group(1)); dq = m.group(2)
                if n not in BY_N: continue
                act = BY_N[n]["density"]
                if abs(act - float(dq)) < 0.5 * 10 ** -(len(dq) - 2): continue
                # "0.0462099 at n = 2759" belongs to the n that FOLLOWS it, not
                # to the one that preceded the sentence.  Lists of the form
                # "0.041812 (n = 575) -> 0.041107 (n = 2183)" are entirely of
                # this shape, and pairing leftwards there mis-reports every
                # entry.  So a number carrying its own n on the right is skipped.
                if re.match(r"[\s,)]*(?:at\s*)?\(?\s*n\s*[=≈]",
                            line[m.end():m.end() + 25]): continue
                if _exempt(line, m.start(), m.end()): continue
                if not shown: print(f"\n{d}:"); shown = True
                hits += 1; findings += 1
                print(f"   L{ln:<6} n = {n}: prose says density {dq}, table has {act:.6f}")
    if not hits:
        print("no sentence names an n whose winner or density the table contradicts.")
    else:
        print(f"\n{hits} witness-at-n finding(s).")
        print("Not all are errors: naming a shape that is ADMISSIBLE at an n without")
        print("winning there is legitimate, and so is a deliberate historical citation.")
        print("What the pass guarantees is that each such pairing was decided rather")
        print("than inherited from a superseded table.")

# ------------------------------------------------------------- PASS 11 pending
#
# THE 1E5 TAG IS A SCOPE MARKER, NOT A CORRECTNESS MARKER, and the difference
# decides what this pass does.  A tagged figure is CORRECT on the range it names
# and will MOVE when `mu_exact.py` reaches n = 100,000.  So the pass does not
# try to decide whether a tagged number is right -- it cannot, and the number is
# right.  It does three things instead:
#
#   (a) inventories every tagged site, so the retirement is all-or-nothing
#       rather than piecemeal.  A half-requoted document is worse than a fully
#       stale one: the range words stop being a reliable guide to which
#       population a figure came from, which is the confusion the prefix/tail
#       discipline exists to prevent;
#   (b) recomputes, at the CURRENT table, the handful of quantities the CSV can
#       supply, and prints them beside the frontier -- so that when the run
#       lands the requote is a transcription rather than a re-derivation;
#   (c) flags the OPPOSITE failure, which is the one that actually bites: a
#       range-scoped aggregate that is NOT tagged.  Those are the sites that go
#       stale silently on the next extension, because nothing then points at
#       them.  Tag coverage is the thing worth checking mechanically; tag
#       accuracy is not checkable at all.
#
# It also reports whether the tag is due for retirement, by comparing the
# table's frontier against the target.

TAG_1E5 = "\u27e6PENDING-1E5-EXACT-RUN\u27e7"
TAG_TARGET = 100000

if A.only in ("all", "pending"):
    print("\n" + "=" * 72); print("PASS 11  PENDING 1E5 EXACT RUN"); print("=" * 72)
    tagged, defined = [], set()
    for d in DOCS:
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            if TAG_1E5 not in line:
                continue
            # the banner definition explains the tag; every other site uses it
            if "the one tag that is about" in line:
                defined.add(d); continue
            tagged.append((d, ln, line.strip()))
    print(f"tag defined in: {', '.join(sorted(defined)) or 'NOWHERE -- define it in the status banner'}")
    # A work list may name the tag without carrying a tagged figure, and does:
    # pending-checks.md's R0b item is the retirement procedure.  Only documents
    # that DEFINE the tag hold sites the requote has to visit.
    tagged = [t for t in tagged if t[0] in defined]
    print(f"tagged sites: {len(tagged)}")
    for d, ln, line in tagged:
        body = re.sub(r"^(?:> |\- |\d+\. |\| )*", "", line).replace(TAG_1E5, "").strip()
        print(f"   {d} L{ln}  {body[:110]}")
    if not defined and tagged:
        findings += 1
        print("   *** the tag is used but never defined; a reader meeting it has nowhere to go")

    # (b) what the CSV can supply now, for the requote
    print(f"\ncurrent frontier n = {NMAX} (contiguous to {CONTIG}); target for retirement {TAG_TARGET}")
    print("quantities the CSV can supply at the current frontier, for transcription:")
    for k in ("row count", "n max", "density floor", "density floor at n", "median density",
              "one-part winners", "two-part winners", "three-part winners",
              "count delta <= 1/16", "count delta > 1/9", "omega(n) = 2"):
        if k in CUR:
            print(f"   {k:<24} {CUR[k]}")
    print("   NOT supplied by the CSV: the orbital-count distribution (t is not a column),")
    print("   and every certificate coverage figure, which is a run output.")

    # (c) untagged range-scoped aggregates -- the silent-staleness class
    print()
    RANGEY = re.compile(r"contiguous range|\[6, ?2600\]|over the (?:completed|current) table|"
                        r"over the table\b|in range\b", re.I)
    AGG = re.compile(r"\*\*[\d][\d,]{1,6}\*\*|\d+\.\d{3,}|\d{1,3}(?:\.\d)?%")
    # A theorem, a closed form or a threshold is not an aggregate however many
    # digits it carries, and tagging one would be noise.
    STRUCTURAL = re.compile(r"cap_?[F1-9]|ceiling|closed form|Theorem|Lemma|Corollary|"
                            r"Proposition|√|conjectur|threshold|1/\d+\b", re.I)
    miss = 0
    for d in DOCS:
        if d not in defined:
            continue                      # a document that does not use the tag
        try: txt = open(d).read()
        except OSError: continue
        for ln, line in enumerate(txt.split("\n"), 1):
            if TAG_1E5 in line or not RANGEY.search(line) or not AGG.search(line):
                continue
            if "PENDING-" in line:
                continue                  # already carries a tag of its own
            if STRUCTURAL.search(line):
                continue
            findings += 1; miss += 1
            print(f"{d} L{ln}  *** UNTAGGED RANGE-SCOPED AGGREGATE *** will move on the "
                  f"10\u2075 run and nothing points at it")
            print(f"   {line.strip()[:150]}\n")
    if not miss:
        print("[ok] every range-scoped aggregate in a tag-using document carries the tag.")

    if NMAX >= TAG_TARGET:
        findings += 1
        print(f"\n*** THE TAG IS DUE FOR RETIREMENT: the table reaches {NMAX} >= {TAG_TARGET}.")
        print("    Requote every site above, then delete the tag from all of them AND from")
        print("    the banner definition in each document.  See pending-checks.md R0b.")
    else:
        print(f"\n[ok] tag still live: {TAG_TARGET - NMAX} short of the retirement frontier.")


print("\n" + "=" * 72)
print(f"{findings} finding(s) needing a decision.")
print("Not all are errors. Historical citations are legitimate and a figure matching")
print("an old checkpoint may be deliberate. The point is that each is a decision")
print("rather than an oversight.")
sys.exit(1 if findings else 0)
