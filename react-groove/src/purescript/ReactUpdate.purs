module ReactUpdate where


import Prelude
import Data.Array as Array
import Data.Traversable (traverse)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Reactix as R

type SideEffect state action = Tuple state (action -> Effect Unit) -> Effect Unit
type UpdateModel state action = { state :: state, sideEffects :: Array (SideEffect state action) }

data UpdateMsg state action
  = NoUpdate
  | Update state
  | SideEffect (SideEffect state action)

reducer :: forall s a. ((s -> a -> (UpdateMsg s a))) -> (UpdateModel s a) -> a -> (UpdateModel s a)
reducer r model msg = case (r model.state msg) of
  NoUpdate              -> model
  Update state          -> model { state = state }
  SideEffect sideEffect -> model { sideEffects = Array.snoc model.sideEffects sideEffect }

useReducer' :: forall s a. (s -> a -> (UpdateMsg s a)) -> s -> R.Hooks (R.Reducer s a)
useReducer' r s = do
  updModel /\ dispatch <- R.useReducer' (reducer r) { state: s, sideEffects: [] }
  R.useEffect1' updModel.sideEffects $ do
    results <- traverse (\f -> f (updModel.state /\ dispatch)) updModel.sideEffects
    pure $ unit
  pure $ (updModel.state /\ dispatch)
