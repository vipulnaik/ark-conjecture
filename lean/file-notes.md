# Lean development: per-file mathematical notes

What each file proves, the route it takes, and the findings against the text that formalising turned up. The orientation document is `README.md` in this directory; this one is reference for anyone reading or extending a particular file.

## File index, in detail

| file | what it proves |
|---|---|
| `ArkCore.lean` | the short note's arithmetic in ℕ: the construction inequality (`central_even`/`central_odd`), the admissible-d table, `orb` identities; E.5's arithmetic half of the fused bound (`fused_value`) |
| `E5Core.lean` | E.5's counting and congruence steps; see "E.5" below |
| `Note.lean` | the short note's arithmetic half (`theorem_arithmetic_half`), with Mathlib wrappers over `ArkCore` |
| `Basic.lean` | the inequality core: `orb_full`, Lemma D1, Prop F.1, the E′ s-bound and its threshold ladders, the `capF` algebra, the six ceiling constants, the two-foreign closed form, the quadratic-residue collapse |
| `Bridge.lean` | `E5Core.IsPrimeN p ↔ Nat.Prime p` |
| `E5Assembly.lean` | SAFE as a function (Part G.3); **Theorem E.5 in full**: `e5` (all branches) and `e5_exceptions` (exceptional n = the table's 12) |
| `E6.lean` | Corollary E.6 on a model of the shape space including D2's parts; μ\* abstract (sandwich halves as hypotheses) |
| `D2.lean` | Lemma D2's counting classes for a permutation group of the orbit; the normal form as hypothesis (discharged by `Glue`/`Rescale`/`D2Full`/`D2q`) |
| `Chain.lean` | Oliver's chain; r-subgroups cyclic (r ∉ {p, q}); D2 Step 1, given affine block actions (supplied by `LemmaB`) |
| `Step2.lean` | D2 Step 2's change of origins: H¹ = 0 by averaging, for any finite Q with #Q invertible |
| `Glue.lean` | Step 2 applied to Γ restricted to O, modulo T\*: per-block origins giving the normal form (σi, a·x + s) |
| `Rescale.lean` | **Lemma D2's C(F,2)·r bound end to end** (r ∉ {p, q}), given affine block actions (discharged in `D2Full`) |
| `LemmaB.lean` | **Lemma B for a prime block** (`lemmaB_block`), by an elementary route |
| `D2Full.lean` | **Lemma D2 (r ∉ {p, q}) from the chain alone, no Lemma B hypothesis** (`d2_noB`) |
| `D2q.lean` | **Lemma D2q (r = q) from the chain**, and `lemmaD2`: all three of D2's classes |
| `FoBridge.lean` | E.6's `fo` scores proved to bound real orbitals (from `lemmaD2`) |
| `D1.lean` | Lemma D1 (absorption) in the E.6 model |
| `LemmaBprime.lean` | **Lemma B′** from the chain and primitivity alone (`lemmaBprime_primitive`): an outside block has prime size, twist a q-group |
| `Prop1.lean` | `ladder-completeness.md` Proposition 1's counting clauses: share > 1/5 and ≤ 4 parts, fusion count **sharpened to F ≤ 15**, foreign efficiency, the S12 merge, the three-foreign-prime reduction k ≤ 5/12/17 |
| `ThreeForeign.lean` | **Proposition 1: no configuration above 1/25 has three foreign primes**, every q and exponent (`no_three_foreign`) |
| `Prop1Final.lean` | **Proposition 1 assembled** (`prop1`): above the line, matched by ≤ 1 class + ≤ 2 foreign parts, F ≤ 15 |
| `TwoForeign.lean` | **Proposition 2**: S6 ≤ C(n,2)/9, S11 ≤ C(n,2)/16, every q, no exceptions (`s6_ceiling`, `s11_ceiling`); both **strict** (`s6_ceiling_lt`, `s11_ceiling_lt`, via `two_foreign_lt`: the kernel check rerun one unit tighter) |
| `BCG.lean` | (BCG) as **specification × quantifier**: `Hyp W L`, filters `atTop` (AL) and `almostAll` (AA), AL ⇒ AA, AA non-vacuous; the note's arithmetic half proved pointwise and lifted to both |
| `Sigma.lean` | Σ₀ as data; (BH-SW) six-cell agreement by `decide`; balance point and window lemma for any (F, η, window); clause 2's window ↔ (1 − ε)δ₀; §3.3.5 caps as instances (`cap_table`) |
| `SigmaHalf.lean` | **the arithmetic half of (BCG) for any class specification** (`pointwise_half`), and for Σ₀ under (AL) or (AA) by one proof (`sigma0_half`) |
| `PartE1.lean` | **Part E for F = 1**: explicit group on 𝔽_c ⊔ ℤ/r with an Oliver chain and every pair-orbital ≥ SAFE (`partE_F1_exists`); Σ₀'s even-n floor with Part E proved (`sigma0_F1_realised`) |
| `PartEF.lean` | **Part E for a fused class (F ≥ 2)** via the entangled generator (`partE_F_exists`); **Σ₀'s floor at every class with Part E proved** (`PartEAll.sigma0_realised`) |
| `PartEG.lean` | **Part E for any number of classes (Fᵢ ≥ 1, full twist) beside any number of foreign blocks** of distinct primes with q-power twists, any q (`partE_M`, `partE_M_exists`, configuration `cfgM`): the chain (`chain`; coherence rⱼ ∤ Fᵢ·(cᵢ − 1) via the Chinese remainder theorem in `ρ_mem`) and every orbital ≥ REFINED; between two classes the orbital is only ≥ Fᵢ·cᵢ·cᵢ' (`orbit_CC`) |
| `PartEMu.lean` | *(given `HypHuppert`)* realisable configurations have REFINED ≤ μ\*(n) (`RealCfg`, `real_le_mu`, `mu_ge`); the SAFE optimum above 1/25 can be taken realisable (`e6_real`, with the finite check `badOK_all`); **`e6_mu`: μ\*(n) = B_safe(n) = B_refined(n) above 1/25**; **`sigma0_muStar`**: Σ₀'s floor on μ\* itself, under (AL) or (AA) |
| `CycGood.lean` | the cyclic χ-tables: C_k (k = 1, 2, 3, 6) admits no invariant proper complex with χ ≡ 1 (mod q), for q as stated (`good1`, `good2`, `good3`, `good6`; k = 6 by `decide +kernel`, ~60 s) |
| `Evasive.lean` | abstract evasiveness interface: down-closed properties, orbitals, the **named hypothesis `HypKSSOliver`** (KSS/Oliver congruence), and the single-good-type Proposition (`evasive_of_good_type`) |
| `RGlue.lean` | the ℤ/r block's pair-orbitals under multiplication by U·⟨w⟩: r(r−1)/2 pairs in exactly k orbits of type i (`O_injective`, `O_union_card`) |
| `Threshold.lean` | *(given `HypKSSOliver`)* **the threshold beyond μ\*** (staging, `../notes/threshold-beyond-mu.md` Proposition L lower half): under (AL) or (AA), every property with e_max < m on n points is evasive given KSS/Oliver, with 2m ≥ ((1 − ε)·δ_cyc − κ/n)·n(n − 1), δ_cyc = 1/4 even, 3 − 2√2 odd (`thr_realised`) |
| `Cover.lean` | **the ⇒ direction of `arithmetic-of-density.md` §6** (covering statement): a SAFE floor δ > 1/25 under (AL) or (AA) forces n into Proposition 1's systems, shrinking with δ — F ≤ 15 (`cover_25`), F ≤ 8 and no S11 above 1/16 (`cover_16`), F ≤ 3 and no S6/S11 above 1/9 (`cover_9`); general form `cover_hyp`; closed floors at 1/16 and 1/9 (`fexact`, `cover_16_closed`, `cover_9_closed`); parity rule (`parity_one`, `parity_two`) |
| `CoverDensity.lean` | the escapes counted: O(x/log x) up to x (`esc_count`, via Mathlib's Chebyshev bound on π(x)); so a floor δ > 1/25 under (AL) or (AA) forces a system **with a foreign part** outside O(x/log x) exceptions (`cover_foreign`) |
| `Upper.lean` | *(given two named hypotheses)* **Proposition U_typ** (the ceiling on μ\*_N^fpf): m\*_N, m\*_typ, N\*; level 1 sound under `HypKSSOliver` (`evasive_below_mN`); Step 1 (`Nstar_orb`); Step 3 exactly, 2·m\*_N·W² < n(n − 1) (`mN_lt_intrans`); splitting halves (`mN_half`); given `HypStep2` (§6.3 Step 2) and `HypConjP` (Conjecture P): m\*_N(Γ) < δ_cyc(n)·C(n,2) for fixed-point-free Oliver Γ, n not a prime power, n ∉ E (`Utyp_even`, `Utyp_odd`); Step 4 proved (`step4`), so Conjecture P can be replaced by Step 5 alone plus Step 2 for blocks (`HypStep5`, `HypStep2Block`; `Utyp_even_steps`, `Utyp_odd_steps`) |
| `UpperDensity.lean` | E is O(x/log x): its first clause lies in `CoverDensity`'s escapes (`E1_count`), and its second clause at odd n is 2^j + (prime power ≤ 2^(j+2)), counted by a geometric sum (`E2_count`). **`ceiling_density`**: given the three named hypotheses, μ\*_N^fpf(n) < δ_cyc(n)·C(n,2) outside O(x/log x) exceptions |
| `Part0.lean` | Part 0's assembly and per-part bounds. Part A's assembly: if Γ *realises* a configuration (Γ-invariant disjoint point sets of the parts' sizes, each part's own SAFE terms bounded by orbitals), some orbital is ≤ SAFE (`orbLe_safe`; cross terms by `cross_orbLe`). Per-part: a class's terms by its blocks, the flat cap (`blocks_orbLe`, `pc_terms`, `pc_terms_of_set`); a least nontrivial block and its block system (`exists_least_block`, `blockSys`); the fixed-point case (`fixed_orbLe`: an orbital ≤ n − 1) |
| `Part0Fr.lean` | Part 0, step 2: **a foreign orbit's SAFE term bounds an orbital of Γ** (`fr_orbit`): an orbit of prime size r ≠ p of an Oliver Γ has an orbital ≤ orb(r, q^f) for some q^f ∣ r − 1, from the chain alone (Lemma B for prime blocks + Lemma B′; the multipliers form a q-group `mulGp`, halving at even t via −1). Also the transport from an invariant set of Γ to a model type (`resHom`, `orbit2_res_le`), and the block stabiliser of a least block, primitive on it (`stabB`, `chainSub`, `stab_primitive`); a least block is a power of p or a prime r ≠ p (`block_kind`, given `HypHuppert`); **two unfused orbits of one prime r ∉ {p, q} have an orbital ≤ r** (`two_orbits`) |
| `Part0Fo.lean` | a fused outside orbit (F ≥ 2 blocks of prime size r ≠ p) relabelled as `Fin F × ℤ/r` (`fusedEquiv`), and Lemma D2's `fo` terms carried back to Γ (`fused_orbit`, via `FoBridge`) |
| `Part0Main.lean` | *(given `HypHuppert`)* **Part 0: μ\* ≤ B_safe** (`part0`): an Oliver group on n ≥ 2 points has a fixed point (then an orbital ≤ n − 1), or the configuration read off it (classes from p-power least blocks; one `fr`/`fo` part per outside prime) is admissible (`GAdm`), on n points, with SAFE ≥ one of its orbitals. `part0_Bsafe`: with B = B_safe(n), some orbital ≤ max(B, n − 1) — `E6.e6`'s `hcap` |
| `Part0Mu.lean` | *(given `HypHuppert`)* **μ\*(n) as a number, and the wiring.** The fixed-point case is dominated at every n ≥ 2 (`Bsafe_ge`: a fused configuration over a prime-power divisor c ≥ 3 of n, or n = 2, has SAFE ≥ n − 1), so `part0'` drops that disjunct. `muStar n` = the largest least orbital of an Oliver group on `Fin n`; `muStar_le`: **μ\*(n) ≤ B_safe(n)**. Wiring: `floor_of_mu` (δ·C(n,2) ≤ μ\*(n) ⇒ `Cover.Floor δ n`), `cover_mu`, `cover_foreign_mu` (the covering statements with their hypothesis on μ\*) |


## Part 0: μ\* ≤ B_safe

- **Assembly (`Part0.lean`).** If Γ *realises* a configuration (Γ-invariant disjoint point sets of the parts' sizes, each part's own SAFE terms bounded by orbitals), some orbital is ≤ SAFE (`orbLe_safe`; cross terms by `cross_orbLe`). A class's terms are bounded by its blocks at the flat cap (`blocks_orbLe`, `pc_terms`, `pc_terms_of_set`); a least nontrivial block and its block system come from `exists_least_block`, `blockSys`.
- **Foreign orbits (`Part0Fr.lean`).** An orbit of prime size r ≠ p has an orbital ≤ orb(r, q^f) for some q^f ∣ r − 1 (`fr_orbit`). Two unfused orbits of one prime r ∉ {p, q} have an orbital ≤ r (`two_orbits`): the stabiliser of a point acts on the other orbit as a q-group, by the cyclic Sylow-r, so it fixes a point. A least block is a power of p or a prime r ≠ p (`block_kind`), given `HypHuppert`.
- **Fused orbits (`Part0Fo.lean`).** F ≥ 2 blocks of prime size r ≠ p, relabelled as `Fin F × ℤ/r`, get D2's `fo` terms via `FoBridge`.
- **The theorem (`Part0Main.part0`, `Part0Mu.part0'`).** An Oliver group on n ≥ 2 points has an orbital ≤ SAFE(C) for an admissible C on n points. The fixed-point case (an orbital ≤ n − 1) is dominated at every n ≥ 2 by `Part0Mu.Bsafe_ge`: a one-class configuration over a prime-power divisor c ≥ 3 of n, or n = 2.
- **μ\* as a number (`Part0Mu.lean`).** `muStar n` is the largest least orbital of an Oliver group on `Fin n`; `muStar_le` gives μ\*(n) ≤ B_safe(n). `e6_mu`, `floor_of_mu`, `cover_mu` and `cover_foreign_mu` restate E.6 and the covering statements on μ\*.

## Part E: realisability

- **The construction (`PartEG.lean`).** Classes i of Fᵢ ≥ 1 blocks of 𝔽_{cᵢ} at full twist, beside foreign blocks ℤ/r₁, …, ℤ/r_k of distinct primes, each with a twist group Wⱼ of q-power order (any q, q = 2 included). G = ⟨T, γ, μ(U)⟩: T the block translations; γ the entangled rotation on every class at once (one diagonal carrier) and z ↦ z + 1 on every ℤ/rⱼ; U = Πⱼ Wⱼ acting by multiplication. The chain is T ◁ ⟨T, γ⟩ ◁ G. Its one arithmetic input is **coherence**, rⱼ ∤ Fᵢ·(cᵢ − 1) for all i, j: then, by the Chinese remainder theorem (`ZMod.prodEquivPi`), every translation vector of the foreign blocks is a power of γ (`ρ_mem`), which is what makes μ(U) normalise ⟨T, γ⟩. The orbitals: Fᵢ·C(cᵢ,2), K0·cᵢ², Fᵢ·cᵢ·rⱼ, rⱼ·rₗ, ≥ orb(rⱼ, |Wⱼ|) inside ℤ/rⱼ (`orbit_RR`: injective images when −1 ∉ Wⱼ, at most 2-to-1 otherwise).
- **Between two classes (`orbit_CC`): lcm(Fᵢ, Fᵢ')·cᵢ·cᵢ', not sᵢ·sᵢ'.** The one carrier moves both classes' blocks together. A direct orbit computation (two classes of two blocks over 𝔽₃ and 𝔽₉, n = 24) gives 54 against sᵢsᵢ' = 108. The text claimed sᵢsⱼ ("the translations of distinct orbits act independently"); corrected in `enumeration-proof.md` Part E. The REFINED score is unaffected: the orbital is ≥ Fᵢ·cᵢ·cᵢ' ≥ Fᵢ·C(cᵢ,2) for the class with the smaller blocks.
- **What a blanket "Part E" would ask is more than any construction gives.** Every admissible configuration realised at its REFINED score fails for a fallback configuration at full twist (Lemma C's coupling caps the foreign twist), for a `fo` part (D2's scores are upper bounds), and for a foreign prime dividing some Fᵢ·(cᵢ − 1) (the carrier cannot be coprime to r, and the top's twist on ℤ/r dies). So no theorem here takes it as a hypothesis: the μ\* statements (`PartEMu.e6_mu`, `PartEMu.sigma0_muStar`) rest on the explicit constructions.
- **What E.6 needs (`PartEMu.lean`).** One realisable optimum. `e6_real`: a D2 part is matched by `E6.d2_case` (whose witnesses are D2-free); Proposition 1 leaves ≤ 1 class and ≤ 2 foreign parts; a class with a foreign r ∣ c − 1 is a bare safe-prime pair, re-read (`E6.e6_of_view` returns the re-reading); a foreign r ∣ F forces n < 73 (F ≤ 15, the share bound), where `badOK_all` (kernel-checked) supplies a single-class witness at the six n that reach the line; otherwise the twist is raised to full. A configuration with no class re-reads its smaller prime as one. Then `real_le_mu` and `Part0Mu.muStar_le` give **`e6_mu`: μ\*(n) = B_safe(n) = B_refined(n) above 1/25, given only `HypHuppert`**.
- **Not formalised:** reduced twists (REFINED below SAFE, the Lemma C strip) and F_top as a separate top-layer factor (here all of F is carried by the cyclic layer, which realises the same score).

## Theorem E.5 and Corollary E.6

Theorem E.5 (`enumeration-proof.md` Part E‴) caps the SAFE score of every fallback configuration below `C(n,2)/25`; Corollary E.6 then gives `μ*(n) = B(n)` wherever `B(n) > C(n,2)/25`, which is what covers every `n ≤ 10⁶`. Both are formalised; the details follow.

## E.5: the A9 items and the SAFE model

`E5Core.lean` proves E.5's counting and congruence steps (see its header). For `pending-checks.md` A9:

- `ArkCore.orb_self_pairing` — on a block of odd size c, `orb c d false = c·d/2 ↔ d even` for `1 ≤ d ≤ c − 1`. **c odd is needed**: at even c and d = c − 1 the cap `pairs c` equals `c·d/2` with d odd.
- `ArkCore.fused_value`, `ArkCore.fused_value_orb` — for `Q ∣ n`, `(n/Q)·pairs Q = (n/Q)·orb Q (Q−1) b = n(Q−1)/2`: the arithmetic half of `μ*(n) ≥ n·(Q(n) − 1)/2`. That the fused construction is an Oliver group with this as its least orbital is group theory and is not claimed.
- `Bridge.lean` — `ArkBridge.isPrimeN_iff_prime : E5Core.IsPrimeN p ↔ Nat.Prime p`, which is Mathlib's `Nat.prime_def` reversed. This is route 1 of the reconciliation below: Mathlib-side code can feed `Nat.Prime` hypotheses to `E5Core`'s lemmas.

**Reconciling `E5Core` with Mathlib.** `E5Core`/`ArkCore` define their own versions of standard notions so that they compile without Mathlib:

| `E5Core` / `ArkCore` | Mathlib equivalent |
|---|---|
| `IsPrimeN p` (`2 ≤ p ∧ ∀ d, d ∣ p → d = 1 ∨ d = p`) | `Nat.Prime p` — bridged in `Bridge.lean` |
| `prime_pow_dvd_coprime`, `dvd_of_dvd_mul_coprime`, `dvd_sub_le`, `gcd_pow_eq_one`, `gcd_two_pow_pm`, `gcd_succ` | `Nat.Coprime` API (one-liners there) |
| `isPrimeN_of_bounded`, `isPrimeN_three`, `isPrimeN_13` | `Nat.Prime` by `norm_num` / `decide` |
| `pairs n` (`ArkCore`) | `n.choose 2`, bridged in `Note.lean` |

Route 1 (import and bridge) is in place. Route 2, a Mathlib-native rewrite of `E5Core`, is no longer blocked (the separate core-4.15 build has been dropped) but nothing requires it. Meanwhile: stay inside the namespaces, prefix any helper whose bare name could exist in Mathlib, and add any new home-made notion to the table in the same edit.

**The SAFE model —: Option B, exceptions row by row** (Vipul: "whatever most faithfully matches the text"). `E5Assembly.lean` defines configurations and SAFE from Part G.3/G.3a and *proves* the inequalities E.5's proof consumes, rather than taking them as fields:

- **Model.** `Part` (`pc F c` a p-characteristic class, `fr r t` a foreign block), `Fallback` (class (F, c), foreign (r, t), leftover list), `Fallback.safe` = min over G.3's orbital types: intra (flat F·C(c,2) for a p-class, per B_safe; `orb r t false` for a foreign block), smallest within-part cross ((F or F/2)·c², F ≥ 2), and every between-parts sᵢsⱼ. `Admissible W p a q` carries the text's hypotheses: c = p^a, r prime ≠ p with r ∣ c − 1, leftover parts p-power classes or foreign primes, every foreign twist dividing r − 1 and a power of **one** prime q (Lemma B′ — group theory, an explicit hypothesis exactly as the text cites it), and **foreign primes distinct** (the second-reading fix).
- **Proved from the definition.** `safe_le_pairs_r` (SAFE ≤ C(r,2)), `safe_le_pairs_part` (every part has C(size,2) ≥ SAFE — the text's ℓ(B)), `safe_le_orb`.
- **Branches.** `e5_s_ge4`; `e5_s2a1`, the whole s = 2, a = 1 branch for any non-bare W, all four sub-cases. In the one-foreign-leftover sub-case the ratio window and the cofactor bounds (r−1)/t ≤ 3, (r′−1)/t′ ≤ 7 are **derived from SAFE** (`cofactor_r`, `cofactor_r'`), where `E5Core.odd_q_leftover` took them as hypotheses; q = 2 is closed too (r ∈ {3, 5} via Mathlib's `Nat.pow_of_pow_add_prime` and `E5Core`'s divisibilities). The two-or-more-parts sub-case uses the exact count n ≥ c + r + 2ℓ (`two_part_leftover`) rather than the text's θ-estimate — same conclusion, simpler route.
- **Exceptions.** `exceptions`: one configuration per table row, leftover composed as `fallback_sup.py` composes it, with n, SAFE (= the table's 1, 3, 3, 3, 21, 21, 18, 21, 21, 10, 39, 155) and 25·SAFE ≥ C(n,2) checked by `decide`. `ex28_admissible` checks `Admissible` on the row where every clause is non-vacuous.
- **The other branches.** `e5_s1` (E.1's classification: p odd forces (3, 2); p = 2 forces r = 2^a − 1 Mersenne with a prime, via Mathlib's `Nat.prime_of_pow_sub_one_prime`; a ≥ 7 is `e1_mersenne`), `e5_s3` (E.4: r = 2, or 2^{2b} − 1 = 3r forces b = 2, i.e. (16, 5)), `e5_s2a2` (E.3(i): (p−1)/2 divides r, so p = 3; a even is impossible mod 8; a = 3 is (27, 13); a ≥ 5 is `e3_repunit`).
- **`e5`, the assembly.** For `Admissible W p a q` and `¬ W.Bare`: `25 * W.safe < pairs W.n ∨ (W.c, W.r) ∈ excPairs`, the six pairs (3,2), (4,3), (8,7), (16,5), (27,13), (32,31). Inputs not proved in Lean: Lemma B′ (one q for all twists) and distinct foreign primes, both as hypotheses in `Admissible`, as in the text.
- **The exceptional n, pinned (`e5_exceptions`).** If 25·SAFE ≥ C(n,2) then n is one of the table's twelve values. Route: for each of the six pairs, SAFE ≤ orb(r, t), with t a prime power dividing r − 1, bounds n (≤ 88; ≤ 62 except at (32, 31)). A leftover part must hold B, which forces 5·size ≥ n + 3 (`n_add3_le`). So three leftover parts never fit, and two fit only at (8, 7). What remains is a finite list, enumerated by `chk` and checked by `decide +kernel` (about 30 s). The enumeration is a superset of the admissible parts: it drops "one q" when t = 1 and does not require the leftover's foreign primes to be distinct. `glue` and `mem_cands` prove that every admissible configuration appears in it. So E.5's exception statement, "exactly these twelve n", is a theorem and does not rest on `fallback_sup.py`.
- **Text finding.** The table lists one configuration per n. At n = 23 and 31, (F, c, r) = (2, 8, 7) and (3, 8, 7) with no leftover are also exceptions with the same SAFE (`exceptions_more`). So "exactly 12 exceptions" counts values of n; the F column shows one representative.

**Corollary E.6 (`E6.lean`).**
- **The model.** A `Config` is a list of parts:
  - classes `pc F c d`, with c = p^b and *any* d ∣ c − 1;
  - foreign blocks `fr r t`, with t a power of one q;
  - **Lemma D2 parts** `fo F r t`: F ≥ 2 outside blocks of one prime, fused or simply repeated, scored by D2's two classes. Those are F·C(r,2), and for F < r the same-position class, C(F,2)·r or F·r at r = q (D2q); the model takes the larger.

  This is Theorem 3.1's shape list with F any integer, *including* the D2 shapes the enumerator leaves out. `safe` values a class at F·C(c,2); `refined` values it at F·orb(c, d). A fallback configuration is, as in E.5, a class with a foreign prime r ∣ c − 1. No hypothesis about how twists are reduced is needed (see "Reconciliation" below).
- **Pieces.**
  - `refined_eq_safe` (fallback-free); `refined_le_safe` (everywhere).
  - `safe_eq_view` / `view_admissible`: a fallback configuration *is* an E.5 `Fallback` with the same SAFE. This needs SAFE to be permutation-invariant (`crossTerms_perm`).
  - `reread_*`: E.3(ii)'s (r, r) re-reading.
  - `Config.full`: raise every twist to full.
  - `exc_beaten`: at the twelve exceptional n, a one-class configuration beats every fallback.
  - **`d2_case`: D2's domination, proved in the model.** A SAFE optimum above the line that contains a D2 part is matched by a fallback-free configuration. Above the line, a D2 part has F, r ≤ 25 and n < 614 (`d2_small`, by counting). In that region, a kernel-checked table (`d2check`, about a minute) gives at each of 256 values of n a one- or two-part fallback-free witness that scores at least D2's bound. The witnesses' admissibility is checked by `admB`, which is proved to imply `GAdm`.
- **Results.**
  - `e6_core`: a SAFE optimum above 1/25 is matched by an admissible fallback-free configuration with REFINED = SAFE.
  - **`e6_maxima`**: `IsBsafe n B` with C(n,2) < 25·B implies `IsBrefined n B`. This is E.6's B_refined = B_safe, stated on the two maxima.
  - Non-vacuity: `isBsafe_primePow` / `isBrefined_primePow` give B_safe(p^b) = B_refined(p^b) = C(p^b, 2).
- **Reconciliation with Parts 0 and D.**
  - **Twists.** A first version assumed "a twist below c − 1 needs a foreign r ∣ c − 1" (Lemma C's coupling). That assumption is gone: SAFE ignores twists, so a configuration with no fallback has the same SAFE as its full-twist version (`Config.full`), which is fallback-free. The model therefore allows any d ∣ c − 1, exactly as Theorem 3.1 does, and Lemma C is not used anywhere. That matches the text's claim that B_safe and E.6's proof are independent of Lemma C.
  - **F.** F is any integer. That is the permissive reading of F = F_mid·F_top that the certificates use. Since Theorem 3.1 imposes no coprimality on F_mid, it is at least as large as the true shape space.
  - **Fused foreign classes and repeated foreign primes** are in the model as `fo` parts. Their domination above the line is a theorem here (`d2_case`), where the text relies on Corollary D2′ plus the computed table below n = 471. That supports the enumerator's choice to omit them, at least for the E.6 question.
- **Inputs.** Part 0 (μ ≤ B_safe) is supplied by `Part0Mu.muStar_le`; Part E for the optimum E.6 needs by `PartEMu.e6_real` and `PartEG`, so `PartEMu.e6_mu` proves μ\* = B_safe above the line with neither as a hypothesis. Lemma D2, the source of the `fo` terms, is a theorem; `FoBridge.fo_terms_valid` connects the two.

**Lemma D2 (`D2.lean`).** This file works on actual permutation groups: G ≤ Sym(Fin F × ZMod r), the image Γ|_O. Orbitals are G-orbits on unordered pairs (`orbit2`), and the generic fact is that an orbit inside a G-invariant set is no larger than the set (`orbit2_card_le`).
- **Branch (a), `d2a`.** If G preserves the block system, some orbital has at most F·C(r,2) pairs. This is unconditional, as in the text.
- **Step 3, `d2b`.** If every element acts as (i, x) ↦ (σi, a·x + s), the same-position pairs are invariant, so some orbital has at most C(F,2)·r pairs.
- **D2q step (7), `d2q`.** If every linear part is trivial, so (i, x) ↦ (σi, x + sᵢ), the pairs with within-block difference ±1 are invariant, giving an orbital of at most F·r pairs.
- **Step 1's order arguments.** `step1_sigma`: an element of r-power order in Sym(F) with F < r is trivial. `step1_mult`: an r-power multiplier is trivial.
- **Step 2's first claim, `step2_mult_equal`.** If conjugation keeps the diagonal translation diagonal, all the multipliers are equal.
- **Link to `E6`.** These bounds are exactly `E6`'s `fo` terms (`fo_terms_match`).
- **Steps 1–2, supplied by other files.** The normal-form hypothesis of `d2b` and `d2q` is discharged by `Chain`, `Step2`, `Glue`, `Rescale`, `LemmaB`, `D2Full` and `D2q`, described below.

**Oliver's chain and D2's Step 1 (`Chain.lean`).**
- **The chain.** `OliverChain H p q` is Γ₂ ⊴ Γ₁ ⊴ H with Γ₂ a p-group, Γ₁/Γ₂ cyclic and H/Γ₁ a q-group. `OliverChain.map` carries it to any surjective image, in particular Γ|_O.
- **`rsub_cyclic`: every r-subgroup is cyclic when r ∉ {p, q}.** An r-subgroup lies in Γ₁, because its image in the q-group is trivial (`rsub_le_N₁`). It meets the p-group Γ₂ trivially (`rsub_inf_N₂`). So it embeds in the cyclic layer. This is the fact D2's Step 1 attributes to the chain.
- **`step1_translations` / `step1_Gamma`.** For Γ with a chain acting on O = Fin F × ZMod r, the translations in Γ|_O form an r-group, hence a cyclic one, so they are the multiples k·v of a single vector. That is the text's "T\* ≅ C_r generated by one vector".
- **`step1_full_support`, `step1_diagonal`.** If every block sees a nonzero translation, v has full support, and per-block rescaling sends v to the diagonal.
- **`step1_full`: Step 1 complete, given affine block actions (Lemma B, proved for prime blocks in `LemmaB.lean`).** Assume every element acts affinely, (i, x) ↦ (σi, aᵢx + tᵢ) with aᵢ ≠ 0, and Γ|_O is transitive on O. Then:
  - F·r divides |Γ|_O|, so by Cauchy there is an element of order r;
  - it is a pure translation (`rElem_is_translation`: σ = 1 by `D2.step1_sigma`, aᵢ = 1 by `D2.step1_mult`);
  - conjugating it to each block (`conj_translation`) shows the generator has every component nonzero.

  So T\* is the diagonal C_r after rescaling, which is the text's Step 1 in full.
- **`not_rsq_dvd`: Sylow-r of Γ|_O is T\*.** r² doesn't divide |Γ|_O|, so |Γ|_O/T\*| is prime to r.
- **`Step2.origin_change`: Step 2's second claim, the H¹ = 0 computation.** Take any finite group Q with |Q| invertible in K, a multiplier a : Q → K, a block action σ, and translation parts t forming a cocycle modulo constants. Then the origins o := −|Q|⁻¹ Σ_h a_h⁻¹ t_h make every element's translation part the same on all blocks. Multiplicativity of σ is not even needed.
- **`step2_common_mult`: Step 2's first claim, for the group.** Every element's multipliers satisfy aᵢvᵢ = λ·v_{σi}, so they are all equal once v is rescaled to 𝟙.
- **Completing D2 for r ∉ {p, q}:**
  - **Lemma B** (block actions are affine): proved for prime blocks in `LemmaB.lean`, below.
  - **The rescaling: done.** `Rescale.lean` conjugates Γ|_O by the per-block rescaling ψ(i, x) = (i, vᵢx). In the new coordinates every element has one multiplier and T\* is diagonal (`conj_affine`, `conj_translation_scale`). [Γ|_O : T\*] is prime to r, because |T\*| is divisible by r and r² ∤ |Γ|_O|. Orbital sizes are preserved under conjugation (`orbit2_conj`). **`d2_full`** then assembles Step 1 → Step 2 → Step 3: Γ|_O with an Oliver chain, 2 ≤ F < r, r ∉ {p, q}, Lemma B's affine form and transitivity on O together give an orbital of at most C(F,2)·r pairs. With `D2.d2a`, that is Lemma D2's statement for r ∉ {p, q}.
  - **The bridge to `D2.lean`'s normal form:** `Glue.lean` assembles Step 1, Step 2 and the affine form into "every element is (σi, a·x + s)".

**Lemma B for prime blocks, and D2 without hypotheses (`LemmaB.lean`, `D2Full.lean`).** The text proves Lemma B from "a solvable primitive group is affine", a classical theorem not in Mathlib. For outside blocks of prime size r, which are all that D2 needs, an elementary route is fully formalised.
- **`LemmaB.lemmaB_block`.** Take a transitive group H on ZMod r with an Oliver chain, r ∉ {p, q}. Then:
  - the bottom layer acts trivially (`normal_pgroup_trivial`), so the middle layer is cyclic;
  - Cauchy gives z of order r, which lies in the middle layer (`rsub_le_N₁`), so every h conjugates z to a power of z (`conj_mem_zpowers`);
  - z is an r-cycle (Mathlib's `isCycle_of_prime_order''`), and labelling points by k ↦ zᵏ(0) turns it into x ↦ x + 1;
  - so every relabelled h is affine (`affine_of_normalizes`).
- **`D2Full.d2_noB`.** This transports `lemmaB_block` from block 0 to every block:
  - restrict the chain to the block stabiliser (`OliverChain.comap`) and push it to the block (`ρ`);
  - relabel block j through a transversal gⱼ, Ψ(j, x) = gⱼ(0, E x);
  - check every element is then affine block-to-block;
  - conjugate by Ψ and apply `Rescale.d2_full`.

  **Result.** Take G preserving a block system of F blocks of prime size r, transitive, with an Oliver chain, 2 ≤ F < r and r ∉ {p, q}. Then some orbital has at most C(F,2)·r pairs. **No Lemma B hypothesis**, and no circularity: Step 1 is applied only after Lemma B has been derived.
- **D2q (`D2q.lean`).**
  - **Lemma B for q-blocks.** `LemmaB.lemmaB_block_any` handles a block of size q. If the middle layer acts trivially, H is a q-group of degree q, so H = ⟨z⟩.
  - **The core, `d2q_fixed`.** There is a full-support v with aᵢ(g)·vᵢ = v_{σi} for every g.
    - First, a v fixed by the middle layer. If N₁ contains a nonzero translation, its commutator with any n ∈ N₁ is a q-element in [N₁, N₁] ⊆ Γ₂ (step 5). Otherwise the commutator is a translation inside N₁, so trivial (step 6).
    - Then every g fixes v: g^(qᵏ) ∈ N₁, g^(F!(q−1)) is a translation (`pow_is_translation`), and the two exponents are coprime.
  - **`d2q_affine` / `d2q_noB`.** Rescaling by v makes every multiplier 1, and `D2.d2q` gives the F·q orbital.
- **`D2q.lemmaD2`: Lemma D2 assembled.** F·C(r,2) always; C(F,2)·r when F < r and r ≠ q; F·r when F < r and r = q. All from the chain, a preserved block system and transitivity.

**Closing two loops (`FoBridge.lean`, `D1.lean`).**
- **`FoBridge.fo_terms_valid`.** Every SAFE term `E6.lean` assigns to a fused/repeated outside part (F·C(r,2), and max(C(F,2)·r, F·r) when F < r) is at least the size of some orbital of every group of that shape. So the E.6 model's D2 scores are theorems from the chain, block system and transitivity, not numbers copied from the text.
- **`D1.lemmaD1`.** In the E.6 model, F = pᵏ copies of a p-block of size c read as one part of size F·c. That reading stays admissible, keeps n, and does not lower SAFE. This is the domination the text uses to drop bottom-layer block copies.

**Lemma B′ (`LemmaBprime.lean`).**
- **`step0`.** If V is minimal normal and C_G(V) ≤ V, every nontrivial normal subgroup contains V. This is the text's Step 0, and it uses both hypotheses, as the text's "two dependencies" note says.
- **`lemmaBprime` (abstract).** Take G with an Oliver chain (p, q) and V a nontrivial normal abelian p₀-subgroup, p₀ ≠ p, minimal normal, with C_G(V) ≤ V. Then:
  - V is cyclic;
  - G/V is a q-group;
  - if the middle layer is trivial, then p₀ = q.

  Both of the text's cases appear. In **Case 1** the middle layer contains V, is cyclic and abelian, so it equals V. In **Case 2** G is a q-group, and a central subgroup of order q is normal, so by Step 0 it contains V.
- **`lemmaBprime_affine` (concrete).** O = 𝔽_{p₀}^a, G ≤ Sym(O) containing all translations, every element affine, linear parts irreducible. The abstract hypotheses are derived: C_G(V) = V from affineness, and minimality from irreducibility. The conclusions are **a = 1**, and every element has a qᵏ-th power that is a translation, so the twist is a q-group.
- **`lemmaBprime_primitive`: B′ with no affine-form input.** Take G ≤ Sym(X) primitive, with an Oliver chain (p, q), |X| ≥ 2 and p ∤ |X| (an outside block). Then |X| is prime, and there is a normal V of order |X| such that every element's qᵏ-th power lies in V, so the twist is a q-group. If the middle layer is trivial, |X| = q. The proof:
  - a nontrivial abelian normal subgroup of a primitive group is regular (`card_eq_of_abelian_normal`);
  - Γ₂ would be transitive, forcing |X| to be a p-power, so Γ₂ = 1 and Γ₁ is cyclic;
  - if Γ₁ ≠ 1 it is regular, and so is its subgroup of elements of prime order p₀, which has order p₀;
  - if Γ₁ = 1, G is a q-group, and a central subgroup of order q is regular.

  So **Lemma B′ is proved outright** from the chain and primitivity. The classical "solvable primitive ⇒ affine" theorem, which the text cites and Mathlib lacks, is not needed for B′. (The affine-coordinates form of Lemma B is still unformalised for general primitive blocks, though it isn't needed for B′; for prime blocks it is `LemmaB.lemmaB_block_any`.)

**Proposition 1's counting clauses (`Prop1.lean`).** `ladder-completeness.md` Proposition 1 says a SAFE optimum above C(n,2)/25 has fusion count F ≤ 16 for a class beside other parts, because cap_F(1) = 1/(1 + √F)² < 1/25 for F ≥ 17.
- **`cap16`.** Exactly in ℕ: for F ≥ 16, 25·min(F·C(c,2), C(s,2)) ≤ C(F·c + s, 2). Split on s ≤ 4c (then 25·C(s,2) ≤ C(5s,2)) or s > 4c (then (F + 4)² − 25F = (F − 1)(F − 16) ≥ 0).
- **`fusion_cap`.** In the `E6` model: a class `pc F c d` beside any other part (any order) with 25·SAFE > C(n,2) has **F ≤ 15**. Every part has a SAFE term at most C(size, 2) (`exists_term_le`).
- **Finding.** The text's F ≤ 16 is true but one loose: cap_16(1) = 1/25 exactly, so F = 16 also fails the strict inequality. The ladder's menu (F ≤ 16) is one wider than needed, which is harmless.
- **`part_share`, `parts_le_four`.** Above the line every part has n + 3 ≤ 5·size, so at most four parts (Proposition F.1 in the model).
- **`foreign_efficient`.** A foreign part `fr r t` with 2r < n has 2(r − 1) < 25t: the text's k ≤ 12 for r − 1 = k·t, from orb(r, t) ≤ r·t alone.
- **`merge_classes`: no S12.** Classes `pc F₁ (m·c)` and `pc F₂ c` merge into `pc (F₁·m + F₂) c` with the same n and SAFE no lower. The within-class cross term of the merged class is at least F₂·C(c,2) (`within_ge`), which is the text's "never binds".
- **`three_foreign`: the reduction for three foreign primes.** Three foreign parts r₁ ≤ r₂ ≤ r₃ above the line have 9r₁ < 50t₁ + 3, 2r₂ < 25t₂ + 1 and r₃ < 18t₃; with rⱼ − 1 = kⱼtⱼ, k₁ ≤ 5, k₂ ≤ 12, k₃ ≤ 17. The shares are ≤ 1/3, ≤ 1/2 and < 3/5, the last because the other two parts each have share > 1/5.
- **`ThreeForeign.no_three_foreign`: three foreign primes excluded outright.** For every q and every exponent, not only the text's enumerated range.
  - Normalise by the least twist T = q^m: rⱼ = aⱼT + 1, tⱼ = bⱼT with bⱼ = q^(eⱼ) ∣ aⱼ, one bⱼ = 1.
  - The part with bⱼ = 1 bounds A = Σaⱼ ≤ 31, so the patterns are finite.
  - In every pattern some part has a bound whose leading coefficient is ≤ A² and linear coefficient ≤ 5A, so it fails at *every* T. A kernel check (one `decide` per q ≤ 31, one for q ≥ 32) confirms this; about two minutes.
  - Inputs used: orb ≤ c·r·t/2 (halving when q = 2 and t ≥ 2), orb ≤ C(r,2), share > 1/5, and the parity of a prime rⱼ = aⱼT + 1. The text's continuous worst case, 1/27 at q = 2, is consistent.
- **`Prop1Final.prop1`: Proposition 1 assembled.** Every admissible configuration with no D2 part above the line is matched (same n, SAFE no lower, admissible) by one with at most one class and at most two foreign parts, and F ≤ 15 when the class has company. Classes are merged repeatedly (`merge_all`, larger block first); a third foreign part is excluded after sorting the primes (`fr_le_two`). The remaining clauses (shares, foreign efficiency, fallback-freeness via `E6.e6_core`) apply to the matched configuration as separate theorems; D2 parts are handled by `E6.d2_case`.
- **`TwoForeign`: Proposition 2.** `s6_ceiling` (two foreign primes: 9·SAFE ≤ C(n,2)) and `s11_ceiling` (a class and two foreign primes: 16·SAFE ≤ C(n,2)), for every q and exponent.
  - The key lemma `two_foreign`: for r₁ < r₂ and R = r₁ + r₂, one part has 18·orb ≤ R(R − 1). Same normalisation and per-q kernel check as `ThreeForeign` (A < 18).
  - One family passes the coefficient test, q = 2 with r₁ = 2T + 1, r₂ = 3T + 1; primality kills it (T = 2 is {5, 7}, numerically fine; T = 2^m ≥ 4 makes one divisible by 3 or 5).
  - S11 reduces to the same lemma: a class above 1/16 has 3s > R, so 9n(n − 1) ≥ 16R(R − 1).
  - **Finding.** The text's exceptions {3, 5} and {5, 7} are not needed in the model: they exceed 1/9 only in the continuous ceilings. And "S6 has n even" fails at the edges {2, 3} and {2, 5} (n = 5, 7, SAFE = 1), which is harmless.
- **Not formalised from `ladder-completeness.md`:** Proposition 3 (conditional on (BCG-AL), not a target).

**(BCG) as a specification and a quantifier (`BCG.lean`).** Mirrors `arithmetic-of-density.md` §3.5.3's "specification and quantifier" paragraph.
- **Shape.** A specification is a witness predicate `W : ℕ → Prop` (clauses 1–4 at one n). The quantifier is a filter: `atTop` for (AL), `almostAll` for (AA), whose sets are those with exceptional set ≤ C·x/(log x)^A + C up to x, for every A. `Hyp W L := ∀ᶠ n in L, W n`.
- **Proved.** `almostAll` is a filter; `atTop_le_almostAll` (AL ⇒ AA, for every W); `almostAll_neBot` (AA is not vacuous); `Hyp.lift` / `Hyp.lift_large` (a pointwise result lifts to any quantifier below `atTop`).
- **The note as an instance.** `noteWitness` is `Note.HypBCG`'s clause (`note_hyp_iff`). `note_pointwise` is the arithmetic half at one n; `note_arithmetic_half` lifts it, giving `Note.theorem_arithmetic_half` under (AL) and its (AA) counterpart from one proof.
- **Σ₀ and the window lemma (`Sigma.lean`).**
  - `F0`, `d0`: Σ₀'s table. `bhsw_agrees`: the (BH-SW) per-class (k, d) of `bcp-to-floor.md` is the same table (`decide`).
  - `xstar`, `balance`: for any (F, η), both binding terms equal `capF F η` at the balance point.
  - `target`, `window`, `target_le_cap`, `target_at_balance`: the window lemma for any (F, η, window).
  - `window_of_eps`: the window x₋ = x\*√(1 − ε), 1 − F·x₊ = (1 − F·x\*)√(1 − ε) has target exactly (1 − ε)·cap, so clause 2's two readings correspond for every (F, η).
  - `pointwise`: the exact single-n bound on the two binding terms, (target − κ/n)·n(n − 1).
  - `cap_table`: §3.3.5's cap column is `capF (F0 a) (2 / d0 a)` at all twelve classes.
- **The assembly (`SigmaHalf.lean`).**
  - `ClassSpec` (F, d, window), its `Witness` (n = F·p^b + r in the window, r = dq + 1, q odd prime, r ≠ p, r ∤ p^b − 1) and regularity `Good` (including the one cross-term side condition 2F·x₋·y₋ ≥ target).
  - `pointwise_half`: for any regular specification, a witness at n gives an admissible `E6` configuration with 2·SAFE ≥ (target − κ/n)·n(n − 1). Inputs: `orb_dq` (orb(r, q) = (2/d)·C(r,2)), `within_ge` (the within-class cross term never binds), `Sigma.pointwise`.
  - `specEps_good`: every (F ≥ 1, d ≥ 2) at the ε-window is regular, side condition included.
  - `sigma0_half`: under `Hyp (W0 ε) L`, L = `atTop` or `almostAll`, L-eventually 2·SAFE ≥ ((1 − ε)·δ₀(n mod 12) − κ/n)·n(n − 1). One proof for both quantifiers; Σ₀ enters only through `spec0`.
  - `PartEMu.sigma0_muStar`: L-eventually 2·μ\*(n) ≥ ((1 − ε)·δ₀(n mod 12) − κ/n)·n(n − 1). This is the conditional floor statement, in both quantifier strengths, from one proof.
- **Part E for F = 1 (`PartE1.lean`).** The group is K's affine group alongside z ↦ u·z + v on ℤ/r, u in the order-q subgroup of (ℤ/r)ˣ.
  - Oliver chain: translations of K (p-group, characteristic p) ◁ trivial ℤ/r-multiplier (layer ≅ Kˣ × ℤ/r, cyclic by CRT since r ∤ c − 1) ◁ G (q-group on top).
  - Orbitals: C(c,2) inside K (2-homogeneity), c·r mixed, ≥ q·r inside ℤ/r (−1 ∉ U as q is odd). So every orbital is ≥ SAFE.
  - `sigma0_F1_realised`: at n ≡ 0, 2, 4, 6, 8, 10 (mod 12), under (AL) or (AA), the floor holds with Part E **proved**: an Oliver group on n points all of whose pair-orbitals are ≥ m with 2m ≥ ((1 − ε)·δ₀ − κ/n)·n(n − 1).
- **Part E for F ≥ 2 (`PartEF.lean`).** F blocks of 𝔽_c with the entangled generator zc: (i, x) ↦ (i + 1, x), wrapping with ×ω, so zc^F is the full twist on every block.
  - Group ⟨translations, γ = zc ⊕ (z ↦ z + 1), μ(U)⟩; chain T ◁ ⟨T, γ⟩ ◁ G, with the layer cyclic because it is generated by γ over T, and the top a q-group because every element is μ_u modulo N₁. Coherence r ∤ F(c − 1) is used once: to put ρ_v (z ↦ z + v) into N₁, which makes N₁ normal.
  - Orbitals: F·C(c,2) within blocks; ≥ K0·c² across blocks (K0 = F odd, F/2 even — the rotation orbit of a block pair); F·c·r block–ℤ/r; ≥ q·r inside ℤ/r. Exactly the SAFE terms.
  - `PartEAll.sigma0_realised`: **Σ₀'s floor at every residue class with Part E proved**, under (AL) or (AA): the conditional floor rests only on the quantified witness hypothesis (and on Oliver/KSS for what μ\* means downstream).
- **Threshold beyond μ\* (`CycGood`, `Evasive`, `RGlue`, `Threshold`).** Same parameter-change pattern as Σ₀: the threshold class specification is `specEps F 2 ε` (η = 1), F = 1 at even n and F = 2 at odd n, so the targets are (1 − ε)·capF F 1 = (1 − ε)/4 and (1 − ε)(3 − 2√2) (`capT_even`, `capT_odd`). Same groups as Part E (`thr_1` on `PartE1.G`, `thr_F` on `PartEF.G`), with r = 2kq + 1 and the ℤ/r block now **credited at full capacity C(r,2)** instead of ≥ q·r: its k pair-orbit types are glued by a good C_k (`CycGood`), and evasiveness follows from `HypKSSOliver`, a named hypothesis (Mathlib has no evasiveness, KSS or Oliver). k by class: 1 at n ≡ 0, 1, 4, 6, 9, 10; 2 at 3, 7; 3 at 2, 5, 8; 6 at 11 (mod 12); q > 7 prime throughout. The witness hypothesis `WT` is quantified as in `BCG.Hyp`.
- **The covering statement (`Cover.lean`), §6's ⇒ direction.** `Floor δ n` (some admissible configuration at n has SAFE ≥ δ·C(n,2)) holding L-eventually gives `ShapeD δ Fmax n` L-eventually. `ShapeD` lists the S2 and lone-prime escapes, n = F·c + r (F ≤ Fmax), n = r₁ + r₂ only if δ ≤ 1/9, and n = F·c + r₁ + r₂ only if δ ≤ 1/16. The F-bounds come from `fbound`, the fusion ceiling as an inequality √δ·(n − 1)(1 + √F) ≤ n; the two-foreign ceilings come from `TwoForeign`; D2 parts appear only below n = 614.
  - **Not included:** the hypothesis is on B_safe (its restatement on μ\* is `Part0Mu.cover_mu` / `cover_foreign_mu`); the escapes are kept as disjuncts; local obstructions (§6.3(c)) are not applied; at the boundary, `fexact` shows a perfect-square F = s² never reaches 1/(1 + s)² at finite n, so δ₀ = 1/16 and 1/9 are covered for the F-bounds; δ₀ = 1/25 is not (Proposition 1 is strict), and S6 at 1/9 and S11 at 1/16 are excluded by the strict ceilings `s6_ceiling_lt` and `s11_ceiling_lt`.
  - **On dropping the escapes (`CoverDensity.lean`):** the S2 escape has F ≤ 25 (the class's own ceiling, proved in `shape_of_small`), so the escapes are the primes and at most 25 multiples of prime powers. `esc_count` counts them: O(x/log x). So `cover_foreign` drops them with O(x/log x) exceptions. That is the true rate, since the primes alone are ≍ x/log x; it is not (AA)'s O(x/(log x)^A).
- **Scope of Part E here:** the two-part shapes Σ₀ uses (one class, one foreign block, odd q). `PartEG` generalises the construction; see "Part E" below.

**The Lean scoring model against the Python scorers (`../scripts/lean_score_crosscheck.py`).** The theorems here are about `E6.Config`'s SAFE and REFINED, so a drift between those definitions and the scripts that produced the table would make them true of the wrong thing. The script compares the **full sorted term lists**, not the minima (a mis-scored term that does not bind would hide behind the minimum), of random configurations: Lean against `mu_enumerate_v3.value` in SAFE and refined mode, and `validate_table_v3.score` against `mu_enumerate_v3`.
- **Result:** 8,000 configurations (p ∈ {2,…,13}, q ∈ {2, 3, 5, 7}, F up to 7 both parities, c up to p³, r < 120, Lemma C changing a term in 2,750), 0 mismatches; 20,000 for the validator, 0 mismatches.
- **Control:** a mutant `orb` without the 2 | t halving is caught (121 of 500, 273 of 2,000).
- **Not covered:** `mu_ladder_exact.py`'s inline scoring (cross-checked against the exact table in `pending-checks.md` R0), D2 parts, and `Note.lean`'s note-specific values.

> **Mathlib coverage, to recheck on every bump.** In the pinned Mathlib (v4.36.0), Mathlib has primitive and quasiprimitive actions, Jordan's theorems, Schur–Zassenhaus and solvable groups. It has no minimal-normal-subgroup or socle theory, no O'Nan–Scott, and no "a solvable primitive group is affine". Several results here are hand-proved because of that gap: `card_eq_of_abelian_normal`, `LemmaB.lemmaB_block_any`, the Step 0 and Lemma B′ arguments, and `LemmaB.mem_zpowers_of_orderOf_eq`. **When Mathlib is next bumped, check whether ready-made versions now exist.** Candidates:
> - socle / minimal normal subgroups;
> - "solvable primitive ⇒ affine";
> - normalisers of regular cyclic subgroups in Sym(p);
> - uniqueness of subgroups of a given order in a cyclic group.
>
> Swapping one in would mean a toolchain and Mathlib version bump, a re-pin of `lean-toolchain` and the lakefile `rev`, a fresh `lake exe cache get`, and fixing the name drift such bumps bring (see the lemma-name lesson above). So it is not to be done lightly. But it would shorten the proofs and move trust onto Mathlib's reviewed library.
