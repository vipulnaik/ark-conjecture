# Session log 14 — the fallback branch gets a ceiling, and μ = B becomes a theorem to 10⁶

*Two sittings: an audit pass over the core documents with fresh eyes, and then a targeted attack on the B_refined / μ / B_safe sandwich. The second produced the session's one real theorem; the first produced eight corrections, of which one was a genuine model error rather than drift.*

---

## 1. What changed in the mathematics

### 1.1 Theorem E.5 and Corollary E.6 — the collapse above density 1/25

**The gap as it stood.** `ep` proved the collapse branch by branch along the s-ladder: E.1 (s = 1), E.3(iii) (s = 2, a ≥ 2), E.4 (s = 3), and E.3(ii) for the s = 2, a = 1 **bare pair**. The declared residue was the s = 2, a = 1 branch *with a leftover*, and it was residue at **every density** — nothing written down confined it to a low-density tail. Per n the certificates always closed it; over all n, nothing did. E″ recorded a wall: within a fallback configuration's own partition the fallback reading is forced (cases α–γ), so a promotion has to compare across partitions of n, where arithmetic supply enters.

**What broke it open** was reading the script outputs as evidence about a *bound* rather than as a list of closed values. `wide_cert.py`'s two survivors, n = 50,817 and n = 89,697, died at density **0.039994** and **0.039996** — recorded in `pending-checks` as a B_lo deficiency, and it was one, but the coincidence of two independent values landing a hair under 1/25 is not a fact about B_lo. A brute-force sup of SAFE over *every* fallback configuration at every n ≤ 3000 (`fallback_sup.py`: any (F, c), any r | c−1, any top prime, leftover of zero, one or two admissible parts) confirmed the shape of it: only **15 configurations anywhere reach C(n,2)/25, all at n ≤ 63**, all Mersenne, repunit or the r = 2 degeneracy — and the sharp approaches from below are 0.9955 at n = 1797, 0.9936 at 1257, 0.9911 at 897, every one an n = 5r + 2 with (q, 2q+1, 4q+3) a Cunningham chain of length 3.

**Theorem E.5.** Every fallback configuration other than a bare safe-prime pair has SAFE < C(n,2)/25, with those 15 exceptions. The proof is four sub-cases of s = 2, a = 1 on top of the existing branch theorems, and each is a counting bound on n: F ≥ 2 or a p-characteristic leftover forces n ≥ 5r + 2; two or more leftover parts give δ ≤ θ/(3 + 2√θ)²; and the one-foreign-leftover case — the genuinely new one — is closed by observing that r′/r ∈ (3/4, 2) plus twists that are powers of the **same** q leaves only r′ = 2r − 1, i.e. n = 5r, at q odd, and at q = 2 leaves c = 2r + 1 divisible by 3 or 5.

**Corollary E.6.** δ(n) > 1/25 ⟹ B_refined = μ = B_safe. Combined with `ladder_verify.py`'s unconditional floor 0.04621 on n ≤ 10⁶ — and a ladder score is a lower bound on B_safe — this gives **μ(n) = B(n) at every eligible n ≤ 10⁶ by theorem, with no B(n) computed anywhere in the argument.**

**Three things worth recording about the shape of the argument.**

- *The route was neither per-shape nor per-n but **per-density**.* `ep` had argued at length (the box in E′) that a per-shape argument cannot dispatch a family available at a density-zero set of n yet decisive where available, and concluded that per-n was therefore the right instrument. Both halves of that were right and the conclusion did not follow: a bound on the *value* is available where a bound on the *supply* is not. The box now says so.
- *The trusted base of the new route and of the certificates overlap only in Part 0.* E.5 uses counting on SAFE terms plus q-power twist arithmetic — no Lemma C, no Corollary C′, no J0a, and not the eight necessary conditions. So an error in `fb_common.py`'s conditions can no longer take the collapse with it above 1/25, which is a real demotion of risk item 7.
- *The two 1/25s are the same 1/25.* The conjectured floor and the fallback ceiling are both "five parts of size ≈ n/5", reached from opposite sides — the floor by what it would take a balanced family to fall that far, the ceiling by n = 5r + 2 and n = 5r. The collapse therefore holds exactly as far as the floor does.

### 1.2 The trichotomy, resolved

The question "if the sandwich opened, where would μ sit?" now has an answer rather than a shrug:

- **Above 1/25** the ends coincide (E.6).
- **At a = 1** — which is the whole s = 2 branch and the sharp shape — μ is pinned to the **lower** end. The c-block's stabiliser is a subgroup of 𝔽_c^× with c prime, so there is no exotic option; Lemma C at a = 1 is automatic and kills the foreign twist on a share, and otherwise d | 2. So μ = B_refined < B_safe there, provably: B_safe would simply be loose.
- **Strictly in between** needs all three of a proper prime power c, a stripped twist, and a density below the E.1/E.3(iii) caps. The mechanism is that `orb(c, d)` scores a **cyclic** twist and ignores the Galois layer: at c = 343 with foreign 19, C₁₈ ⋊ Frob₃ ≤ ΓL(1,343) is Oliver at q = 3 and realises 3087 against the stripped reading's 1029.

