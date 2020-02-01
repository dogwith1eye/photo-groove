module Widgets.Thumbnail1 where

import Prelude hiding (append)

import Data.Tuple (Tuple(..))
import Effect (Effect)
import Foreign.Object (Object)
import Specular.Dom.Builder.Class (dynText,elAttr, elDynAttr)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget, liftWidget, runMainWidgetInBody)
import Specular.FRP (Dynamic, Event, foldDyn, leftmost)
import Specular.FRP.Fix (fixFRP)
import Specular.FRP.WeakDynamic (WeakDynamic)
import Widgets.Img (imgOnClick)

main :: Effect Unit
main = runMainWidgetInBody mainWidget

mainWidget :: forall m. MonadWidget m => m Unit
mainWidget = fixFRP $ view >=> control

control :: forall m. MonadWidget m => { evImg1 :: Event String, evImg2 :: Event String } -> m (Tuple (Dynamic String) Unit)
control { evImg1, evImg2 } = do
  selId <- foldDyn ($) "1.jpeg" $ const <$> leftmost [evImg1, evImg2]
  pure (Tuple selId unit)

view :: forall m. MonadWidget m => WeakDynamic String -> m { evImg1 :: Event String, evImg2 :: Event String }
view selId = liftWidget $ do
  huh <- elAttr "div" ("class":="columns") do
    evImg1 <- elAttr "div" ("class":="column") do
      thumbnail "1.jpeg" selId
    evImg2 <- elAttr "div" ("class":="column") do
      thumbnail "2.jpeg" selId
    pure { evImg1, evImg2 }
  _ <- dynText selId
  pure huh

thumbnail :: forall m. MonadWidget m => String -> WeakDynamic String -> m (Event String)
thumbnail id selId = liftWidget $ do
  ev <- elDynAttr "div" dynAttr do
    elAttr "div" ("class":="image is-200by267 is-marginless") do
      imgOnClick (pure $ "src":=("http://elm-in-action.com/" <> id))
  pure $ id <$ ev
  where
    dynAttr :: WeakDynamic (Object String)
    dynAttr = flip map selId $ (\x -> case (x /= id) of
      true -> ("class" := "column")
      false -> ("class" := "column has-background-primary"))
