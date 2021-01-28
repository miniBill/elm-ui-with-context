module Element.WithContext.Border exposing
    ( color
    , width, widthXY, widthEach
    , solid, dashed, dotted
    , rounded, roundEach
    , glow, innerGlow, shadow, innerShadow
    )

{-|

@docs color


## Border Widths

@docs width, widthXY, widthEach


## Border Styles

@docs solid, dashed, dotted


## Rounded Corners

@docs rounded, roundEach


## Shadows

@docs glow, innerGlow, shadow, innerShadow

-}

import Element.Border as Border
import Element.WithContext exposing (Attr, Attribute, Color)
import Element.WithContext.Internal exposing (attr, attribute)


{-| -}
color : Color -> Attr context decorative msg
color clr =
    attr <| Border.color clr


{-| -}
width : Int -> Attribute context msg
width v =
    attribute <| Border.width v


{-| Set horizontal and vertical borders.
-}
widthXY : Int -> Int -> Attribute context msg
widthXY x y =
    attribute <| Border.widthXY x y


{-| -}
widthEach :
    { bottom : Int
    , left : Int
    , right : Int
    , top : Int
    }
    -> Attribute context msg
widthEach edges =
    attribute <| Border.widthEach edges



-- {-| No Borders
-- -}
-- none : Attribute context msg
-- none =
--     Class "border" "border-none"


{-| -}
solid : Attribute context msg
solid =
    attribute Border.solid


{-| -}
dashed : Attribute context msg
dashed =
    attribute Border.dashed


{-| -}
dotted : Attribute context msg
dotted =
    attribute Border.dotted


{-| Round all corners.
-}
rounded : Int -> Attribute context msg
rounded radius =
    attribute <| Border.rounded radius


{-| -}
roundEach :
    { topLeft : Int
    , topRight : Int
    , bottomLeft : Int
    , bottomRight : Int
    }
    -> Attribute context msg
roundEach edges =
    attribute <| Border.roundEach edges


{-| A simple glow by specifying the color and size.
-}
glow : Color -> Float -> Attr context decorative msg
glow clr size =
    attr <| Border.glow clr size


{-| -}
innerGlow : Color -> Float -> Attr context decorative msg
innerGlow clr size =
    attr <| Border.innerGlow clr size


{-| -}
shadow :
    { offset : ( Float, Float )
    , size : Float
    , blur : Float
    , color : Color
    }
    -> Attr context decorative msg
shadow almostShade =
    attr <| Border.shadow almostShade


{-| -}
innerShadow :
    { offset : ( Float, Float )
    , size : Float
    , blur : Float
    , color : Color
    }
    -> Attr context decorative msg
innerShadow almostShade =
    attr <| Border.innerShadow almostShade
