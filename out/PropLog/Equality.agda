{-
This second-order equational theory was created from the following second-order syntax description:

syntax PropLog | PR

type
  * : 0-ary

term
  false : * | ⊥
  or    : *  *  ->  * | _∨_ l20
  true  : * | ⊤
  and   : *  *  ->  * | _∧_ l30
  not   : *  ->  * | ¬_ r50

theory
  (⊥U∨ᴸ) a |> or (false, a) = a
  (⊥U∨ᴿ) a |> or (a, false) = a
  (∨A) a b c |> or (or(a, b), c) = or (a, or(b, c))
  (∨C) a b |> or(a, b) = or(b, a)
  (⊤U∧ᴸ) a |> and (true, a) = a
  (⊤U∧ᴿ) a |> and (a, true) = a
  (∧A) a b c |> and (and(a, b), c) = and (a, and(b, c))
  (∧D∨ᴸ) a b c |> and (a, or (b, c)) = or (and(a, b), and(a, c))
  (∧D∨ᴿ) a b c |> and (or (a, b), c) = or (and(a, c), and(b, c))
  (⊥X∧ᴸ) a |> and (false, a) = false
  (⊥X∧ᴿ) a |> and (a, false) = false
  (¬N∨ᴸ) a |> or (not (a), a) = false
  (¬N∨ᴿ) a |> or (a, not (a)) = false
  (∧C) a b |> and(a, b) = and(b, a)
  (∨I) a |> or(a, a) = a
  (∧I) a |> and(a, a) = a
  (¬²) a |> not(not (a)) = a
  (∨D∧ᴸ) a b c |> or (a, and (b, c)) = and (or(a, b), or(a, c))
  (∨D∧ᴿ) a b c |> or (and (a, b), c) = and (or(a, c), or(b, c))
  (⊤X∨ᴸ) a |> or (true, a) = true
  (⊤X∨ᴿ) a |> or (a, true) = true
  (¬N∧ᴸ) a |> and (not (a), a) = false
  (¬N∧ᴿ) a |> and (a, not (a)) = false
  (DM∧) a b |> not (and (a, b)) = or (not(a), not(b))
  (DM∨) a b |> not (or (a, b)) = and (not(a), not(b))
-}

module PropLog.Equality where

open import SOAS.Common
open import SOAS.Context
open import SOAS.Variable
open import SOAS.Families.Core
open import SOAS.Families.Build
open import SOAS.ContextMaps.Inductive

open import PropLog.Signature
open import PropLog.Syntax

open import SOAS.Metatheory.SecondOrder.Metasubstitution PR:Syn
open import SOAS.Metatheory.SecondOrder.Equality PR:Syn

private
  variable
    α β γ τ : *T
    Γ Δ Π : Ctx

infix 1 _▹_⊢_≋ₐ_

-- Axioms of equality
data _▹_⊢_≋ₐ_ : ∀ 𝔐 Γ {α} → (𝔐 ▷ PR) α Γ → (𝔐 ▷ PR) α Γ → Set where
  ⊥U∨ᴸ : ⁅ * ⁆̣             ▹ ∅ ⊢       ⊥ ∨ 𝔞 ≋ₐ 𝔞
  ∨A   : ⁅ * ⁆ ⁅ * ⁆ ⁅ * ⁆̣ ▹ ∅ ⊢ (𝔞 ∨ 𝔟) ∨ 𝔠 ≋ₐ 𝔞 ∨ (𝔟 ∨ 𝔠)
  ∨C   : ⁅ * ⁆ ⁅ * ⁆̣       ▹ ∅ ⊢       𝔞 ∨ 𝔟 ≋ₐ 𝔟 ∨ 𝔞
  ⊤U∧ᴸ : ⁅ * ⁆̣             ▹ ∅ ⊢       ⊤ ∧ 𝔞 ≋ₐ 𝔞
  ∧A   : ⁅ * ⁆ ⁅ * ⁆ ⁅ * ⁆̣ ▹ ∅ ⊢ (𝔞 ∧ 𝔟) ∧ 𝔠 ≋ₐ 𝔞 ∧ (𝔟 ∧ 𝔠)
  ∧D∨ᴸ : ⁅ * ⁆ ⁅ * ⁆ ⁅ * ⁆̣ ▹ ∅ ⊢ 𝔞 ∧ (𝔟 ∨ 𝔠) ≋ₐ (𝔞 ∧ 𝔟) ∨ (𝔞 ∧ 𝔠)
  ⊥X∧ᴸ : ⁅ * ⁆̣             ▹ ∅ ⊢       ⊥ ∧ 𝔞 ≋ₐ ⊥
  ¬N∨ᴸ : ⁅ * ⁆̣             ▹ ∅ ⊢   (¬ 𝔞) ∨ 𝔞 ≋ₐ ⊥
  ∧C   : ⁅ * ⁆ ⁅ * ⁆̣       ▹ ∅ ⊢       𝔞 ∧ 𝔟 ≋ₐ 𝔟 ∧ 𝔞
  ∨I   : ⁅ * ⁆̣             ▹ ∅ ⊢       𝔞 ∨ 𝔞 ≋ₐ 𝔞
  ∧I   : ⁅ * ⁆̣             ▹ ∅ ⊢       𝔞 ∧ 𝔞 ≋ₐ 𝔞
  ¬²   : ⁅ * ⁆̣             ▹ ∅ ⊢     ¬ (¬ 𝔞) ≋ₐ 𝔞
  ∨D∧ᴸ : ⁅ * ⁆ ⁅ * ⁆ ⁅ * ⁆̣ ▹ ∅ ⊢ 𝔞 ∨ (𝔟 ∧ 𝔠) ≋ₐ (𝔞 ∨ 𝔟) ∧ (𝔞 ∨ 𝔠)
  ⊤X∨ᴸ : ⁅ * ⁆̣             ▹ ∅ ⊢       ⊤ ∨ 𝔞 ≋ₐ ⊤
  ¬N∧ᴸ : ⁅ * ⁆̣             ▹ ∅ ⊢   (¬ 𝔞) ∧ 𝔞 ≋ₐ ⊥
  DM∧  : ⁅ * ⁆ ⁅ * ⁆̣       ▹ ∅ ⊢   ¬ (𝔞 ∧ 𝔟) ≋ₐ (¬ 𝔞) ∨ (¬ 𝔟)
  DM∨  : ⁅ * ⁆ ⁅ * ⁆̣       ▹ ∅ ⊢   ¬ (𝔞 ∨ 𝔟) ≋ₐ (¬ 𝔞) ∧ (¬ 𝔟)

