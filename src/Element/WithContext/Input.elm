module Element.WithContext.Input exposing
    ( focusedOnLoad
    , button
    , checkbox, defaultCheckbox
    , text, multiline
    , Placeholder, placeholder, runPlaceholder, runLabel
    , username, newPassword, currentPassword, email, search, spellChecked
    , slider, Thumb, thumb, defaultThumb
    , radio, radioRow, Option, option, optionWith, OptionState(..)
    , Label, labelAbove, labelBelow, labelLeft, labelRight, labelHidden
    )

{-| Input elements have a lot of constraints!

We want all of our input elements to:

  - _Always be accessible_
  - _Behave intuitively_
  - _Be completely restyleable_

While these three goals may seem pretty obvious, Html and CSS have made it surprisingly difficult to achieve!

And incredibly difficult for developers to remember all the tricks necessary to make things work. If you've every tried to make a `<textarea>` be the height of it's content or restyle a radio button while maintaining accessibility, you may be familiar.

This module is intended to be accessible by default. You shouldn't have to wade through docs, articles, and books to find out [exactly how accessible your html actually is](https://www.powermapper.com/tests/screen-readers/aria/index.html).


# Focus Styling

All Elements can be styled on focus by using [`Element.focusStyle`](Element#focusStyle) to set a global focus style or [`Element.focused`](Element#focused) to set a focus style individually for an element.

@docs focusedOnLoad


# Buttons

@docs button


# Checkboxes

A checkbox requires you to store a `Bool` in your model.

This is also the first input element that has a [`required label`](#Label).

    import Element exposing (text)
    import Element.Input as Input

    type Msg
        = GuacamoleChecked Bool

    view model =
        Input.checkbox []
            { onChange = GuacamoleChecked
            , icon = Input.defaultCheckbox
            , checked = model.guacamole
            , label =
                Input.labelRight []
                    (text "Do you want Guacamole?")
            }

@docs checkbox, defaultCheckbox


# Text

@docs text, multiline

@docs Placeholder, placeholder, runPlaceholder, runLabel


## Text with autofill

If we want to play nicely with a browser's ability to autofill a form, we need to be able to give it a hint about what we're expecting.

The following inputs are very similar to `Input.text`, but they give the browser a hint to allow autofill to work correctly.

@docs username, newPassword, currentPassword, email, search, spellChecked


# Sliders

A slider is great for choosing between a range of numerical values.

  - **thumb** - The icon that you click and drag to change the value.
  - **track** - The line behind the thumb denoting where you can slide to.

@docs slider, Thumb, thumb, defaultThumb


# Radio Selection

The fact that we still call this a radio selection is fascinating. I can't remember the last time I actually used an honest-to-goodness button on a radio. Chalk it up along with the floppy disk save icon or the word [Dashboard](https://en.wikipedia.org/wiki/Dashboard).

Perhaps a better name would be `Input.chooseOne`, because this allows you to select one of a set of options!

Nevertheless, here we are. Here's how you put one together

    Input.radio
        [ padding 10
        , spacing 20
        ]
        { onChange = ChooseLunch
        , selected = Just model.lunch
        , label = Input.labelAbove [] (text "Lunch")
        , options =
            [ Input.option Burrito (text "Burrito")
            , Input.option Taco (text "Taco!")
            , Input.option Gyro (text "Gyro")
            ]
        }

**Note** we're using `Input.option`, which will render the default radio icon you're probably used to. If you want compeltely custom styling, use `Input.optionWith`!

@docs radio, radioRow, Option, option, optionWith, OptionState


# Labels

Every input has a required `Label`.

@docs Label, labelAbove, labelBelow, labelLeft, labelRight, labelHidden


# Form Elements

You might be wondering where something like `<form>` is.

What I've found is that most people who want `<form>` usually want it for the [implicit submission behavior](https://html.spec.whatwg.org/multipage/form-control-infrastructure.html#implicit-submission) or to be clearer, they want to do something when the `Enter` key is pressed.

Instead of implicit submission behavior, [try making an `onEnter` event handler like in this Ellie Example](https://ellie-app.com/5X6jBKtxzdpa1). Then everything is explicit!

And no one has to look up obtuse html documentation to understand the behavior of their code :).


# File Inputs

Presently, elm-ui does not expose a replacement for `<input type="file">`; in the meantime, an `Input.button` and `elm/file`'s `File.Select` may meet your needs.


# Disabling Inputs

You also might be wondering how to disable an input.

Disabled inputs can be a little problematic for user experience, and doubly so for accessibility. This is because it's now your priority to inform the user _why_ some field is disabled.

If an input is truly disabled, meaning it's not focusable or doesn't send off a `Msg`, you actually lose your ability to help the user out! For those wary about accessibility [this is a big problem.](https://ux.stackexchange.com/questions/103239/should-disabled-elements-be-focusable-for-accessibility-purposes)

Here are some alternatives to think about that don't involve explicitly disabling an input.

**Disabled Buttons** - Change the `Msg` it fires, the text that is rendered, and optionally set a `Region.description` which will be available to screen readers.

    import Element.Input as Input
    import Element.Region as Region

    myButton ready =
        if ready then
            Input.button
                [ Background.color blue
                ]
                { onPress =
                    Just SaveButtonPressed
                , label =
                    text "Save blog post"
                }

        else
            Input.button
                [ Background.color grey
                , Region.description
                    "A publish date is required before saving a blogpost."
                ]
                { onPress =
                    Just DisabledSaveButtonPressed
                , label =
                    text "Save Blog "
                }

Consider showing a hint if `DisabledSaveButtonPressed` is sent.

For other inputs such as `Input.text`, consider simply rendering it in a normal `paragraph` or `el` if it's not editable.

Alternatively, see if it's reasonable to _not_ display an input if you'd normally disable it. Is there an option where it's only visible when it's editable?

-}

import Element as Vanilla
import Element.Input as Input
import Element.WithContext exposing (Attribute, Element, element)
import Element.WithContext.Internal exposing (attribute, attributes, run, wrapAttrs)


{-| -}
type Placeholder context msg
    = Placeholder (context -> Input.Placeholder msg)


{-| -}
placeholder : List (Attribute context msg) -> Element context msg -> Placeholder context msg
placeholder attrs child =
    Placeholder
        (\context ->
            Input.placeholder (attributes context attrs) (run context child)
        )


{-| -}
type Label context msg
    = Label (context -> Input.Label msg)


buildLabel :
    (List (Vanilla.Attribute msg)
     -> Vanilla.Element msg
     -> Input.Label msg
    )
    -> List (Attribute context msg)
    -> Element context msg
    -> Label context msg
buildLabel f attrs child =
    Label
        (\context ->
            f (attributes context attrs) (run context child)
        )


{-| -}
labelRight : List (Attribute context msg) -> Element context msg -> Label context msg
labelRight =
    buildLabel Input.labelRight


{-| -}
labelLeft : List (Attribute context msg) -> Element context msg -> Label context msg
labelLeft =
    buildLabel Input.labelLeft


{-| -}
labelAbove : List (Attribute context msg) -> Element context msg -> Label context msg
labelAbove =
    buildLabel Input.labelAbove


{-| -}
labelBelow : List (Attribute context msg) -> Element context msg -> Label context msg
labelBelow =
    buildLabel Input.labelBelow


{-| Sometimes you may need to have a label which is not visible, but is still accessible to screen readers.

Seriously consider a visible label before using this.

The situations where a hidden label makes sense:

  - A searchbar with a `search` button right next to it.
  - A `table` of inputs where the header gives the label.

Basically, a hidden label works when there are other contextual clues that sighted people can pick up on.

-}
labelHidden : String -> Label context msg
labelHidden content =
    Label <| \_ -> Input.labelHidden content


{-| A standard button.

The `onPress` handler will be fired either `onClick` or when the element is focused and the `Enter` key has been pressed.

    import Element exposing (rgb255, text)
    import Element.Background as Background
    import Element.Input as Input

    blue =
        Element.rgb255 238 238 238

    myButton =
        Input.button
            [ Background.color blue
            , Element.focused
                [ Background.color purple ]
            ]
            { onPress = Just ClickMsg
            , label = text "My Button"
            }

**Note** If you have an icon button but want it to be accessible, consider adding a [`Region.description`](Element-Region#description), which will describe the button to screen readers.

-}
button :
    List (Attribute context msg)
    ->
        { onPress : Maybe msg
        , label : Element context msg
        }
    -> Element context msg
button =
    wrapAttrs Input.button
        (\context { onPress, label } ->
            { onPress = onPress
            , label = run context label
            }
        )


{-|

  - **onChange** - The `Msg` to send.
  - **icon** - The checkbox icon to show. This can be whatever you'd like, but `Input.defaultCheckbox` is included to get you started.
  - **checked** - The current checked state.
  - **label** - The [`Label`](#Label) for this checkbox

-}
checkbox :
    List (Attribute context msg)
    ->
        { onChange : Bool -> msg
        , icon : Bool -> Element context msg
        , checked : Bool
        , label : Label context msg
        }
    -> Element context msg
checkbox =
    wrapAttrs Input.checkbox
        (\context { label, icon, checked, onChange } ->
            { label = runLabel context label
            , icon = icon >> run context
            , checked = checked
            , onChange = onChange
            }
        )


{-| -}
type Thumb context
    = Thumb (context -> Input.Thumb)


{-| -}
thumb : List (Attribute context Never) -> Thumb context
thumb attrs =
    Thumb <| \context -> Input.thumb <| attributes context attrs


runThumb : a -> Thumb a -> Input.Thumb
runThumb context (Thumb f) =
    f context


{-| -}
defaultThumb : Thumb context
defaultThumb =
    Thumb <| \_ -> Input.defaultThumb


{-| A slider input, good for capturing float values.

    Input.slider
        [ Element.height (Element.px 30)

        -- Here is where we're creating/styling the "track"
        , Element.behindContent
            (Element.el
                [ Element.width Element.fill
                , Element.height (Element.px 2)
                , Element.centerY
                , Background.color grey
                , Border.rounded 2
                ]
                Element.none
            )
        ]
        { onChange = AdjustValue
        , label =
            Input.labelAbove []
                (text "My Slider Value")
        , min = 0
        , max = 75
        , step = Nothing
        , value = model.sliderValue
        , thumb =
            Input.defaultThumb
        }

`Element.behindContent` is used to render the track of the slider. Without it, no track would be rendered. The `thumb` is the icon that you can move around.

The slider can be vertical or horizontal depending on the width/height of the slider.

  - `height fill` and `width (px someWidth)` will cause the slider to be vertical.
  - `height (px someHeight)` and `width (px someWidth)` where `someHeight` > `someWidth` will also do it.
  - otherwise, the slider will be horizontal.

**Note** If you want a slider for an `Int` value:

  - set `step` to be `Just 1`, or some other whole value
  - `value = toFloat model.myInt`
  - And finally, round the value before making a message `onChange = round >> AdjustValue`

-}
slider :
    List (Attribute context msg)
    ->
        { onChange : Float -> msg
        , label : Label context msg
        , min : Float
        , max : Float
        , value : Float
        , thumb : Thumb context
        , step : Maybe Float
        }
    -> Element context msg
slider =
    wrapAttrs Input.slider
        (\context config ->
            { onChange = config.onChange
            , label = runLabel context config.label
            , min = config.min
            , max = config.max
            , value = config.value
            , thumb = runThumb context config.thumb
            , step = config.step
            }
        )


textHelper :
    (List (Vanilla.Attribute msg)
     ->
        { onChange : String -> msg
        , text : String
        , label : Input.Label msg
        , placeholder : Maybe (Input.Placeholder msg)
        }
     -> Vanilla.Element msg
    )
    -> List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , label : Label context msg
        , placeholder : Maybe (Placeholder context msg)
        }
    -> Element context msg
textHelper f =
    wrapAttrs f
        (\context config ->
            { onChange = config.onChange
            , text = config.text
            , label = runLabel context config.label
            , placeholder = Maybe.map (runPlaceholder context) config.placeholder
            }
        )


runPlaceholder : context -> Placeholder context msg -> Input.Placeholder msg
runPlaceholder context (Placeholder f) =
    f context


runLabel : context -> Label context msg -> Input.Label msg
runLabel context (Label f) =
    f context


{-| -}
text :
    List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder context msg)
        , label : Label context msg
        }
    -> Element context msg
text =
    textHelper Input.text


{-| If spell checking is available, this input will be spellchecked.
-}
spellChecked :
    List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder context msg)
        , label : Label context msg
        }
    -> Element context msg
