module Component.App where

import Prelude

import Component.Data (Message(..), Photo)
import Component.Helpers (chunks)
import Component.Thumbnail (thumbnail)
import Data.Array (length)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Reactix as R
import Reactix.DOM.HTML as H
import Reactix.React (Element)

type Props = ()

type Model = { photos :: Array Photo, selectedUrl :: String }

app :: R.Component Props
app = R.hooksComponent "App" cpt
  where
  urlPrefix :: String
  urlPrefix = "http://elm-in-action.com/"

  initialModel :: Model
  initialModel =
    { photos:
      [ { url: "1.jpeg" }
      , { url: "2.jpeg" }
      , { url: "3.jpeg" }
      ]
    , selectedUrl: "1.jpeg"
    }

  viewThumbnailCols :: (Message -> Effect Unit) -> Model -> Array Element
  viewThumbnailCols reduceMsg model = cols <$> (chunks 2 model.photos)
    where
    cols :: Array Photo -> Element
    cols xs = H.div { className: "columns" }
      (viewThumbnail (length xs == 1) <$> xs)

    viewThumbnail :: Boolean -> Photo -> Element
    viewThumbnail isHalf thumb =
      thumbnail
        { urlPrefix: urlPrefix
        , url: thumb.url
        , selected: thumb.url == model.selectedUrl
        , isHalf: isHalf
        , reduceMsg: reduceMsg
        }

  reducer :: Model -> Message -> Model
  reducer model = case _ of
    None -> model
    ClickedPhoto url -> model { selectedUrl = url }

  cpt {} _ = do
    model /\ dispatch <- R.useReducer' reducer initialModel
    pure $ H.section { className: "section" }
      [ H.div { className: "content" }
        [ H.h1 {} [ H.text "Photo Groove" ]
        , H.div { className: "columns" }
          [ H.div { className: "column" } (viewThumbnailCols dispatch model)
          , H.div { className: "column" } [ H.img { className: "image is-fullwidth", src: urlPrefix <> model.selectedUrl } ]
          ]
        ]
      ]

mkApp :: Record Props -> Element
mkApp props = R.createElement app props []
