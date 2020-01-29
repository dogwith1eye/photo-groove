module Widgets.Counter (mainWidget) where

import Prelude hiding (append)

import Data.Tuple (Tuple(..))
import Specular.Dom.Builder.Class (dynText, el, text)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget)
import Specular.Dom.Widgets.Button (buttonOnClick)
import Specular.FRP (class MonadFRP, Dynamic, Event, foldDyn, leftmost)
import Specular.FRP.Fix (fixFRP)
import Specular.FRP.WeakDynamic (WeakDynamic)

mainWidget :: forall m. MonadWidget m => m Unit
mainWidget = fixFRP $ view >=> control

view :: forall m. MonadWidget m
  => { value :: WeakDynamic Int }
  -> m
    { increment :: Event Unit
    , decrement :: Event Unit
    }
view {value} = do
  el "p" $ dynText (show <$> value)

  increment <- buttonOnClick (pure $ "class" := "increment") $ text "Increment"
  decrement <- buttonOnClick (pure $ "class" := "decrement") $ text "Decrement"

  pure { increment, decrement }

control :: forall m. MonadFRP m
  => { increment :: Event Unit
     , decrement :: Event Unit
     }
  -> m (Tuple
    { value :: Dynamic Int }
    Unit
    )
control {increment,decrement} = do
  value <- foldDyn ($) 0 $
    leftmost
      [ (_ + 1) <$ increment
      , (_ - 1) <$ decrement
      ]
  pure (Tuple {value} unit)
