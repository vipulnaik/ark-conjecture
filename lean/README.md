# Lean formalisation of the ARK framework

This directory machine-checks the arithmetic of the ARK framework and the finite-group arguments downstream of Oliver's chain. The deep inputs it does not formalise (Oliver's theorem, KSS, the analytic hypotheses, one classical group-theory fact) enter as **named hypotheses**, always as `structure`s and never as `axiom`s, so every file rests on Lean's three standard axioms.

**What a green build establishes:** the arguments between the named hypotheses and the conclusions are correct, and the units are consistent. It does not verify the hypotheses themselves.

Companion documents:
- `file-notes.md`: per-file mathematical notes (routes taken, findings against the text, the scorer cross-check, Mathlib gaps).
- `formalisation-rationale.md`: why formalise, the lessons learned, and what formalising does not buy.
- `../notes/groupprops-lean-thread.md`: the independent Groupprops/mathcheck thread.

## Project state

Every file compiles with zero `sorry`. The named hypotheses:

| hypothesis | stands for | used by |
|---|---|---|
| `HypKSSOliver` | the KSS–Oliver congruence for non-evasive properties | `Evasive`, `Threshold`, `Upper` |
| `HypHuppert` | a primitive Oliver group whose degree p divides has p-power degree ("solvable primitive ⇒ affine") | `Part0Fr`, `Part0Main`, `Part0Mu` |
| `Hyp W L`, `WT` | (BCG)/(BH-SW) witness hypotheses, under (AL) or (AA) | `BCG`, `SigmaHalf`, `PartE*`, `Threshold`, `Cover` |
| `PartE μ` | Part E for shapes beyond the two-part ones | `SigmaHalf.sigma0_mu`; `E6.e6` and `Part0Mu.e6_mu` take it as `hconstr` |
| `HypBCG`, `OliverAnnihilation` | the short note's own two inputs | `Note` |
| `HypStep2`, `HypStep2Block`, `HypStep5`, `HypConjP` | §6.3 Steps 2 and 5 / Conjecture P of the upper side | `Upper`, `UpperDensity` |

What is proved, by area:

| area | files | headline |
|---|---|---|
| inequality core and the short note | `ArkCore`, `Basic`, `Note` | the note's arithmetic half; caps, ladders, ceiling constants |
| Theorem E.5, Corollary E.6 | `E5Core`, `Bridge`, `E5Assembly`, `E6`, `D1` | E.5 in full with its 12 exceptional n; B_refined = B_safe above 1/25 |
| Lemmas B, B′, D2 from Oliver's chain | `Chain`, `Step2`, `Glue`, `Rescale`, `LemmaB`, `LemmaBprime`, `D2`, `D2Full`, `D2q`, `FoBridge` | all three D2 classes, no Lemma B hypothesis |
| `ladder-completeness.md` Propositions 1–2 | `Prop1`, `ThreeForeign`, `Prop1Final`, `TwoForeign` | ≤ 1 class + ≤ 2 foreign parts, F ≤ 15; strict S6/S11 ceilings |
| the conditional floor | `BCG`, `Sigma`, `SigmaHalf`, `PartE1`, `PartEF` | Σ₀'s floor at every class, Part E proved for its shapes |
| threshold beyond μ\* | `CycGood`, `Evasive`, `RGlue`, `Threshold` | evasiveness below (1 − ε)·δ_cyc·C(n,2) |
| covering statement (§6 ⇒) | `Cover`, `CoverDensity` | a floor δ > 1/25 forces Proposition 1's systems, O(x/log x) exceptions |
| upper side | `Upper`, `UpperDensity` | the ceiling on μ\*_N^fpf, outside O(x/log x) exceptions |
| Part 0 | `Part0`, `Part0Fr`, `Part0Fo`, `Part0Main`, `Part0Mu` | μ\*(n) ≤ B_safe(n); E.6 and the covering statement restated on μ\* |

