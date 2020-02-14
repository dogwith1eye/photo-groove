module App where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Vue as V
import HTML as H

type Props = ()

container :: V.Component Props
container = V.staticComponent "Container" cpt
  where
    cpt {} _ = H.div { className: "container" } [ H.text "ps hello world" ]

mkApp :: Record Props -> V.Element
mkApp props = V.createElement container props []
