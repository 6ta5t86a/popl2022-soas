
-- Equational theory of partial differentiation
module PDiff.Equality where

open import SOAS.Common hiding (_×_)
open import SOAS.Context
open import SOAS.Variable
open import SOAS.Families.Core
open import SOAS.Families.Build
open import SOAS.ContextMaps.Inductive

open import PDiff.Signature
open import PDiff.Syntax

open import SOAS.Metatheory.SecondOrder.Metasubstitution PD:Syn
open import SOAS.Metatheory.SecondOrder.Equality PD:Syn
open import SOAS.Metatheory

open PD:Syntax
open import SOAS.Syntax.Shorthands PDᵃ

private
  variable
    α β γ τ : *T
    Γ Δ Π : Ctx

-- Axioms of rings and partial differentiation
data Axiom : (𝔐 : MCtx)(Γ : Ctx){α : *T} → (𝔐 ▷ PD) α Γ → (𝔐 ▷ PD) α Γ → Set where
  𝟘LU : Axiom (⊪ *) ∅ (𝟘 + 𝔞 ⟨⟩) (𝔞 ⟨⟩)
  𝟘RU : Axiom (⊪ *) ∅ (𝔞 ⟨⟩ + 𝟘) (𝔞 ⟨⟩)
  𝟘LA : Axiom (⊪ *) ∅ (𝟘 × 𝔞 ⟨⟩) (𝟘)
  +LI : Axiom (⊪ *) ∅ (– (𝔞 ⟨⟩) + 𝔞 ⟨⟩) (𝟘)
  +C : Axiom (⊩ * ≀ ⊪ *) ∅ (𝔞 ⟨⟩ + 𝔟 ⟨⟩) (𝔟 ⟨⟩ + 𝔞 ⟨⟩)
  +A : Axiom (⊩ * ≀ ⊩ * ≀ ⊪ *) ∅
        ((𝔞 ⟨⟩ + 𝔟 ⟨⟩) + 𝔠 ⟨⟩) (𝔞 ⟨⟩ + (𝔟 ⟨⟩ + 𝔠 ⟨⟩))
  𝟙LU : Axiom (⊪ *) ∅ (𝟙 × 𝔞 ⟨⟩) (𝔞 ⟨⟩)
  𝟙RU : Axiom (⊪ *) ∅ (𝔞 ⟨⟩ × 𝟙) (𝔞 ⟨⟩)
  ×C : Axiom (⊩ * ≀ ⊪ *) ∅ (𝔞 ⟨⟩ × 𝔟 ⟨⟩) (𝔟 ⟨⟩ × 𝔞 ⟨⟩)
  ×A : Axiom (⊩ * ≀ ⊩ * ≀ ⊪ *) ∅
        ((𝔞 ⟨⟩ × 𝔟 ⟨⟩) × 𝔠 ⟨⟩) (𝔞 ⟨⟩ × (𝔟 ⟨⟩ × 𝔠 ⟨⟩))
  LD : Axiom (⊩ * ≀ ⊩ * ≀ ⊪ *) ∅
          (𝔞 ⟨⟩ × (𝔟 ⟨⟩ + 𝔠 ⟨⟩)) ((𝔞 ⟨⟩ × 𝔟 ⟨⟩) + (𝔞 ⟨⟩ × 𝔠 ⟨⟩))
  RD : Axiom (⊩ * ≀ ⊩ * ≀ ⊪ *) ∅
          ((𝔞 ⟨⟩ + 𝔟 ⟨⟩) × 𝔠 ⟨⟩) ((𝔞 ⟨⟩ × 𝔠 ⟨⟩) + (𝔟 ⟨⟩ × 𝔠 ⟨⟩))

  ∂+ : Axiom (⊪ *) (⌊ * ⌋) (∂₀ (x₀ + 𝔞 ⟨⟩)) 𝟙
  ∂× : Axiom (⊪ *) (⌊ * ⌋) (∂₀ (𝔞 ⟨⟩ × x₀)) (𝔞 ⟨⟩)
  ∂com : Axiom (⌊ * ∙ * ⌋ ⊪ *) (⌊ * ∙ * ⌋)
    (∂₁ (∂₀ (𝔞 ⟨ x₀ ◂ x₁ ⟩)))
    (∂₀ (∂₁ (𝔞 ⟨ x₀ ◂ x₁ ⟩)))
  ∂CH₂ : Axiom (⌊ * ∙ * ⌋ ⊩ * ≀ ⌊ * ⌋ ⊩ * ≀ ⌊ * ⌋ ⊪ *) (⌊ * ⌋)
    (∂₀ (𝔞 ⟨ (𝔟 ⟨ x₀ ⟩) ◂ (𝔠 ⟨ x₀ ⟩) ⟩))
    ( (∂ (𝔞 ⟨ x₀ ◂ (𝔠 ⟨ x₁ ⟩) ⟩) ∣ 𝔟 ⟨ x₀ ⟩) × (∂₀ (𝔟 ⟨ x₀ ⟩))
    + (∂ (𝔞 ⟨ (𝔟 ⟨ x₁ ⟩) ◂ x₀ ⟩) ∣ 𝔠 ⟨ x₀ ⟩) × (∂₀ (𝔠 ⟨ x₀ ⟩)))

