module UI.Link exposing (init, toHtml)

import Element as Element exposing (Element)
import Element.Events as Event
import Element.Font as Font


type alias Url =
    String


type alias Label =
    String


type alias Options =
    { url : Url
    , label : Label
    }


type Link msg
    = Link msg Options


init : msg -> Url -> Label -> Link msg
init msg url label =
    Link msg (Options url label)


toHtml : Link msg -> Element msg
toHtml (Link msg_ options) =
    Element.link
        [ Event.onClick msg_
        , Font.color (Element.rgb255 68 127 245)
        ]
        { url = options.url
        , label = Element.text options.label
        }
