module Effcounter where

import Prelude
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ( (/\) )
import Effect (Effect)
import Reactix as R
import Reactix.DOM.HTML as H
import Reactix.React (Element)

type Props = ( count :: Int, label :: String, onClick :: Int -> Effect Unit, counterType :: CounterOp )

data CounterOp = Increment | Decrement

counterOpToString :: CounterOp -> String
counterOpToString = case _ of
  Increment -> "increment"
  Decrement -> "decrement"

counterOpFromString :: String -> Maybe CounterOp
counterOpFromString = case _ of
  "increment" -> Just Increment
  "decrement" -> Just Decrement
  _ -> Nothing

effcounter :: R.Component Props
effcounter = R.hooksComponent "Effcounter" cpt
  where
    cpt {count, label, onClick, counterType} _ = do
      y /\ reduceY <- R.useReducer' reduce count
      R.useEffect $ do
        onClick y
        pure mempty
      pure $ H.div { className: "counter" }
        [ H.button { type: "button",  on: { click: \_ -> reduceY counterType } } [ H.text "++" ]
        , H.div {} [ H.text (label <> ": " <> (show y)) ] ]
    reduce count Increment = count + 1
    reduce count Decrement = count - 1

mkEffcounter :: Record Props -> Element
mkEffcounter props = R.createElement effcounter props []