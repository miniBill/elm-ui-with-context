module Element.WithContext.Font exposing
    ( color, size
    , family, Font, typeface, serif, sansSerif, monospace
    , external
    , alignLeft, alignRight, center, justify, letterSpacing, wordSpacing
    , underline, strike, italic, unitalicized
    , heavy, extraBold, bold, semiBold, medium, regular, light, extraLight, hairline
    , Variant, variant, variantList, smallCaps, slashedZero, ligatures, ordinal, tabularNumbers, stackedFractions, diagonalFractions, swash, feature, indexed
    , glow, shadow
    )

{-|

    import Element.WithContext as Element
    import Element.WithContext.Font as Font

    view =
        Element.el
            [ Font.color (Element.rgb 0 0 1)
            , Font.size 18
            , Font.family
                [ Font.typeface "Open Sans"
                , Font.sansSerif
                ]
            ]
            (Element.text "Woohoo, I'm stylish text")

**Note:** `Font.color`, `Font.size`, and `Font.family` are inherited, meaning you can set them at the top of your view and all subsequent nodes will have that value.

**Other Note:** If you're looking for something like `line-height`, it's handled by `Element.spacing` on a `paragraph`.

@docs color, size


## Typefaces

@docs family, Font, typeface, serif, sansSerif, monospace

@docs external


## Alignment and Spacing

@docs alignLeft, alignRight, center, justify, letterSpacing, wordSpacing


## Font Styles

@docs underline, strike, italic, unitalicized


## Font Weight

@docs heavy, extraBold, bold, semiBold, medium, regular, light, extraLight, hairline


## Variants

@docs Variant, variant, variantList, smallCaps, slashedZero, ligatures, ordinal, tabularNumbers, stackedFractions, diagonalFractions, swash, feature, indexed


## Shadows

@docs glow, shadow

-}

import Element.Font as Font
import Element.WithContext exposing (Attr, Attribute, Color)
import Element.WithContext.Internal exposing (attr, attribute)


{-| -}
type alias Font =
    Font.Font


{-| -}
color : Color -> Attr context decorative msg
color fontColor =
    attr <| Font.color fontColor


{-|

    import Element.WithContext as Element
    import Element.WithContext.Font as Font

    myElement =
        Element.el
            [ Font.family
                [ Font.typeface "Helvetica"
                , Font.sansSerif
                ]
            ]
            (text "")

-}
family : List Font -> Attribute context msg
family families =
    attribute <| Font.family families


{-| -}
serif : Font
serif =
    Font.serif


{-| -}
sansSerif : Font
sansSerif =
    Font.sansSerif


{-| -}
monospace : Font
monospace =
    Font.monospace


{-| -}
typeface : String -> Font
typeface name =
    Font.typeface name


{-| **Note** it's likely that `Font.external` will cause a flash on your page on loading.

To bypass this, import your fonts using a separate stylesheet and just use `Font.typeface`.

It's likely that `Font.external` will be removed or redesigned in the future to avoid the flashing.

`Font.external` can be used to import font files. Let's say you found a neat font on <http://fonts.google.com>:

    import Element
    import Element.Font as Font

    view =
        Element.el
            [ Font.family
                [ Font.external
                    { name = "Roboto"
                    , url = "https://fonts.googleapis.com/css?family=Roboto"
                    }
                , Font.sansSerif
                ]
            ]
            (Element.text "Woohoo, I'm stylish text")

-}
external : { url : String, name : String } -> Font
external =
    Font.external


{-| Font sizes are always given as `px`.
-}
size : Int -> Attr context decorative msg
size i =
    attr <| Font.size i


{-| In `px`.
-}
letterSpacing : Float -> Attribute context msg
letterSpacing offset =
    attribute <| Font.letterSpacing offset


{-| In `px`.
-}
wordSpacing : Float -> Attribute context msg
wordSpacing offset =
    attribute <| Font.wordSpacing offset


{-| Align the font to the left.
-}
alignLeft : Attribute context msg
alignLeft =
    attribute Font.alignLeft


