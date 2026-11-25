/-
# `Bridge.lean` — the core-Lean primality predicate agrees with Mathlib's

`E5Core` states primality as `IsPrimeN p := 2 ≤ p ∧ ∀ d, d ∣ p → d = 1 ∨ d = p`, because core
Lean has no `Nat.Prime`.  This file proves the two agree, so that Mathlib-side code can supply
`Nat.Prime` hypotheses to `E5Core.lemma_E2`, `E5Core.e1_mersenne` and their relatives.  It is
route 1 of the README's Mathlib reconciliation ("import and bridge").
-/
import Mathlib
import E5Core

namespace ArkBridge

/-- `IsPrimeN` is literally Mathlib's `Nat.prime_def`, so the bridge is that lemma reversed.
    Should `Nat.prime_def` be renamed upstream, the fallback is `Nat.Prime.two_le` plus
    `Nat.Prime.eq_one_or_self_of_dvd` one way and `Nat.prime_def_lt` the other. -/
theorem isPrimeN_iff_prime (p : ℕ) : E5Core.IsPrimeN p ↔ Nat.Prime p :=
  Nat.prime_def.symm

theorem isPrimeN_of_prime {p : ℕ} (hp : Nat.Prime p) : E5Core.IsPrimeN p :=
  (isPrimeN_iff_prime p).mpr hp

theorem prime_of_isPrimeN {p : ℕ} (hp : E5Core.IsPrimeN p) : Nat.Prime p :=
  (isPrimeN_iff_prime p).mp hp

end ArkBridge