open EqLogic _▹_⊢_≋ₐ_
open ≋-Reasoning

-- Derived equations
⊥U∨ᴿ : ⁅ * ⁆̣ ▹ ∅ ⊢ 𝔞 ∨ ⊥ ≋ 𝔞
⊥U∨ᴿ = tr (ax ∨C with《 𝔞 ◃ ⊥ 》) (ax ⊥U∨ᴸ with《 𝔞 》)
⊤U∧ᴿ : ⁅ * ⁆̣ ▹ ∅ ⊢ 𝔞 ∧ ⊤ ≋ 𝔞
⊤U∧ᴿ = tr (ax ∧C with《 𝔞 ◃ ⊤ 》) (ax ⊤U∧ᴸ with《 𝔞 》)
∧D∨ᴿ : ⁅ * ⁆ ⁅ * ⁆ ⁅ * ⁆̣ ▹ ∅ ⊢ (𝔞 ∨ 𝔟) ∧ 𝔠 ≋ (𝔞 ∧ 𝔠) ∨ (𝔟 ∧ 𝔠)
∧D∨ᴿ = begin
  (𝔞 ∨ 𝔟) ∧ 𝔠       ≋⟨ ax ∧C with《 𝔞 ∨ 𝔟 ◃ 𝔠 》 ⟩
  𝔠 ∧ (𝔞 ∨ 𝔟)       ≋⟨ ax ∧D∨ᴸ with《 𝔠 ◃ 𝔞 ◃ 𝔟 》 ⟩
  (𝔠 ∧ 𝔞) ∨ (𝔠 ∧ 𝔟)  ≋⟨ cong₂[ ax ∧C with《 𝔠 ◃ 𝔞 》 ][ ax ∧C with《 𝔠 ◃ 𝔟 》 ]inside ◌ᵈ ∨ ◌ᵉ ⟩
  (𝔞 ∧ 𝔠) ∨ (𝔟 ∧ 𝔠)  ∎
⊥X∧ᴿ : ⁅ * ⁆̣ ▹ ∅ ⊢ 𝔞 ∧ ⊥ ≋ ⊥
⊥X∧ᴿ = tr (ax ∧C with《 𝔞 ◃ ⊥ 》) (ax ⊥X∧ᴸ with《 𝔞 》)
¬N∨ᴿ : ⁅ * ⁆̣ ▹ ∅ ⊢ 𝔞 ∨ (¬ 𝔞) ≋ ⊥
¬N∨ᴿ = tr (ax ∨C with《 𝔞 ◃ (¬ 𝔞) 》) (ax ¬N∨ᴸ with《 𝔞 》)
∨D∧ᴿ : ⁅ * ⁆ ⁅ * ⁆ ⁅ * ⁆̣ ▹ ∅ ⊢ (𝔞 ∧ 𝔟) ∨ 𝔠 ≋ (𝔞 ∨ 𝔠) ∧ (𝔟 ∨ 𝔠)
∨D∧ᴿ = begin
  (𝔞 ∧ 𝔟) ∨ 𝔠       ≋⟨ ax ∨C with《 𝔞 ∧ 𝔟 ◃ 𝔠 》 ⟩
  𝔠 ∨ (𝔞 ∧ 𝔟)       ≋⟨ ax ∨D∧ᴸ with《 𝔠 ◃ 𝔞 ◃ 𝔟 》 ⟩
  (𝔠 ∨ 𝔞) ∧ (𝔠 ∨ 𝔟)  ≋⟨ cong₂[ ax ∨C with《 𝔠 ◃ 𝔞 》 ][ ax ∨C with《 𝔠 ◃ 𝔟 》 ]inside ◌ᵈ ∧ ◌ᵉ ⟩
  (𝔞 ∨ 𝔠) ∧ (𝔟 ∨ 𝔠)  ∎
⊤X∨ᴿ : ⁅ * ⁆̣ ▹ ∅ ⊢ 𝔞 ∨ ⊤ ≋ ⊤
⊤X∨ᴿ = tr (ax ∨C with《 𝔞 ◃ ⊤ 》) (ax ⊤X∨ᴸ with《 𝔞 》)
¬N∧ᴿ : ⁅ * ⁆̣ ▹ ∅ ⊢ 𝔞 ∧ (¬ 𝔞) ≋ ⊥
¬N∧ᴿ = tr (ax ∧C with《 𝔞 ◃ (¬ 𝔞) 》) (ax ¬N∧ᴸ with《 𝔞 》)
