module App where

import Prelude

import Data.Array (length)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Helpers (chunks, classList)
import Reactix as R
import Reactix.DOM.HTML as H
import Reactix.React (Element)

type Props = ()

urlPrefix :: String
urlPrefix = "http://elm-in-action.com/"

data Msg
  = None
  | ClickedPhoto String
  | ClickedSurpriseMe

view :: (Msg -> Effect Unit) -> Model -> Element
view dispatch model =
  H.section { className: "section" }
    [ H.div { className: "content" }
      [ H.h1 {} [ H.text "Photo Groove" ]
      , H.div { className: "columns" }
        [ H.div { className: "column" }
          [ H.div { className: "field is-horizontal" }
              [ H.div { className: "field-label" }
                [ H.label { className: "label" } [ H.text "Color:" ] ]
              , H.div { className: "field-body" }
                [ H.div { className: "field" } [] ]
              ]
          ]
        , H.div { className: "column" }
            [ H.div { className: "field" }
                [ H.div { className: "control" }
                    [ H.a { className: "button is-primary", on: { click: \_ -> dispatch ClickedSurpriseMe } } [ H.text "Surprise Me!" ] ]
                ]
            ]
        ]
      , H.div { className: "columns" }
        [ H.div { className: "column" } (viewThumbnailCols dispatch model)
        , H.div { className: "column" } [ H.img { className: "image is-fullwidth", src: urlPrefix <> model.selectedUrl } ]
        ]
      ]
    ]

viewThumbnailCols :: (Msg -> Effect Unit) -> Model -> Array Element
viewThumbnailCols dispatch model = cols <$> (chunks 2 model.photos)
  where
  cols :: Array Photo -> Element
  cols xs = H.div { className: "columns" }
    (viewThumbnail dispatch (length xs == 1) model.selectedUrl <$> xs)

viewThumbnail :: (Msg -> Effect Unit) -> Boolean -> String -> Photo -> Element
viewThumbnail dispatch isHalf selectedUrl thumb =
  H.div { className: classList [("column" /\ true), ("is-half" /\ isHalf), ("has-background-primary" /\ (selectedUrl == thumb.url)) ] }
      [ H.figure { className: "image is-200by267 is-marginless" }
        [ H.img { src: urlPrefix <> thumb.url, on: { click: \_ -> dispatch (ClickedPhoto thumb.url) } } ]
      ]

type Photo = { url :: String }

type Model = { photos :: Array Photo, selectedUrl :: String }

initialModel :: Model
initialModel =
  { photos:
    [ { url: "1.jpeg" }
    , { url: "2.jpeg" }
    , { url: "3.jpeg" }
    ]
  , selectedUrl: "1.jpeg"
  }

reducer :: Model -> Msg -> Model
reducer model = case _ of
  None -> model
  ClickedPhoto url -> model { selectedUrl = url }
  ClickedSurpriseMe -> model { selectedUrl = "2.jpeg" }

app :: R.Component Props
app = R.hooksComponent "App" cpt
  where
  cpt {} _ = do
    model /\ dispatch <- R.useReducer' reducer initialModel
    pure $ view dispatch model

mkApp :: Record Props -> Element
mkApp props = R.createElement app props []
