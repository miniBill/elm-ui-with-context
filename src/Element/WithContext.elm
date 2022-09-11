module Element.WithContext exposing
    ( with, withAttribute, withDecoration, layout, layoutWith, element, attribute, attr, toElement, toAttribute, toAttr, mapContextInElement, mapContextInAttr
    , Element, none, text, el
    , row, wrappedRow, column
    , paragraph, textColumn
    , Column, table, IndexedColumn, indexedTable
    , Attribute, width, height, Length, px, shrink, fill, fillPortion, maximum, minimum
    , explain
    , padding, paddingXY, paddingEach
    , spacing, spacingXY, spaceEvenly
    , centerX, centerY, alignLeft, alignRight, alignTop, alignBottom
    , transparent, alpha, pointer
    , moveUp, moveDown, moveRight, moveLeft, rotate, scale
    , clip, clipX, clipY
    , scrollbars, scrollbarX, scrollbarY
    , Option, noStaticStyleSheet, forceHover, noHover, focusStyle, FocusStyle
    , link, newTabLink, download, downloadAs
    , image
    , Color, rgba, rgb, rgb255, rgba255, fromRgb, fromRgb255, toRgb
    , above, below, onRight, onLeft, inFront, behindContent
    , Attr, Decoration, mouseOver, mouseDown, focused
    , Device, DeviceClass(..), Orientation(..), classifyDevice
    , modular
    , map, mapAttribute
    , html, htmlAttribute
    , withContext, withContextAttribute, withContextDecoration
    )

