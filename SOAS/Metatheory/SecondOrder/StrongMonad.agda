
open import SOAS.Metatheory.Syntax

-- Strong monad of terms
module SOAS.Metatheory.SecondOrder.StrongMonad {T : Set}(Syn : Syntax {T}) where

open Syntax Syn

open import SOAS.Metatheory.FreeMonoid Syn
open import SOAS.Metatheory.TermFunctor Syn
open import SOAS.Metatheory.SecondOrder.Strength Syn
open import SOAS.Metatheory.SecondOrder.Monad Syn

open import SOAS.Common
open import SOAS.Families.Core {T}
open import SOAS.Context
open import SOAS.Variable
open import SOAS.Construction.Structure
open import SOAS.ContextMaps.Combinators
open import SOAS.ContextMaps.CategoryOfRenamings
open import SOAS.ContextMaps.Properties

open import SOAS.Abstract.Hom
open import SOAS.Abstract.Monoid

import SOAS.Abstract.Coalgebra as →□
open →□.Sorted
open →□.Unsorted using (⊤ᵇ) renaming (Coalg to UCoalg ; Coalg⇒ to UCoalg⇒ ; □ᵇ to □ᵘᵇ)
import SOAS.Abstract.Box as □ ; open □.Sorted

-- open import Categories.Monad

-- open import SOAS.Coalgebraic.Monoid
-- open import SOAS.Coalgebraic.Map

-- open import SOAS.Metatheory.Coalgebraic
open import SOAS.Metatheory Syn

open import SOAS.Linear.Exponential
open import SOAS.Linear.Tensor
open import SOAS.Linear.Strength
open import SOAS.Linear.Distributor

open Theory
-- using (𝕋 ; SynAlg ; SynAlg⇒ ; module Semantics ; 𝕋ᵇ ; 𝕋ᵃ ; 𝕋ᵐ ; 𝕣𝕖𝕟 ; 𝕤𝕖𝕞ᵇ⇒)

private
  variable
    X Y Z : Family
    𝒳 𝒴 𝒵 : Familyₛ
    Γ Δ Θ Ξ : Ctx
    α τ : T

-- Compatibility of strength and substitution
--                   𝕤𝕦𝕓                                        〖id, 𝕝𝕤𝕥𝕣〗
--  𝕋 (X ⊸ 𝒴) ─────────────── 〖 𝕋 (X ⊸ 𝒴) , 𝕋 (X ⊸ 𝒴) 〗 ─────────────────── 〖 𝕋 (X ⊸ 𝒴) , X ⊸ 𝕋 𝒴 〗
--       ╰───── X ⊸ 𝕋 𝒴 ────────  X ⊸ 〖 𝕋 𝒴 , 𝕋 𝒴 〗 ─────── 〖 X ⊸ 𝕋 𝒴 , X ⊸ 𝕋 𝒴 〗 ───────────╯
--         𝕝𝕤𝕥𝕣            X ⊸ 𝕤𝕦𝕓                       dist                            〖𝕝𝕤𝕥𝕣, id〗
--
𝕝𝕤𝕥𝕣∘𝕤𝕦𝕓≈ : MapEq₁ (X ⊸ 𝒴) {𝒜 = X ⊸ 𝕋 𝒴}  (𝕋ᴮ (X ⊸ 𝒴)) (λ t x → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) t x))
  (λ t σ x → 𝕝𝕤𝕥𝕣 (𝕤𝕦𝕓 (X ⊸ 𝒴) t σ) x)
  (λ t σ x → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 t) (𝕝𝕤𝕥𝕣 ∘ σ) x)