{-| Align the font to the right.
-}
alignRight : Attribute context msg
alignRight =
    attribute Font.alignRight


{-| Center align the font.
-}
center : Attribute context msg
center =
    attribute Font.center


{-| -}
justify : Attribute context msg
justify =
    attribute Font.justify



-- {-| -}
-- justifyAll : Attribute context msg
-- justifyAll =
--     Internal.class classesTextJustifyAll


{-| -}
underline : Attribute context msg
underline =
    attribute Font.underline


{-| -}
strike : Attribute context msg
strike =
    attribute Font.strike


{-| -}
italic : Attribute context msg
italic =
    attribute Font.italic


{-| -}
bold : Attribute context msg
bold =
    attribute Font.bold


{-| -}
light : Attribute context msg
light =
    attribute Font.light


{-| -}
hairline : Attribute context msg
hairline =
    attribute Font.hairline


{-| -}
extraLight : Attribute context msg
extraLight =
    attribute Font.extraLight


{-| -}
regular : Attribute context msg
regular =
    attribute Font.regular


{-| -}
semiBold : Attribute context msg
semiBold =
    attribute Font.semiBold


{-| -}
medium : Attribute context msg
medium =
    attribute Font.medium


{-| -}
extraBold : Attribute context msg
extraBold =
    attribute Font.extraBold


{-| -}
heavy : Attribute context msg
heavy =
    attribute Font.heavy


{-| This will reset bold and italic.
-}
unitalicized : Attribute context msg
unitalicized =
    attribute Font.unitalicized


{-| -}
shadow :
    { offset : ( Float, Float )
    , blur : Float
    , color : Color
    }
    -> Attr context decorative msg
shadow shade =
    attr <| Font.shadow shade


{-| A glow is just a simplified shadow.
-}
glow : Color -> Float -> Attr context decorative msg
glow clr i =
    attr <| Font.glow clr i



{- Variants -}


{-| -}
type alias Variant =
    Font.Variant


{-| You can use this to set a single variant on an element itself such as:

    el
        [ Font.variant Font.smallCaps
        ]
        (text "rendered with smallCaps")

**Note** These will **not** stack. If you want multiple variants, you should use `Font.variantList`.

-}
variant : Variant -> Attribute context msg
variant var =
    attribute <| Font.variant var


{-| -}
variantList : List Variant -> Attribute context msg
variantList vars =
    attribute <| Font.variantList vars


{-| [Small caps](https://en.wikipedia.org/wiki/Small_caps) are rendered using uppercase glyphs, but at the size of lowercase glyphs.
-}
smallCaps : Variant
smallCaps =
    Font.smallCaps


{-| Add a slash when rendering `0`
-}
slashedZero : Variant
slashedZero =
    Font.slashedZero


{-| -}
ligatures : Variant
ligatures =
    Font.ligatures


{-| Oridinal markers like `1st` and `2nd` will receive special glyphs.
-}
ordinal : Variant
ordinal =
    Font.ordinal


{-| Number figures will each take up the same space, allowing them to be easily aligned, such as in tables.
-}
tabularNumbers : Variant
tabularNumbers =
    Font.tabularNumbers


{-| Render fractions with the numerator stacked on top of the denominator.
-}
stackedFractions : Variant
stackedFractions =
    Font.stackedFractions


{-| Render fractions
-}
diagonalFractions : Variant
diagonalFractions =
    Font.diagonalFractions


{-| -}
swash : Int -> Variant
swash =
    Font.swash


{-| Set a feature by name and whether it should be on or off.

Feature names are four-letter names as defined in the [OpenType specification](https://docs.microsoft.com/en-us/typography/opentype/spec/featurelist).

-}
feature : String -> Bool -> Variant
feature =
    Font.feature


{-| A font variant might have multiple versions within the font.

In these cases we need to specify the index of the version we want.

-}
indexed : String -> Int -> Variant
indexed =
    Font.indexed
