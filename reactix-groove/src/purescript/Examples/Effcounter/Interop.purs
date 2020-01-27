module Effcounter.Interop where

import Prelude

import Effcounter (CounterOp(..), counterOpFromString, Props, mkEffcounter)
import Data.Maybe (fromMaybe)
import Data.Nullable (Nullable, toMaybe)
import Data.Int (fromString)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Reactix.React (Element)

type JSProps = 
    ( count :: Nullable String
    , label :: Nullable String 
    , onClick :: Nullable (EffectFn1 Int Unit)
    , counterType :: Nullable String 
    )

jsPropsToProps :: Record JSProps -> Record Props
jsPropsToProps { count, label, onClick, counterType } = 
    { count: 
        fromMaybe 0 $ fromString =<< toMaybe count
    , label: 
        fromMaybe "Count" $ toMaybe label
    , onClick:
        fromMaybe mempty $ map runEffectFn1 $ toMaybe onClick
    , counterType:
        fromMaybe Increment $ counterOpFromString =<< toMaybe counterType
    }

jsEffcounter :: Record JSProps -> Element
jsEffcounter = mkEffcounter <<< jsPropsToProps