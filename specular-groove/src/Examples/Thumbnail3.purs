module Examples.Thumbnail3 where

import Prelude hiding (append)

import Data.Traversable(traverse)
import Effect (Effect)
import Widget.Img (imgOnClick)
import Foreign.Object (Object)
import Specular.Dom.Builder.Class (elAttr, elDynAttr)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget, liftWidget, runMainWidgetInBody)
import Specular.FRP (Event, foldDyn, leftmost)
import Specular.FRP.Fix (fixFRP_)
import Specular.FRP.WeakDynamic (WeakDynamic)

thumbnails :: Array String
thumbnails = ["1.jpeg", "2.jpeg"]

main :: Effect Unit
main = runMainWidgetInBody $ mainWidget thumbnails

mainWidget :: forall m. MonadWidget m => Array String -> m Unit
mainWidget thumbs = fixFRP_ $ \selId -> do
  newId <- elAttr "div" ("class":="columns") do
    evs <- traverse (thumbCol selId) thumbs
    foldDyn ($) "1.jpeg" $ const <$> leftmost evs
  pure newId
  where
    thumbCol selId thumb = elAttr "div" ("class":="column") do
      thumbnail thumb selId

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