𝕝𝕤𝕥𝕣∘𝕤𝕦𝕓≈ {X}{𝒴} = record
  { φ = 𝕝𝕤𝕥𝕣
  ; χ = λ l ε x → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → 𝕞𝕧𝕒𝕣 𝒴 (l x)) ε x
  ; f⟨𝑣⟩ = λ{ {σ = σ}{v} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕤𝕦𝕓 (X ⊸ 𝒴) (𝕧𝕒𝕣 (X ⊸ 𝒴) v) σ) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (Substitution.𝕥⟨𝕧⟩ (X ⊸ 𝒴)) ⟩
        𝕝𝕤𝕥𝕣 (σ v) x
    ∎ }
  ; f⟨𝑚⟩ = λ{ {σ = σ}{l}{ε} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕤𝕦𝕓 (X ⊸ 𝒴) (𝕞𝕧𝕒𝕣 (X ⊸ 𝒴) l ε) σ) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (Substitution.𝕥⟨𝕞⟩ (X ⊸ 𝒴)) ⟩
        𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (X ⊸ 𝒴) l (λ v → 𝕤𝕦𝕓 (X ⊸ 𝒴) (ε v) σ)) x
    ≡⟨ cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕞⟩ {𝔪 = l} {ε = (λ v → 𝕤𝕦𝕓 (X ⊸ 𝒴) (ε v) σ)}) ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → 𝕞𝕧𝕒𝕣 𝒴 (l x)) (λ p → 𝕝𝕤𝕥𝕣 (𝕤𝕦𝕓 (X ⊸ 𝒴) (ε p) σ)) x
    ∎ }
  ; f⟨𝑎⟩ = λ{ {σ = σ}{t} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕤𝕦𝕓 (X ⊸ 𝒴) (𝕒𝕝𝕘 (X ⊸ 𝒴) t) σ) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (Substitution.𝕥⟨𝕒⟩ (X ⊸ 𝒴)) ⟩
        𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ 𝒴) (str (𝕋ᴮ (X ⊸ 𝒴)) (𝕋 (X ⊸ 𝒴)) (⅀₁ (𝕤𝕦𝕓 (X ⊸ 𝒴)) t) σ)) x
    ≡⟨ cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕒⟩ {t = (str (𝕋ᴮ (X ⊸ 𝒴)) (𝕋 (X ⊸ 𝒴)) (⅀₁ (𝕤𝕦𝕓 (X ⊸ 𝒴)) t) σ)}) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 (str (𝕋ᴮ (X ⊸ 𝒴)) (𝕋 (X ⊸ 𝒴)) (⅀₁ (𝕤𝕦𝕓 (X ⊸ 𝒴)) t) σ)) x)
    ≡˘⟨ cong (𝕒𝕝𝕘 𝒴) (lstr≈₁ (str-nat₂ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕤𝕦𝕓 (X ⊸ 𝒴)) t) σ)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (𝕋ᴮ (X ⊸ 𝒴)) (X ⊸ 𝕋 𝒴) (⅀₁ (λ{ h σ → 𝕝𝕤𝕥𝕣 (h σ)}) (⅀₁ (𝕤𝕦𝕓 (X ⊸ 𝒴)) t)) σ) x)
    ≡˘⟨ congr ⅀.homomorphism (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (𝕋ᴮ (X ⊸ 𝒴)) (X ⊸ 𝕋 𝒴) - σ) x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (𝕋ᴮ (X ⊸ 𝒴)) (X ⊸ 𝕋 𝒴) (⅀₁ (λ{ t σ → 𝕝𝕤𝕥𝕣 (𝕤𝕦𝕓 (X ⊸ 𝒴) t σ) }) t) σ) x)
    ∎ }
  ; g⟨𝑣⟩ = λ{ {σ = σ}{v} → dext λ x → begin
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ 𝒴) v)) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨ Substitution.𝕥≈₁ 𝒴 (cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕧⟩ {v = v})) ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → 𝕤𝕦𝕓 𝒴 (𝕧𝕒𝕣 𝒴 (inl _ v))) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨ Substitution.𝕥⟨𝕧⟩ 𝒴 ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x σ → σ (inl _ v)) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨⟩
        copair (𝕋 𝒴) (λ v → 𝕝𝕤𝕥𝕣 (σ v) x) (𝕧𝕒𝕣 𝒴 ∘ inr _) (inl _ v)
    ≡⟨ copair∘inl (𝕋 𝒴) v ⟩
        𝕝𝕤𝕥𝕣 (σ v) x
    ∎ }
    -- https://tinyurl.com/yansqvgw
  ; g⟨𝑚⟩ = λ{ {σ = σ}{l}{ε} → dext λ x → begin
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (X ⊸ 𝒴) l ε)) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨ Substitution.𝕥≈₁ 𝒴 (cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕞⟩ {𝔪 = l}{ε})) ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → 𝕤𝕦𝕓 𝒴 (dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ l) (𝕝𝕤𝕥𝕣 ∘ ε) x)) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → dist X (𝕧𝕒𝕣 𝒴) 〖 𝕋 𝒴 , 𝕋 𝒴 〗 (λ x ε → 𝕤𝕦𝕓 𝒴 (𝕞𝕧𝕒𝕣 𝒴 (l x) ε)) (𝕝𝕤𝕥𝕣 ∘ ε) x) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨ Substitution.𝕥⟨𝕞⟩ 𝒴 ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → dist X (𝕧𝕒𝕣 𝒴) 〖 𝕋 𝒴 , 𝕋 𝒴 〗 (λ x ε σ → 𝕞𝕧𝕒𝕣 𝒴 (l x) (λ v → 𝕤𝕦𝕓 𝒴 (ε v) σ)) (𝕝𝕤𝕥𝕣 ∘ ε) x) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨⟩
        dist X (𝕧𝕒𝕣 𝒴) 〖 𝕋 𝒴 , 𝕋 𝒴 〗 (λ x ε σ → 𝕞𝕧𝕒𝕣 𝒴 (l x) (λ v → 𝕤𝕦𝕓 𝒴 (ε v) σ)) (𝕝𝕤𝕥𝕣 ∘ ε) x (copair (𝕋 𝒴) (λ v → 𝕝𝕤𝕥𝕣 (σ v) x) (𝕧𝕒𝕣 𝒴 ∘ inr _))
    ≡˘⟨ congr (dist-nat₂ X (𝕧𝕒𝕣 𝒴) (j (𝕋 𝒴)) 〖 𝕋 𝒴 , 𝕋 𝒴 〗 (𝕤𝕦𝕓 𝒴) (λ v → Substitution.⟨𝕧⟩ 𝒴) (λ x σ ε → 𝕞𝕧𝕒𝕣 𝒴 (l x) (λ v → σ v ε)) (𝕝𝕤𝕥𝕣 ∘ ε) x) (λ - → - (copair (𝕋 𝒴) (λ v → 𝕝𝕤𝕥𝕣 (σ v) x) (𝕧𝕒𝕣 𝒴 ∘ inr _))) ⟩
        dist {𝒴 = 〖 𝕋 𝒴 , 𝕋 𝒴 〗} X (j (𝕋 𝒴)) 〖 𝕋 𝒴 , 𝕋 𝒴 〗 ((λ x σ ε → 𝕞𝕧𝕒𝕣 𝒴 (l x) (λ v → σ v ε))) (λ p x → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 (ε p) x)) x (copair (𝕋 𝒴) (λ v → 𝕝𝕤𝕥𝕣 (σ v) x) (𝕧𝕒𝕣 𝒴 ∘ inr _))
    ≡⟨⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → dist {𝒴 = 〖 𝕋 𝒴 , 𝕋 𝒴 〗} X (j (𝕋 𝒴)) (〖 𝕋 𝒴 , 𝕋 𝒴 〗) (λ x σ ε → 𝕞𝕧𝕒𝕣 𝒴 (l x) (λ v → σ v ε)) (λ p x → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 (ε p) x)) x) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨ dist-L {𝒵 = 𝕋 𝒴} (𝕞𝕧𝕒𝕣 𝒴 ∘ l) (𝕧𝕒𝕣 𝒴) id (λ p x → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 (ε p) x)) (𝕝𝕤𝕥𝕣 ∘ σ) x ⟩
        L (X ⊸ 𝕋 𝒴) (X ⊸ 𝕋 𝒴) (X ⊸ 𝕋 𝒴) (dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ l)) (λ p → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 (ε p))) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ l) (λ p → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 (ε p)) (𝕝𝕤𝕥𝕣 ∘ σ)) x
    ∎ }
  -- https://tinyurl.com/yc2z47jp
  ; g⟨𝑎⟩ = λ{ {σ = σ}{t} → dext λ x → begin
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ 𝒴) t)) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨ Substitution.𝕥≈₁ 𝒴 (cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕒⟩ {t = t})) ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → 𝕤𝕦𝕓 𝒴 (𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) x))) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨ Substitution.𝕥⟨𝕒⟩ 𝒴 ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x σ → 𝕒𝕝𝕘 𝒴 (str (𝕋ᴮ 𝒴) (𝕋 𝒴) (⅀₁ (𝕤𝕦𝕓 𝒴) (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) x)) σ)) (𝕝𝕤𝕥𝕣 ∘ σ) x
    ≡⟨⟩
        𝕒𝕝𝕘 𝒴 (dist X (𝕧𝕒𝕣 𝒴) (⅀ (𝕋 𝒴)) (λ x σ → str (𝕋ᴮ 𝒴) (𝕋 𝒴) (⅀₁ (𝕤𝕦𝕓 𝒴) (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) x)) σ) (𝕝𝕤𝕥𝕣 ∘ σ) x)
    ≡˘⟨ cong (𝕒𝕝𝕘 𝒴) (str≈₁ (lstr-nat₂ (𝕤𝕦𝕓 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) x)) ⟩
        𝕒𝕝𝕘 𝒴 (dist X (𝕧𝕒𝕣 𝒴) (⅀ (𝕋 𝒴)) (λ x σ → str (𝕋ᴮ 𝒴) (𝕋 𝒴) (lstr 〖 𝕋 𝒴 , 𝕋 𝒴 〗 (⅀₁ {X ⊸ 𝕋 𝒴} {X ⊸ 〖 𝕋 𝒴 , 𝕋 𝒴 〗} (𝕤𝕦𝕓 𝒴 ∘_) (⅀₁ 𝕝𝕤𝕥𝕣 t)) x) σ) (𝕝𝕤𝕥𝕣 ∘ σ) x)
    ≡˘⟨ congr ⅀.homomorphism (λ - → 𝕒𝕝𝕘 𝒴 (dist X (𝕧𝕒𝕣 𝒴) (⅀ (𝕋 𝒴)) (λ x σ → str (𝕋ᴮ 𝒴) (𝕋 𝒴) (lstr 〖 𝕋 𝒴 , 𝕋 𝒴 〗 - x) σ) (𝕝𝕤𝕥𝕣 ∘ σ) x)) ⟩ --cong (𝕒𝕝𝕘 𝒴) (compat-strs (𝕤𝕦𝕓ᶜ 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) (𝕝𝕤𝕥𝕣 ∘ σ) x) ⟩
        𝕒𝕝𝕘 𝒴 (dist X (𝕧𝕒𝕣 𝒴) (⅀ (𝕋 𝒴)) (λ x σ → str (𝕋ᴮ 𝒴) (𝕋 𝒴) (lstr 〖 𝕋 𝒴 , 𝕋 𝒴 〗 (⅀₁ {𝕋 (X ⊸ 𝒴)} {X ⊸ 〖 𝕋 𝒴 , 𝕋 𝒴 〗} (λ t x → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 t x)) t) x) σ) (𝕝𝕤𝕥𝕣 ∘ σ) x)
    ≡⟨ cong (𝕒𝕝𝕘 𝒴) (compat-strs (𝕋ᴮ 𝒴) (⅀₁ {𝕋 (X ⊸ 𝒴)} {X ⊸ 〖 𝕋 𝒴 , 𝕋 𝒴 〗} (λ t x → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 t x)) t) (𝕝𝕤𝕥𝕣 ∘ σ) x) ⟩ --cong (𝕒𝕝𝕘 𝒴) (compat-strs (𝕤𝕦𝕓ᶜ 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) (𝕝𝕤𝕥𝕣 ∘ σ) x) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (X ⊸ᴮ 𝕋ᴮ 𝒴) (X ⊸ 𝕋 𝒴) (⅀₁ (dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴)) (⅀₁ {𝕋 (X ⊸ 𝒴)} {X ⊸ 〖 𝕋 𝒴 , 𝕋 𝒴 〗} (λ t x → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 t x)) t)) (𝕝𝕤𝕥𝕣 ∘ σ)) x)
    ≡˘⟨ congr ⅀.homomorphism (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (X ⊸ᴮ (𝕋ᴮ 𝒴)) (X ⊸ 𝕋 𝒴) - (𝕝𝕤𝕥𝕣 ∘ σ)) x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (X ⊸ᴮ (𝕋ᴮ 𝒴)) (X ⊸ 𝕋 𝒴) (⅀₁ (λ{ t σ → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 t) σ}) t) (𝕝𝕤𝕥𝕣 ∘ σ)) x)
    ≡⟨ cong (𝕒𝕝𝕘 𝒴) (lstr≈₁ (str-nat₁ 𝕝𝕤𝕥𝕣ᴮ⇒ (⅀₁ (λ{ t σ x → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 t) σ x }) t) σ)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (𝕋ᴮ (X ⊸ 𝒴)) (X ⊸ 𝕋 𝒴) (⅀₁ {〖 X ⊸ 𝕋 𝒴 , X ⊸ 𝕋 𝒴 〗} {〖 𝕋 (X ⊸ 𝒴) , X ⊸ 𝕋 𝒴 〗}
                (λ { h ς → h (𝕝𝕤𝕥𝕣 ∘ ς) }) (⅀₁ (λ{ t σ → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 t) σ}) t)) σ) x)
    ≡˘⟨ congr ⅀.homomorphism (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (𝕋ᴮ (X ⊸ 𝒴)) (X ⊸ 𝕋 𝒴) - σ) x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (𝕋ᴮ (X ⊸ 𝒴)) (X ⊸ 𝕋 𝒴) (⅀₁ (λ{ t σ → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 t) (𝕝𝕤𝕥𝕣 ∘ σ) }) t) σ) x)
    ∎ }
  }

  where open ≡-Reasoning

