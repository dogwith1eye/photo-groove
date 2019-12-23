module Bicounter where

import Prelude
import Data.Tuple.Nested ( (/\) )
import Reactix as R
import Reactix.DOM.HTML as H

type CounterProps = ( count :: Int )

data BicounterOp = Inc | Dec

bicounterCpt :: R.Component CounterProps
bicounterCpt = R.hooksComponent "Bicounter" cpt
  where
    cpt {count} _ = do
      y /\ reduceY <- R.useReducer' reduce count
      pure $ H.div { className: "counter" }
        [ H.button { type: "button",  on: { click: \_ -> reduceY Inc } } [ H.text "++" ]
        , H.button { type: "button",  on: { click: \_ -> reduceY Dec } } [ H.text "--" ]
        , H.div {} [ H.text (show y) ] ]
    reduce count Inc = count + 1
    reduce count Dec = count - 1
