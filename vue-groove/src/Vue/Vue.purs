module Vue
 ( Element
 , class IsComponent
 , Component, createDOMElement, createElement
 , staticComponent
 )
where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import FFI.Simple (args2, defineProperty, (..), (...))
import FFI.Simple.PseudoArray as PA

foreign import data Vue :: Type

foreign import vue :: Vue

-- basic types

newtype Component props = Component (EffectFn1 (Record props) Element)

-- | A Vue Element node
foreign import data Element :: Type

class IsComponent component (props :: # Type) children
  | component -> props, component -> children where
  createElement :: component -> Record props -> children -> Element

instance componentIsComponent :: IsComponent (Component props) props (Array Element) where
  createElement = rawCreateElement

rawCreateElement :: forall c p cs. c -> p -> Array cs -> Element
rawCreateElement c p cs = vue ... "h" $ args
  where args = PA.unshift c $ PA.unshift p cs

createDOMElement :: forall r. String -> Record r -> Array Element -> Element
createDOMElement = rawCreateElement

-- Component building

-- | The type of a function that can be turned into a component with
-- | `staticComponent`. Will not have access to the `Hooks` Monad.

type StaticComponent props = Record props -> Array Element -> Element

-- | Turns a `StaticComponent` function into a Component
staticComponent :: forall props. String -> StaticComponent props -> Component props
staticComponent name c = Component $ named name $ mkEffectFn1 c'
  where
    c' :: Record props -> Effect Element
    c' props = pure $ c props []

named
  :: forall props
  .  String
  -> EffectFn1 (Record props) Element
  -> EffectFn1 (Record props) Element
named = flip $ defineProperty "name"
