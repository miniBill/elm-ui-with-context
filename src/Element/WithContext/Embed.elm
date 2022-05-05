module Element.WithContext.Embed exposing
    ( el, attr
    , unwrap, unwrapAttr, unwrapLabel, unwrapOption, unwrapPlaceholder, unwrapThumb
    )

{-|

@docs el, attr

-}

import Element
import Element.Input
import Element.WithContext.Input.Internal as Internal exposing (Label(..), Option(..), Placeholder(..), Thumb(..), runLabel, runOption, runPlaceholder, runThumb)
import Element.WithContext.Internal as Internal exposing (Attr(..), Element(..), run, runAttr)


unwrap =
    Internal.run


unwrapAttr =
    Internal.runAttr


unwrapLabel =
    Internal.runLabel


unwrapOption =
    Internal.runOption


unwrapPlaceholder =
    Internal.runPlaceholder


unwrapThumb =
    Internal.runThumb


{-| Allow integration with external libraries that require elm-ui `Element`s to be passed in.
-}
el :
    ({ context : context
     , unwrap : Element context msg -> Element.Element msg
     , unwrapAttr : Attr context decorative msg -> Element.Attr decorative msg
     , unwrapPlaceholder : Placeholder context msg -> Element.Input.Placeholder msg
     , unwrapLabel : Label context msg -> Element.Input.Label msg
     , unwrapThumb : Thumb context -> Element.Input.Thumb
     , unwrapOption : Option context value msg -> Element.Input.Option value msg
     }
     -> Element context msg
    )
    -> Element context msg
el ctor =
    Element <|
        \context ->
            let
                (Element result) =
                    ctor
                        { context = context
                        , unwrap = \(Element f) -> f context
                        , unwrapAttr = \(Attribute f) -> f context
                        , unwrapPlaceholder = \(Placeholder f) -> f context
                        , unwrapLabel = \(Label f) -> f context
                        , unwrapThumb = \(Thumb f) -> f context
                        , unwrapOption = \(Option f) -> f context
                        }
            in
            result context


{-| Allow integration with external libraries that require elm-ui `Element`s to be passed in.
-}
attr :
    ({ context : context
     , unwrap : Element context msg -> Element.Element msg
     , unwrapAttr : Attr context decorative msg -> Element.Attr decorative msg
     , unwrapPlaceholder : Placeholder context msg -> Element.Input.Placeholder msg
     , unwrapLabel : Label context msg -> Element.Input.Label msg
     , unwrapThumb : Thumb context -> Element.Input.Thumb
     , unwrapOption : Option context value msg -> Element.Input.Option value msg
     }
     -> Attr context decorative msg
    )
    -> Attr context decorative msg
attr ctor =
    Attribute <|
        \context ->
            let
                (Attribute result) =
                    ctor
                        { context = context
                        , unwrap = \(Element f) -> f context
                        , unwrapAttr = \(Attribute f) -> f context
                        , unwrapPlaceholder = \(Placeholder f) -> f context
                        , unwrapLabel = \(Label f) -> f context
                        , unwrapThumb = \(Thumb f) -> f context
                        , unwrapOption = \(Option f) -> f context
                        }
            in
            result context
