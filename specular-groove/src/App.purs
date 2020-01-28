module App where

import Prelude hiding (append)


import Effect (Effect)
-- import Specular.Dom.Builder.Class (dynText, el, el_)
import Specular.Dom.Element(attr, attrs, class_, classes, el, el_, text)
--import Specular.Dom.Element.Class(el)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (liftWidget, class MonadWidget, RWidget, Widget, runMainWidgetInBody)
-- import Specular.Dom.Widgets.Button (buttonOnClick)
-- import Specular.FRP (class MonadFRP, Dynamic, Event, foldDyn, leftmost)
-- import Specular.FRP.Fix (fixFRP)
-- import Specular.FRP.WeakDynamic (WeakDynamic)

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

mainWidget :: Widget Unit
mainWidget = text "huh"

mainWidget1 :: forall r. RWidget r Unit
mainWidget1 = text "huh"

mainWidget2 :: forall m. MonadWidget m => m Unit
mainWidget2 = liftWidget $ text "huh"

testWidget :: forall m. MonadWidget m => m Unit
testWidget = liftWidget $
  el "div" [classes ["alert", "alert-warning", "alert-dismissible", "fade", "show"], attr "role" "alert"] do
  el_ "strong" $ text "Holy guacamole!"
  text " You should check in on some of those fields below."
  el "button" [class_ "close", attrs ("type":="button" <> "data-dismiss":="alert" <> "aria-label":="Close")] do
    el "span" [attr "aria-hidden"  "true"] do
      text "×"

view :: forall m. MonadWidget m => m Unit
view = liftWidget $
  el "section" [class_ "section"] do
    el "div" [class_ "content"] do
      el_ "h1" $ text "Photo Groove"
      el "div" [class_ "columns"] do
        el "div" [class_ "column"] do
          el "div" [classes ["field", "is-horizontal", "is-pulled-left"]] do
            el "div" [class_ "field-label"] do
              el "label" [class_ "label"] $ text "Color:"
            el "div" [class_ "field-body"] do
              el "div" [class_ "field"] do
                el "div" [class_ "control"] $ text "viewColorChooser"
        el "div" [class_ "column"] do
          el "div" [class_ "field"] do
            el "div" [class_ "control"] $ text "Surprise Me!"
      el "div" [class_ "columns"] do
        el "div" [class_ "column"] $ text "photos"
        el "div" [class_ "column"] $ text "selected"

main :: Effect Unit
main = runMainWidgetInBody view
