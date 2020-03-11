module VueF
 ( Props, Setup, Element, Component
 , render, component
 )
where

import Prelude

import Data.Function.Uncurried (mkFn2)
import FFI.Simple ((...))
import FFI.Simple.PseudoArray as PA

foreign import data Vue :: Type

foreign import vue :: Vue

foreign import data Props :: Type
foreign import data Setup :: Type
foreign import data Element :: Type

type Component = Props -> Setup -> Element

render :: forall c p cs. c -> p -> Array cs -> Element
render c p cs = vue ... "h" $ args
  where args = PA.unshift c $ PA.unshift p cs

component :: forall p cs. Component -> p -> Array cs -> Element
component c p cs = render (mkFn2 c) p cs
