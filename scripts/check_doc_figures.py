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

  PASS 6  REFS.  Every section reference and every named-result citation is
          resolved against the headings and bolded statements actually present
          in the documents.  Dangling ones are reported with the nearest
          candidates.  This is the pass for the failure mode the other four are
          blind to: excising a section leaves its inbound pointers behind, and
          a reader following one has no way to tell a typo from a move.

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
                choices=["all", "figures", "scope", "prose", "hygiene", "census", "refs"])
ap.add_argument("--quiet", action="store_true", help="findings only")
A = ap.parse_args()
DOCS = [d for d in A.docs if d.endswith(".md")]

# ------------------------------------------------------------------ the table

rows = list(csv.DictReader(open(A.table)))
for r in rows:
    r["n"] = int(r["n"]); r["density"] = float(r["density"])
    r["parts"] = int(r["parts"]); r["certified_K"] = int(r["certified_K"])
NMAX = max(r["n"] for r in rows)

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

# Checkpoints: every n at which the table has been quoted at some point, plus the
# current maximum.  A figure written against an older frontier then reports as
# "correct for n <= C" rather than as unexplained.
#
# APPEND THE OLD MAXIMUM ON EVERY TABLE EXTENSION.  Two minutes, and skipping it
# turns every historical figure in the documents into noise in PASS 1.
CHECKPOINTS = sorted({c for c in [1306, 1428, 1540, 1572, 2000, 2007, 2212,
                                  2298, 2376, NMAX] if c <= NMAX})

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
CUR = BY_RANGE[NMAX]

if not A.quiet:
    print(f"{A.table}: {len(rows)} rows, n up to {NMAX}")
    print(f"checkpoints: {', '.join(str(c) for c in CHECKPOINTS)}\n")
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
                if not hits or any(c == NMAX for _, c in hits):
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
ARCHIVE = re.compile(r"session-log|pending-checks|README", re.I)

# ----------------------------------------------------------------- PASS 2 scope

SCOPE = [
    (re.compile(r"every computed value has (?:δ|delta) (?:≥|>=|>) ?([\d.]+)"), "abs"),
    (re.compile(r"(?:δ|delta) (?:≥|>=|>) ?([\d.]+)[^.]{0,70}(?:throughout|everywhere|at every computed|all computed)"), "abs"),
    (re.compile(r"(?:δ|delta) (?:>|exceeds) 1/(\d+)\b[^.]{0,40}forces"), "inv"),
    (re.compile(r"no computed value (?:falls |is |lies )?below ([\d.]+)"), "abs"),
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
         "the notes": "orbital-evasiveness-notes.md",
         "these notes": "orbital-evasiveness-notes.md",
         "the companion": "enumeration-proof.md"}
ALIAS_CITE = re.compile(r"`(aod)`")
ROLE_AFTER = re.compile(r"^\s*(?:of|in)\s+(the notes|these notes|the companion)")
# Words that follow "Theorem"/"Lemma" without naming one.
NOT_A_LABEL = {"E", "A", "I", "N", "X", "The", "It", "This", "That", "If", "For",
               "In", "Its", "Two", "One", "Three", "Both", "So", "But", "And"}
# Files whose references are not ours to maintain: the logs and the pending list
# describe states and cite items by name, and the literature notes cite other
# people's numbered results, which resolve against their papers and not against
# anything here.  Checking them produces only noise.
NOT_OURS = re.compile(r"session-log|pending-checks|README|literature-findings", re.I)

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
                print(f"{d}: skipped -- logs and literature notes cite outward, "
                      f"not into these documents")
            continue
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
                target = names[-1].group(1) if names else d
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

print("\n" + "=" * 72)
print(f"{findings} finding(s) needing a decision.")
print("Not all are errors. Historical citations are legitimate and a figure matching")
print("an old checkpoint may be deliberate. The point is that each is a decision")
print("rather than an oversight.")
sys.exit(1 if findings else 0)
