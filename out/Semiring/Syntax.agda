{-
This second-order term syntax was created from the following second-order syntax description:

syntax Semiring | SR

type
  * : 0-ary

term
  zero : * | 𝟘
  add  : *  *  ->  * | _⊕_ l20
  one  : * | 𝟙
  mult : *  *  ->  * | _⊗_ l30

theory
  (𝟘U⊕ᴸ) a |> add (zero, a) = a
  (𝟘U⊕ᴿ) a |> add (a, zero) = a
  (⊕A) a b c |> add (add(a, b), c) = add (a, add(b, c))
  (⊕C) a b |> add(a, b) = add(b, a)
  (𝟙U⊗ᴸ) a |> mult (one, a) = a
  (𝟙U⊗ᴿ) a |> mult (a, one) = a
  (⊗A) a b c |> mult (mult(a, b), c) = mult (a, mult(b, c))
  (⊗D⊕ᴸ) a b c |> mult (a, add (b, c)) = add (mult(a, b), mult(a, c))
  (⊗D⊕ᴿ) a b c |> mult (add (a, b), c) = add (mult(a, c), mult(b, c))
  (𝟘X⊗ᴸ) a |> mult (zero, a) = zero
  (𝟘X⊗ᴿ) a |> mult (a, zero) = zero
-}


module Semiring.Syntax where

open import SOAS.Common
open import SOAS.Context
open import SOAS.Variable
open import SOAS.Families.Core
open import SOAS.Construction.Structure
open import SOAS.ContextMaps.Inductive

open import SOAS.Metatheory.Syntax

open import Semiring.Signature

private
  variable
    Γ Δ Π : Ctx
    α : *T
    𝔛 : Familyₛ

