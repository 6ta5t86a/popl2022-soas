
open import SOAS.Metatheory.Syntax

-- Linear strength for term functor
module SOAS.Metatheory.SecondOrder.Strength {T : Set}(Syn : Syntax {T}) where

open Syntax Syn

open import SOAS.Metatheory.FreeMonoid Syn
open import SOAS.Metatheory.TermFunctor Syn

open import SOAS.Common
open import SOAS.Families.Core {T}
open import SOAS.Context
open import SOAS.Variable
open import SOAS.ContextMaps.Combinators
open import SOAS.ContextMaps.CategoryOfRenamings
open import SOAS.ContextMaps.Properties

open import SOAS.Abstract.Hom
import SOAS.Abstract.Box as □ ; open □.Sorted
import SOAS.Abstract.Coalgebra as →□ ; open →□.Sorted

open import SOAS.Metatheory Syn

open import SOAS.Linear.Tensor
open import SOAS.Linear.Exponential
open import SOAS.Linear.Strength
open import SOAS.Linear.Distributor

open Theory using (𝕋 ; SynAlg ; module Semantics ; 𝕋ᵇ ; 𝕋ᵃ ; 𝕋ᵐ ; 𝕣𝕖𝕟)

private
  variable
    X Y : Family
    𝒳 𝒴 𝒵 𝒜 ℳ : Familyₛ
    Γ Δ Θ Ξ Π : Ctx
    α τ : T

-- Functorial action on metavariable family
SynAlg₁ : (f : 𝒳 ⇾̣ 𝒴) → SynAlg 𝒴 𝒜 → SynAlg 𝒳 𝒜
SynAlg₁ {𝒳}{𝒴} f 𝒜ᵃ = record { 𝑎𝑙𝑔 = 𝑎𝑙𝑔 ; 𝑣𝑎𝑟 = 𝑣𝑎𝑟 ; 𝑚𝑣𝑎𝑟 = 𝑚𝑣𝑎𝑟 ∘ f }
  where open SynAlg 𝒴 𝒜ᵃ

-- If 𝒜 is a (Σ, 𝒴)-syntactic algebra, X ⊸ 𝒴 is a (Σ, X ⊸ 𝒴)-syntactic algebra
LinParamᵃ : SynAlg 𝒴 𝒜 → SynAlg (X ⊸ 𝒴) (X ⊸ 𝒜)
LinParamᵃ {𝒴}{𝒜}{X} 𝒜ᵃ = record
  { 𝑎𝑙𝑔 = λ t x → 𝑎𝑙𝑔 (lstr 𝒜 t x)
  ; 𝑣𝑎𝑟 = λ v y → 𝑣𝑎𝑟 (κ° X v y)
  ; 𝑚𝑣𝑎𝑟 = λ 𝔩 → dist X 𝑣𝑎𝑟 𝒜 (𝑚𝑣𝑎𝑟 ∘ 𝔩)
  } where open SynAlg 𝒴 𝒜ᵃ

module LinParam {X}{𝒜}{𝒴} (𝒜ᵃ : SynAlg 𝒴 𝒜) = Semantics (X ⊸ 𝒴) (LinParamᵃ 𝒜ᵃ)

-- Special case: linear strength for 𝕋
module 𝕃𝕊𝕥𝕣 {X}{𝒴} = LinParam {X} (𝕋ᵃ 𝒴)

𝕝𝕤𝕥𝕣 : 𝕋 (X ⊸ 𝒴) ⇾̣ (X ⊸ 𝕋 𝒴)
𝕝𝕤𝕥𝕣 = 𝕃𝕊𝕥𝕣.𝕤𝕖𝕞

open Theory

-- Homomorphism conditions for strength
𝕝𝕤𝕥𝕣⟨𝕧⟩ : (v : ℐ α Γ){x : X Δ}
      → 𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ 𝒴) v) x
      ≡ 𝕧𝕒𝕣 𝒴 (κ° X v x)
𝕝𝕤𝕥𝕣⟨𝕧⟩ v {x} = cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕧⟩ {v = v})

𝕝𝕤𝕥𝕣⟨𝕒⟩ : (t : ⅀ (𝕋 (X ⊸ 𝒴)) α Γ){x : X Δ}
      → 𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ 𝒴) t) x
      ≡ 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) x)
𝕝𝕤𝕥𝕣⟨𝕒⟩ t {x} = cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕒⟩ {t = t})

𝕝𝕤𝕥𝕣⟨𝕞⟩ : (𝔩 : (X ⊸ 𝒴) α Π)(ε : Π ~[ 𝕋 (X ⊸ 𝒴) ]↝ Γ){x : X Δ}
      → 𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (X ⊸ 𝒴) 𝔩 ε) x
      ≡ dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ 𝔩) (𝕝𝕤𝕥𝕣 ∘ ε) x
𝕝𝕤𝕥𝕣⟨𝕞⟩ 𝔩 ε {x} = cong (λ - → - x) (𝕃𝕊𝕥𝕣.⟨𝕞⟩ {𝔪 = 𝔩}{ε})


𝕝𝕤𝕥𝕣≈₁ : {t s : 𝕋 (X ⊸ 𝒴) α Γ}{x : X Δ} (t≡s : t ≡ s)
     → 𝕝𝕤𝕥𝕣 {X}{𝒴} t x ≡ 𝕝𝕤𝕥𝕣 s x
𝕝𝕤𝕥𝕣≈₁ refl = refl


