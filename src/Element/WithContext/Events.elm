module Element.WithContext.Events exposing
    ( onClick, onDoubleClick, onMouseDown, onMouseUp, onMouseEnter, onMouseLeave, onMouseMove
    , onFocus, onLoseFocus
    )

{-|


## Mouse Events

@docs onClick, onDoubleClick, onMouseDown, onMouseUp, onMouseEnter, onMouseLeave, onMouseMove


## Focus Events

@docs onFocus, onLoseFocus

-}

import Element.Events as Events
import Element.WithContext exposing (Attribute)
import Element.WithContext.Internal exposing (attribute)



-- MOUSE EVENTS


{-| -}
onMouseDown : msg -> Attribute context msg
onMouseDown msg =
    attribute <| Events.onMouseDown msg


{-| -}
onMouseUp : msg -> Attribute context msg
onMouseUp msg =
    attribute <| Events.onMouseUp msg


{-| -}
onClick : msg -> Attribute context msg
onClick msg =
    attribute <| Events.onClick msg


{-| -}
onDoubleClick : msg -> Attribute context msg
onDoubleClick msg =
    attribute <| Events.onDoubleClick msg


{-| -}
onMouseEnter : msg -> Attribute context msg
onMouseEnter msg =
    attribute <| Events.onMouseEnter msg


{-| -}
onMouseLeave : msg -> Attribute context msg
onMouseLeave msg =
    attribute <| Events.onMouseLeave msg


{-| -}
onMouseMove : msg -> Attribute context msg
onMouseMove msg =
    attribute <| Events.onMouseMove msg



-- FOCUS EVENTS


{-| -}
onLoseFocus : msg -> Attribute context msg
onLoseFocus msg =
    attribute <| Events.onLoseFocus msg


{-| -}
onFocus : msg -> Attribute context msg
onFocus msg =
    attribute <| Events.onFocus msg
