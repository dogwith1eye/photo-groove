module App where

import Prelude hiding (append)

import Data.Foldable (for_)
import Data.Traversable(traverse)
import Effect (Effect)
import Foreign.Object (Object)
import Specular.Dom.Builder.Class (el, elAttr, elDynAttr, text)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget, liftWidget, runMainWidgetInBody)
import Specular.FRP (Event, foldDyn, leftmost)
import Specular.FRP.Fix (fixFRP_)
import Specular.FRP.WeakDynamic (WeakDynamic)
import Widget.Img (imgOnClick)

urlPrefix :: String
urlPrefix = "http://elm-in-action.com/"

type Photo = { url :: String }

data ThumbnailColor
    = Primary
    | Info
    | Danger

instance showThumbnailColor :: Show ThumbnailColor where
  show Primary = "Primary"
  show Info = "Info"
  show Danger = "Danger"

type Model = { photos :: Array Photo, selectedUrl :: String, chosenColor :: ThumbnailColor, surpriseMe :: Boolean }

initialModel :: Model
initialModel =
  { photos:
    [ { url: "1.jpeg" }
    , { url: "2.jpeg" }
    , { url: "3.jpeg" }
    ]
  , selectedUrl: "1.jpeg"
  , chosenColor: Primary
  , surpriseMe: false
  }

view :: forall m. MonadWidget m => Model -> m Unit
view model = fixFRP_ $ \selId -> do
  newId <- elAttr "section" ("class":="section") do
    elAttr "div" ("class":="content") do
      el "h1" $ text "Photo Groove"
      elAttr "div" ("class":="columns") do
        elAttr "div" ("class":="column") do
          elAttr "div" ("class":="field is-horizontal is-pulled-left") do
            elAttr "div" ("class":="field-label") do
              elAttr "label" ("class":="label") $ text "Color:"
            elAttr "div" ("class":="field-body") do
              elAttr "div" ("class":="field") do
                elAttr "div" ("class":="control") $ text "viewColorChooser"
        elAttr "div" ("class":="column") do
          elAttr "div" ("class":="field") do
            elAttr "div" ("class":="control") $ text "Surprise Me!"
      elAttr "div" ("class":="columns") do
        t1Id <- elAttr "div" ("class":="column") do
          evs <- traverse (thumbnail selId) model.photos
          foldDyn ($) model.selectedUrl $ const <$> leftmost evs
        elAttr "div" ("class":="column") $ text "selected"
        pure t1Id
  pure newId

thumbnail :: forall m. MonadWidget m => WeakDynamic String -> Photo -> m (Event String)
thumbnail selId thumb = liftWidget $ do
  ev <- elDynAttr "div" dynAttr do
    elAttr "div" ("class":="image is-200by267 is-marginless") do
      imgOnClick (pure $ "src":=(urlPrefix <> thumb.url))
  pure $ thumb.url <$ ev
  where
    dynAttr :: WeakDynamic (Object String)
    dynAttr = flip map selId $ (\x -> case (x /= thumb.url) of
      true -> ("class" := "column")
      false -> ("class" := "column has-background-primary"))

main :: Effect Unit
main = runMainWidgetInBody (view initialModel)
