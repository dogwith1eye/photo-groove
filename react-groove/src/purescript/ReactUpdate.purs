module ReactUpdate where

import Prelude

import Data.Array as Array
import Data.Tuple.Nested ((/\))
import Data.Traversable (traverse)
import Effect (Effect)
import Reactix as R

type Self a s = { dispatch :: a -> Effect Unit, state :: s }
type FullState a s = { state :: s, sideEffects :: Array((Self a s) -> Effect Unit) }

data Msg a s
  = NoUpdate
  | Update s
  | SideEffect ((Self a s) -> Effect Unit)
  | UpdateWithSideEffect s ((Self a s) -> Effect Unit)

useHuh' :: forall s a. (s -> a -> s) -> s -> R.Hooks (R.Reducer s a)
useHuh' r s = do
  model /\ dispatch <- R.useReducer' reducer { state: s, sideEffects: []}
  -- R.useEffect1' model.sideEffects $ do
  --   effs <- traverse (\f -> f { dispatch: dispatch, state: model}) model.sideEffects
  --   pure
  -- pure $ ("huh" /\ dispatch)
  pure $ (model.state /\ dispatch)
  where
    reducer {state, sideEffects} action = case r state action of
      NoUpdate                              -> model
      Update state                          -> model { state = state }
      SideEffect sideEffect                 -> model { sideEffects = Array.snoc model.sideEffects sideEffect }
      UpdateWithSideEffect state sideEffect -> model { state = state, sideEffects = Array.snoc model.sideEffects sideEffect }
