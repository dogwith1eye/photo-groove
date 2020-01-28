module App where

import Prelude hiding (append)


import Effect (Effect)
-- import Specular.Dom.Builder.Class (dynText, el, el_)
-- import Specular.Dom.Element(attr, attrs, class_, classes, text)
import Specular.Dom.Element(text)
--import Specular.Dom.Element.Class(el)
-- import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (liftWidget, class MonadWidget, RWidget, Widget, runMainWidgetInBody)
-- import Specular.Dom.Widgets.Button (buttonOnClick)
-- import Specular.FRP (class MonadFRP, Dynamic, Event, foldDyn, leftmost)
-- import Specular.FRP.Fix (fixFRP)
-- import Specular.FRP.WeakDynamic (WeakDynamic)

main :: Effect Unit
main = runMainWidgetInBody mainWidget

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

--mainWidget :: forall m. MonadWidget m => m Unit
mainWidget :: Widget Unit
mainWidget = text "huh"

mainWidget1 :: forall r. RWidget r Unit
mainWidget1 = text "huh"

mainWidget2 :: forall m. MonadWidget m => m Unit
mainWidget2 = liftWidget $ text "huh"

-- view :: forall m. MonadWidget m
--   => { }
--   -> m { }
-- view {} = do
--   el "div" [classes ["alert", "alert-warning", "alert-dismissible", "fade", "show"], attr "role" "alert"] do
--     el_ "Holy guacamole!"
--     text " You should check in on some of those fields below."

--   pure { }

-- control :: forall m. MonadFRP m
--   => {}
--   -> m (Tuple
--     { }
--     Unit
--     )
-- control {} = do
--   pure (Tuple {} unit)
