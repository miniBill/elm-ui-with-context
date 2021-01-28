# Elm-ui-with-context
This library wraps [`mdgriffith/elm-ui`](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) to provide a global context available while building the view. If you're not familiar with `elm-ui`, you should try it and only come back to this library when you have a problem to solve.

A context is a global, *constant or mostly constant* object. It can be used to store those things that you will need *almost everywhere* in your `view` but don't change often, or at all.

Examples of things you could want to put in the context:
1. theme (dark/light/custom) - this is needed almost everwhere for colors, and styles, and changes very rarely;
2. language - this is needed for every single label for localization, and changes rarely or never;
3. timezone - this is needed to display local times for the user, and mostly doesn't change;
4. responsive class (phone/tablet/desktop) - this doesn't usually change (unless the user dramatically resizes the window).

Example of things that you do *not* want in the context:
1. time - this changes constantly;
2. window size - on desktop, this can change a lot while resizing;
3. user ID - this should be part of your regular model.

A good test for inclusion is to think of this: does it make sense to completely redraw the user interface when the value changes? In particular, changing anything in the context will force the recalculation of all the `lazy` nodes.

## How to use it
1. Define a `Context` type (it will usually be a type alias);
2. replace any `import Element` with `import Element.WithContext as Element` and any `import Element.X as X` with `import Element.WithContext.X as X`;
3. don't expose `Element` or `Attribute`, but instead define your type aliases `type Element msg = Element.Element Context msg` and `type Attribute msg = Element.Attribute Context msg`;
4. pass the context to `Element.layout`;
5. everything should work as before, but now you can use `with` and `withAttribute` to access your context.


## Example: localization
A nice way to do localization is to completely avoid exposing `text` from `Element.WithContext`, and instead defining your custom one like this:

```
type Language
    = En
    | It
    | Fr


type alias L10N a =
    { en : a
    , it : a
    , fr : a
    }


text : L10N String -> Element { a | language : Language } msg
text { en, it, fr } =
    Element.with
        (\{ language } ->
            case language of
                En ->
                    en

                It ->
                    it

                Fr ->
                    fr
        )
        Element.text
```

So that you can use it like this: `text { en = "Hello", it = "Ciao", fr = "Bonjour" }` (you should also probably move all the localized strings into a `Localization` package).

This has the advantage of keeping a nice API while making it (almost) impossible to have untranslated labels.

Notice how `text` simply requires a context that includes a `language` field, so is very generic.

This tecnique can be adapted for image sources, title texts, and anything that needs localization.

Strings with placeholders can be represented as `L10N (a -> b -> String)` and used by defining an `apply : L10N (a -> b) -> a -> L10N b`. Beware: different languages can have very different rules on plurals, genders, special cases, ...


## Example: Theme
If you have a field `theme : Theme` in your context then you can replace any color constants in your code with `Theme -> Color` functions, and use them like this:


```
type Theme
    = Light
    | Dark


fontColor : Theme -> Color
fontColor theme =
    case theme of
        Light ->
            rgb 0.2 0.2 0.2

        Dark ->
            rgb 0.8 0.8 0.8


someViewFunction =
    el
        [ Element.withAttribute
            (\{theme} -> fontColor theme)
            Font.color
        ]
        (text "Hello")
```

(`\{theme} -> fontColor theme` can be replaced by `.theme >> fontColor`, depending on taste).

This also has the advantage that you can "force" a particular theme in places that need it, like the theme picker, by just doing `fontColor Light`.

## API differences from the original `elm-ui`

1. `Element msg` becomes `Element context msg` and `Attribute msg` becomes `Attribute context msg`,
2. `layout` requires a `context` parameter,
3. you have access to the `with` and `withAttribute` functions.

---

You should also have a look at [the original README](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/).
