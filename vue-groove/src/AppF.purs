module AppF where

import VueF as V

type Props = ()

container :: V.Component
container p s = V.render "div" { class: "container" } []

containerHello :: V.Component
containerHello p s = V.render "div" { class: "container" } [ "hello purescript" ]

containerSlot :: V.Component
containerSlot p s = V.render "div" { class: "container" } [ V.slot s "default"]

mkApp :: Record Props -> V.Element
mkApp props = V.component containerSlot {} ["ps hello slot"]
