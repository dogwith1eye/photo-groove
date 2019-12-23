module Counter where

import Prelude
import Data.Tuple.Nested ( (/\) )
import Reactix as R
import Reactix.DOM.HTML as H

type CounterProps = ( count :: Int )

counterCpt :: R.Component CounterProps
counterCpt = R.hooksComponent "Counter" cpt
  where
    cpt {count} _ = do
      y /\ setY <- R.useState' count
      pure $ H.div { className: "counter" }
        [ H.button { type: "button", on: { click: \_ -> setY (_ + 1) } } [ H.text "++" ]
        , H.div {} [ H.text (show y) ] ]
