module Vue
 ( render
 )
where

import Prelude

import DOM.Simple (createTextNode)
import Effect (Effect)
import FFI.Simple ((...))

foreign import data Vue :: Type

foreign import vue :: Vue

foreign import data VNode :: Type
foreign import data Element :: Type

createTextVNode::
  String ->
  Number ->
  VNode
createTextVNode text flag = vue ... "createTextVNode" text flag

render ::
  VNode ->
  Element ->
  Effect Unit
render vnode dom = vue ... "render" vnode dom
