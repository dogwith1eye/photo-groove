module AppF where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import VueF as V

type Props = ()

container :: V.ComponentF
container c = V.createElement "div" { class: "container" } []

mkApp :: V.Element
mkApp = V.createApp container
