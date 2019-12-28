module Counter.Interop where

import Prelude

import Counter (Props, mkCounter)
import Data.Maybe (fromMaybe)
import Data.Nullable (Nullable, toMaybe)
import Data.Int (fromString)
import Reactix.React (Element)

type JSProps = ( count :: Nullable String, label :: Nullable String )

jsPropsToProps :: Record JSProps -> Record Props
jsPropsToProps { count, label } = { 
    count: fromMaybe 0 $ fromString =<< toMaybe count, 
    label: fromMaybe "Count" $ toMaybe label }

jsCounter :: Record JSProps -> Element
jsCounter = mkCounter <<< jsPropsToProps