𝕝𝕤𝕥𝕣∘𝕤𝕦𝕓 : (t : 𝕋 (X ⊸ 𝒴) α Γ)(σ : Γ ~[ 𝕋 (X ⊸ 𝒴) ]↝ Δ)(x : X Θ)
      → 𝕝𝕤𝕥𝕣 (𝕤𝕦𝕓 (X ⊸ 𝒴) t σ) x
      ≡ dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 t) (𝕝𝕤𝕥𝕣 ∘ σ) x
𝕝𝕤𝕥𝕣∘𝕤𝕦𝕓 t σ x = cong (λ - → - x) (MapEq₁.≈ _ 𝕝𝕤𝕥𝕣∘𝕤𝕦𝕓≈ t)

-- Compatibility of monad multiplication and strength
--                      𝕛𝕠𝕚𝕟                     𝕝𝕤𝕥𝕣
--  𝕋 (𝕋 (X ⊸ 𝒴)) ──────────── 𝕋 (X ⊸ 𝒴) ──────────── X ⊸ 𝕋 𝒴
--       ╰─────── 𝕋 (X ⊸ 𝕋 𝒴) ────── X ⊸ 𝕋 (𝕋 𝒴) ─────────╯
--         𝕋 𝕝𝕤𝕥𝕣                 𝕝𝕤𝕥𝕣                 X ⊸ 𝕛𝕠𝕚𝕟
𝕝𝕤𝕥𝕣∘𝕛𝕠𝕚𝕟≈ : MapEq₀ (𝕋 (X ⊸ 𝒴)) (X ⊸ 𝕋 𝒴)
  (λ t x → 𝕝𝕤𝕥𝕣 (𝕛𝕠𝕚𝕟 t) x)
  (λ t x → 𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕋₁ 𝕝𝕤𝕥𝕣 t) x))
