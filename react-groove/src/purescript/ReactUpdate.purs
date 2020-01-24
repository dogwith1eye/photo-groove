module ReactUpdate where


import Prelude
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Reactix as R

type SideEffect state action = Tuple state (action -> Effect Unit) -> Effect Unit
type UpdateModel state action = { state :: state, sideEffect :: Unit -> SideEffect state action }

data UpdateMsg state action
  = NoUpdate
  | Update state
  | SideEffect (SideEffect state action)

reducer :: forall s a. ((s -> a -> (UpdateMsg s a))) -> (UpdateModel s a) -> a -> (UpdateModel s a)
reducer r model msg = case (r model.state msg) of
  NoUpdate              -> model
  Update state          -> model { state = state }
  SideEffect sideEffect -> model { sideEffect = (\f -> sideEffect) }

useReducer' :: forall s a. (s -> a -> (UpdateMsg s a)) -> s -> R.Hooks (R.Reducer s a)
useReducer' r s = do
  updModel /\ dispatch <- R.useReducer' (reducer r) { state: s, sideEffect: (\x -> \y -> pure $ unit) }
  R.useEffect1' updModel.sideEffect $ do
    results <- updModel.sideEffect unit (updModel.state /\ dispatch)
    pure $ unit
  pure $ (updModel.state /\ dispatch)
