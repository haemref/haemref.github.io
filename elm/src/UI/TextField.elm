module UI.TextField exposing (FieldType(..), init, toHtml, withFieldType, withFocus)

import Element as Element exposing (Element)
import Element.Background as Background
import Element.Events as Event
import Element.Input as Input
import Svg as Svg
import Svg.Attributes as Svga


type FieldType msg
    = Username
    | CurrentPassword msg Show
    | Email
    | Text
    | Search msg


type alias Options msg =
    { fieldType : FieldType msg
    , focus : Focus
    }


type alias Show =
    Bool


type alias Label =
    String


type alias Text =
    String


type alias Focus =
    Bool


type TextField msg
    = TextField (Options msg) (String -> msg) String Label


defaultOptions : Options msg
defaultOptions =
    { fieldType = Text
    , focus = False
    }


init : (String -> msg) -> Text -> Label -> TextField msg
init msg text label =
    TextField defaultOptions msg text label


withFieldType : FieldType msg -> TextField msg -> TextField msg
withFieldType fieldType (TextField options msg text label) =
    TextField { options | fieldType = fieldType } msg text label


withFocus : Focus -> TextField msg -> TextField msg
withFocus focus (TextField options msg text label) =
    TextField { options | focus = focus } msg text label


toHtml : TextField msg -> Element msg
toHtml (TextField options msg text_ label_) =
    let
        focused =
            case options.focus of
                True ->
                    [ Input.focusedOnLoad ]

                False ->
                    []
    in
    case options.fieldType of
        Text ->
            Input.text ([] ++ focused)
                { label = Input.labelAbove [] (Element.text label_)
                , onChange = msg
                , placeholder = Just (Input.placeholder [] (Element.text label_))
                , text = text_
                }

        Username ->
            Input.username ([] ++ focused)
                { label = Input.labelAbove [] (Element.text label_)
                , onChange = msg
                , placeholder = Just (Input.placeholder [] (Element.text label_))
                , text = text_
                }

        Email ->
            Input.email ([] ++ focused)
                { label = Input.labelAbove [] (Element.text label_)
                , onChange = msg
                , placeholder = Just (Input.placeholder [] (Element.text label_))
                , text = text_
                }

        Search msg_ ->
            Element.row
                [ Element.onRight
                    (Element.el
                        [ Element.alignRight
                        , Element.pointer
                        , Element.paddingXY 6 0
                        , Element.moveRight 0.45
                        , Event.onClick msg_
                        , Background.color (Element.rgb255 68 127 245)
                        ]
                        searchIcon
                    )
                , Element.moveLeft 28
                ]
                [ Input.search
                    ([] ++ focused)
                    { label = Input.labelHidden label_
                    , onChange = msg
                    , placeholder = Nothing
                    , text = text_
                    }
                ]

        CurrentPassword msg_ show_ ->
            Element.row
                [ Element.inFront
                    (Element.el
                        [ Element.alignRight
                        , Element.paddingXY 10 38
                        , Element.scale 0.8
                        , Event.onClick msg_
                        , Element.pointer
                        ]
                        (Element.text
                            (case show_ of
                                True ->
                                    "Hide"

                                False ->
                                    "Show"
                            )
                        )
                    )
                ]
                [ Input.currentPassword
                    ([] ++ focused)
                    { label = Input.labelAbove [] (Element.text label_)
                    , onChange = msg
                    , placeholder = Just (Input.placeholder [] (Element.text label_))
                    , text = text_
                    , show = show_
                    }
                ]


searchIcon =
    Element.el
        []
        (Svg.svg
            [ Svga.width "40"
            , Svga.height "42"
            , Svga.viewBox "0 0 40 40"
            , Svga.fill "#447ff5"
            ]
            [ Svg.circle
                [ Svga.cx "18"
                , Svga.cy "18"
                , Svga.r "10"
                , Svga.stroke "#fff"
                , Svga.strokeWidth "2"
                ]
                []
            , Svg.line
                [ Svga.x1 "23"
                , Svga.x2 "28"
                , Svga.y1 "28"
                , Svga.y2 "36"
                , Svga.stroke "#fff"
                , Svga.strokeWidth "2"
                ]
                []
            ]
            |> Element.html
        )
