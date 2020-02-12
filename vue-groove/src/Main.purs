module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Vue (Element, createDOMElement, render)

app :: Element
app = createDOMElement "div" {} []

main :: Effect Unit
main = do
  render app app

mainOld :: Effect Unit
mainOld = do
  log "🍝"
