module AppUpdate where

import Prelude

import Data.Array as Array
import Data.Maybe (Maybe(..))
import Data.Tuple(Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
--import Effect.Console (log, logShow)
import Effect.Random (randomInt)
import Helpers (chunks, classList)
import Reactix as R
import Reactix.DOM.HTML as H
import Reactix.React (Element)
import ReactUpdate (UpdateMsg(..), useReducer')

type Props = ()

urlPrefix :: String
urlPrefix = "http://elm-in-action.com/"

data Msg
  = None
  | ClickedColor ThumbnailColor
  | ClickedPhoto String
  | ClickedSurpriseMe
  | GotSelectedIndex Int

view :: (Msg -> Effect Unit) -> Model -> Element
view dispatch model =
  H.section { className: "section" }
    [ H.div { className: "content" }
      [ H.h1 {} [ H.text "Photo Groove" ]
      , H.div { className: "columns" }
        [ H.div { className: "column" }
          [ H.div { className: "field is-horizontal is-pulled-left" }
              [ H.div { className: "field-label" }
                [ H.label { className: "label" } [ H.text "Color:" ] ]
              , H.div { className: "field-body" }
                [ H.div { className: "field" }
                  [ H.div { className: "control" } (viewColorChooser dispatch <$> [ Primary, Info, Danger ]) ]
                ]
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
    (viewThumbnail dispatch model.chosenColor (Array.length xs == 1) model.selectedUrl <$> xs)

viewThumbnail :: (Msg -> Effect Unit) -> ThumbnailColor -> Boolean -> String -> Photo -> Element
viewThumbnail dispatch chosenColor isHalf selectedUrl thumb =
  H.div { className: classList [("column" /\ true), ("is-half" /\ isHalf), (colorClass /\ isSelected) ] }
      [ H.figure { className: "image is-200by267 is-marginless" }
        [ H.img { src: urlPrefix <> thumb.url, on: { click: \_ -> dispatch (ClickedPhoto thumb.url) } } ]
      ]
  where
    colorClass = colorToClass chosenColor
    isSelected = selectedUrl == thumb.url

viewColorChooser ::  (Msg -> Effect Unit) -> ThumbnailColor -> Element
viewColorChooser dispatch color =
    H.label { className: "radio" }
      [ H.input { type: "radio", name: "color", on: { click: \_ -> dispatch (ClickedColor color) } }
      , H.text ("\n" <> show color)
      ]

data ThumbnailColor
    = Primary
    | Info
    | Danger

instance showThumbnailColor :: Show ThumbnailColor where
  show Primary = "Primary"
  show Info = "Info"
  show Danger = "Danger"

colorToClass :: ThumbnailColor -> String
colorToClass = case _ of
  Primary -> "has-background-primary"
  Info    -> "has-background-info"
  Danger  -> "has-background-danger"

type Photo = { url :: String }

type Model = { photos :: Array Photo, selectedUrl :: String, chosenColor :: ThumbnailColor }

initialModel :: Model
initialModel =
  { photos:
    [ { url: "1.jpeg" }
    , { url: "2.jpeg" }
    , { url: "3.jpeg" }
    ]
  , selectedUrl: "1.jpeg"
  , chosenColor: Primary
  }

getPhotoUrl :: Int -> String
getPhotoUrl index =
  case Array.index initialModel.photos index of
    Just photo -> photo.url
    Nothing -> ""

surpriseMe :: Tuple Model (Msg -> Effect Unit) -> Effect Unit
surpriseMe (state /\ dispatch) = do
    index <- randomInt 0 (Array.length initialModel.photos - 1)
    dispatch (GotSelectedIndex index)

reducer :: Model -> Msg -> (UpdateMsg Model Msg)
reducer model = case _ of
  None                   -> Update(model)
  ClickedColor color     -> Update(model { chosenColor = color })
  ClickedPhoto url       -> Update(model { selectedUrl = url })
  ClickedSurpriseMe      -> SideEffect(surpriseMe)
  GotSelectedIndex index -> Update(model { selectedUrl = getPhotoUrl index })

app :: R.Component Props
app = R.hooksComponent "App" cpt
  where
  cpt {} _ = do
    model /\ dispatch <- useReducer' reducer initialModel
    pure $ view dispatch model

mkApp :: Record Props -> Element
mkApp props = R.createElement app props []
