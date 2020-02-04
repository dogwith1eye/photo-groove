module Examples.Visible where

import Prelude hiding (append)

import Effect (Effect)
import Foreign.Object (Object)
import Specular.Dom.Element (attrsD, el, text)
import Specular.Dom.Node.Class ((:=))
import Specular.Dom.Widget (class MonadWidget, liftWidget, runMainWidgetInBody)
import Specular.Dom.Widgets.Button (buttonOnClick)
import Specular.FRP (Dynamic, foldDyn)

main :: Effect Unit
main = runMainWidgetInBody mainWidget

mainWidget :: forall m. MonadWidget m => m Unit
mainWidget = liftWidget $ do

  -- View Widget to Generate Events
  -- button widget is defined in library, it creates a simple button
  evClick <- buttonOnClick (pure mempty) $ text "Click Me!"

  -- Controller
  -- Handle events and create a 'Dynamic t Bool' value
  -- This toggles the visibility when the button is pressed
  isVisible <- foldDyn ($) false $ (_ # not) <$ evClick

  -- View
  -- This is a simple widget that takes a 'Dynamic t Bool' as input
  textWithDynamicVisiblility isVisible

  pure unit

-- This widget takes the input value of visibility
-- and creates a view based on that
textWithDynamicVisiblility :: forall m. MonadWidget m => Dynamic Boolean -> m Unit
textWithDynamicVisiblility isVisible = liftWidget $
    el "div" [attrsD dynAttr] $ text "Click the button again to make me disappear!"
    where
      dynAttr :: Dynamic (Object String)
      dynAttr = flip map isVisible $ (case _ of
        true -> ("style" := "")
        false -> ("style" := "display: none;" ))
