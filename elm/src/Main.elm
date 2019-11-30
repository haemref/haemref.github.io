module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Element exposing (Element, el, fill, padding, row, text, width)
import Element.Events as Event
import Element.Font as Font
import Page.Contact as Contact
import Page.Home as Home
import Page.Ripss as Ripss
import Route as Route
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Page
    = HomePage Home.Model
    | ContactPage
    | RipssPage


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , page : Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        ( page, cmd ) =
            changeRoute key url
    in
    ( Model key url page, cmd )


changeRoute : Nav.Key -> Url.Url -> ( Page, Cmd Msg )
changeRoute key url =
    case Route.fromUrl url of
        Nothing ->
            initHome

        Just Route.Home ->
            initHome

        Just Route.Contact ->
            initContact

        Just Route.Ripss ->
            initRipss


initHome : ( Page, Cmd Msg )
initHome =
    Home.init
        |> (\( m, c ) -> ( HomePage m, c |> Cmd.map HomeMsg ))


initContact : ( Page, Cmd Msg )
initContact =
    ( ContactPage, Cmd.none )


initRipss : ( Page, Cmd Msg )
initRipss =
    ( RipssPage, Cmd.none )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UserClickedLogo
    | HomeMsg Home.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        ( UrlChanged url, _ ) ->
            let
                ( page, cmd ) =
                    changeRoute model.key url
            in
            ( { model | url = url, page = page }
            , cmd
            )

        ( UserClickedLogo, _ ) ->
            ( model, Route.pushUrl model.key Route.Home )

        ( HomeMsg homeMsg, HomePage homeModel ) ->
            let
                ( subModel, subCmd ) =
                    Home.update model.key homeMsg homeModel
            in
            ( { model | page = HomePage subModel }, subCmd |> Cmd.map HomeMsg )

        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        { title, body } =
            case model.page of
                HomePage subModel ->
                    { title = "Home", body = Home.view subModel |> Element.map HomeMsg }

                ContactPage ->
                    { title = "Contact", body = Contact.view }

                RipssPage ->
                    { title = "RIPSS", body = Ripss.view }
    in
    { title = title
    , body =
        [ Element.layoutWith
            { options =
                [ Element.focusStyle
                    (Element.FocusStyle (Just (Element.rgb255 68 127 245)) Nothing (Just { color = Element.rgb255 68 127 245, offset = ( 0, 0 ), blur = 0, size = 1 }))
                ]
            }
            [ Font.size 16 ]
            (Element.column
                [ Element.centerX
                , Element.width Element.fill
                , Element.height Element.fill
                ]
                [ viewHeader, body, viewFooter ]
            )
        ]
    }


viewHeader : Element Msg
viewHeader =
    Element.row
        [ Element.width Element.fill
        , Element.alignLeft
        , Element.height (Element.px 40)
        , Element.padding 10
        ]
        [ Element.el
            [ Event.onClick UserClickedLogo
            , Element.pointer
            ]
            (Element.text "About")
        ]


viewFooter : Element msg
viewFooter =
    Element.row
        [ Element.width Element.fill
        , Element.height (Element.px 72)
        , Element.padding 10
        , Element.alignBottom
        ]
        [ Element.column [ Element.centerX ] [ Element.text "Footer" ] ]
