module AppF where

import VueF as V

type Props = ()

container :: V.Component
container p s = V.render "div" { class: "container" } []

mkApp :: Record Props -> V.Element
mkApp props = V.component container []

containerHello :: V.Component
containerHello p s = V.render "div" { class: "container" } [ "hello purescript" ]

mkApp1 :: Record Props -> V.Element
mkApp1 props = V.component containerHello []

containerSlot :: V.Component
containerSlot p s = V.render "div" { class: "container" } [ V.slot s "default"]

mkApp2 :: Record Props -> V.Element
mkApp2 props = V.component containerSlot [(\sprops -> "hello purescript default")]

containerSlotProp :: V.Component
containerSlotProp p s = V.render "div" { class: "container" } [ V.slotPropString s "default" "hello slot" ]

mkApp3 :: Record Props -> V.Element
mkApp3 props = V.component containerSlotProp [(\sprops -> V.render "div" {} [sprops])]

containerSlotPropRecord :: V.Component
containerSlotPropRecord p s = V.render "div" { class: "container" } [ V.slotProp s "default" { text: "hello slot" } ]

mkApp4 :: Record Props -> V.Element
mkApp4 props = V.component containerSlotPropRecord [(\sprops -> V.render "div" sprops [])]

mkApp5 :: Record Props -> V.Element
mkApp5 props = V.component containerSlotPropRecord [(\sprops -> V.render "div" {} [sprops.text])]