spellChecked =
    textHelper Input.spellChecked


{-| -}
search :
    List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder context msg)
        , label : Label context msg
        }
    -> Element context msg
search =
    textHelper Input.search


{-| A password input that allows the browser to autofill.

It's `newPassword` instead of just `password` because it gives the browser a hint on what type of password input it is.

A password takes all the arguments a normal `Input.text` would, and also **show**, which will remove the password mask (e.g. `****` vs `pass1234`)

-}
newPassword :
    List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder context msg)
        , label : Label context msg
        , show : Bool
        }
    -> Element context msg
newPassword =
    wrapAttrs Input.newPassword
        (\context config ->
            { onChange = config.onChange
            , text = config.text
            , label = runLabel context config.label
            , placeholder = Maybe.map (runPlaceholder context) config.placeholder
            , show = config.show
            }
        )


{-| -}
currentPassword :
    List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder context msg)
        , label : Label context msg
        , show : Bool
        }
    -> Element context msg
currentPassword =
    wrapAttrs Input.currentPassword
        (\context config ->
            { onChange = config.onChange
            , text = config.text
            , label = runLabel context config.label
            , placeholder = Maybe.map (runPlaceholder context) config.placeholder
            , show = config.show
            }
        )


{-| -}
username :
    List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder context msg)
        , label : Label context msg
        }
    -> Element context msg
