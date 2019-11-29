module UI.Button exposing (..)

import Animation as Animation
import Element as Element exposing (Element)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input


type Role
    = Primary
    | Secondary


type Enabled
    = Idle
    | Disabled


type alias Options =
    { enabled : Enabled
    , role : Role
    , animation : Animation.State
    , animationLabel : Maybe Label
    }


type alias Label =
    String


type Button msg
    = Button Options msg Label


defaultOptions : Options
defaultOptions =
    { role = Primary
    , enabled = Idle
    , animation = Animation.style []
    , animationLabel = Nothing
    }


init : msg -> Label -> Button msg
init msg label =
    Button defaultOptions msg label


withRole : Role -> Button msg -> Button msg
withRole role (Button options msg label) =
    Button { options | role = role } msg label


withEnabled : Enabled -> Button msg -> Button msg
withEnabled enabled (Button options msg label) =
    Button { options | enabled = enabled } msg label


withAnimation : Animation.State -> Button msg -> Button msg
withAnimation animation (Button options msg label) =
    Button { options | animation = animation } msg label


toHtml : Button msg -> Element msg
toHtml (Button options msg label) =
    Input.button
        (List.concat
            [ case options.role of
                Primary ->
                    primaryAttr

                _ ->
                    secondaryAttr
            ]
            ++ [ Border.width 1
               , Border.rounded 3
               , Border.color (Element.rgb255 0 0 0)
               ]
            ++ List.map (\a -> Element.htmlAttribute a) (Animation.render options.animation)
        )
        { label = Element.text label
        , onPress = Just msg
        }


secondaryAttr : List (Element.Attribute msg)
secondaryAttr =
    [ Element.paddingEach { edges | right = 20, left = 20, top = 15, bottom = 15 }
    ]


primaryAttr : List (Element.Attribute msg)
primaryAttr =
    [ Element.paddingEach { edges | right = 20, left = 20, top = 15, bottom = 15 }
    ]


edges : { top : Int, left : Int, right : Int, bottom : Int }
edges =
    { top = 0
    , left = 0
    , right = 0
    , bottom = 0
    }
