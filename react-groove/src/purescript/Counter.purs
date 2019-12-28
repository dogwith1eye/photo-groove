module Counter where

import Prelude
import Data.Tuple.Nested ( (/\) )
import Reactix as R
import Reactix.DOM.HTML as H
import Reactix.React (Element)

type Props = ( count :: Int, label :: String )

counter :: R.Component Props
counter = R.hooksComponent "Counter" cpt
  where
    cpt {count, label} _ = do
      y /\ setY <- R.useState' count
      pure $ H.div { className: "counter" }
        [ H.button { type: "button", on: { click: \_ -> setY (_ + 1) } } [ H.text "++" ]
        , H.div {} [ H.text (label <> ": " <> (show y)) ] ]

mkCounter :: Record Props -> Element
mkCounter props = R.createElement counter props []