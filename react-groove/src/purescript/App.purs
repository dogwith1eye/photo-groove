module App where

import Prelude

import Data (Message(..), Photo)
import Data.Array (length)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Helpers (chunks)
import Reactix as R
import Reactix.DOM.HTML as H
import Reactix.React (Element)
import Thumbnail (thumbnail)

type Props = ()

type Model = { photos :: Array Photo, selectedUrl :: String }

reducer :: Model -> Message -> Model
reducer model = case _ of
  None -> model
  ClickedPhoto url -> model { selectedUrl = url }

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

  viewThumbnailCols :: ((Message -> Message) -> Effect Unit) -> Model -> Array Element
  viewThumbnailCols setMsg model = cols <$> (chunks 2 model.photos)
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
        , setMsg: setMsg
        }

  cpt {} _ = do
    model /\ dispatch <- R.useReducer' reducer initialModel
    pure $ H.section { className: "section" }
      [ H.div { className: "content" }
        [ H.h1 {} [ H.text "Photo Groove" ]
        , H.div { className: "columns" }
          [ H.div { className: "column" } (viewThumbnailCols dispatch initialModel)
          , H.div { className: "column" } [ H.img { className: "image is-fullwidth", src: urlPrefix <> initialModel.selectedUrl } ]
          ]
        ]
      ]

mkApp :: Record Props -> Element
mkApp props = R.createElement app props []
