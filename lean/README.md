# Lean formalisation of the ARK framework

This directory machine-checks the arithmetic of the ARK framework and the finite-group arguments downstream of Oliver's chain. The deep inputs it does not formalise (Oliver's theorem, KSS, the analytic hypotheses, one classical group-theory fact, and the upper side's group-theoretic steps) enter as **named hypotheses**, always as `structure`s and never as `axiom`s, so every file rests on Lean's three standard axioms.

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
| `HypHuppert` | a primitive Oliver group whose degree p divides has p-power degree ("solvable primitive ⇒ affine") | `Part0Fr`, `Part0Main`, `Part0Mu`, `PartEMu`, `VertexTransitive` |
| `Hyp W L`, `WT` | (BCG)/(BH-SW) witness hypotheses, under (AL) or (AA) | `BCG`, `SigmaHalf`, `PartE1`, `PartEF`, `PartEMu`, `Threshold`, `Cover`, `CoverDensity`, `Part0Mu` |
| `HypBCG`, `OliverAnnihilation` | the short note's own two inputs | `Note` |
| `HypStep2`, `HypStep2Block`, `HypStep5` | §6.3 Steps 2 and 5 of the upper side | `Upper`, `UpperDensity` (the ceiling theorems use exactly these three) |
| `HypConjP` | Conjecture P, for transitive Oliver groups | `Upper` only (`Utyp_even`/`Utyp_odd`); the `_steps` versions replace it by the weaker `HypStep2Block` + `HypStep5` |

What is proved, by area:

| area | files | headline |
|---|---|---|
| inequality core and the short note | `ArkCore`, `Basic`, `Note` | the note's arithmetic half; caps, ladders, ceiling constants |
| Theorem E.5, Corollary E.6 | `E5Core`, `Bridge`, `E5Assembly`, `E6`, `D1` | E.5 in full with its 12 exceptional n; B_refined = B_safe above 1/25 |
| Part E (realisability) | `PartE1`, `PartEF`, `PartEG`, `PartEMu` | Oliver groups realising any classes beside any foreign blocks (coherent, full twist); **μ\*(n) = B_safe(n) above 1/25, given only `HypHuppert`** (the ≥ half unconditional); Σ₀'s floor on μ\* |
| vertex-transitive Oliver-resistance | `VertexTransitive` | its threshold μ\*_vt(n) = n(q(n) − 1)/2 (lower half unconditional), and μ\*(n) ≥ it |
| Lemmas B, B′, D2 from Oliver's chain | `Chain`, `Step2`, `Glue`, `Rescale`, `LemmaB`, `LemmaBprime`, `D2`, `D2Full`, `D2q`, `FoBridge` | all three D2 classes, no Lemma B hypothesis |
| `ladder-completeness.md` Propositions 1–2 | `Prop1`, `ThreeForeign`, `Prop1Final`, `TwoForeign` | ≤ 1 class + ≤ 2 foreign parts, F ≤ 15; strict S6/S11 ceilings |
| the conditional floor | `BCG`, `Sigma`, `SigmaHalf` | Σ₀'s floor at every class, Part E proved for its shapes |
| threshold beyond μ\* | `CycGood`, `Evasive`, `RGlue`, `Threshold` | evasiveness below (1 − ε)·δ_cyc·C(n,2) |
| covering statement (§6 ⇒) | `Cover`, `CoverDensity` | a floor δ > 1/25 forces Proposition 1's systems, O(x/log x) exceptions |
| upper side | `Upper`, `UpperDensity` | the ceiling on μ\*_N^fpf, outside O(x/log x) exceptions |
| Part 0 | `Part0`, `Part0Fr`, `Part0Fo`, `Part0Main`, `Part0Mu` | μ\*(n) ≤ B_safe(n); the covering statement restated on μ\* |

The per-file index, with the main theorem names, is the first section of `file-notes.md`.

## What is open

- **Part E outside the realisable shapes**: configurations with a reduced twist (REFINED below SAFE), or with a foreign prime dividing some Fᵢ·(cᵢ − 1). No computed n needs them (every one is above 1/25, where `PartEMu.e6_real` applies); a statement below 1/25 would.
- **The upper side's hypotheses** `HypStep2`, `HypStep2Block`, `HypStep5`.
- **δ₀ = 1/25 itself** in the covering statement (Proposition 1 is strict there).
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
- **Keep the pin; don't bump in the middle of a piece of work.** Most Lean failures here have been name drift, not wrong mathematics. Where a goal is routine, prefer a tactic or old, stable lemmas over a named iff-lemma or convenience lemma. Known deprecations at this pin: `if_pos`/`if_neg` (use `simp only [h, ite_true]`, `↓reduceIte` or `split_ifs`), `Set.mem_setOf_eq` (use `Set.mem_ofPred_eq`), `push_neg` (use `push Not`).
- **On a Mathlib bump, recheck the gaps** listed in `file-notes.md` ("Mathlib coverage"): several results here are hand-proved only because Mathlib lacked them.
- **Home-made notions** in `E5Core`/`ArkCore` (`IsPrimeN`, `pairs`, …) have their Mathlib bridges tabled in `file-notes.md`; add any new one there in the same edit.
- **A new file** gets a root in `lakefile.toml` and a row in `file-notes.md`'s index; `check_doc_figures.py --pass lean` checks both against this README's area table.
- **No dates or commit hashes here.** Status changes go through git history; `check_doc_figures.py --pass lean` enforces it.
