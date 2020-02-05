module Examples.Thumbnail4 where

import Prelude hiding (append)

import Data.Traversable (traverse)
import Effect (Effect)
import Foreign.Object (Object)
import Specular.Dom.Builder.Class (elAttr, elAttr_, elDynAttr, text)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget, liftWidget, runMainWidgetInBody)
import Specular.FRP (Event, foldDyn, leftmost)
import Specular.FRP.Fix (fixFRP_)
import Specular.FRP.WeakDynamic (WeakDynamic)
import Widget.Img (imgOnClick)

thumbnails :: Array String
thumbnails = ["1.jpeg", "2.jpeg"]

main :: Effect Unit
main = runMainWidgetInBody $ mainWidget thumbnails

mainWidget :: forall m. MonadWidget m => Array String -> m Unit
mainWidget thumbs = fixFRP_ $ \selId -> do
  elAttr "div" ("class":="columns") do
    tempId <- elAttr "div" ("class":="column") do
      evs <- traverse (thumbCol selId) thumbs
      foldDyn ($) "1.jpeg" $ const <$> leftmost evs
    elAttr "div" ("class":="column") $ text "selected"
    pure tempId
  where
    thumbCol selId thumb = elAttr "div" ("class":="column") do
      thumbnail selId thumb

thumbnail :: forall m. MonadWidget m => WeakDynamic String -> String -> m (Event String)
thumbnail selId id = liftWidget $ do
  ev <- elDynAttr "div" dynAttr do
    elAttr "div" ("class":="image is-200by267 is-marginless") do
      imgOnClick (pure $ "src":=("http://elm-in-action.com/" <> id))
  pure $ id <$ ev
  where
    dynAttr :: WeakDynamic (Object String)
    dynAttr = flip map selId $ (\x -> case (x /= id) of
      true -> ("class" := "column")
      false -> ("class" := "column has-background-primary"))
