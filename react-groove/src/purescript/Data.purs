module Data where

type Photo = { url :: String }

data Message
  = None
  | ClickedPhoto String
