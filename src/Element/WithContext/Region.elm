module Element.WithContext.Region exposing
    ( mainContent, navigation, heading, aside, footer
    , description
    , announce, announceUrgently
    )

{-| This module is meant to make accessibility easy!

These are sign posts that accessibility software like screen readers can use to navigate your app.

All you have to do is add them to elements in your app where you see fit.

Here's an example of annotating your navigation region:

    import Element.Region as Region

    myNavigation =
        Element.row [ Region.navigation ]
            [-- ..your navigation links
            ]

@docs mainContent, navigation, heading, aside, footer

@docs description

@docs announce, announceUrgently

-}

import Element.Region as Region
import Element.WithContext exposing (Attribute)
import Element.WithContext.Internal exposing (attribute)


{-| -}
mainContent : Attribute context msg
mainContent =
    attribute Region.mainContent


{-| -}
aside : Attribute context msg
aside =
    attribute Region.aside


{-| -}
navigation : Attribute context msg
navigation =
    attribute Region.navigation


{-| -}
footer : Attribute context msg
footer =
    attribute Region.footer


{-| This will mark an element as `h1`, `h2`, etc where possible.

Though it's also smart enough to not conflict with existing nodes.

So, this code

    link [ Region.heading 1 ]
        { url = "http://fruits.com"
        , label = text "Best site ever"
        }

will generate

    <a href="http://fruits.com">
        <h1>Best site ever</h1>
    </a>

-}
heading : Int -> Attribute context msg
heading level =
    attribute <| Region.heading level


{-| Screen readers will announce changes to this element and potentially interrupt any other announcement.
-}
announceUrgently : Attribute context msg
announceUrgently =
    attribute Region.announceUrgently


{-| Screen readers will announce when changes to this element are made.
-}
announce : Attribute context msg
announce =
    attribute Region.announce


{-| Adds an `aria-label`, which is used by accessibility software to identity otherwise unlabeled elements.

A common use for this would be to label buttons that only have an icon.

-}
description : String -> Attribute context msg
description desc =
    attribute <| Region.description desc
