module Thumbnail where

import Prelude

import Data (Message(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Helpers (classList)
import Reactix as R
import Reactix.DOM.HTML as H
import Reactix.React (Element)

type Props = ( urlPrefix :: String, url :: String, selected :: Boolean, isHalf :: Boolean, reduceMsg :: Message -> Effect Unit)

thumbnailCpt :: R.Component Props
thumbnailCpt = R.hooksComponent "Thumbnail" cpt
  where
  cpt { urlPrefix, url, selected, isHalf, reduceMsg } _ = do
    pure $ H.div { className: classList [("column" /\ true), ("is-half" /\ isHalf), ("has-background-primary" /\ selected) ] }
      [ H.figure { className: "image is-200by267 is-marginless" }
        [ H.img { src: urlPrefix <> url, on: { click: \_ -> reduceMsg (ClickedPhoto url) } } ]
      ]

thumbnail :: Record Props -> Element
thumbnail props = R.createElement thumbnailCpt props []
