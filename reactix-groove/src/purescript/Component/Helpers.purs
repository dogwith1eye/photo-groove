module Component.Helpers where

import Prelude
import Data.Array (drop, filter, take)
import Data.String (joinWith)
import Data.Tuple (fst, snd, Tuple)

chunks :: forall a. Int -> Array a -> Array (Array a)
chunks _ [] = []
chunks n xs = pure (take n xs) <> (chunks n $ drop n xs)

classList :: Array (Tuple String Boolean) -> String
classList classes = joinWith " " $ map (fst) $ filter (snd) classes
