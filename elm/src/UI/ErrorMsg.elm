module UI.ErrorMsg exposing (..)

import Element as Element exposing (Element)


type ErrorMsg
    = ErrorMsg (Maybe String)


init : Maybe String -> ErrorMsg
init s =
    ErrorMsg s


toHtml : ErrorMsg -> Element msg
toHtml (ErrorMsg s) =
    case s of
        Nothing ->
            Element.none

        Just m ->
            Element.el [] (Element.text m)