username =
    textHelper Input.username


{-| -}
email :
    List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder context msg)
        , label : Label context msg
        }
    -> Element context msg
email =
    textHelper Input.email


{-| A multiline text input.

By default it will have a minimum height of one line and resize based on it's contents.

-}
multiline :
    List (Attribute context msg)
    ->
        { onChange : String -> msg
        , text : String
        , placeholder : Maybe (Placeholder context msg)
        , label : Label context msg
        , spellcheck : Bool
        }
    -> Element context msg
multiline =
    wrapAttrs Input.multiline
        (\context config ->
            { onChange = config.onChange
            , text = config.text
            , label = runLabel context config.label
            , placeholder = Maybe.map (runPlaceholder context) config.placeholder
            , spellcheck = config.spellcheck
            }
        )


{-| -}
type Option context value msg
    = Option (context -> Input.Option value msg)


runOption : a -> Option a value msg -> Input.Option value msg
runOption context (Option f) =
    f context


{-| -}
type OptionState
    = Idle
    | Focused
    | Selected


{-| Add a choice to your radio element. This will be rendered with the default radio icon.
-}
option : value -> Element context msg -> Option context value msg
option val txt =
    Option <| \context -> Input.option val (run context txt)


{-| Customize exactly what your radio option should look like in different states.
-}
optionWith : value -> (OptionState -> Element context msg) -> Option context value msg
optionWith val view =
    let
        optionStateConverter optionState =
            case optionState of
                Input.Idle ->
                    Idle

                Input.Focused ->
                    Focused

                Input.Selected ->
                    Selected

        viewConverted optionState =
            view (optionStateConverter optionState)
    in
    Option <| \context -> Input.optionWith val (run context << viewConverted)


