module Element.WithContext.Keyed exposing (el, column, row)

{-| Notes from the `Html.Keyed` on how keyed works:

---

A keyed node helps optimize cases where children are getting added, moved, removed, etc. Common examples include:

  - The user can delete items from a list.
  - The user can create new items in a list.
  - You can sort a list based on name or date or whatever.

When you use a keyed node, every child is paired with a string identifier. This makes it possible for the underlying diffing algorithm to reuse nodes more efficiently.

This means if a key is changed between renders, then the diffing step will be skipped and the node will be forced to rerender.

---

@docs el, column, row

-}

import Element.Keyed as Keyed
import Element.WithContext exposing (Attribute, Element)
import Element.WithContext.Internal exposing (run, wrapAttrs)


{-| -}
el : List (Attribute context msg) -> ( String, Element context msg ) -> Element context msg
el =
    wrapAttrs Keyed.el (Tuple.mapSecond << run)


{-| -}
row : List (Attribute context msg) -> List ( String, Element context msg ) -> Element context msg
row =
    wrapAttrs Keyed.row <| List.map << (Tuple.mapSecond << run)


{-| -}
column : List (Attribute context msg) -> List ( String, Element context msg ) -> Element context msg
column =
    wrapAttrs Keyed.column <| List.map << (Tuple.mapSecond << run)