The per-file index, with the main theorem names, is the first section of `file-notes.md`.

## What is open

- **Part E beyond two-part shapes** (several classes or foreign blocks, F_top > 1, q = 2). Discharging it would remove `PartE μ`.
- **The upper side's hypotheses** `HypStep2`, `HypStep2Block`, `HypStep5`.
- **δ₀ = 1/25 itself** in the covering statement (Proposition 1 is strict there).
- **The BBKN replacement**: μ\*(n) ≥ n·(Q(n) − 1)/2 from the fused construction at c = Q(n). The arithmetic half is `ArkCore.fused_value`; the group is not built.
- **Phase 3**: `B n` as a computable function, so `native_decide` can check individual table rows. Optional; the table's own validators already cover the rows.
- **Optionally, `HypHuppert`**: Mathlib has no "solvable primitive ⇒ affine", so this is a sizeable project.
- **Out of scope:** deriving the chain from Oliver's theorem, KSS, and the analytic inputs ((BH-SW)/(BCG), the circle-method reduction in `bcp-to-floor.md`). They stay named hypotheses.

## Building

This directory is a lake project. `lean-toolchain` pins `leanprover/lean4:v4.36.0`, `lakefile.toml` pins Mathlib to the tag `v4.36.0`, and `lake-manifest.json` records the exact dependency commits. The `.lean` files sit at the top level and import each other by bare module name (`import ArkCore`); the lakefile lists them as roots of one library with `srcDir = "."`.

```bash
cd lean
lake exe cache get        # prebuilt Mathlib; needs cache.mathlib.org
lake build                # ~20 minutes cold (the kernel checks in TwoForeign, ThreeForeign, E5Assembly dominate)
bash leancheck.sh         # per-file errors / warnings / sorry counts; or name files to check a few
```

`leancheck.sh` must run from this directory. The only expected warning is Mathlib's suggestion to adopt the module system, which it does not count.

**Network, for a sandboxed container.** `lake exe cache get` needs `cache.mathlib.org`; cloning Mathlib needs GitHub. elan downloads toolchains from `releases.lean-lang.org`. If that host is blocked, fetch the tarball from GitHub releases and register it by hand:

```bash
curl -sSfL https://github.com/leanprover/lean4/releases/download/v4.36.0/lean-4.36.0-linux.tar.zst -o lean.tar.zst
python3 -c "import zstandard,tarfile; tarfile.open(fileobj=zstandard.ZstdDecompressor().stream_reader(open('lean.tar.zst','rb')),mode='r|').extractall('.')"   # no zstd binary in the image
elan toolchain link leanprover/lean4:v4.36.0 $PWD/lean-4.36.0-linux
```

## Conventions

- **Named hypotheses are `structure`s, never `axiom`s.**
- **Lean follows the text, not the reverse.** Names and statement order track the vetted documents; a formalisation that wants to rename something files a note instead.
- **Keep the pin; don't bump in the middle of a piece of work.** Most Lean failures here have been name drift, not wrong mathematics. Where a goal is routine, prefer a tactic or old, stable lemmas over a named iff-lemma or convenience lemma. Known deprecations at this pin: `if_pos`/`if_neg` (use `simp only [h, ite_true]` or `↓reduceIte`), `Set.mem_setOf_eq` (use `Set.mem_ofPred_eq`).
- **On a Mathlib bump, recheck the gaps** listed in `file-notes.md` ("Mathlib coverage"): several results here are hand-proved only because Mathlib lacked them.
- **Home-made notions** in `E5Core`/`ArkCore` (`IsPrimeN`, `pairs`, …) have their Mathlib bridges tabled in `file-notes.md`; add any new one there in the same edit.
- **A new file** gets a root in `lakefile.toml` and a row in `file-notes.md`'s index; `check_doc_figures.py --pass lean` checks both against this README's area table.
- **No dates or commit hashes here.** Status changes go through git history; `check_doc_figures.py --pass lean` enforces it.