{-| -}
radio :
    List (Attribute context msg)
    ->
        { onChange : option -> msg
        , options : List (Option context option msg)
        , selected : Maybe option
        , label : Label context msg
        }
    -> Element context msg
radio =
    wrapAttrs Input.radio radioHelper


{-| Same as radio, but displayed as a row
-}
radioRow :
    List (Attribute context msg)
    ->
        { onChange : option -> msg
        , options : List (Option context option msg)
        , selected : Maybe option
        , label : Label context msg
        }
    -> Element context msg
radioRow =
    wrapAttrs Input.radioRow radioHelper


radioHelper :
    context
    ->
        { onChange : option -> msg
        , options : List (Option context option msg)
        , selected : Maybe option
        , label : Label context msg
        }
    ->
        { onChange : option -> msg
        , options : List (Input.Option option msg)
        , selected : Maybe option
        , label : Input.Label msg
        }
radioHelper context config =
    { onChange = config.onChange
    , options = List.map (runOption context) config.options
    , selected = config.selected
    , label = runLabel context config.label
    }


{-| Attach this attribute to any `Input` that you would like to be automatically focused when the page loads.

You should only have a maximum of one per page.

-}
focusedOnLoad : Attribute context msg
focusedOnLoad =
    attribute Input.focusedOnLoad


{-| The blue default checked box icon.

You'll likely want to make your own checkbox at some point that fits your design.

-}
defaultCheckbox : Bool -> Element context msg
defaultCheckbox checked =
    element <| Input.defaultCheckbox checked
