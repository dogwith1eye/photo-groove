module Helpers.Specular where

import Prelude

import Data.Tuple (Tuple)
import Specular.Dom.Browser (Node, TagName)
import Specular.Dom.Builder.Class (class MonadDomBuilder, elAttr', elAttr_, elDynAttr, elDynAttr')
import Specular.Dom.Node.Class ((:=))
import Specular.FRP (WeakDynamic)

ffor :: forall f a b. Functor f => f a -> (a -> b) -> f b
ffor = flip map

elDynClass' :: forall m a. MonadDomBuilder m => TagName -> WeakDynamic String -> m a -> m (Tuple Node a)
elDynClass' tagName cls = elDynAttr' tagName (map ((:=) "class") cls)

elDynClass :: forall m a. MonadDomBuilder m => TagName -> WeakDynamic String -> m a -> m a
elDynClass tagName cls inner = elDynAttr tagName (map ((:=) "class") cls) inner

elClass' :: forall m a. MonadDomBuilder m => TagName -> String -> m a -> m (Tuple Node a)
elClass' tagName cls = elAttr' tagName ("class" := cls)

elClass_ :: forall m. MonadDomBuilder m => TagName -> String -> m Unit
elClass_ tagName cls = elAttr_ tagName ("class" := cls)
