module Examples.Thumbnail where

import Prelude hiding (append)

import Data.Tuple (Tuple(..))
import Effect (Effect)
import Foreign.Object (Object)
import Specular.Dom.Builder.Class (elAttr, elDynAttr)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget, liftWidget, runMainWidgetInBody)
import Specular.FRP (class MonadFRP, Dynamic, Event, foldDyn)
import Specular.FRP.Fix (fixFRP)
import Specular.FRP.WeakDynamic (WeakDynamic)
import Widget.Img (imgOnClick)

main :: Effect Unit
main = runMainWidgetInBody mainWidget

mainWidget :: forall m. MonadWidget m => m Unit
mainWidget = fixFRP $ view >=> control

control :: forall m. MonadFRP m => { evClick :: Event Unit } -> m (Tuple { isSelected :: Dynamic Boolean } Unit)
control { evClick } = do
  isSelected <- foldDyn ($) false $ (_ # not) <$ evClick
  pure (Tuple { isSelected } unit)

view :: forall m. MonadWidget m => { isSelected :: WeakDynamic Boolean } -> m { evClick :: Event Unit }
view { isSelected } = liftWidget $ do
  evClick <- elDynAttr "div" dynAttr do
    elAttr "div" ("class":="image is-200by267 is-marginless") do
      imgOnClick (pure $ "src":="http://elm-in-action.com/1.jpeg")

  pure { evClick }
  where
    dynAttr :: WeakDynamic (Object String)
    dynAttr = flip map isSelected $ (case _ of
      true -> ("class" := "column")
      false -> ("class" := "column has-background-primary"))