Filed as **A28**: score the Galois layer, giving **B_refined⁺**. After that the only remaining source of an interior μ is J0a proper — a stabiliser outside ΓL(1, c) altogether — which is a much sharper residue than "the refined scoring is not tight".

### 1.3 A side result: Lemma C's bound without J0a

Lemma C's coupling conclusion t | ord_r(p) needs a Frobenius exponent and so assumes semilinearity at a ≥ 2. The **bound** it is consumed for, orb(r,t) ≤ r·a, does not: the r-element's eigenvalues on 𝔽_p^a are r-th roots of unity closed under Frobenius, hence in ≤ a/ord_r(p) orbits; conjugation is a power map whose reduction mod r is the induced multiplier, so the multiplier group permutes those orbits and M⟨p⟩/⟨p⟩ acts freely on cosets, giving |M| ≤ a. **One reading only, nothing rests on it**, filed as **A29**.

---

## 2. What changed in the audit pass

Eight items, listed in `pending-checks`. The one that is a model error rather than drift:

**S7 at F = 3 is not a vanishing shape.** The census said "wins → 0" for S7 at F ≥ 3 odd, on the argument that F·c even forces c = 2^a. That is true for odd F at **odd n** only. At even n, c is an ordinary odd prime and the supply is a full Hardy–Littlewood system; and at **n ≡ 2, 8 (mod 12)** — where the ℓ = 3 obstruction cuts S3 to η = 1/3 — cap₃(1) = cap₁(1/3) = 0.13397 **exactly**, so F = 3 at full efficiency ties for the class ceiling and co-wins the class. On the exact table 1,261 of the 1,352 F = 3 winners are even n, every one at those two classes. A congruence-free even-n scan reproduces the tie (sups 0.13397 at F = 1 and 0.13395 at F = 3) and closes the even-n F-search the same way the odd-n one closes: cap₅(1) = 0.09549 < 0.13397.

**Third instance of one pattern**, after the ΓL(1) step and the q-power block count: *a case analysis whose proof covers one half of a partition while its statement quantifies over both*. Sharpest detail — `fusion-count-ceilings.md` **diagnoses exactly this pattern** for the odd-n even-F case, and then works its whole analysis under "F even is forced at odd n", never reaching the even-n odd-F branch. Finding the same error inside the document written to record it is the strongest argument yet for mechanising the check, which is now invariant **I8**.

The other seven: S5 vanishes in **bursts** not monotonically (one r serves a window of n proportional to r; 59 of 80 winners at r = 12289), so the decline test was the wrong instrument; `oen` §2.3 attributed the B₀/B gap to a gcd between two *matching* twists, which do not constrain each other at all — it is Lemma B′'s single-prime confinement of the *foreign* twist that carries the arithmetic; `ep`'s worked Case C taught the superseded twist-cut and contradicted both enumerators; four sites still described condition (4) as applying a twist strip; Part 0's step 2 diagram stated the within-class cross term as an upper bound, which a 2-homogeneous permuter beats; fixed points were not excluded in `oen`'s Theorems 2.2 and 2.3; and two stale constants (45,390 worklist entries against 44,091, and C′/D2′ thresholds derived from the pre-repair floor 0.02516).

---

## 3. Runs

| run | result |
|---|---|
| `mu_exact.py` | complete and **fully contiguous to n = 36,848** — 32,860 rows, no gaps, **no worklist tail**; agrees with `mu_enumerate_v3.py` at every common value |
| `validate_table_v3.py` on it | **26 PASS / 0 FAIL / 13 INFO** after the census fixes (the one FAIL was S7f3, item 2 above) |
| `fallback_cert.py --no-theorems` on the exact table | **0 candidates over all 21,471 rows to n = 24,236**, 24,062 s-branches all searched, largest s = 3, e = 1 share 97.6% (~25 min; run it detached) |
| `fallback_sup.py 3000` | new; 15 configurations reach C(n,2)/25, all n ≤ 63; sharp approach 0.9955 at n = 1797 |
| `a18_verify.py` on the exact table | all passes, worst UB/B **0.8276 at n = 56**; thresholds now printed per floor (the superseded 0.02516 → 1582, the current **0.04621 → 471**) |
| `converse_check.py` on the exact table | 0 violations; max cofactor still 12 (n = 221); inequality (1) saturated at 0.9999 (n = 20,378) |
| `check_doc_figures.py` | no EXPIRED, no INVARIANT findings; the residue is cross-reference notes of the `[elsewhere]` class |

**Table status change worth flagging.** The new table is contiguous with no tail, so the file floor and the contiguous floor coincide at 0.04621 (n = 2759) — the prefix/tail discipline is **dormant, not retired**, and applies again the moment an extension is worklist-driven. Figures scoped to [6, 2600] in the documents remain correct as scoped statements and have not all been recomputed at the new frontier.

---

## 4. Where this leaves the open items

