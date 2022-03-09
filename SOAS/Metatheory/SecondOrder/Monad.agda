
open import SOAS.Metatheory.Syntax

-- Term monad
module SOAS.Metatheory.SecondOrder.Monad {T : Set}(Syn : Syntax {T}) where

open Syntax Syn

open import SOAS.Metatheory.FreeMonoid Syn
open import SOAS.Metatheory.TermFunctor Syn
open import SOAS.Metatheory.SecondOrder.Strength Syn

open import SOAS.Common
open import SOAS.Families.Core {T}
open import SOAS.Context
open import SOAS.Variable
open import SOAS.Construction.Structure

import SOAS.Abstract.Coalgebra as →□ ; open →□.Sorted

open import Categories.Monad

open import SOAS.Metatheory Syn

open import SOAS.Linear.Exponential
open import SOAS.Linear.Tensor
open import SOAS.Linear.Strength
open import SOAS.Linear.Distributor

open Theory hiding (runit)

private
  variable
    X Y Z : Family
    𝒳 𝒴 𝒵 ℳ : Familyₛ
    Γ Δ Θ Ξ : Ctx
    α τ : T

-- A Σ-monoid ℳ is a 𝕋-algebra - it absorbs the term functor
module Absorb (Σℳᵐ : ΣMon ℳ) where
  open FΣM ℳ Σℳᵐ id public

  𝕒𝕓𝕤 : 𝕋 ℳ ⇾̣ ℳ
  𝕒𝕓𝕤 = 𝕖𝕩𝕥

  𝕒𝕓𝕤ᵇ⇒ : Coalg⇒ (𝕋ᵇ ℳ) ᵇ 𝕒𝕓𝕤
  𝕒𝕓𝕤ᵇ⇒ = 𝕖𝕩𝕥ᵇ⇒

  𝕒𝕓𝕤ᵃ⇒ : SynAlg⇒ ℳ (𝕋ᵃ ℳ) ℳᵃ 𝕒𝕓𝕤
  𝕒𝕓𝕤ᵃ⇒ = 𝕤𝕖𝕞ᵃ⇒

-- 𝕋 𝒳 is a 𝕋-algebra with 𝕛𝕠𝕚𝕟 as the algebra map
module Join 𝒳 = Absorb (Σ𝕋ᵐ 𝒳)
𝕛𝕠𝕚𝕟 : 𝕋 (𝕋 𝒳) ⇾̣ 𝕋 𝒳
𝕛𝕠𝕚𝕟 {𝒳} = Join.𝕒𝕓𝕤 𝒳

𝕛𝕠𝕚𝕟ᵇ⇒ : Coalg⇒ (𝕋ᵇ (𝕋 𝒳)) (𝕋ᵇ 𝒳) 𝕛𝕠𝕚𝕟
𝕛𝕠𝕚𝕟ᵇ⇒ {𝒳} = 𝕤𝕖𝕞ᵇ⇒ (𝕋 𝒳) (𝕋ᵇ 𝒳) (record { 𝑎𝑙𝑔 = 𝕒𝕝𝕘 𝒳 ; 𝑣𝑎𝑟 = 𝕧𝕒𝕣 𝒳 ; 𝑚𝑣𝑎𝑟 = λ 𝔪 ε → 𝕤𝕦𝕓 𝒳 𝔪 ε }) (record
    { ⟨𝑎𝑙𝑔⟩ = λ{ {t = t} → Renaming.⟨𝕒⟩ 𝒳}
    ; ⟨𝑣𝑎𝑟⟩ = λ{ {v = v} → Renaming.⟨𝕧⟩ 𝒳 }
    ; ⟨𝑚𝑣𝑎𝑟⟩ = λ{ {𝔪 = t}{ε} → dext λ ρ → 𝕤𝕦𝕓ᶜ.r∘f 𝒳 } })
    where open ≡-Reasoning

𝕛𝕠𝕚𝕟-nat : (f : 𝒳 ⇾̣ 𝒴)(t : 𝕋 (𝕋 𝒳) α Γ) → 𝕛𝕠𝕚𝕟 (𝕋₁ (𝕋₁ f) t) ≡ 𝕋₁ f (𝕛𝕠𝕚𝕟 t)
𝕛𝕠𝕚𝕟-nat f t = μ.commute f where open Monad ΣMon:Monad