𝕝𝕤𝕥𝕣∘𝕛𝕠𝕚𝕟≈ {X}{𝒴} = record
  { ᵃ = record { 𝑎𝑙𝑔 = λ t x → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) t x)
               ; 𝑣𝑎𝑟 = λ v x → 𝕧𝕒𝕣 𝒴 (inl _ v)
               ; 𝑚𝑣𝑎𝑟 = λ t ε x → dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 t x)) ε x }
  ; f⟨𝑣⟩ = λ{ {Γ = Γ}{x = v} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕛𝕠𝕚𝕟 (𝕧𝕒𝕣 (𝕋 (X ⊸ 𝒴)) v)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (⟨𝕧⟩ (X ⊸ 𝒴)) ⟩
        𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ 𝒴) v) x
    ≡⟨ cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕧⟩ {v = v}) ⟩
        𝕧𝕒𝕣 𝒴 (inl Γ v)
    ∎ }
  ; f⟨𝑚⟩ = λ{ {𝔪 = t}{ε} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕛𝕠𝕚𝕟 (𝕞𝕧𝕒𝕣 (𝕋 (X ⊸ 𝒴)) t ε)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (⟨𝕞⟩ (X ⊸ 𝒴)) ⟩
        𝕝𝕤𝕥𝕣 (𝕤𝕦𝕓 (X ⊸ 𝒴) t (𝕛𝕠𝕚𝕟 ∘ ε)) x
    ≡⟨ 𝕝𝕤𝕥𝕣∘𝕤𝕦𝕓 t (𝕛𝕠𝕚𝕟 ∘ ε) x ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (λ x → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 t x)) (𝕝𝕤𝕥𝕣 ∘ 𝕛𝕠𝕚𝕟 ∘ ε) x
    ∎ }
  ; f⟨𝑎⟩ = λ{ {t = t} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕛𝕠𝕚𝕟 (𝕒𝕝𝕘 (𝕋 (X ⊸ 𝒴)) t)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (⟨𝕒⟩ (X ⊸ 𝒴)) ⟩
        𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ 𝒴) (⅀₁ 𝕛𝕠𝕚𝕟 t)) x
    ≡⟨ cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕒⟩ {t = ⅀₁ 𝕛𝕠𝕚𝕟 t}) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ 𝕛𝕠𝕚𝕟 t)) x)
    ≡˘⟨ congr (⅀.homomorphism {f = 𝕛𝕠𝕚𝕟}{𝕝𝕤𝕥𝕣}{x = t}) (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) - x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ (𝕝𝕤𝕥𝕣 ∘ 𝕛𝕠𝕚𝕟) t) x)
    ∎ }
  ; g⟨𝑣⟩ = λ{ {Γ = Γ}{x = v} → dext λ x → begin
        𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕋₁ 𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (𝕋 (X ⊸ 𝒴)) v)) x)
    ≡⟨ cong 𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣≈₁ (𝕧𝕒𝕣-nat 𝕝𝕤𝕥𝕣 v)) ⟩
        𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ 𝕋 𝒴) v) x)
    ≡⟨ cong 𝕛𝕠𝕚𝕟 (cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕧⟩ {v = v})) ⟩
        𝕛𝕠𝕚𝕟 (𝕧𝕒𝕣 (𝕋 𝒴) (inl Γ v))
    ≡⟨ ⟨𝕧⟩ 𝒴 ⟩
        𝕧𝕒𝕣 𝒴 (inl Γ v)
    ∎ }
  ; g⟨𝑚⟩ = λ{ {𝔪 = t}{ε} → dext λ x → begin
        𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕋₁ 𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (𝕋 (X ⊸ 𝒴)) t ε)) x)
    ≡⟨ cong 𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣≈₁ (𝕞𝕧𝕒𝕣-nat 𝕝𝕤𝕥𝕣 t ε)) ⟩
        𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (X ⊸ 𝕋 𝒴) (𝕝𝕤𝕥𝕣 t) (𝕋₁ 𝕝𝕤𝕥𝕣 ∘ ε)) x)
    ≡⟨ cong 𝕛𝕠𝕚𝕟 (cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕞⟩ {𝔪 = 𝕝𝕤𝕥𝕣 t}{ε = 𝕋₁ 𝕝𝕤𝕥𝕣 ∘ ε})) ⟩
        𝕛𝕠𝕚𝕟 (dist X (𝕧𝕒𝕣 (𝕋 𝒴)) (𝕋 (𝕋 𝒴)) (λ x ε → 𝕞𝕧𝕒𝕣 (𝕋 𝒴) (𝕝𝕤𝕥𝕣 t x) ε) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ 𝕝𝕤𝕥𝕣 ∘ ε) x)
    ≡⟨⟩
        dist X (𝕧𝕒𝕣 (𝕋 𝒴)) (𝕋 𝒴) (λ x ε → 𝕛𝕠𝕚𝕟 (𝕞𝕧𝕒𝕣 (𝕋 𝒴) (𝕝𝕤𝕥𝕣 t x) ε)) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ 𝕝𝕤𝕥𝕣 ∘ ε) x
    ≡⟨ ⟨𝕞⟩ 𝒴 ⟩
        dist X (𝕧𝕒𝕣 (𝕋 𝒴)) (𝕋 𝒴) (λ x ε → 𝕤𝕦𝕓 𝒴 (𝕝𝕤𝕥𝕣 t x) (𝕛𝕠𝕚𝕟 ∘ ε)) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ 𝕝𝕤𝕥𝕣 ∘ ε) x
    ≡˘⟨ dist-nat₂ X (𝕧𝕒𝕣 (𝕋 𝒴)) (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) 𝕛𝕠𝕚𝕟 (λ v → ⟨𝕧⟩ 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 t) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ 𝕝𝕤𝕥𝕣 ∘ ε) x ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕤𝕦𝕓 𝒴 ∘ 𝕝𝕤𝕥𝕣 t) (λ v → 𝕛𝕠𝕚𝕟 ∘ 𝕝𝕤𝕥𝕣 (𝕋₁ 𝕝𝕤𝕥𝕣 (ε v))) x
    ∎ }
  ; g⟨𝑎⟩ = λ{ {t = t} → dext λ x → begin
        𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕋₁ 𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (𝕋 (X ⊸ 𝒴)) t)) x)
    ≡⟨ cong 𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣≈₁ (𝕒𝕝𝕘-nat 𝕝𝕤𝕥𝕣 t)) ⟩
        𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ 𝕋 𝒴) (⅀₁ (𝕋₁ 𝕝𝕤𝕥𝕣) t)) x)
    ≡⟨ cong 𝕛𝕠𝕚𝕟 (cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕒⟩ {t = ⅀₁ (𝕋₁ 𝕝𝕤𝕥𝕣) t})) ⟩
        𝕛𝕠𝕚𝕟 (𝕒𝕝𝕘 (𝕋 𝒴) (lstr (𝕋 (𝕋 𝒴)) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ 𝕝𝕤𝕥𝕣) t)) x))
    ≡⟨ ⟨𝕒⟩ 𝒴 ⟩
        𝕒𝕝𝕘 𝒴 (⅀₁ 𝕛𝕠𝕚𝕟 (lstr (𝕋 (𝕋 𝒴)) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ 𝕝𝕤𝕥𝕣) t)) x))
    ≡˘⟨ cong (𝕒𝕝𝕘 𝒴) (lstr-nat₂ 𝕛𝕠𝕚𝕟 (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ 𝕝𝕤𝕥𝕣) t)) x) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ (λ{ l x → 𝕛𝕠𝕚𝕟 (l x) }) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ 𝕝𝕤𝕥𝕣) t))) x)
    ≡˘⟨ congr (⅀.homomorphism {𝕋 (X ⊸ 𝕋 𝒴)}{X ⊸ 𝕋 (𝕋 𝒴)}{X ⊸ 𝕋 𝒴}) (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) - x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ (λ{ t x → 𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 t x) }) (⅀₁ (𝕋₁ 𝕝𝕤𝕥𝕣) t)) x)
    ≡˘⟨ congr (⅀.homomorphism {𝕋 (𝕋 (X ⊸ 𝒴))}{𝕋 (X ⊸ 𝕋 𝒴)}{X ⊸ 𝕋 𝒴}) (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) - x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ (λ{ t x → 𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕋₁ 𝕝𝕤𝕥𝕣 t) x)}) t) x)
    ∎ }
  }
  where
  open ≡-Reasoning
  open Join

