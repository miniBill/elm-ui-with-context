module Element.WithContext.Input.Internal exposing (Label(..), Option(..), Placeholder(..), Thumb(..), runLabel, runOption, runPlaceholder, runThumb)

import Element.Input as Input


type Placeholder context msg
    = Placeholder (context -> Input.Placeholder msg)


runPlaceholder : context -> Placeholder context msg -> Input.Placeholder msg
runPlaceholder context (Placeholder f) =
    f context


type Label context msg
    = Label (context -> Input.Label msg)


runLabel : context -> Label context msg -> Input.Label msg
runLabel context (Label f) =
    f context


type Option context value msg
    = Option (context -> Input.Option value msg)


runOption : a -> Option a value msg -> Input.Option value msg
runOption context (Option f) =
    f context


{-| -}
type Thumb context
    = Thumb (context -> Input.Thumb)


runThumb : a -> Thumb a -> Input.Thumb
runThumb context (Thumb f) =
    f context