-- Strength is a coalgebra homomorphism
𝕝𝕤𝕥𝕣ᵇ⇒ : Coalg⇒ (𝕋ᵇ (X ⊸ 𝒴)) (X ⊸ᵇ 𝕋ᵇ 𝒴) 𝕝𝕤𝕥𝕣
𝕝𝕤𝕥𝕣ᵇ⇒ {X}{𝒴} = 𝕤𝕖𝕞ᵇ⇒ (X ⊸ 𝒴) (X ⊸ᵇ 𝕋ᵇ 𝒴) (LinParamᵃ (𝕋ᵃ 𝒴)) (record
  -- https://tinyurl.com/y7bpch95
  { ⟨𝑎𝑙𝑔⟩ = λ{ {t = t} → dext² λ ρ {Θ} x → begin
        ⊸□ (𝕋 𝒴) (𝕣𝕖𝕟 𝒴 ∘ 𝕒𝕝𝕘 𝒴 ∘ lstr (𝕋 𝒴) t) ρ x
    ≡⟨ Renaming.𝕥⟨𝕒⟩ 𝒴 ⟩
        ⊸□ (𝕋 𝒴) (λ x ρ → 𝕒𝕝𝕘 𝒴 (str ℐᴮ (𝕋 𝒴) (⅀₁ (𝕣𝕖𝕟 𝒴) (lstr (𝕋 𝒴) t x)) ρ)) ρ x
    ≡˘⟨ cong (𝕒𝕝𝕘 𝒴) (str≈₁ (lstr-nat₂ (𝕣𝕖𝕟 𝒴) t x)) ⟩ --(str≈₁ (lstr-nat₂ (𝕋ᵇ 𝒴) (□ᵇ (𝕋 𝒴)) rᵇ⇒ t x)) ⟩
        ⊸□ (𝕋 𝒴) (λ x ρ → 𝕒𝕝𝕘 𝒴 (str ℐᴮ (𝕋 𝒴) (lstr (□ (𝕋 𝒴)) (⅀₁ {X ⊸ 𝕋 𝒴}{X ⊸ □ (𝕋 𝒴)} (𝕣𝕖𝕟 𝒴 ∘_) t) x) ρ)) ρ x
    ≡⟨⟩
        𝕒𝕝𝕘 𝒴 (⊸□ (⅀ (𝕋 𝒴)) (λ x ρ → str ℐᴮ (𝕋 𝒴) (lstr (□ (𝕋 𝒴)) (⅀₁ {X ⊸ 𝕋 𝒴}{X ⊸ □ (𝕋 𝒴)} (𝕣𝕖𝕟 𝒴 ∘_) t) x) ρ) ρ x)
    ≡⟨ cong (𝕒𝕝𝕘 𝒴) (compat-strs ℐᴮ (⅀₁ {X ⊸ 𝕋 𝒴}{X ⊸ □ (𝕋 𝒴)} (𝕣𝕖𝕟 𝒴 ∘_) t) (κ° X ∘ ρ) x) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (X ⊸ᴮ ℐᴮ) (X ⊸ 𝕋 𝒴) (⅀₁ (dist X id (𝕋 𝒴)) (⅀₁ {X ⊸ 𝕋 𝒴}{X ⊸ □ (𝕋 𝒴)} (𝕣𝕖𝕟 𝒴 ∘_) t)) (κ° X ∘ ρ)) x)
    ≡˘⟨ congr ⅀.homomorphism (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (X ⊸ᴮ ℐᴮ) (X ⊸ 𝕋 𝒴) - (κ° X ∘ ρ)) x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str (X ⊸ᴮ ℐᴮ) (X ⊸ 𝕋 𝒴) (⅀₁ (λ{ l ρ → dist X id (𝕋 𝒴) (𝕣𝕖𝕟 𝒴 ∘ l) ρ}) t) (κ° X ∘ ρ)) x)
    ≡⟨ cong (𝕒𝕝𝕘 𝒴) (lstr≈₁ (str-nat₁ (κ°ᴮ⇒ X) (⅀₁ (λ{ l ρ x → dist X id (𝕋 𝒴) (𝕣𝕖𝕟 𝒴 ∘ l) ρ x}) t) ρ))  ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str ℐᴮ (X ⊸ 𝕋 𝒴) (⅀₁ (λ{ h ρ → h (κ° X ∘ ρ)}) (⅀₁ (λ{ l ρ → dist X id (𝕋 𝒴) (𝕣𝕖𝕟 𝒴 ∘ l) ρ}) t)) ρ) x)
    ≡˘⟨ congr ⅀.homomorphism (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str ℐᴮ (X ⊸ 𝕋 𝒴) - ρ) x))  ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str ℐᴮ (X ⊸ 𝕋 𝒴) (⅀₁ (λ{ l ρ → dist X id (𝕋 𝒴) (𝕣𝕖𝕟 𝒴 ∘ l) (κ° X ∘ ρ)}) t) ρ) x)
    ≡⟨⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (str ℐᴮ (X ⊸ 𝕋 𝒴) (⅀₁ (λ{ l ρ x → ⊸□ (𝕋 𝒴) (𝕣𝕖𝕟 𝒴) ρ (l x)}) t) ρ) x)
    ∎ }
  ; ⟨𝑣𝑎𝑟⟩ = λ{ {Γ = Γ}{v = v} → dext² λ {Δ} ρ {Θ} x → begin
        𝕣𝕖𝕟 𝒴 (𝕧𝕒𝕣 𝒴 (inl Γ v)) (ρ ∣∔ Θ)
    ≡⟨ Renaming.𝕥⟨𝕧⟩ 𝒴 ⟩
        𝕧𝕒𝕣 𝒴 ((ρ ∣∔ Θ) (inl Γ v))
    ≡⟨ cong (𝕧𝕒𝕣 𝒴) (∔.inject₁ {f = inl _ ∘ ρ}{g = inr _}) ⟩
        𝕧𝕒𝕣 𝒴 (inl Δ (ρ v))
    ∎ }
  -- https://tinyurl.com/y362evek
  ; ⟨𝑚𝑣𝑎𝑟⟩ = λ{ {𝔪 = l}{ε} → dext² λ {Δ} ρ {Θ} x → begin
        dist X id (𝕋 𝒴) (λ x ρ → 𝕣𝕖𝕟 𝒴 (dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ l) ε x) ρ) (κ° X ∘ ρ) x
    ≡⟨⟩
        dist X id (𝕋 𝒴) (dist X (𝕧𝕒𝕣 𝒴) (□ (𝕋 𝒴)) (λ x → 𝕣𝕖𝕟 𝒴 ∘ 𝕞𝕧𝕒𝕣 𝒴 (l x)) ε) (κ° X ∘ ρ) x
    ≡⟨ Renaming.𝕥⟨𝕞⟩ 𝒴 ⟩
        dist X id (𝕋 𝒴) (dist X (𝕧𝕒𝕣 𝒴) (□ (𝕋 𝒴)) (λ x ε ρ → 𝕞𝕧𝕒𝕣 𝒴 (l x) (λ v → 𝕣𝕖𝕟 𝒴 (ε v) ρ)) ε) (κ° X ∘ ρ) x
    ≡˘⟨ congr (dist-nat₂ X {𝒵 = □ (𝕋 𝒴)}(𝕧𝕒𝕣 𝒴) (λ v ρ → 𝕧𝕒𝕣 𝒴 (ρ v)) (□ (𝕋 𝒴)) (𝕣𝕖𝕟 𝒴) (λ v → Renaming.⟨𝕧⟩ 𝒴) (λ{ x ε ρ → 𝕞𝕧𝕒𝕣 𝒴 (l x) (λ v → ε v ρ)}) ε x)
               (λ - → - (copair ℐ (λ v → κ° X (ρ v) x) (inr Δ)))⟩
        dist {𝒴 = □ (𝕋 𝒴)} X (λ v ρ → 𝕧𝕒𝕣 𝒴 (ρ v)) (□ (𝕋 𝒴)) (λ x ε ρ → 𝕞𝕧𝕒𝕣 𝒴 (l x) (λ v → ε v ρ)) (λ v → 𝕣𝕖𝕟 𝒴 ∘ ε v) x (copair ℐ (λ v → κ° X (ρ v) x) (inr Δ))
    ≡⟨ dist-L {𝒵 = 𝕋 𝒴} (𝕞𝕧𝕒𝕣 𝒴 ∘ l) id (𝕧𝕒𝕣 𝒴) (λ v → 𝕣𝕖𝕟 𝒴 ∘ ε v) (κ° X ∘ ρ) x ⟩
        L (X ⊸ ℐ) (X ⊸ 𝕋 𝒴) (X ⊸ 𝕋 𝒴) (dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ l)) (λ v → dist X id (𝕋 𝒴) (𝕣𝕖𝕟 𝒴 ∘ ε v)) (κ° X ∘ ρ) x
    ≡⟨⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ l) (λ v x → dist X id (𝕋 𝒴) (𝕣𝕖𝕟 𝒴 ∘ ε v) (κ° X ∘ ρ) x) x
    ∎ }
  })
  where
  open ≡-Reasoning

