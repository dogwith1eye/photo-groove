module Widgets.Thumbnail2 where

import Prelude hiding (append)

import Data.Tuple (Tuple(..))
import Effect (Effect)
import Foreign.Object (Object)
import Specular.Dom.Builder.Class (elAttr, elDynAttr)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget, liftWidget, runMainWidgetInBody)
import Specular.FRP (Event, foldDyn, leftmost)
import Specular.FRP.Fix (fixFRP, fixFRP_)
import Specular.FRP.WeakDynamic (WeakDynamic)
import Widgets.Img (imgOnClick)

main :: Effect Unit
main = runMainWidgetInBody mainWidget2

mainWidget :: forall m. MonadWidget m => m Unit
mainWidget = fixFRP $ \selId -> do
  huh <- elAttr "div" ("class":="columns") do
    evImg1 <- elAttr "div" ("class":="column") do
      thumbnail "1.jpeg" selId
    evImg2 <- elAttr "div" ("class":="column") do
      thumbnail "2.jpeg" selId
    pure { evImg1, evImg2 }
  newId <- foldDyn ($) "1.jpeg" $ const <$> leftmost [huh.evImg1, huh.evImg2]
  pure (Tuple newId unit) 

mainWidget1 :: forall m. MonadWidget m => m Unit
mainWidget1 = fixFRP $ \selId -> do
  newId <- elAttr "div" ("class":="columns") do
    evImg1 <- elAttr "div" ("class":="column") do
      thumbnail "1.jpeg" selId
    evImg2 <- elAttr "div" ("class":="column") do
      thumbnail "2.jpeg" selId
    foldDyn ($) "1.jpeg" $ const <$> leftmost [evImg1, evImg2]
  pure (Tuple newId unit)

mainWidget2 :: forall m. MonadWidget m => m Unit
mainWidget2 = fixFRP_ $ \selId -> do
  newId <- elAttr "div" ("class":="columns") do
    evImg1 <- elAttr "div" ("class":="column") do
      thumbnail "1.jpeg" selId
    evImg2 <- elAttr "div" ("class":="column") do
      thumbnail "2.jpeg" selId
    foldDyn ($) "1.jpeg" $ const <$> leftmost [evImg1, evImg2]
  pure newId

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