{-|


# `elm-ui-with-context` specific functions

@docs with, withAttribute, withDecoration, layout, layoutWith, element, attribute, attr, toElement, toAttribute, toAttr, mapContextInElement, mapContextInAttr

Apart from some other functions in [`Element.WithContext.Input`](Element-WithContext-Input),
this is everything `elm-ui-with-context` adds to `elm-ui`.


# Basic Elements

@docs Element, none, text, el


# Rows and Columns

When we want more than one child on an element, we want to be _specific_ about how they will be laid out.

So, the common ways to do that would be `row` and `column`.

@docs row, wrappedRow, column


# Text Layout

Text layout needs some specific considerations.

@docs paragraph, textColumn


# Data Table

@docs Column, table, IndexedColumn, indexedTable


# Size

@docs Attribute, width, height, Length, px, shrink, fill, fillPortion, maximum, minimum


# Debugging

@docs explain


# Padding and Spacing

There's no concept of margin in `elm-ui`, instead we have padding and spacing.

Padding is the distance between the outer edge and the content, and spacing is the space between children.

So, if we have the following row, with some padding and spacing.

    Element.row [ padding 10, spacing 7 ]
        [ Element.el [] none
        , Element.el [] none
        , Element.el [] none
        ]

Here's what we can expect:

![Three boxes spaced 7 pixels apart. There's a 10 pixel distance from the edge of the parent to the boxes.](https://mdgriffith.gitbooks.io/style-elements/content/assets/spacing-400.png)

**Note** `spacing` set on a `paragraph`, will set the pixel spacing between lines.

@docs padding, paddingXY, paddingEach

@docs spacing, spacingXY, spaceEvenly


# Alignment

Alignment can be used to align an `Element` within another `Element`.

    Element.el [ centerX, alignTop ] (text "I'm centered and aligned top!")

If alignment is set on elements in a layout such as `row`, then the element will push the other elements in that direction. Here's an example.

    Element.row []
        [ Element.el [] Element.none
        , Element.el [ alignLeft ] Element.none
        , Element.el [ centerX ] Element.none
        , Element.el [ alignRight ] Element.none
        ]

will result in a layout like

    |-|-|    |-|    |-|

Where there are two elements on the left, one on the right, and one in the center of the space between the elements on the left and right.

**Note** For text alignment, check out `Element.Font`!

@docs centerX, centerY, alignLeft, alignRight, alignTop, alignBottom


# Transparency

@docs transparent, alpha, pointer


# Adjustment

@docs moveUp, moveDown, moveRight, moveLeft, rotate, scale


# Clipping and Scrollbars

Clip the content if it overflows.

@docs clip, clipX, clipY

Add a scrollbar if the content is larger than the element.

@docs scrollbars, scrollbarX, scrollbarY


# Rendering

@docs Option, noStaticStyleSheet, forceHover, noHover, focusStyle, FocusStyle


# Links

@docs link, newTabLink, download, downloadAs


# Images

@docs image


# Color

In order to use attributes like `Font.color` and `Background.color`, you'll need to make some colors!

@docs Color, rgba, rgb, rgb255, rgba255, fromRgb, fromRgb255, toRgb


# Nearby Elements

Let's say we want a dropdown menu. Essentially we want to say: _put this element below this other element, but don't affect the layout when you do_.

    Element.row []
        [ Element.el
            [ Element.below (Element.text "I'm below!")
            ]
            (Element.text "I'm normal!")
        ]

This will result in

    |- I'm normal! -|
       I'm below

Where `"I'm Below"` doesn't change the size of `Element.row`.

This is very useful for things like dropdown menus or tooltips.

@docs above, below, onRight, onLeft, inFront, behindContent


# Temporary Styling

@docs Attr, Decoration, mouseOver, mouseDown, focused


# Responsiveness

The main technique for responsiveness is to store window size information in your model.

Install the `Browser` package, and set up a subscription for [`Browser.Events.onResize`](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Events#onResize).

You'll also need to retrieve the initial window size. You can either use [`Browser.Dom.getViewport`](https://package.elm-lang.org/packages/elm/browser/latest/Browser-Dom#getViewport) or pass in `window.innerWidth` and `window.innerHeight` as flags to your program, which is the preferred way. This requires minor setup on the JS side, but allows you to avoid the state where you don't have window info.

@docs Device, DeviceClass, Orientation, classifyDevice


# Scaling

@docs modular


# Mapping

@docs map, mapAttribute


# Compatibility

@docs html, htmlAttribute


# Advanced

Sometimes it's more convenient to just access the whole context while building your view. This functions allow you do just that.

@docs withContext, withContextAttribute, withContextDecoration

-}

import Element
import Element.WithContext.Internal as Internal exposing (Attr(..), Attribute, Element(..), attributes, run, runAttr, wrapAttrs, wrapContainer)
import Html exposing (Html)


{-| -}
type alias Color =
    Internal.Color


{-| Provide the red, green, and blue channels for the color.

Each channel takes a value between 0 and 1.

-}
rgb : Float -> Float -> Float -> Color
rgb =
    Element.rgb


{-| -}
rgba : Float -> Float -> Float -> Float -> Color
rgba =
    Element.rgba


{-| Provide the red, green, and blue channels for the color.

Each channel takes a value between 0 and 255.

-}
rgb255 : Int -> Int -> Int -> Color
rgb255 =
    Element.rgb255


{-| -}
rgba255 : Int -> Int -> Int -> Float -> Color
rgba255 =
    Element.rgba255


{-| Create a color from an RGB record.
-}
fromRgb :
    { red : Float
    , green : Float
    , blue : Float
    , alpha : Float
    }
    -> Color
fromRgb =
    Element.fromRgb


{-| -}
fromRgb255 :
    { red : Int
    , green : Int
    , blue : Int
    , alpha : Float
    }
    -> Color
fromRgb255 =
    Element.fromRgb255


{-| Deconstruct a `Color` into its rgb channels.
-}
toRgb :
    Color
    ->
        { red : Float
        , green : Float
        , blue : Float
        , alpha : Float
        }
toRgb =
    Element.toRgb


{-| The basic building block of your layout.

    howdy : Element context msg
    howdy =
        Element.el [] (Element.text "Howdy!")

-}
type alias Element context msg =
    Internal.Element context msg


{-| An attribute that can be attached to an `Element`
-}
type alias Attribute context msg =
    Internal.Attribute context msg


{-| This is a special attribute that counts as both a `Attribute context msg` and a `Decoration context`.
-}
type alias Attr context decorative msg =
    Internal.Attr context decorative msg


{-| Only decorations
-}
type alias Decoration context =
    Internal.Decoration context


{-| -}
html : Html msg -> Element context msg
html child =
    element <| Element.html child


{-| -}
htmlAttribute : Html.Attribute msg -> Attribute context msg
htmlAttribute child =
    attribute <| Element.htmlAttribute child


{-| Embed an element from the original elm-ui library. This is useful for interop with existing code, like `lemol/ant-design-icons-elm-ui`.

`element` can also be used in combination with `with`
to supply arguments to an elm-ui element from the context.

For example

    module SomePackage exposing (Context, view)

    import Element exposing (Element)

    view :
        { backgroundColor : Element.Color
        , foregroundColor : Element.Color
        }
        -> Element msg

in your code

    module YourCode exposing (main)

    import Element.WithContext exposing (Element)

    type alias Context =
        { theme : Theme }

    type Theme
        = Black
        | White

    themeToColors :
        Theme
        -> { background : Element.WithContext.Color
           , foreground : Element.WithContext.Color
           }

    view : Element Context msg
    view =
        Element.WithContext.column
            []
            [ ...
            , Element.WithContext.with
                (\{ theme } ->
                    let
                        themeColors =
                            theme |> themeToColors
                    in
                    SomePackage.view
                        { backgroundColor = themeColors.background
                        , foregroundColor = themeColors.foreground
                        }
                        |> Element.WithContext.element
                )
            ]

-}
element : Element.Element msg -> Element context msg
element elem =
    Element <| \_ -> elem


{-| Embed an attribute from the original elm-ui library. This is useful for interop with existing code.
-}
attribute : Element.Attribute msg -> Attribute context msg
attribute elem =
    Attribute <| \_ -> elem


{-| Embed an attribute from the original elm-ui library. This is useful for interop with existing code.
-}
attr : Element.Attr decorative msg -> Attr context decorative msg
attr elem =
    Attribute <| \_ -> elem


{-| Construct an element from the original elm-ui supplying a complete context.

This can be used as the final step before
embedding sub-elements that use elm-ui-with-context
in a bigger elm-ui element
without elm-ui-with-context becoming "infectious"
and forcing higher-level elements to adopt context.

For example

    module SomePackage exposing (Context, view)

    import Element.WithContext exposing (Element)

    type alias Context =
        { backgroundColor : Element.WithContext.Color
        , foregroundColor : Element.WithContext.Color
        }

    view : Element Context msg

in your code

    module YourCode exposing (main)

    import Element exposing (Element)
    import Element.WithContext

    view : Element msg
    view =
        Element.WithContext.column
            []
            [ ...
            , SomePackage.view
                -- app currently only supports a black theme
                -- but `SomePackage`'s theme must be configured ↓
                |> Element.WithContext.toElement
                    { backgroundColor = Element.WithContext.rgb 0 0 0
                    , foregroundColor = Element.WithContext.rgb 1 1 1
                    }
            ]

-}
toElement : context -> Element context msg -> Element.Element msg
toElement context (Element f) =
    f context


{-| Construct an attribute for the original elm-ui supplying a complete context.
[`toElement`](#toElement) documents use-cases.
-}
toAttribute : context -> Attribute context msg -> Element.Attribute msg
toAttribute context (Attribute f) =
    f context


{-| Construct an attribute from the original elm-ui by supplying a complete context.
[`toElement`](#toElement) documents use-cases.
-}
toAttr : context -> Attr context decorative msg -> Element.Attr decorative msg
toAttr context (Attribute f) =
    f context


{-| Change how the context looks for a given element.

This is used to embed elm-ui-with-context
from another origin (like a package)
with another context type.

This is quite similar to [`map`](#map)
but instead of transforming the inner msg type to match the outer type,
it transforms the outer context type to match the inner type.

For example

    module SomePackage exposing (Context, view)

    import Element.WithContext exposing (Element)

    type alias Context =
        { backgroundColor : Element.WithContext.Color
        , foregroundColor : Element.WithContext.Color
        }

    view : Element Context msg

in your code

    module YourCode exposing (main)

    import Element.WithContext exposing (Element)

    type alias Context =
        { theme : Theme }

    type Theme
        = Black
        | White

    themeToColors :
        Theme
        -> { background : Element.WithContext.Color
           , foreground : Element.WithContext.Color
           }

    view : Element Context msg
    view =
        Element.WithContext.column
            []
            [ ...
            , Element.WithContext.mapContextInElement
                (\{ theme } ->
                    let
                        themeColors =
                            theme |> themeToColors
                    in
                    { backgroundColor = themeColors.background
                    , foregroundColor = themeColors.foreground
                    }
                )
                SomePackage.view
            ]

-}
mapContextInElement : (outerContext -> innerContext) -> Element innerContext msg -> Element outerContext msg
mapContextInElement outerToInnerContext (Element f) =
    Element (outerToInnerContext >> f)


{-| Change how the context looks for a given attribute.
[`mapContextInElement`](#mapContextInElement) documents use-cases.
-}
mapContextInAttr : (outerContext -> innerContext) -> Attr innerContext decorative msg -> Attr outerContext decorative msg
mapContextInAttr outerToInnerContext (Attribute f) =
    Attribute (outerToInnerContext >> f)


{-| -}
map : (msg -> msg1) -> Element context msg -> Element context msg1
map f (Element g) =
    Element (g >> Element.map f)


{-| -}
mapAttribute : (msg -> msg1) -> Attribute context msg -> Attribute context msg1
mapAttribute f (Attribute g) =
    Attribute (g >> Element.mapAttribute f)


{-| Use a property from the context to build an `Element`. Have a look at the README for examples.
-}
with : (context -> property) -> (property -> Element context msg) -> Element context msg
with selector f =
    Element <| \context -> run context <| f <| selector context


{-| Use a property from the context to build an `Attribute`. Have a look at the README for examples.
-}
withAttribute : (context -> property) -> (property -> Attribute context msg) -> Attribute context msg
withAttribute selector f =
    Attribute <| \context -> runAttr context <| f <| selector context


{-| Use a property from the context to build a `Decoration`. Have a look at the README for examples.
-}
withDecoration : (context -> property) -> (property -> Decoration context) -> Decoration context
withDecoration selector f =
    Attribute <| \context -> runAttr context <| f <| selector context


{-| Use the context to build an `Element`. Have a look at the README for examples.
-}
withContext : (context -> Element context msg) -> Element context msg
withContext f =
    Element <| \context -> run context <| f context


{-| Use the context to build an `Attribute`. Have a look at the README for examples.
-}
withContextAttribute : (context -> Attribute context msg) -> Attribute context msg
withContextAttribute f =
    Attribute <| \context -> runAttr context <| f context


{-| Use the context to build a `Decoration`. Have a look at the README for examples.
-}
withContextDecoration : (context -> Decoration context) -> Decoration context
withContextDecoration f =
    Attribute <| \context -> runAttr context <| f context


{-| -}
type alias Length =
    Element.Length


{-| -}
px : Int -> Length
px =
    Element.px


{-| Shrink an element to fit its contents.
-}
shrink : Length
shrink =
    Element.shrink


{-| Fill the available space. The available space will be split evenly between elements that have `width fill`.
-}
fill : Length
fill =
    Element.fill


{-| Similarly you can set a minimum boundary.

     el
        [ height
            (fill
                |> maximum 300
                |> minimum 30
            )

        ]
        (text "I will stop at 300px")

-}
minimum : Int -> Length -> Length
minimum =
    Element.minimum


{-| Add a maximum to a length.

    el
        [ height
            (fill
                |> maximum 300
            )
        ]
        (text "I will stop at 300px")

-}
maximum : Int -> Length -> Length
maximum =
    Element.maximum


{-| Sometimes you may not want to split available space evenly. In this case you can use `fillPortion` to define which elements should have what portion of the available space.

So, two elements, one with `width (fillPortion 2)` and one with `width (fillPortion 3)`. The first would get 2 portions of the available space, while the second would get 3.

**Also:** `fill == fillPortion 1`

-}
fillPortion : Int -> Length
fillPortion =
    Element.fillPortion


{-| This is your top level node where you can turn `Element` into `Html`.
-}
layout : context -> List (Attribute context msg) -> Element context msg -> Html msg
layout context attrs elem =
    Element.layout (attributes context attrs) (elem |> toElement context)


{-| -}
layoutWith : context -> { options : List Option } -> List (Attribute context msg) -> Element context msg -> Html msg
layoutWith context options attrs elem =
    Element.layoutWith options (attributes context attrs) (elem |> toElement context)


{-| -}
type alias Option =
    Element.Option


{-| Elm UI embeds two StyleSheets, one that is constant, and one that changes dynamically based on styles collected from the elements being rendered.

This option will stop the static/constant stylesheet from rendering.

If you're embedding multiple elm-ui `layout` elements, you need to guarantee that only one is rendering the static style sheet and that it's above all the others in the DOM tree.

-}
noStaticStyleSheet : Option
noStaticStyleSheet =
    Element.noStaticStyleSheet


{-| -}
type alias FocusStyle =
    { borderColor : Maybe Color
    , backgroundColor : Maybe Color
    , shadow :
        Maybe
            { color : Color
            , offset : ( Int, Int )
            , blur : Int
            , size : Int
            }
    }


{-| -}
focusStyle : FocusStyle -> Option
focusStyle =
    Element.focusStyle


{-| Disable all `mouseOver` styles.
-}
noHover : Option
noHover =
    Element.noHover


{-| Any `hover` styles, aka attributes with `mouseOver` in the name, will be always turned on.

This is useful for when you're targeting a platform that has no mouse, such as mobile.

-}
forceHover : Option
forceHover =
    Element.forceHover


{-| When you want to render exactly nothing.
-}
none : Element context msg
none =
    element Element.none


{-| Create some plain text.

    text "Hello, you stylish developer!"

**Note** text does not wrap by default. In order to get text to wrap, check out `paragraph`!

-}
text : String -> Element context msg
text content =
    element <| Element.text content


{-| The basic building block of your layout.

You can think of an `el` as a `div`, but it can only have one child.

If you want multiple children, you'll need to use something like `row` or `column`

    import Element.WithContext as Element exposing (Element, rgb)
    import Element.WithContext.Background as Background
    import Element.WithContext.Border as Border

    myElement : Element context msg
    myElement =
        Element.el
            [ Background.color (rgb 0 0.5 0)
            , Border.color (rgb 0 0.7 0)
            ]
            (Element.text "You've made a stylish element!")

-}
el : List (Attribute context msg) -> Element context msg -> Element context msg
el =
    wrapAttrs Element.el run


{-| -}
row : List (Attribute context msg) -> List (Element context msg) -> Element context msg
row =
    wrapContainer Element.row


{-| -}
column : List (Attribute context msg) -> List (Element context msg) -> Element context msg
column =
    wrapContainer Element.column


{-| Same as `row`, but will wrap if it takes up too much horizontal space.
-}
wrappedRow : List (Attribute context msg) -> List (Element context msg) -> Element context msg
wrappedRow =
    wrapContainer Element.wrappedRow


{-| This is just an alias for `Debug.todo`
-}
type alias Todo =
    String -> Never


{-| Highlight the borders of an element and it's children below. This can really help if you're running into some issue with your layout!

**Note** This attribute needs to be handed `Debug.todo` in order to work, even though it won't do anything with it. This is a safety measure so you don't accidently ship code with `explain` in it, as Elm won't compile with `--optimize` if you still have a `Debug` statement in your code.

    el
        [ Element.explain Debug.todo
        ]
        (text "Help, I'm being debugged!")

-}
explain : Todo -> Attribute context msg
explain t =
    attribute <| Element.explain t


{-| -}
type alias Column context record msg =
    { header : Element context msg
    , width : Length
    , view : record -> Element context msg
    }


{-| Show some tabular data.

Start with a list of records and specify how each column should be rendered.

So, if we have a list of `persons`:

    type alias Person =
        { firstName : String
        , lastName : String
        }

    persons : List Person
    persons =
        [ { firstName = "David"
          , lastName = "Bowie"
          }
        , { firstName = "Florence"
          , lastName = "Welch"
          }
        ]

We could render it using

    Element.table []
        { data = persons
        , columns =
            [ { header = Element.text "First Name"
              , width = fill
              , view =
                    \person ->
                        Element.text person.firstName
              }
            , { header = Element.text "Last Name"
              , width = fill
              , view =
                    \person ->
                        Element.text person.lastName
              }
            ]
        }

**Note:** Sometimes you might not have a list of records directly in your model. In this case it can be really nice to write a function that transforms some part of your model into a list of records before feeding it into `Element.table`.

-}
table :
    List (Attribute context msg)
    ->
        { data : List records
        , columns : List (Column context records msg)
        }
    -> Element context msg
table =
    wrapAttrs Element.table <|
        \context config ->
            { data = config.data
            , columns =
                List.map
                    (\col ->
                        { header = run context col.header
                        , width = col.width
                        , view = run context << col.view
                        }
                    )
                    config.columns
            }


{-| -}
type alias IndexedColumn context record msg =
    { header : Element context msg
    , width : Length
    , view : Int -> record -> Element context msg
    }


{-| Same as `Element.table` except the `view` for each column will also receive the row index as well as the record.
-}
indexedTable :
    List (Attribute context msg)
    ->
        { data : List records
        , columns : List (IndexedColumn context records msg)
        }
    -> Element context msg
indexedTable =
    wrapAttrs Element.indexedTable <|
        \context config ->
            { data = config.data
            , columns =
                List.map
                    (\col ->
                        { header = run context col.header
                        , width = col.width
                        , view = \i -> run context << col.view i
                        }
                    )
                    config.columns
            }


{-| A paragraph will layout all children as wrapped, inline elements.

    import Element exposing (el, paragraph, text)
    import Element.Font as Font

    view =
        paragraph []
            [ text "lots of text ...."
            , el [ Font.bold ] (text "this is bold")
            , text "lots of text ...."
            ]

This is really useful when you want to markup text by having some parts be bold, or some be links, or whatever you so desire.

Also, if a child element has `alignLeft` or `alignRight`, then it will be moved to that side and the text will flow around it, (ah yes, `float` behavior).

This makes it particularly easy to do something like a [dropped capital](https://en.wikipedia.org/wiki/Initial).

    import Element exposing (alignLeft, el, padding, paragraph, text)
    import Element.Font as Font

    view =
        paragraph []
            [ el
                [ alignLeft
                , padding 5
                ]
                (text "S")
            , text "o much text ...."
            ]

Which will look something like

![A paragraph where the first letter is twice the height of the others](https://mdgriffith.gitbooks.io/style-elements/content/assets/Screen%20Shot%202017-08-25%20at%209.41.52%20PM.png)

**Note** `spacing` on a paragraph will set the pixel spacing between lines.

-}
paragraph : List (Attribute context msg) -> List (Element context msg) -> Element context msg
paragraph =
    wrapContainer Element.paragraph


{-| Now that we have a paragraph, we need some way to attach a bunch of paragraph's together.

To do that we can use a `textColumn`.

The main difference between a `column` and a `textColumn` is that `textColumn` will flow the text around elements that have `alignRight` or `alignLeft`, just like we just saw with paragraph.

In the following example, we have a `textColumn` where one child has `alignLeft`.

    Element.textColumn [ spacing 10, padding 10 ]
        [ paragraph [] [ text "lots of text ...." ]
        , el [ alignLeft ] none
        , paragraph [] [ text "lots of text ...." ]
        ]

Which will result in something like:

![A text layout where an image is on the left.](https://mdgriffith.gitbooks.io/style-elements/content/assets/Screen%20Shot%202017-08-25%20at%208.42.39%20PM.png)

-}
textColumn : List (Attribute context msg) -> List (Element context msg) -> Element context msg
textColumn =
    wrapContainer Element.textColumn


{-| Both a source and a description are required for images.

The description is used for people using screen readers.

Leaving the description blank will cause the image to be ignored by assistive technology. This can make sense for images that are purely decorative and add no additional information.

So, take a moment to describe your image as you would to someone who has a harder time seeing.

-}
image : List (Attribute context msg) -> { src : String, description : String } -> Element context msg
image =
    wrapAttrs Element.image (always identity)


{-|

    link []
        { url = "http://fruits.com"
        , label = text "A link to my favorite fruit provider."
        }

-}
link :
    List (Attribute context msg)
    ->
        { url : String
        , label : Element context msg
        }
    -> Element context msg
link =
    wrapAttrs Element.link
        (\context { url, label } ->
            { url = url
            , label = run context label
            }
        )


{-| -}
newTabLink :
    List (Attribute context msg)
    ->
        { url : String
        , label : Element context msg
        }
    -> Element context msg
newTabLink =
    wrapAttrs Element.newTabLink
        (\context { url, label } ->
            { url = url
            , label = run context label
            }
        )


{-| A link to download a file.
-}
download :
    List (Attribute context msg)
    ->
        { url : String
        , label : Element context msg
        }
    -> Element context msg
download =
    wrapAttrs Element.download
        (\context { url, label } ->
            { url = url
            , label = run context label
            }
        )


{-| A link to download a file, but you can specify the filename.
-}
downloadAs :
    List (Attribute context msg)
    ->
        { label : Element context msg
        , filename : String
        , url : String
        }
    -> Element context msg
downloadAs =
    wrapAttrs Element.downloadAs
        (\context { url, label, filename } ->
            { url = url
            , filename = filename
            , label = run context label
            }
        )



{- NEARBYS -}


createNearby : (Element.Element msg -> Element.Attribute msg) -> Element context msg -> Attribute context msg
createNearby elementToAttr (Element f) =
    Attribute (f >> elementToAttr)


{-| -}
below : Element context msg -> Attribute context msg
below =
    createNearby Element.below


{-| -}
above : Element context msg -> Attribute context msg
above =
    createNearby Element.above


{-| -}
onRight : Element context msg -> Attribute context msg
onRight =
    createNearby Element.onRight


{-| -}
onLeft : Element context msg -> Attribute context msg
onLeft =
    createNearby Element.onLeft


{-| This will place an element in front of another.

**Note:** If you use this on a `layout` element, it will place the element as fixed to the viewport which can be useful for modals and overlays.

-}
inFront : Element context msg -> Attribute context msg
inFront =
    createNearby Element.inFront


{-| This will place an element between the background and the content of an element.
-}
behindContent : Element context msg -> Attribute context msg
behindContent =
    createNearby Element.behindContent


{-| -}
width : Length -> Attribute context msg
width l =
    attribute <| Element.width l


{-| -}
height : Length -> Attribute context msg
height l =
    attribute <| Element.height l


{-| -}
scale : Float -> Attr context decorative msg
scale n =
    attr <| Element.scale n


{-| Angle is given in radians. [Here are some conversion functions if you want to use another unit.](https://package.elm-lang.org/packages/elm/core/latest/Basics#degrees)
-}
rotate : Float -> Attr context decorative msg
rotate angle =
    attr <| Element.rotate angle


{-| -}
moveUp : Float -> Attr context decorative msg
moveUp y =
    attr <| Element.moveUp y


{-| -}
moveDown : Float -> Attr context decorative msg
moveDown y =
    attr <| Element.moveDown y


{-| -}
moveRight : Float -> Attr context decorative msg
moveRight x =
    attr <| Element.moveRight x


{-| -}
moveLeft : Float -> Attr context decorative msg
moveLeft x =
    attr <| Element.moveLeft x


{-| -}
padding : Int -> Attribute context msg
padding x =
    attribute <| Element.padding x


{-| Set horizontal and vertical padding.
-}
paddingXY : Int -> Int -> Attribute context msg
paddingXY x y =
    attribute <| Element.paddingXY x y


{-| If you find yourself defining unique paddings all the time, you might consider defining

    edges =
        { top = 0
        , right = 0
        , bottom = 0
        , left = 0
        }

And then just do

    paddingEach { edges | right = 5 }

-}
paddingEach : { top : Int, right : Int, bottom : Int, left : Int } -> Attribute context msg
paddingEach paddings =
    attribute <| Element.paddingEach paddings


{-| -}
centerX : Attribute context msg
centerX =
    attribute Element.centerX


{-| -}
centerY : Attribute context msg
centerY =
    attribute Element.centerY


{-| -}
alignTop : Attribute context msg
alignTop =
    attribute Element.alignTop


{-| -}
alignBottom : Attribute context msg
alignBottom =
    attribute Element.alignBottom


{-| -}
alignLeft : Attribute context msg
alignLeft =
    attribute Element.alignLeft


{-| -}
alignRight : Attribute context msg
alignRight =
    attribute Element.alignRight


{-| -}
spaceEvenly : Attribute context msg
spaceEvenly =
    attribute Element.spaceEvenly


{-| -}
spacing : Int -> Attribute context msg
spacing x =
    attribute <| Element.spacing x


{-| In the majority of cases you'll just need to use `spacing`, which will work as intended.

However for some layouts, like `textColumn`, you may want to set a different spacing for the x axis compared to the y axis.

-}
spacingXY : Int -> Int -> Attribute context msg
spacingXY x y =
    attribute <| Element.spacingXY x y


{-| Make an element transparent and have it ignore any mouse or touch events, though it will stil take up space.
-}
transparent : Bool -> Attr context decorative msg
transparent on =
    attr <| Element.transparent on


{-| A capped value between 0.0 and 1.0, where 0.0 is transparent and 1.0 is fully opaque.

Semantically equivalent to html opacity.

-}
alpha : Float -> Attr context decorative msg
alpha o =
    attr <| Element.alpha o


{-| -}
scrollbars : Attribute context msg
scrollbars =
    attribute Element.scrollbars


{-| -}
scrollbarY : Attribute context msg
scrollbarY =
    attribute Element.scrollbarY


{-| -}
scrollbarX : Attribute context msg
scrollbarX =
    attribute Element.scrollbarX


{-| -}
clip : Attribute context msg
clip =
    attribute Element.clip


{-| -}
clipY : Attribute context msg
clipY =
    attribute Element.clipY


{-| -}
clipX : Attribute context msg
clipX =
    attribute Element.clipX


{-| Set the cursor to be a pointing hand when it's hovering over this element.
-}
pointer : Attribute context msg
pointer =
    attribute Element.pointer


{-| -}
type alias Device =
    { class : DeviceClass
    , orientation : Orientation
    }


{-| -}
type DeviceClass
    = Phone
    | Tablet
    | Desktop
    | BigDesktop


{-| -}
type Orientation
    = Portrait
    | Landscape


{-| Takes in a Window.Size and returns a device profile which can be used for responsiveness.

If you have more detailed concerns around responsiveness, it probably makes sense to copy this function into your codebase and modify as needed.

-}
classifyDevice : { window | height : Int, width : Int } -> Device
classifyDevice size =
    let
        { class, orientation } =
            Element.classifyDevice size
    in
    { class =
        case class of
            Element.Phone ->
                Phone

            Element.Tablet ->
                Tablet

            Element.Desktop ->
                Desktop

            Element.BigDesktop ->
                BigDesktop
    , orientation =
        case orientation of
            Element.Portrait ->
                Portrait

            Element.Landscape ->
                Landscape
    }


{-| When designing it's nice to use a modular scale to set spacial rythms.

    scaled =
        Element.modular 16 1.25

A modular scale starts with a number, and multiplies it by a ratio a number of times.
Then, when setting font sizes you can use:

    Font.size (scaled 1) -- results in 16

    Font.size (scaled 2) -- 16 * 1.25 results in 20

    Font.size (scaled 4) -- 16 * 1.25 ^ (4 - 1) results in 31.25

We can also provide negative numbers to scale below 16px.

    Font.size (scaled -1) -- 16 * 1.25 ^ (-1) results in 12.8

-}
modular : Float -> Float -> Int -> Float
modular =
    Element.modular


{-| -}
mouseOver : List (Decoration context) -> Attribute context msg
mouseOver decs =
    Attribute <| \context -> Element.mouseOver <| List.map (\(Attribute f) -> f context) decs


{-| -}
mouseDown : List (Decoration context) -> Attribute context msg
mouseDown decs =
    Attribute <| \context -> Element.mouseDown <| List.map (\(Attribute f) -> f context) decs


{-| -}
focused : List (Decoration context) -> Attribute context msg
focused decs =
    Attribute <| \context -> Element.focused <| List.map (\(Attribute f) -> f context) decs