𝕝𝕤𝕥𝕣ᴮ⇒ : Coalgₚ⇒ (𝕋ᴮ (X ⊸ 𝒴)) (X ⊸ᴮ 𝕋ᴮ 𝒴) 𝕝𝕤𝕥𝕣
𝕝𝕤𝕥𝕣ᴮ⇒ = record { ᵇ⇒ = 𝕝𝕤𝕥𝕣ᵇ⇒ ; ⟨η⟩ = 𝕃𝕊𝕥𝕣.⟨𝕧⟩ }

-- Naturality for strength
𝕝𝕤𝕥𝕣-nat₁≈ : (f : X ⇾ Y) → MapEq₀ (Y ⊸ 𝒴) (X ⊸ 𝕋 𝒴)
  (λ t x → 𝕝𝕤𝕥𝕣 {Y}{𝒴} t (f x))
  (λ t x → 𝕝𝕤𝕥𝕣 (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) t) x)
𝕝𝕤𝕥𝕣-nat₁≈ {X}{Y}{𝒴} f = record
  { ᵃ = SynAlg₁ {Y ⊸ 𝒴}{X ⊸ 𝒴}(_∘ f) (LinParamᵃ (𝕋ᵃ 𝒴))
  ; f⟨𝑣⟩ = λ{ {x = v} → dext λ x → 𝕝𝕤𝕥𝕣⟨𝕧⟩ v }
  ; f⟨𝑚⟩ = λ{ {𝔪 = 𝔩}{ε} → dext λ x → begin
        𝕝𝕤𝕥𝕣 {Y}{𝒴} (𝕞𝕧𝕒𝕣 (Y ⊸ 𝒴) 𝔩 ε) (f x)
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕞⟩ 𝔩 ε ⟩
        dist Y (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ 𝔩) (𝕝𝕤𝕥𝕣 ∘ ε) (f x)
    ≡⟨⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ 𝔩 ∘ f) (λ v → 𝕝𝕤𝕥𝕣 (ε v) ∘ f) x
    ∎ }
  ; f⟨𝑎⟩ = λ{ {t = t} → dext (λ x → begin
        𝕝𝕤𝕥𝕣 {Y}{𝒴} (𝕒𝕝𝕘 (Y ⊸ 𝒴) t) (f x)
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕒⟩ t ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) (f x))
    ≡⟨ cong (𝕒𝕝𝕘 𝒴) (lstr-nat₁ f (⅀₁ 𝕝𝕤𝕥𝕣 t) x) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ {Y ⊸ 𝕋 𝒴}{X ⊸ 𝕋 𝒴}(_∘ f) (⅀₁ 𝕝𝕤𝕥𝕣 t)) x)
    ≡˘⟨ congr (⅀.homomorphism {𝕋 (Y ⊸ 𝒴)}{Y ⊸ 𝕋 𝒴}{X ⊸ 𝕋 𝒴}) (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) - x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ (λ{ t x → 𝕝𝕤𝕥𝕣 t (f x) }) t) x)
    ∎) }
  ; g⟨𝑣⟩ = λ{ {x = v} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) (𝕧𝕒𝕣 (Y ⊸ 𝒴) v)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕧𝕒𝕣-nat {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) v) ⟩
        𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ 𝒴) v) x
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕧⟩ v ⟩
        𝕧𝕒𝕣 𝒴 (inl _ v)
    ∎ }
  ; g⟨𝑚⟩ = λ{ {𝔪 = 𝔩}{ε} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) (𝕞𝕧𝕒𝕣 (Y ⊸ 𝒴) 𝔩 ε)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕞𝕧𝕒𝕣-nat {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) 𝔩 ε) ⟩
        𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (X ⊸ 𝒴) (𝔩 ∘ f) (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) ∘ ε)) x
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕞⟩ (𝔩 ∘ f)(𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) ∘ ε) ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ 𝔩 ∘ f) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) ∘ ε) x
    ∎ }
  ; g⟨𝑎⟩ = λ{ {t = t} → dext (λ x → begin
        𝕝𝕤𝕥𝕣 (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) (𝕒𝕝𝕘 (Y ⊸ 𝒴) t)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕒𝕝𝕘-nat {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) t) ⟩
        𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ 𝒴) (⅀₁ (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴}(_∘ f)) t)) x
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕒⟩ (⅀₁ (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴}(_∘ f)) t) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴}(_∘ f)) t)) x)
    ≡˘⟨ congr (⅀.homomorphism {𝕋 (Y ⊸ 𝒴)}{𝕋 (X ⊸ 𝒴)}{X ⊸ 𝕋 𝒴}) (λ - → 𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) - x)) ⟩
        𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ ( 𝕝𝕤𝕥𝕣 ∘ 𝕋₁ {Y ⊸ 𝒴} {X ⊸ 𝒴} (_∘ f)) t) x)
    ∎) }
  } where open ≡-Reasoning

