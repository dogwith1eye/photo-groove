module Widgets.Thumb (
    imgOnClick
) where

import Prelude

import Data.Tuple (Tuple(..))
import Specular.Dom.Builder.Class (domEventWithSample, elDynAttr')
import Specular.Dom.Node.Class (Attrs)
import Specular.Dom.Widget (class MonadWidget)
import Specular.FRP (Event, WeakDynamic)

-- | `imgOnClick attrs` - Creates a HTML `<img>` element with the
-- | specified dynamic attributes.
-- |
-- | Returns an Event that occurs when the img is clicked.
imgOnClick :: forall m. MonadWidget m => WeakDynamic Attrs -> m (Event Unit)
imgOnClick attrs = do
  Tuple node _ <- elDynAttr' "img" attrs (pure unit)
  domEventWithSample (\_ -> pure unit) "click" node

-- module Thumb where

-- import Prelude hiding (append)

-- import Data.Maybe (Maybe(..))
-- import Data.Tuple (Tuple(..))
-- import Effect (Effect)
-- import Specular.Dom.Element (attr, attrs, class_, classes, el, el_, text)
-- import Specular.Dom.Node.Class ((:=))
-- import Specular.Dom.Widget (class MonadWidget, liftWidget, RWidget, Widget, runMainWidgetInBody)
-- import Specular.FRP (class MonadFRP, Dynamic, Event, foldDyn, leftmost, readDynamic)
-- import Specular.FRP.Fix (fixFRP, fixFRP_)
-- import Specular.FRP.WeakDynamic (WeakDynamic, unWeakDynamic)
-- import Widgets.Img (imgOnClick)

-- urlPrefix :: String
-- urlPrefix = "http://elm-in-action.com/"

-- type Photo = { url :: String }

-- data ThumbnailColor
--     = Primary
--     | Info
--     | Danger

-- instance showThumbnailColor :: Show ThumbnailColor where
--   show Primary = "Primary"
--   show Info = "Info"
--   show Danger = "Danger"

-- type Model = { photos :: Array Photo, photo :: Photo, selectedUrl :: String, chosenColor :: ThumbnailColor, surpriseMe :: Boolean }

-- initialModel :: Model
-- initialModel =
--   { photos:
--     [ { url: "1.jpeg" }
--     , { url: "2.jpeg" }
--     , { url: "3.jpeg" }
--     ]
--   , photo: { url: "1.jpeg" }
--   , selectedUrl: "1.jpeg"
--   , chosenColor: Primary
--   , surpriseMe: false
--   }

-- mainWidget :: Widget Unit
-- mainWidget = text "huh"

-- mainWidget1 :: forall r. RWidget r Unit
-- mainWidget1 = text "huh"

-- mainWidget2 :: forall m. MonadWidget m => m Unit
-- mainWidget2 = liftWidget $ text "huh"

-- testWidget :: forall m. MonadWidget m => m Unit
-- testWidget = liftWidget $
--   el "div" [classes ["alert", "alert-warning", "alert-dismissible", "fade", "show"], attr "role" "alert"] do
--   el_ "strong" $ text "Holy guacamole!"
--   text " You should check in on some of those fields below."
--   el "button" [class_ "close", attrs ("type":="button" <> "data-dismiss":="alert" <> "aria-label":="Close")] do
--     el "span" [attr "aria-hidden"  "true"] do
--       text "×"

-- viewDynamic :: WeakDynamic String -> Widget (Event String)
-- viewDynamic model = do
--   dynVal <- readDynamic $ unWeakDynamic model
--   case dynVal of
--     Just dynVal' -> viewThumbnail dynVal'
--     Nothing -> viewThumbnail ""

-- -- view :: Model -> Widget (Event String)
-- -- view model = liftWidget $
-- --   viewThumbnail model.photo

-- -- view :: Model -> Widget Unit
-- -- view model = liftWidget $
-- --   el "section" [class_ "section"] do
-- --     el "div" [class_ "content"] do
-- --       el_ "h1" $ text "Photo Groove"
-- --       el "div" [class_ "columns"] do
-- --         el "div" [class_ "column"] do
-- --           el "div" [classes ["field", "is-horizontal", "is-pulled-left"]] do
-- --             el "div" [class_ "field-label"] do
-- --               el "label" [class_ "label"] $ text "Color:"
-- --             el "div" [class_ "field-body"] do
-- --               el "div" [class_ "field"] do
-- --                 el "div" [class_ "control"] $ text "viewColorChooser"
-- --         el "div" [class_ "column"] do
-- --           el "div" [class_ "field"] do
-- --             el "div" [class_ "control"] $ text "Surprise Me!"
-- --       el "div" [class_ "columns"] do
-- --         el "div" [class_ "column"] do
-- --           for_ model.photos $ viewThumbnail
-- --         el "div" [class_ "column"] $ text "selected"

-- -- viewThumbnail1 :: forall m. MonadWidget m => Photo -> m { selected :: Event Unit }
-- -- viewThumbnail1 thumb = liftWidget $
-- --   el "div" [class_ "column"] do
-- --     el "div" [classes ["image", "is-200by267", "is-marginless"]] do
-- --       selected <- imgOnClick (pure $ "src":=(urlPrefix <> thumb.url))
-- --       pure { selected }

-- --viewThumbnail :: Model -> Widget (Event String)
-- viewThumbnail :: forall m. MonadWidget m => String -> m (Event String)
-- viewThumbnail model = do
--   -- el "div" [class_ "column"] do
--   --   el "div" [classes ["image", "is-200by267", "is-marginless"]] do
--   --     selected <- imgOnClick (pure $ "src":=src)
--   --     --pure $ (const src) <$> selected
--   --     pure selected
--   -- where
--   --   src = urlPrefix <> model.photo.url
--   selected <- imgOnClick (pure $ "src":=src)
--   pure $ (const src) <$> selected
--   where
--     src = urlPrefix <> model

-- control :: forall m. MonadFRP m
--   => (Event String)
--   -> m (Tuple (Dynamic String) Unit)
-- control selected = do
--   value <- foldDyn ($) "" $
--     leftmost
--       [ (\_ -> "2.jpeg") <$ selected
--       ]
--   pure (Tuple value unit)

-- --appWidget :: forall m. MonadWidget m => m (Event String)
-- appWidget :: forall m. MonadWidget m => m Unit
-- appWidget = fixFRP_ $ viewDynamic >=> control

-- main :: Effect Unit
-- main = runMainWidgetInBody appWidget
