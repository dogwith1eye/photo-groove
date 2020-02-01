module Widgets.VisibleFix where

import Prelude hiding (append)

import Data.Tuple (Tuple(..))
import Effect (Effect)
import Foreign.Object (Object)
import Specular.Dom.Builder.Class (elDynAttr)
import Specular.Dom.Element (text)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget, liftWidget, runMainWidgetInBody)
import Specular.Dom.Widgets.Button (buttonOnClick)
import Specular.FRP (class MonadFRP, Dynamic, Event, foldDyn)
import Specular.FRP.Fix (fixFRP)
import Specular.FRP.WeakDynamic (WeakDynamic)

main :: Effect Unit
main = runMainWidgetInBody mainWidget

mainWidget :: forall m. MonadWidget m => m Unit
mainWidget = fixFRP $ view >=> control

control :: forall m. MonadFRP m => { evClick :: Event Unit } -> m (Tuple { isVisible :: Dynamic Boolean } Unit)
control { evClick } = do
  isVisible <- foldDyn ($) false $ (_ # not) <$ evClick
  pure (Tuple { isVisible } unit)

view :: forall m. MonadWidget m => { isVisible :: WeakDynamic Boolean } -> m { evClick :: Event Unit }
view { isVisible } = liftWidget $ do
  evClick <- buttonOnClick (pure mempty) $ text "Click Me!"

  elDynAttr "div" dynAttr $ text "Click the button again to make me disappear!"

  pure { evClick }
  where
    dynAttr :: WeakDynamic (Object String)
    dynAttr = flip map isVisible $ (case _ of
      true -> ("style" := "")
      false -> ("style" := "display: none;" ))
