module Widgets.Counter1 (mainWidget) where

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
    { increment :: Event Int
    }
view {value} = do
  el "p" $ dynText (show <$> value)

  increment <- buttonOnClick (pure $ "class" := "increment") $ text "Increment"

  pure { increment: (const 5) <$> increment }

control :: forall m. MonadFRP m
  => { increment :: Event Int
     }
  -> m (Tuple
    { value :: Dynamic Int }
    Unit
    )
control {increment} = do
  value <- foldDyn ($) 0 $
    leftmost
      [ (_ + 1) <$ increment
      ]
  pure (Tuple {value} unit)
