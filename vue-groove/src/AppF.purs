module AppF where

import VueF as V

type Props = ()

container :: V.Component
container p s = V.render "div" { class: "container" } []

containerHello :: V.Component
containerHello p s = V.render "div" { class: "container" } [ "hello purescript" ]

mkApp :: Record Props -> V.Element
mkApp props = V.component containerHello {} []
