module Examples.Img (
    imgOnClick
) where

import Prelude

import Data.Tuple (Tuple(..))
import Specular.Dom.Builder.Class (domEventWithSample, elDynAttr')
import Specular.Dom.Node.Class (Attrs)
import Specular.Dom.Widget (class MonadWidget)
import Specular.FRP (Event, WeakDynamic)

-- | `imgOnClick attrs` - Creates a HTML `<img>` element with the
-- | specified dynamic attributes.
-- |
-- | Returns an Event that occurs when the img is clicked.
imgOnClick :: forall m. MonadWidget m => WeakDynamic Attrs -> m (Event Unit)
imgOnClick attrs = do
  Tuple node _ <- elDynAttr' "img" attrs (pure unit)
  domEventWithSample (\_ -> pure unit) "click" node