open EqLogic Axiom
open ≋-Reasoning

-- Derivative of a variable is 1
∂id : ◾ ▹ ⌊ * ⌋ ⊢ ∂₀ x₀ ≋ 𝟙
∂id = begin
      ∂₀ x₀      ≋⟨ cong[ ax 𝟘RU with《 x₀ 》 ]inside (∂₀ ◌) ⟩ₛ
      ∂₀ x₀ + 𝟘  ≋⟨ ax ∂+ with《 𝟘 》 ⟩
      𝟙          ∎

-- Right annihilation law
𝟘RA : ⊪ * ▹ ∅ ⊢ 𝔞 ⟨⟩ × 𝟘 ≋ 𝟘
𝟘RA = tr (ax ×C with《 𝔞 ⟨⟩ ◃ 𝟘 》) (ax 𝟘LA with《 𝔞 ⟨⟩ 》)

-- Derivative of 0 is 0
∂𝟘 : ◾ ▹ ⌊ * ⌋ ⊢ ∂₀ 𝟘 ≋ 𝟘
∂𝟘 = begin
      ∂₀ 𝟘         ≋⟨ cong[ ax 𝟘LA with《 x₀ 》 ]inside ∂₀ ◌ ⟩ₛ
      ∂₀ (𝟘 × x₀)  ≋⟨ ax ∂× with《 𝟘 》 ⟩
      𝟘            ∎

-- Unary chain rule
∂CH₁ : ⌊ * ⌋ ⊩ * ≀ ⌊ * ⌋ ⊪ * ▹ (⌊ * ⌋)
  ⊢ ∂₀ (𝔞 ⟨ (𝔟 ⟨ x₀ ⟩) ⟩)
  ≋ (∂ 𝔞 ⟨ x₀ ⟩ ∣ 𝔟 ⟨ x₀ ⟩) × (∂₀ 𝔟 ⟨ x₀ ⟩)
∂CH₁ = begin
      ∂₀ (𝔞 ⟨ (𝔟 ⟨ x₀ ⟩) ⟩)
  ≋⟨ ax  ∂CH₂ with《 𝔞 ⟨ x₀ ⟩ ◃ 𝔟 ⟨ x₀ ⟩ ◃ 𝟘 》 ⟩
      (∂ 𝔞 ⟨ x₀ ⟩ ∣ (𝔟 ⟨ x₀ ⟩)) × (∂₀ (𝔟 ⟨ x₀ ⟩))
    + (∂ 𝔞 ⟨ (𝔟 ⟨ x₁ ⟩) ⟩ ∣ 𝟘) × (∂₀ 𝟘)
  ≋⟨ cong[ thm ∂𝟘 ]inside (∂ ↑ 𝔞 ⟨ x₀ ⟩ ∣ (↑ 𝔟 ⟨ x₀ ⟩)) × (∂₀ (↑ 𝔟 ⟨ x₀ ⟩))
                          + (∂ ↑ 𝔞 ⟨ (↑ 𝔟 ⟨ x₁ ⟩) ⟩ ∣ 𝟘) × ◌ ⟩
      (∂ 𝔞 ⟨ x₀ ⟩ ∣ (𝔟 ⟨ x₀ ⟩)) × (∂₀ (𝔟 ⟨ x₀ ⟩))
    + (∂ 𝔞 ⟨ (𝔟 ⟨ x₁ ⟩) ⟩ ∣ 𝟘) × 𝟘
  ≋⟨ cong[ thm 𝟘RA with《 (∂ 𝔞 ⟨ (𝔟 ⟨ x₁ ⟩) ⟩ ∣ 𝟘) 》 ]inside (∂ ↑ 𝔞 ⟨ x₀ ⟩ ∣ (↑ 𝔟 ⟨ x₀ ⟩)) × (∂₀ (↑ 𝔟 ⟨ x₀ ⟩)) + ◌ ⟩
      (∂ (𝔞 ⟨ x₀ ⟩) ∣ (𝔟 ⟨ x₀ ⟩)) × (∂₀ (𝔟 ⟨ x₀ ⟩))
    + 𝟘
  ≋⟨ ax 𝟘RU with《 (∂ (𝔞 ⟨ x₀ ⟩) ∣ (𝔟 ⟨ x₀ ⟩)) × (∂₀ (𝔟 ⟨ x₀ ⟩)) 》 ⟩
      (∂ (𝔞 ⟨ x₀ ⟩) ∣ (𝔟 ⟨ x₀ ⟩)) × (∂₀ (𝔟 ⟨ x₀ ⟩))
  ∎
