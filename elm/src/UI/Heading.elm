module UI.Heading exposing (Heading, HeadingSize(..), init, toHtml, withSize, withWidth)

import Element as Element exposing (Element)
import Element.Font as Font


type HeadingSize
    = Large
    | Normal
    | Small


type alias HeadingOptions =
    { heading : String
    , width : Element.Length
    , size : HeadingSize
    }


type Heading
    = Heading HeadingOptions


init : String -> Heading
init heading =
    Heading
        { heading = heading
        , width = Element.fill
        , size = Normal
        }


withSize : HeadingSize -> Heading -> Heading
withSize size (Heading options) =
    Heading { options | size = size }


withWidth : Element.Length -> Heading -> Heading
withWidth width (Heading options) =
    Heading { options | width = width }


toHtml : Heading -> Element msg
toHtml (Heading options) =
    let
        size =
            case options.size of
                Large ->
                    20

                Normal ->
                    18

                Small ->
                    16
    in
    Element.paragraph [ Font.size size, Element.paddingXY 0 10 ] [ Element.text options.heading ]