𝕝𝕤𝕥𝕣-nat₁ : (f : X ⇾ Y)(t : 𝕋 (Y ⊸ 𝒴) α Γ)(x : X Δ)
        → 𝕝𝕤𝕥𝕣 {Y}{𝒴} t (f x)
        ≡ 𝕝𝕤𝕥𝕣 (𝕋₁ {Y ⊸ 𝒴}{X ⊸ 𝒴} (_∘ f) t) x
𝕝𝕤𝕥𝕣-nat₁ {X}{Y}{𝒴} f t x = cong (λ - → - x) (MapEq₀.≈ (Y ⊸ 𝒴) (𝕝𝕤𝕥𝕣-nat₁≈ f) t)

𝕝𝕤𝕥𝕣-nat₂≈ : (g : 𝒴 ⇾̣ 𝒵) → MapEq₀ (X ⊸ 𝒴) (X ⊸ 𝕋 𝒵)
  (λ t x → 𝕝𝕤𝕥𝕣 (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) t) x)
  (λ t x → 𝕋₁ g (𝕝𝕤𝕥𝕣 t x))
𝕝𝕤𝕥𝕣-nat₂≈ {𝒴}{𝒵}{X} g = record
  { ᵃ = LinParamᵃ (record { 𝑎𝑙𝑔 = 𝕒𝕝𝕘 𝒵 ; 𝑣𝑎𝑟 = 𝕧𝕒𝕣 𝒵 ; 𝑚𝑣𝑎𝑟 = λ 𝔩 → 𝕞𝕧𝕒𝕣 𝒵 (g 𝔩) })
  ; f⟨𝑣⟩ = λ{ {Γ = Γ}{x = v} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) (𝕧𝕒𝕣 (X ⊸ 𝒴) v)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕧𝕒𝕣-nat {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) v)  ⟩
        𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ 𝒵) v) x
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕧⟩ v ⟩
        𝕧𝕒𝕣 𝒵 (inl Γ v)
    ∎ }
  ; f⟨𝑚⟩ = λ{ {𝔪 = 𝔩}{ε} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) (𝕞𝕧𝕒𝕣 (X ⊸ 𝒴) 𝔩 ε)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕞𝕧𝕒𝕣-nat {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) (λ {τ} x → 𝔩 {τ} x) ε) ⟩
        𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (X ⊸ 𝒵) (g ∘ 𝔩) (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) ∘ ε)) x
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕞⟩ (g ∘ 𝔩) (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) ∘ ε) ⟩
        dist X (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (𝕞𝕧𝕒𝕣 𝒵 ∘ g ∘ 𝔩) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) ∘ ε) x
    ∎ }
  ; f⟨𝑎⟩ = λ{ {t = t} → dext λ x → begin
        𝕝𝕤𝕥𝕣 (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) (𝕒𝕝𝕘 (X ⊸ 𝒴) t)) x
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕒𝕝𝕘-nat {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) t) ⟩
        𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ 𝒵) (⅀₁ (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_)) t)) x
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕒⟩ (⅀₁ (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_)) t) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_)) t)) x)
    ≡˘⟨ congr (⅀.homomorphism {f = (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_))}{g = 𝕝𝕤𝕥𝕣}{x = t}) (λ - → 𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) - x)) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (⅀₁ (λ{ t x → 𝕝𝕤𝕥𝕣 (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵} (g ∘_) t) x }) t) x)
    ∎ }
  ; g⟨𝑣⟩ = λ{ {Γ = Γ}{x = v} → dext λ x → begin
        𝕋₁ g (𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ 𝒴) v) x)
    ≡⟨ cong (𝕋₁ g) (𝕝𝕤𝕥𝕣⟨𝕧⟩ v) ⟩
        𝕋₁ g (𝕧𝕒𝕣 𝒴 (inl Γ v))
    ≡⟨ 𝕧𝕒𝕣-nat g (inl Γ v) ⟩
        𝕧𝕒𝕣 𝒵 (inl Γ v)
    ∎ }
  ; g⟨𝑚⟩ = λ{ {𝔪 = 𝔩}{ε} → dext λ x → begin
        𝕋₁ g (𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (X ⊸ 𝒴) 𝔩 ε) x)
    ≡⟨ cong (𝕋₁ g) (𝕝𝕤𝕥𝕣⟨𝕞⟩ 𝔩 ε) ⟩
        𝕋₁ g (dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒴) (𝕞𝕧𝕒𝕣 𝒴 ∘ 𝔩) (𝕝𝕤𝕥𝕣 ∘ ε) x)
    ≡⟨⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒵) (λ x ε → 𝕋₁ g (𝕞𝕧𝕒𝕣 𝒴 (𝔩 x) ε)) (𝕝𝕤𝕥𝕣 ∘ ε) x
    ≡⟨ 𝕞𝕧𝕒𝕣-nat g (𝔩 x) _ ⟩
        dist X (𝕧𝕒𝕣 𝒴) (𝕋 𝒵) (λ x ε → 𝕞𝕧𝕒𝕣 𝒵 (g (𝔩 x)) (𝕋₁ g ∘ ε)) (𝕝𝕤𝕥𝕣 ∘ ε) x
    ≡˘⟨ dist-nat₂ X (𝕧𝕒𝕣 𝒴) (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (𝕋₁ g) (𝕧𝕒𝕣-nat g) (𝕞𝕧𝕒𝕣 𝒵 ∘ g ∘ 𝔩) (𝕝𝕤𝕥𝕣 ∘ ε) x ⟩
        dist X (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (𝕞𝕧𝕒𝕣 𝒵 ∘ g ∘ 𝔩) (λ v → 𝕋₁ g ∘ 𝕝𝕤𝕥𝕣 (ε v)) x
    ∎ }
  ; g⟨𝑎⟩ = λ{ {t = t} → dext λ x → begin
        𝕋₁ g (𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ 𝒴) t) x)
    ≡⟨ cong (𝕋₁ g) (𝕝𝕤𝕥𝕣⟨𝕒⟩ t) ⟩
        𝕋₁ g (𝕒𝕝𝕘 𝒴 (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) x))
    ≡⟨ 𝕒𝕝𝕘-nat g (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) x) ⟩
        𝕒𝕝𝕘 𝒵 (⅀₁ (𝕋₁ g) (lstr (𝕋 𝒴) (⅀₁ 𝕝𝕤𝕥𝕣 t) x))
    ≡˘⟨ cong (𝕒𝕝𝕘 𝒵) (lstr-nat₂ (𝕋₁ g) (⅀₁ 𝕝𝕤𝕥𝕣 t) x) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (⅀₁ {X ⊸ 𝕋 𝒴}{X ⊸ 𝕋 𝒵} (𝕋₁ g ∘_) (⅀₁ 𝕝𝕤𝕥𝕣 t)) x)
    ≡˘⟨ congr (⅀.homomorphism {𝕋 (X ⊸ 𝒴)}{X ⊸ 𝕋 𝒴}{X ⊸ 𝕋 𝒵}) (λ - → 𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) - x)) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (⅀₁ (λ{ t x → 𝕋₁ g (𝕝𝕤𝕥𝕣 t x)}) t) x)
    ∎ }
  }
  where open ≡-Reasoning

