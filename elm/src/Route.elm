module Route exposing (Route(..), fromUrl, href, pushUrl, replaceUrl)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s)



-- ROUTING


type Route
    = Home
    | Contact
    | About
    | Ripss


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map Home Parser.top
        , Parser.map Contact (s "contact")
        , Parser.map About (s "about")
        , Parser.map Ripss (s "ripss")
        ]



-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


pushUrl : Nav.Key -> Route -> Cmd msg
pushUrl key route =
    Nav.pushUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    url
        |> Parser.parse parser



-- INTERNAL


routeToString : Route -> String
routeToString route =
    case route of
        Home ->
            "/"

        Contact ->
            "contact"

        Ripss ->
            "ripss"

        About ->
            "about"