-- Inductive term declaration
module SR:Terms (𝔛 : Familyₛ) where

  data SR : Familyₛ where
    var  : ℐ ⇾̣ SR
    mvar : 𝔛 α Π → Sub SR Π Γ → SR α Γ

    𝟘   : SR * Γ
    _⊕_ : SR * Γ → SR * Γ → SR * Γ
    𝟙   : SR * Γ
    _⊗_ : SR * Γ → SR * Γ → SR * Γ

  infixl 20 _⊕_
  infixl 30 _⊗_

  open import SOAS.Metatheory.MetaAlgebra ⅀F 𝔛

  SRᵃ : MetaAlg SR
  SRᵃ = record
    { 𝑎𝑙𝑔 = λ where
      (zeroₒ ⅋ _)     → 𝟘
      (addₒ  ⅋ a , b) → _⊕_ a b
      (oneₒ  ⅋ _)     → 𝟙
      (multₒ ⅋ a , b) → _⊗_ a b
    ; 𝑣𝑎𝑟 = var ; 𝑚𝑣𝑎𝑟 = λ 𝔪 mε → mvar 𝔪 (tabulate mε) }

  module SRᵃ = MetaAlg SRᵃ

  module _ {𝒜 : Familyₛ}(𝒜ᵃ : MetaAlg 𝒜) where

    open MetaAlg 𝒜ᵃ

    𝕤𝕖𝕞 : SR ⇾̣ 𝒜
    𝕊 : Sub SR Π Γ → Π ~[ 𝒜 ]↝ Γ
    𝕊 (t ◂ σ) new = 𝕤𝕖𝕞 t
    𝕊 (t ◂ σ) (old v) = 𝕊 σ v
    𝕤𝕖𝕞 (mvar 𝔪 mε) = 𝑚𝑣𝑎𝑟 𝔪 (𝕊 mε)
    𝕤𝕖𝕞 (var v) = 𝑣𝑎𝑟 v

    𝕤𝕖𝕞  𝟘        = 𝑎𝑙𝑔 (zeroₒ ⅋ tt)
    𝕤𝕖𝕞 (_⊕_ a b) = 𝑎𝑙𝑔 (addₒ  ⅋ 𝕤𝕖𝕞 a , 𝕤𝕖𝕞 b)
    𝕤𝕖𝕞  𝟙        = 𝑎𝑙𝑔 (oneₒ  ⅋ tt)
    𝕤𝕖𝕞 (_⊗_ a b) = 𝑎𝑙𝑔 (multₒ ⅋ 𝕤𝕖𝕞 a , 𝕤𝕖𝕞 b)

    𝕤𝕖𝕞ᵃ⇒ : MetaAlg⇒ SRᵃ 𝒜ᵃ 𝕤𝕖𝕞
    𝕤𝕖𝕞ᵃ⇒ = record
      { ⟨𝑎𝑙𝑔⟩ = λ{ {t = t} → ⟨𝑎𝑙𝑔⟩ t }
      ; ⟨𝑣𝑎𝑟⟩ = refl
      ; ⟨𝑚𝑣𝑎𝑟⟩ = λ{ {𝔪 = 𝔪}{mε} → cong (𝑚𝑣𝑎𝑟 𝔪) (dext (𝕊-tab mε)) }  }
      where
      open ≡-Reasoning
      ⟨𝑎𝑙𝑔⟩ : (t : ⅀ SR α Γ) → 𝕤𝕖𝕞 (SRᵃ.𝑎𝑙𝑔 t) ≡ 𝑎𝑙𝑔 (⅀₁ 𝕤𝕖𝕞 t)
      ⟨𝑎𝑙𝑔⟩ (zeroₒ ⅋ _) = refl
      ⟨𝑎𝑙𝑔⟩ (addₒ  ⅋ _) = refl
      ⟨𝑎𝑙𝑔⟩ (oneₒ  ⅋ _) = refl
      ⟨𝑎𝑙𝑔⟩ (multₒ ⅋ _) = refl

      𝕊-tab : (mε : Π ~[ SR ]↝ Γ)(v : ℐ α Π) → 𝕊 (tabulate mε) v ≡ 𝕤𝕖𝕞 (mε v)
      𝕊-tab mε new = refl
      𝕊-tab mε (old v) = 𝕊-tab (mε ∘ old) v

    module _ (g : SR ⇾̣ 𝒜)(gᵃ⇒ : MetaAlg⇒ SRᵃ 𝒜ᵃ g) where

      open MetaAlg⇒ gᵃ⇒

      𝕤𝕖𝕞! : (t : SR α Γ) → 𝕤𝕖𝕞 t ≡ g t
      𝕊-ix : (mε : Sub SR Π Γ)(v : ℐ α Π) → 𝕊 mε v ≡ g (index mε v)
      𝕊-ix (x ◂ mε) new = 𝕤𝕖𝕞! x
      𝕊-ix (x ◂ mε) (old v) = 𝕊-ix mε v
      𝕤𝕖𝕞! (mvar 𝔪 mε) rewrite cong (𝑚𝑣𝑎𝑟 𝔪) (dext (𝕊-ix mε))
        = trans (sym ⟨𝑚𝑣𝑎𝑟⟩) (cong (g ∘ mvar 𝔪) (tab∘ix≈id mε))
      𝕤𝕖𝕞! (var v) = sym ⟨𝑣𝑎𝑟⟩

      𝕤𝕖𝕞! 𝟘 = sym ⟨𝑎𝑙𝑔⟩
      𝕤𝕖𝕞! (_⊕_ a b) rewrite 𝕤𝕖𝕞! a | 𝕤𝕖𝕞! b = sym ⟨𝑎𝑙𝑔⟩
      𝕤𝕖𝕞! 𝟙 = sym ⟨𝑎𝑙𝑔⟩
      𝕤𝕖𝕞! (_⊗_ a b) rewrite 𝕤𝕖𝕞! a | 𝕤𝕖𝕞! b = sym ⟨𝑎𝑙𝑔⟩


-- Syntax instance for the signature
SR:Syn : Syntax
SR:Syn = record
  { ⅀F = ⅀F
  ; ⅀:CS = ⅀:CompatStr
  ; mvarᵢ = SR:Terms.mvar
  ; 𝕋:Init = λ 𝔛 → let open SR:Terms 𝔛 in record
    { ⊥ = SR ⋉ SRᵃ
    ; ⊥-is-initial = record { ! = λ{ {𝒜 ⋉ 𝒜ᵃ} → 𝕤𝕖𝕞 𝒜ᵃ ⋉ 𝕤𝕖𝕞ᵃ⇒ 𝒜ᵃ }
    ; !-unique = λ{ {𝒜 ⋉ 𝒜ᵃ} (f ⋉ fᵃ⇒) {x = t} → 𝕤𝕖𝕞! 𝒜ᵃ f fᵃ⇒ t } } } }

-- Instantiation of the syntax and metatheory
open Syntax SR:Syn public
open SR:Terms public
open import SOAS.Families.Build public
open import SOAS.Syntax.Shorthands SRᵃ public
open import SOAS.Metatheory SR:Syn public
