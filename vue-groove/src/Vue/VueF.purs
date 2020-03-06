module VueF
 ( Props, Setup, Element, ComponentF
 , createElement
 , createApp
 )
where

import Prelude

import Data.Function.Uncurried (runFn2, runFn3)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import FFI.Simple (applyTo, args1, args2, defineProperty, (..), (...))
import FFI.Simple.PseudoArray as PA

foreign import data Vue :: Type

foreign import vue :: Vue

-- | A Vue Element node
foreign import data Props :: Type
foreign import data Setup :: Type
foreign import data Element :: Type

createElement :: forall c p cs. c -> p -> Array cs -> Element
createElement c p cs = vue ... "h" $ args
  where args = PA.unshift c $ PA.unshift p cs

type ComponentF = Tuple Props Setup -> Element

createApp :: ComponentF -> Element
createApp f = vue ... "h" $ args
  where args = PA.unshift f