𝕝𝕤𝕥𝕣-nat₂ : (g : 𝒴 ⇾̣ 𝒵)(t : 𝕋 (X ⊸ 𝒴) α Γ)(x : X Δ)
        → 𝕝𝕤𝕥𝕣 (𝕋₁ {X ⊸ 𝒴}{X ⊸ 𝒵}(g ∘_) t) x
        ≡ 𝕋₁ {𝒴}{𝒵} g (𝕝𝕤𝕥𝕣 t x)
𝕝𝕤𝕥𝕣-nat₂ {𝒴}{𝒵}{X} g t x = cong (λ - → - x) (MapEq₀.≈ (X ⊸ 𝒴) (𝕝𝕤𝕥𝕣-nat₂≈ g) t)

-- Interaction of strength and currying
𝕝𝕤𝕥𝕣-curry≈ : MapEq₀ ((X ⊗ Y) ⊸ 𝒵) (X ⊸ Y ⊸ 𝕋 𝒵)
              (λ t x y → curry° (𝕋 𝒵) (𝕝𝕤𝕥𝕣 t) x y)
              (λ t x y → 𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕋₁ (curry° 𝒵) t) x) y)
𝕝𝕤𝕥𝕣-curry≈ {X}{Y}{𝒵} = record
  { ᵃ = record
    { 𝑎𝑙𝑔 = λ l x y → 𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr (Y ⊸ 𝕋 𝒵) l x) y)
    ; 𝑣𝑎𝑟 = λ v x y → 𝕧𝕒𝕣 𝒵 (κ° Y (κ° X v x) y)
    ; 𝑚𝑣𝑎𝑟 = λ 𝔩 → dist {𝒴 = Y ⊸ 𝕋 𝒵} X (λ v → 𝕧𝕒𝕣 𝒵 ∘ κ° Y v) (Y ⊸ 𝕋 𝒵) (λ x → dist Y (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (curry° 〖 𝕋 𝒵 , 𝕋 𝒵 〗 (𝕞𝕧𝕒𝕣 𝒵 ∘ 𝔩) x))
    }
  ; f⟨𝑣⟩ = λ{ {Γ = Γ}{x = v} → dext² (λ {Δ} x {Θ} y → begin
        curry° (𝕋 𝒵) (𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 ((X ⊗ Y) ⊸ 𝒵) v)) x y
    ≡⟨ curry°≈₁ (λ p → 𝕝𝕤𝕥𝕣⟨𝕧⟩ v {p}) ⟩
        curry° (𝕋 𝒵) (𝕧𝕒𝕣 𝒵 ∘ κ° (X ⊗ Y) v) x y
    ≡˘⟨ curry°-nat₃ (𝕧𝕒𝕣 𝒵) (κ° (X ⊗ Y) v) x y ⟩
        𝕧𝕒𝕣 𝒵 (curry° ℐ (κ° (X ⊗ Y) v) x y)
    ≡⟨ cong (𝕧𝕒𝕣 𝒵) (assocˡ≈↝assocˡ Γ (κ° (X ⊗ Y) v (x ⊹ y))) ⟩ --(copair∘inl ℐ v) ⟩
        𝕧𝕒𝕣 𝒵 (↝assocˡ Γ Δ Θ (κ° (X ⊗ Y) v (x ⊹ y)))
    ≡⟨ cong (𝕧𝕒𝕣 𝒵) (copair∘inl ℐ v) ⟩
        𝕧𝕒𝕣 𝒵 (κ° Y (κ° X v x) y)
    ∎) }
  ; f⟨𝑚⟩ = λ{ {𝔪 = 𝔩}{ε} → dext² λ x y → begin
        curry° (𝕋 𝒵) (𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 ((X ⊗ Y) ⊸ 𝒵) 𝔩 ε)) x y
    ≡⟨ curry°≈₁ (λ p → 𝕝𝕤𝕥𝕣⟨𝕞⟩ 𝔩 ε {p}) ⟩
        curry° (𝕋 𝒵) (dist (X ⊗ Y) (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (𝕞𝕧𝕒𝕣 𝒵 ∘ 𝔩) (𝕝𝕤𝕥𝕣 ∘ ε)) x y
    ≡⟨ dist-curry° (𝕧𝕒𝕣 𝒵) (𝕞𝕧𝕒𝕣 𝒵 ∘ 𝔩) (𝕝𝕤𝕥𝕣 ∘ ε) x y ⟩
        dist {𝒴 = Y ⊸ 𝕋 𝒵} X (λ v → 𝕧𝕒𝕣 𝒵 ∘ κ° Y v) (Y ⊸ 𝕋 𝒵) (λ x → dist Y (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (curry° 〖 𝕋 𝒵 , 𝕋 𝒵 〗 (𝕞𝕧𝕒𝕣 𝒵 ∘ 𝔩) x)) (curry° (𝕋 𝒵) ∘ 𝕝𝕤𝕥𝕣 ∘ ε) x y
    ∎}
  ; f⟨𝑎⟩ = λ{ {t = t} → dext² (λ x y → begin
        curry° (𝕋 𝒵) (𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 ((X ⊗ Y) ⊸ 𝒵) t)) x y
    ≡⟨ curry°≈₁ (λ p → 𝕝𝕤𝕥𝕣⟨𝕒⟩ t {p}) ⟩
        curry° (𝕋 𝒵) (𝕒𝕝𝕘 𝒵 ∘ lstr (𝕋 𝒵) (⅀₁ 𝕝𝕤𝕥𝕣 t)) x y
    ≡˘⟨ curry°-nat₃ (𝕒𝕝𝕘 𝒵) (lstr (𝕋 𝒵) (⅀₁ 𝕝𝕤𝕥𝕣 t)) x y ⟩
        𝕒𝕝𝕘 𝒵 (curry° (⅀ (𝕋 𝒵)) (lstr (𝕋 𝒵) (⅀₁ 𝕝𝕤𝕥𝕣 t)) x y)
    ≡⟨ cong (𝕒𝕝𝕘 𝒵) (lstr-curry (⅀₁ 𝕝𝕤𝕥𝕣 t) x y) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr ((Y ⊸ 𝕋 𝒵)) (⅀₁ (curry° (𝕋 𝒵)) (⅀₁ 𝕝𝕤𝕥𝕣 t)) x) y)
    ≡˘⟨ congr (⅀.homomorphism {𝕋 ((X ⊗ Y) ⊸ 𝒵)}{(X ⊗ Y) ⊸ 𝕋 𝒵}{X ⊸ (Y ⊸ 𝕋 𝒵)}) (λ - → 𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr ((Y ⊸ 𝕋 𝒵)) - x) y)) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr (Y ⊸ 𝕋 𝒵) (⅀₁ (curry° (𝕋 𝒵) ∘ 𝕝𝕤𝕥𝕣) t) x) y)
    ∎) }
  ; g⟨𝑣⟩ = λ{ {x = v} → dext² (λ x y → begin
        𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕋₁ (curry° 𝒵) (𝕧𝕒𝕣 ((X ⊗ Y) ⊸ 𝒵) v)) x) y
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕝𝕤𝕥𝕣≈₁ (𝕧𝕒𝕣-nat (curry° 𝒵) v)) ⟩
        𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (X ⊸ Y ⊸ 𝒵) v) x) y
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕝𝕤𝕥𝕣⟨𝕧⟩ v) ⟩
        𝕝𝕤𝕥𝕣 (𝕧𝕒𝕣 (Y ⊸ 𝒵) (κ° X v x)) y
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕧⟩ (κ° X v x) ⟩
        𝕧𝕒𝕣 𝒵 (κ° Y (κ° X v x) y)
    ∎
    ) }
  ; g⟨𝑚⟩ = λ{ {𝔪 = 𝔩}{ε} → dext² λ x y → begin
        𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕋₁ (curry° 𝒵) (𝕞𝕧𝕒𝕣 ((X ⊗ Y) ⊸ 𝒵) 𝔩 ε)) x) y
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕝𝕤𝕥𝕣≈₁ (𝕞𝕧𝕒𝕣-nat (curry° 𝒵) 𝔩 ε)) ⟩
        𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕞𝕧𝕒𝕣 (X ⊸ Y ⊸ 𝒵) (curry° 𝒵 𝔩) (𝕋₁ (curry° 𝒵) ∘ ε)) x) y
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕝𝕤𝕥𝕣⟨𝕞⟩ (curry° 𝒵 𝔩) (𝕋₁ (curry° 𝒵) ∘ ε)) ⟩
        𝕝𝕤𝕥𝕣 (dist {𝒴 = 𝕋 (Y ⊸ 𝒵)} X (𝕧𝕒𝕣 (Y ⊸ 𝒵)) (𝕋 (Y ⊸ 𝒵)) (𝕞𝕧𝕒𝕣 (Y ⊸ 𝒵) ∘ curry° 𝒵 𝔩) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ (curry° 𝒵) ∘ ε) x) y
    ≡⟨⟩
        dist {𝒴 = 𝕋 (Y ⊸ 𝒵)} X (𝕧𝕒𝕣 (Y ⊸ 𝒵)) (Y ⊸ 𝕋 𝒵) (λ x → 𝕝𝕤𝕥𝕣 ∘ 𝕞𝕧𝕒𝕣 (Y ⊸ 𝒵) (curry° 𝒵 𝔩 x)) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ (curry° 𝒵) ∘ ε) x y
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕞⟩ (curry° 𝒵 𝔩 x) _ ⟩
        dist {𝒴 = 𝕋 (Y ⊸ 𝒵)} X (𝕧𝕒𝕣 (Y ⊸ 𝒵)) (Y ⊸ 𝕋 𝒵) (λ x ε → dist Y (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (𝕞𝕧𝕒𝕣 𝒵 ∘ curry° 𝒵 𝔩 x) (𝕝𝕤𝕥𝕣 ∘ ε)) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ (curry° 𝒵) ∘ ε) x y
    ≡˘⟨ cong (λ - → - y) (dist-nat₂ {𝒴 = 𝕋 (Y ⊸ 𝒵)} X {Y ⊸ 𝕋 𝒵} (𝕧𝕒𝕣 (Y ⊸ 𝒵)) (λ v → 𝕧𝕒𝕣 𝒵 ∘ κ° Y v) (Y ⊸ 𝕋 𝒵) 𝕝𝕤𝕥𝕣 (λ v → dext′ (𝕝𝕤𝕥𝕣⟨𝕧⟩ v)) (λ x → dist Y (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (𝕞𝕧𝕒𝕣 𝒵 ∘ curry° 𝒵 𝔩 x)) (𝕝𝕤𝕥𝕣 ∘ 𝕋₁ (curry° 𝒵) ∘ ε) x) ⟩
        dist {𝒴 = Y ⊸ 𝕋 𝒵} X (λ v → 𝕧𝕒𝕣 𝒵 ∘ κ° Y v) (Y ⊸ 𝕋 𝒵) (λ x → dist Y (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (𝕞𝕧𝕒𝕣 𝒵 ∘ curry° 𝒵 𝔩 x)) (λ v → 𝕝𝕤𝕥𝕣 ∘ 𝕝𝕤𝕥𝕣 (𝕋₁ (curry° 𝒵) (ε v))) x y
    ≡⟨ cong (λ - → - _) (curry°-nat₃ {𝒵 = 𝒵}{〖 𝕋 𝒵 , 𝕋 𝒵 〗}(𝕞𝕧𝕒𝕣 𝒵) 𝔩 x y) ⟩
        dist {𝒴 = Y ⊸ 𝕋 𝒵} X (λ v → 𝕧𝕒𝕣 𝒵 ∘ κ° Y v) (Y ⊸ 𝕋 𝒵) (λ x → dist Y (𝕧𝕒𝕣 𝒵) (𝕋 𝒵) (curry° 〖 𝕋 𝒵 , 𝕋 𝒵 〗 (𝕞𝕧𝕒𝕣 𝒵 ∘ 𝔩) x)) (λ v → 𝕝𝕤𝕥𝕣 ∘ 𝕝𝕤𝕥𝕣 (𝕋₁ (curry° 𝒵) (ε v))) x y
    ∎
   }
  ; g⟨𝑎⟩ = λ{ {t = t} → dext² (λ x y → begin
        𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕋₁ (curry° 𝒵) (𝕒𝕝𝕘 ((X ⊗ Y) ⊸ 𝒵) t)) x) y
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕝𝕤𝕥𝕣≈₁ (𝕒𝕝𝕘-nat (curry° 𝒵) t)) ⟩
        𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (X ⊸ Y ⊸ 𝒵) (⅀₁ (𝕋₁ (curry° 𝒵)) t)) x) y
    ≡⟨ 𝕝𝕤𝕥𝕣≈₁ (𝕝𝕤𝕥𝕣⟨𝕒⟩ (⅀₁ (𝕋₁ (curry° 𝒵)) t)) ⟩
        𝕝𝕤𝕥𝕣 (𝕒𝕝𝕘 (Y ⊸ 𝒵) (lstr (𝕋 (Y ⊸ 𝒵)) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ (curry° 𝒵)) t)) x)) y
    ≡⟨ 𝕝𝕤𝕥𝕣⟨𝕒⟩ (lstr (𝕋 (Y ⊸ 𝒵)) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ (curry° 𝒵)) t)) x) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (⅀₁ 𝕝𝕤𝕥𝕣 (lstr (𝕋 (Y ⊸ 𝒵)) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ (curry° 𝒵)) t)) x)) y)
    ≡˘⟨ congr (lstr-nat₂ 𝕝𝕤𝕥𝕣 (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ (curry° 𝒵)) t)) x) (λ - → 𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) - y)) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr (Y ⊸ 𝕋 𝒵) (⅀₁ {X ⊸ 𝕋 (Y ⊸ 𝒵)} {X ⊸ Y ⊸ 𝕋 𝒵} (𝕝𝕤𝕥𝕣 ∘_) (⅀₁ 𝕝𝕤𝕥𝕣 (⅀₁ (𝕋₁ (curry° 𝒵)) t))) x) y)
    ≡˘⟨ congr (⅀.homomorphism {𝕋 (X ⊸ Y ⊸ 𝒵)}{X ⊸ 𝕋 (Y ⊸ 𝒵)}{X ⊸ Y ⊸ 𝕋 𝒵}) (λ - → 𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr (Y ⊸ 𝕋 𝒵) - x) y)) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr (Y ⊸ 𝕋 𝒵) (⅀₁ {𝕋 (X ⊸ Y ⊸ 𝒵)} {X ⊸ Y ⊸ 𝕋 𝒵} (λ{ t x → 𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 t x)}) (⅀₁ (𝕋₁ (curry° 𝒵)) t)) x) y)
    ≡˘⟨ congr (⅀.homomorphism {𝕋 ((X ⊗ Y) ⊸ 𝒵)}{𝕋 (X ⊸ Y ⊸ 𝒵)}{X ⊸ Y ⊸ 𝕋 𝒵}) (λ - → 𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr (Y ⊸ 𝕋 𝒵) - x) y)) ⟩
        𝕒𝕝𝕘 𝒵 (lstr (𝕋 𝒵) (lstr (Y ⊸ 𝕋 𝒵) (⅀₁ (λ { t x → 𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕋₁ (curry° 𝒵) t) x) }) t) x) y)
    ∎) }
  } where open ≡-Reasoning

𝕝𝕤𝕥𝕣-curry : (t : 𝕋 ((X ⊗ Y) ⊸ 𝒵) α Γ)(x : X Δ)(y : Y Θ)
         → curry° (𝕋 𝒵) (𝕝𝕤𝕥𝕣 t) x y
         ≡ 𝕝𝕤𝕥𝕣 (𝕝𝕤𝕥𝕣 (𝕋₁ (curry° 𝒵) t) x) y
𝕝𝕤𝕥𝕣-curry {X}{Y}{𝒵} t x y = cong (λ - → - x y) (MapEq₀.≈ ((X ⊗ Y) ⊸ 𝒵) 𝕝𝕤𝕥𝕣-curry≈ t)

-- 𝕋 is equipped with a linear strength
𝕋:LStr : LinStrength 𝕋F
𝕋:LStr = record
  { lstr = λ 𝒴 → 𝕝𝕤𝕥𝕣
  ; lstr-nat₁ = 𝕝𝕤𝕥𝕣-nat₁
  ; lstr-nat₂ = 𝕝𝕤𝕥𝕣-nat₂
  ; lstr-curry = 𝕝𝕤𝕥𝕣-curry }