𝕝𝕤𝕥𝕣∘𝕛𝕠𝕚𝕟 : (t : 𝕋 (𝕋 (X ⊸ 𝒴)) α Γ)(x : X Δ)
       → 𝕝𝕤𝕥𝕣 (𝕛𝕠𝕚𝕟 t) x ≡ 𝕛𝕠𝕚𝕟 (𝕝𝕤𝕥𝕣 (𝕋₁ {𝕋 (X ⊸ 𝒴)}{X ⊸ 𝕋 𝒴} 𝕝𝕤𝕥𝕣 t) x)
𝕝𝕤𝕥𝕣∘𝕛𝕠𝕚𝕟 {X}{𝒴} t x = cong (λ - → - x) (MapEq₀.≈ (𝕋 (X ⊸ 𝒴)) 𝕝𝕤𝕥𝕣∘𝕛𝕠𝕚𝕟≈ t)

-- Compatibility of strength and monad unit
--          𝕦𝕟𝕚𝕥             𝕝𝕤𝕥𝕣
--  X ⊸ 𝒴 ───── 𝕋 (X ⊸ 𝒴) ───── X ⊸ 𝕋 𝒴
--    ╰─────────────────────────────╯
--               X ⊸ 𝕦𝕟𝕚𝕥
𝕝𝕤𝕥𝕣∘𝕦𝕟𝕚𝕥 : (l : (X ⊸ 𝒴) α Γ)(x : X Δ)
       → 𝕝𝕤𝕥𝕣 {𝒴 = 𝒴} (𝕦𝕟𝕚𝕥 {X ⊸ 𝒴} l) x ≡ 𝕦𝕟𝕚𝕥 (l x)