- **Gap-inventory item 4** narrows from two regimes to one: **δ ≤ 1/25**, which is also where s = 4 and s = 5 live. E.3(ii)'s global promotion is no longer owed.
- **Risk item 3 (the ladder) is promoted**: `ladder_verify.py`'s correctness now carries a theorem-side statement about a million values, not just a floor. Its scoring wants a read — every rung must be an admissible configuration scored no higher than SAFE.
- **Risk item 7 (the eight conditions) is demoted**: they no longer gate the collapse above 1/25, only the certificates' own verdict and their reach below the line.
- **New: A28** (B_refined⁺, score the Galois layer) and **A29** (second reading of the J0a-free t ≤ a).
- **Unchanged and still the top risk**: Part E's realisability, and Part 0's completeness — which E.5 does *not* touch, since it bounds configurations inside the shape space and a missing shape is invisible to it exactly as it is to everything else.

## 4a. The ⟦PENDING-1E5-EXACT-RUN⟧ tag

`mu_exact.py` is running on to n = 100,000, so every distributional figure in the three core documents will move again. Rather than requote them twice, the range-scoped ones now carry **⟦PENDING-1E5-EXACT-RUN⟧** — 24 sites, defined in the status banner of each document and with the retirement procedure at `pending-checks` **R0b**.

**The tag means something different from ⟦PENDING-REBUILD⟧, and the distinction is the point.** A rebuild figure was *possibly wrong*: it was read off a table computed under a superseded cap. A 1E5 figure is *correct on the range it names* — the scope is what is stale, not the number. Conflating the two would either make the documents look more provisional than they are, or make a genuinely provisional figure look scoped.

`check_doc_figures.py --pass pending` supports the retirement: it inventories the tagged sites, recomputes at the current table the quantities the CSV can supply (and names the two it cannot — the orbital-count distribution, since t is not a column, and the certificate coverage counts, which are run outputs), flags **untagged** range-scoped aggregates, which is the class that goes stale silently, and reports when the frontier has passed 100,000. Currently: 24 sites, 0 untagged, tag live with 63,152 to go. The retirement branch is exercised against a synthetic table.

**One instruction inside R0b worth repeating here**: on arrival, compute the *minimum* first. The floor is 0.04621 against a threshold of 1/25, and if the extension turns up anything below 0.04 then Corollary E.6's hypothesis fails at that n and the collapse there reverts to the certificates — which would be the session's result partly unwinding, and is the one outcome worth knowing before anything else is requoted.

## 4b. The "distance to done" for the group theory, executed

The question was how far the framework is from carrying **no group theory per n** — from the group theory being discharged once, up front, so that the value of μ(n) at any given n is a configuration search over prime powers and factorisations of r − 1. The ledger says that above δ = 1/25 this already holds, resting on four finite claims: Lemma B′, Lemma D2, the enumerator's exclusions being dominations, and Part E's constructions being groups. Four items were owed to make that complete; all four were done this session.

1. **Equal foreign primes.** Writing the ledger surfaced a fourth instance of the shared-element-versus-subgroup error: three sites said two foreign parts of the same prime *cannot exist* (C_r × C_r not cyclic). They can — B′ Case 1 puts each orbit's translations inside the cyclic layer, so they share one diagonal C_r. They are *dominated*, by Lemma D2 with its permutation hypothesis dropped (the proof never used it). D2 widened, three sites and `fb_common.py` corrected; the enumerators were already sound, for the right reason now stated.
2. **Lemma B′, third reading.** Step 0, Case 1, Case 2 confirmed as written; the reading is what produced item 1.
3. **Part E at the two points that carry weight.** `build_shapes.py` builds the F = 4 class at n = 451 and the argmin n = 2759 as explicit permutations, machine-checks the chain, and computes every pair-orbital exactly. Both match term for term. **μ(2759) = 175813 is now realised by a group in hand.**
4. **The ladder as a lower bound.** `ladder_verify.py`'s scoring read in full: every emitted score is the REFINED score of an admissible configuration (skips or strips on r | c−1, `orb` shared with the enumerator, F/2 cross at even F, correct 2-adic efficiency rule), with two restrictions that only under-score. So ladder ≤ B_refined, which is what E.6 consumes.

**Where that leaves the reduction.** Above 1/25 — which is every n the ladder reaches and, conditionally on (BH-SW), almost every n — the group theory is *en route only*: it justifies the shape space once and is not consulted again. Below 1/25, μ is sandwiched between two arithmetic functions and the group theory decides which; that regime is conjecturally empty, and A28 would shrink even its interior possibility to J0a proper. J0a itself bears on nothing above the line.

## 5. One methodological note

Both of this session's results came from reading **script output as evidence about a bound**, not as a verdict on the values it was computed for. The two `wide_cert` survivors were filed as a B_lo deficiency and fixed as one; the fix was right and the filing lost the information that the two densities were 0.039994 and 0.039996. Likewise the validator's S7f3 trend FAIL was attributed in advance to a sensitivity limitation of the aggregate. **Whenever a check's failure is explained by a property of the check, the explanation should be tested against the data before it is written down.** Both times it was not, and both times the data were saying something.
