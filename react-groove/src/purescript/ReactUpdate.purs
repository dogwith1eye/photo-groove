module ReactUpdate where

import Prelude
import Data.Array as Array
import Data.Tuple(Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Reactix as R

type UpdateModel state action = { state :: state, sideEffects :: Array (Tuple state (action -> Effect Unit) -> Effect Unit) }

data UpdateMsg state action
  = NoUpdate
  | Update state
  | SideEffect (Tuple state (action -> Effect Unit) -> Effect Unit)

reducer :: forall s a. ((s -> a -> (UpdateMsg s a))) -> (UpdateModel s a) -> a -> (UpdateModel s a)
reducer r model msg = case (r model.state msg) of
  NoUpdate              -> model
  Update state          -> model { state = state }
  SideEffect sideEffect -> model { sideEffects = Array.snoc model.sideEffects sideEffect }

useReducer' :: forall s a. (s -> a -> (UpdateMsg s a)) -> s -> R.Hooks (R.Reducer s a)
useReducer' r s = do
  updModel /\ dispatch <- R.useReducer' (reducer r) { state: s, sideEffects: [] }
  pure $ (updModel.state /\ dispatch)
