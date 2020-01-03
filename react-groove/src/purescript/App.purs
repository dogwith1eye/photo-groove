module App where

import Prelude

import Data.Array (drop, length, take)
import Reactix as R
import Reactix.DOM.HTML as H
import Reactix.React (Element)

type Props = ()
type Thumbnail = { url :: String }

app :: R.Component Props
app = R.hooksComponent "App" cpt
  where
  urlPrefix :: String
  urlPrefix = "http://elm-in-action.com/"

  thumbnails :: Array Thumbnail
  thumbnails =
    [ { url: "1.jpeg" }
    , { url: "2.jpeg" }
    , { url: "3.jpeg" }
    ]

  viewThumbnailCols :: Array Thumbnail -> Array Element
  viewThumbnailCols thumbs = cols <$> (chunks 2 thumbs)
    where
    cols :: Array Thumbnail -> Element
    cols xs = H.div { className: "columns" }
      (column (length xs) <<< viewThumbnail <$> xs)

    column :: Int -> Element -> Element
    column 1 a = H.div {className: "column is-half" } [ a ]
    column _ a = H.div {className: "column" } [ a ]

  viewThumbnail :: Thumbnail -> Element
  viewThumbnail thumb =
    H.figure { className: "image is-200by267 is-marginless" }
      [ H.img { src: urlPrefix <> thumb.url } ]

  chunks :: forall a. Int -> Array a -> Array (Array a)
  chunks _ [] = []
  chunks n xs = pure (take n xs) <> (chunks n $ drop n xs)

  cpt {} _ = do
    pure $ H.section { className: "section" }
      [ H.div { className: "content" }
        [ H.h1 {} [ H.text "Photo Groove" ]
        , H.div {} (viewThumbnailCols thumbnails) ]
      ]

mkApp :: Record Props -> Element
mkApp props = R.createElement app props []
