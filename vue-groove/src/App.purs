module App where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Vue as V
import HTML as H

type Props = ()

app :: V.Component Props
app = V.staticComponent "Counter" cpt
  where
    cpt {} _ = H.div { className: "counter" } [ ]

mkApp :: Record Props -> V.Element
mkApp props = V.createElement app1 props []

app1 :: V.Component Props
app1 = V.staticComponent "Counter" cpt
  where
    cpt {} _ = H.div { className: "counter" } [ H.div { className: "child" } [] ]

mkApp1 :: Record Props -> V.Element
mkApp1 props = V.createElement app1 props []

child :: V.Component Props
child = V.staticComponent "Child" cpt
  where
    cpt {} _ = H.div { className: "child" } []

app2 :: V.Component Props
app2 = V.staticComponent "Counter" cpt
  where
    cpt {} _ = H.div { className: "counter" } [ mkChild {} ]

mkChild :: Record Props -> V.Element
mkChild props = V.createElement child props []

mkAppChild :: Record Props -> V.Element
mkAppChild props = V.createElement app2 props []