module _ (Σℳᵐ : ΣMon ℳ) where
  open Absorb Σℳᵐ

  -- Generalisation of the monad associativity law
  --              𝕛𝕠𝕚𝕟             𝕒𝕓𝕤
  --  𝕋 (𝕋 ℳ) ────────── 𝕋 ℳ ────────── ℳ
  --      ╰────────────── 𝕋 ℳ ───────────╯
  --           𝕋 𝕒𝕓𝕤               𝕒𝕓𝕤
  --
  𝕒𝕓𝕤∘𝕛𝕠𝕚𝕟≈ : MapEq₀ (𝕋 ℳ) ℳ (𝕒𝕓𝕤 ∘ 𝕛𝕠𝕚𝕟) (𝕒𝕓𝕤 ∘ 𝕋₁ 𝕒𝕓𝕤)
  𝕒𝕓𝕤∘𝕛𝕠𝕚𝕟≈ = record
    { ᵃ = record { 𝑎𝑙𝑔 = ℳ𝑎𝑙𝑔 ; 𝑣𝑎𝑟 = η ; 𝑚𝑣𝑎𝑟 = μ ∘ 𝕒𝕓𝕤 }
    ; f⟨𝑣⟩ = λ{ {x = v} → begin
          𝕒𝕓𝕤 (𝕛𝕠𝕚𝕟 (𝕧𝕒𝕣 (𝕋 ℳ) v))   ≡⟨ cong 𝕒𝕓𝕤 (Join.⟨𝕧⟩ ℳ) ⟩
          𝕒𝕓𝕤 (𝕧𝕒𝕣 ℳ v)             ≡⟨ Absorb.⟨𝕧⟩ Σℳᵐ ⟩
          η v
      ∎ }
    ; f⟨𝑚⟩ = λ{ {𝔪 = t}{ε} → begin
          𝕒𝕓𝕤 (𝕛𝕠𝕚𝕟 (𝕞𝕧𝕒𝕣 (𝕋 ℳ) t ε)) ≡⟨ cong 𝕒𝕓𝕤 (Join.⟨𝕞⟩ ℳ) ⟩
          𝕒𝕓𝕤 (𝕤𝕦𝕓 ℳ t (𝕛𝕠𝕚𝕟 ∘ ε))    ≡⟨ Absorb.𝕖𝕩𝕥ᵐ⇒.⟨μ⟩ Σℳᵐ ⟩
          μ (𝕒𝕓𝕤 t) (𝕒𝕓𝕤 ∘ 𝕛𝕠𝕚𝕟 ∘ ε)
      ∎ }
    ; f⟨𝑎⟩ = λ{ {t = t} → begin
          𝕒𝕓𝕤 (𝕛𝕠𝕚𝕟 (𝕒𝕝𝕘 (𝕋 ℳ) t))   ≡⟨ cong 𝕒𝕓𝕤 (Join.⟨𝕒⟩ ℳ) ⟩
          𝕒𝕓𝕤 (𝕒𝕝𝕘 ℳ (⅀₁ 𝕛𝕠𝕚𝕟 t))   ≡⟨ Absorb.⟨𝕒⟩ Σℳᵐ ⟩
          ℳ𝑎𝑙𝑔 (⅀₁ 𝕒𝕓𝕤 (⅀₁ 𝕛𝕠𝕚𝕟 t))  ≡˘⟨ cong ℳ𝑎𝑙𝑔 ⅀.homomorphism ⟩
          ℳ𝑎𝑙𝑔 (⅀₁ (𝕒𝕓𝕤 ∘ 𝕛𝕠𝕚𝕟) t)
      ∎ }
    ; g⟨𝑣⟩ = λ{ {x = v} → begin
          𝕒𝕓𝕤 (𝕋₁ 𝕒𝕓𝕤 (𝕧𝕒𝕣 (𝕋 ℳ) v)) ≡⟨ cong 𝕒𝕓𝕤 (𝕧𝕒𝕣-nat 𝕒𝕓𝕤 v) ⟩
          𝕒𝕓𝕤 (𝕧𝕒𝕣 ℳ v)             ≡⟨ Absorb.⟨𝕧⟩ Σℳᵐ ⟩
          η v
      ∎ }
    ; g⟨𝑚⟩ = λ{ {𝔪 = t}{ε} → begin
          𝕒𝕓𝕤 (𝕋₁ 𝕒𝕓𝕤 (𝕞𝕧𝕒𝕣 (𝕋 ℳ) t ε))       ≡⟨ cong 𝕒𝕓𝕤 (𝕞𝕧𝕒𝕣-nat 𝕒𝕓𝕤 t ε) ⟩
          𝕒𝕓𝕤 (𝕞𝕧𝕒𝕣 ℳ (𝕒𝕓𝕤 t) (𝕋₁ 𝕒𝕓𝕤 ∘ ε))   ≡⟨ Absorb.⟨𝕞⟩ Σℳᵐ ⟩
          μ (𝕒𝕓𝕤 t) (𝕒𝕓𝕤 ∘ 𝕋₁ 𝕒𝕓𝕤 ∘ ε)
      ∎ }
    ; g⟨𝑎⟩ = λ{ {t = t} → begin
          𝕒𝕓𝕤 (𝕋₁ 𝕒𝕓𝕤 (𝕒𝕝𝕘 (𝕋 ℳ) t))     ≡⟨ cong 𝕒𝕓𝕤 (𝕒𝕝𝕘-nat 𝕒𝕓𝕤 t) ⟩
          𝕒𝕓𝕤 (𝕒𝕝𝕘 ℳ (⅀₁ (𝕋₁ 𝕒𝕓𝕤) t))   ≡⟨ Absorb.⟨𝕒⟩ Σℳᵐ ⟩
          ℳ𝑎𝑙𝑔 (⅀₁ 𝕒𝕓𝕤 (⅀₁ (𝕋₁ 𝕒𝕓𝕤) t))  ≡˘⟨ cong ℳ𝑎𝑙𝑔 ⅀.homomorphism ⟩
          ℳ𝑎𝑙𝑔 (⅀₁ (𝕒𝕓𝕤 ∘ (𝕋₁ 𝕒𝕓𝕤)) t)
      ∎ }
    }
    where
    open ≡-Reasoning
    module 𝕛𝕠𝕚𝕟 = SynAlg⇒ (𝕋 ℳ) (Join.𝕒𝕓𝕤ᵃ⇒ ℳ)

  𝕒𝕓𝕤∘𝕛𝕠𝕚𝕟 : (t : 𝕋 (𝕋 ℳ) α Γ)
         → 𝕒𝕓𝕤 (𝕛𝕠𝕚𝕟 t) ≡ 𝕒𝕓𝕤 (𝕋₁ 𝕒𝕓𝕤 t)
  𝕒𝕓𝕤∘𝕛𝕠𝕚𝕟  t = MapEq₀.≈ (𝕋 ℳ) 𝕒𝕓𝕤∘𝕛𝕠𝕚𝕟≈ t

  -- Absorption and unit
  --       𝕦𝕟𝕚𝕥          𝕒𝕓𝕤
  --   ℳ ─────── 𝕋 ℳ ────── ℳ
  --    ╚════════════════════╝
  --              id
  --
  𝕒𝕓𝕤∘𝕦𝕟𝕚𝕥 : (m : ℳ α Γ) → 𝕒𝕓𝕤 (𝕦𝕟𝕚𝕥 m) ≡ m
  𝕒𝕓𝕤∘𝕦𝕟𝕚𝕥 m = begin
        𝕒𝕓𝕤 (𝕦𝕟𝕚𝕥 m)             ≡⟨⟩
        𝕒𝕓𝕤 (𝕞𝕧𝕒𝕣 ℳ m (𝕧𝕒𝕣 ℳ))  ≡⟨ Absorb.⟨𝕞⟩ Σℳᵐ ⟩
        μ m (𝕒𝕓𝕤 ∘ 𝕧𝕒𝕣 ℳ)       ≡⟨ μ≈₂ (Absorb.⟨𝕧⟩ Σℳᵐ) ⟩
        μ m η                   ≡⟨ runit ⟩
        m                       ∎ where open ≡-Reasoning

