module VueF
 ( Props, Setup, Element, Component, Slot
 , render, component, slot, slotProp, slotPropString
 )
where

import Prelude

import Data.Function.Uncurried (mkFn2)
import FFI.Simple ((..), (...))
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

component :: forall cs. Component -> Array cs -> Element
component c cs = render (mkFn2 c) {} cs

foreign import data Slot :: Type

slot :: Setup -> String -> Slot
slot ctx name = ctx .. "slots" ... name $ []

slotProp :: forall p. Setup -> String -> (Record p) -> Slot
slotProp ctx name prop = ctx .. "slots" ... name $ [prop]

slotPropString :: Setup -> String -> String -> Slot
slotPropString ctx name prop = ctx .. "slots" ... name $ [prop]
