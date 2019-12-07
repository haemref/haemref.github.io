module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Element exposing (Element, el, fill, padding, row, text, width)
import Element.Border as Border
import Element.Events as Event
import Element.Font as Font
import Page.About as About
import Page.Contact as Contact
import Page.Home as Home
import Page.Ripss as Ripss
import Route as Route
import UI.Link as Link
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
    | AboutPage


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

        Just Route.About ->
            initAbout


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


initAbout : ( Page, Cmd Msg )
initAbout =
    ( AboutPage, Cmd.none )


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | UserClickedAbout
    | UserClickedHome
    | UserClickedContact
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

        ( UserClickedAbout, _ ) ->
            ( model, Route.pushUrl model.key Route.About )

        ( UserClickedHome, _ ) ->
            ( model, Route.pushUrl model.key Route.Home )

        ( UserClickedContact, _ ) ->
            ( model, Route.pushUrl model.key Route.Contact )

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

                AboutPage ->
                    { title = "About", body = About.view }
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
                [ viewHeader
                , Element.row
                    [ Element.height Element.fill
                    , Element.centerX
                    , Element.height (Element.fill |> Element.minimum 500)
                    , Element.moveUp 50
                    ]
                    [ body ]
                , Element.row [ Element.width Element.fill ] [ viewFooter ]
                ]
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
        , Element.spacingXY 16 0
        , Font.size 14
        ]
        [ Link.init
            UserClickedHome
            "/"
            "Home"
            |> Link.toHtml
        , Link.init
            UserClickedAbout
            "about"
            "About"
            |> Link.toHtml
        , Link.init
            UserClickedContact
            "contact"
            "Contact"
            |> Link.toHtml
        ]


viewFooter : Element msg
viewFooter =
    Element.row
        [ Element.width Element.fill
        , Element.padding 10
        , Border.solid
        , Border.color (Element.rgb255 180 180 180)
        , Border.widthEach { bottom = 0, left = 0, right = 0, top = 2 }
        ]
        [ Element.column [ Element.centerX, Element.padding 20 ]
            [ Element.el [] (Element.text "...other things will go here...")
            ]
        ]