-- | Monad laws

--                 𝕛𝕠𝕚𝕟               𝕒𝕓𝕤
--  𝕋 (𝕋 (𝕋 𝒳)) ──────── 𝕋 (𝕋 𝒳) ────────── (𝕋 𝒳)
--       ╰────────────── 𝕋 (𝕋 𝒳) ─────────────╯
--             𝕋 𝕒𝕓𝕤                 𝕒𝕓𝕤
--
𝕛𝕠𝕚𝕟∘𝕛𝕠𝕚𝕟 : (t : 𝕋 (𝕋 (𝕋 𝒳)) α Γ)
       → 𝕛𝕠𝕚𝕟 (𝕛𝕠𝕚𝕟 t) ≡ 𝕛𝕠𝕚𝕟 (𝕋₁ 𝕛𝕠𝕚𝕟 t)
𝕛𝕠𝕚𝕟∘𝕛𝕠𝕚𝕟 {𝒳} t = 𝕒𝕓𝕤∘𝕛𝕠𝕚𝕟 (Σ𝕋ᵐ 𝒳) t

--         𝕦𝕟𝕚𝕥             𝕛𝕠𝕚𝕟
--   𝕋 𝒳 ────── 𝕋 (𝕋 𝒳) ────── 𝕋 𝒳
--    ╚═════════════════════════╝
--                id
--
𝕛𝕠𝕚𝕟∘𝕦𝕟𝕚𝕥 : (t : 𝕋 𝒳 α Γ) → 𝕛𝕠𝕚𝕟 (𝕦𝕟𝕚𝕥 t) ≡ t
𝕛𝕠𝕚𝕟∘𝕦𝕟𝕚𝕥 {𝒳} t = 𝕒𝕓𝕤∘𝕦𝕟𝕚𝕥 (Σ𝕋ᵐ 𝒳) t

--        𝕋 𝕦𝕟𝕚𝕥            𝕛𝕠𝕚𝕟
--   𝕋 𝒳 ─────── 𝕋 (𝕋 𝒳) ────── 𝕋 𝒳
--    ╚══════════════════════════╝
--                  id
--
𝕛𝕠𝕚𝕟∘𝕋𝕦𝕟𝕚𝕥 : (t : 𝕋 𝒳 α Γ) → 𝕛𝕠𝕚𝕟 (𝕋₁ 𝕦𝕟𝕚𝕥 t) ≡ t
𝕛𝕠𝕚𝕟∘𝕋𝕦𝕟𝕚𝕥 t = Monad.identityˡ ΣMon:Monad
