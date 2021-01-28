module Element.WithContext.Lazy exposing (lazy, lazy2, lazy3)

{-|


## Same as `Html.lazy`. In case you're unfamiliar, here's a note from the `Html` library!

Since all Elm functions are pure we have a guarantee that the same input
will always result in the same output. This module gives us tools to be lazy
about building `Html` that utilize this fact.
Rather than immediately applying functions to their arguments, the `lazy`
functions just bundle the function and arguments up for later. When diffing
the old and new virtual DOM, it checks to see if all the arguments are equal
by reference. If so, it skips calling the function!
This is a really cheap test and often makes things a lot faster, but definitely


## benchmark to be sure!

@docs lazy, lazy2, lazy3

-}

import Element as Vanilla
import Element.Lazy as Lazy
import Element.WithContext exposing (Element)
import Element.WithContext.Internal as Internal exposing (run)


{-| -}
lazy : (a -> Element context msg) -> a -> Element context msg
lazy fn a =
    Internal.Element <| \context -> Lazy.lazy3 apply1 context fn a


{-| -}
lazy2 : (a -> b -> Element context msg) -> a -> b -> Element context msg
lazy2 fn a b =
    Internal.Element <| \context -> Lazy.lazy4 apply2 context fn a b


{-| -}
lazy3 : (a -> b -> c -> Element context msg) -> a -> b -> c -> Element context msg
lazy3 fn a b c =
    Internal.Element <| \context -> Lazy.lazy5 apply3 context fn a b c


apply1 : context -> (c -> Element context msg) -> c -> Vanilla.Element msg
apply1 context fn a =
    run context <| fn a


apply2 : context -> (c -> d -> Element context msg) -> c -> d -> Vanilla.Element msg
apply2 context fn a b =
    run context <| fn a b


apply3 : context -> (c -> d -> e -> Element context msg) -> c -> d -> e -> Vanilla.Element msg
apply3 context fn a b c =
    run context <| fn a b c
