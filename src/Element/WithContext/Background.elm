module Element.WithContext.Background exposing
    ( color, gradient
    , image, uncropped, tiled, tiledX, tiledY
    )

{-|

@docs color, gradient


# Images

@docs image, uncropped, tiled, tiledX, tiledY

**Note** if you want more control over a background image than is provided here, you should try just using a normal `Element.image` with something like `Element.behindContent`.

-}

import Element.Background as Background
import Element.WithContext exposing (Attr, Attribute, Color)
import Element.WithContext.Internal exposing (attr, attribute)


{-| -}
color : Color -> Attr context decorative msg
color clr =
    attr <| Background.color clr


{-| Resize the image to fit the containing element while maintaining proportions and cropping the overflow.
-}
image : String -> Attribute context msg
image src =
    attribute <| Background.image src


{-| A centered background image that keeps its natural proportions, but scales to fit the space.
-}
uncropped : String -> Attribute context msg
uncropped src =
    attribute <| Background.uncropped src


{-| Tile an image in the x and y axes.
-}
tiled : String -> Attribute context msg
tiled src =
    attribute <| Background.tiled src


{-| Tile an image in the x axis.
-}
tiledX : String -> Attribute context msg
tiledX src =
    attribute <| Background.tiledX src


{-| Tile an image in the y axis.
-}
tiledY : String -> Attribute context msg
tiledY src =
    attribute <| Background.tiledY src


{-| A linear gradient.

First you need to specify what direction the gradient is going by providing an angle in radians. `0` is up and `pi` is down.

The colors will be evenly spaced.

-}
gradient :
    { angle : Float
    , steps : List Color
    }
    -> Attr context decorative msg
gradient config =
    attr <| Background.gradient config