𝕝𝕤𝕥𝕣∘𝕦𝕟𝕚𝕥 {X}{𝒴}{α}{Γ}{Δ} l x = begin
      𝕝𝕤𝕥𝕣 {𝒴 = 𝒴} (𝕦𝕟𝕚𝕥 {X ⊸ 𝒴} l) x
  ≡⟨⟩
      𝕝𝕤𝕥𝕣 {𝒴 = 𝒴} (𝕞𝕧𝕒𝕣 (X ⊸ 𝒴) l (𝕧𝕒𝕣 (X ⊸ 𝒴))) x
  ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕞⟩ l (𝕧𝕒𝕣 (X ⊸ 𝒴)) ⟩
      dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ l) (𝕝𝕤𝕥𝕣 ∘ 𝕧𝕒𝕣 (X ⊸ 𝒴)) x
  ≡⟨ SynAlg.𝑚≈₂ 𝒴 (𝕋ᵃ 𝒴) (λ v → begin
        copair (𝕋 𝒴) (λ v → 𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ 𝒴) v) x) (𝕧𝕒𝕣 𝒴 ∘ inr Γ) v
    ≡⟨ copair≈₁ (𝕋 𝒴) (𝕧𝕒𝕣 𝒴 ∘ inr Γ) {v} (λ v → 𝕝𝕤𝕥𝕣⟨𝕧⟩ v)  ⟩
        copair (𝕋 𝒴) (λ v → 𝕧𝕒𝕣 𝒴 (κ° X v x)) (𝕧𝕒𝕣 𝒴 ∘ inr Γ) v
    ≡˘⟨ f∘copair ℐ (𝕧𝕒𝕣 𝒴) (inl Γ) (inr Γ) v ⟩
        𝕧𝕒𝕣 𝒴 (copair ℐ (inl Γ) (inr Γ) v)
    ≡⟨ cong (𝕧𝕒𝕣 𝒴) (copair-η Γ Δ v) ⟩
        𝕧𝕒𝕣 𝒴 v
    ∎) ⟩
      𝕦𝕟𝕚𝕥 (l x)
  ∎ where open ≡-Reasoning
