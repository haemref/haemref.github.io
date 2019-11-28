module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Element as El
import Html exposing (..)
import Html.Attributes exposing (..)
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
    = Home
    | Contact
    | Ripss


type alias Model =
    { key : Nav.Key
    , page : Page
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    page url
        { key = key
        , page = Home
        }


page : Url.Url -> Model -> ( Model, Cmd Msg )
page url model =
    let
        route =
            Route.fromUrl url
    in
    case route of
        Route.Home ->
            ( { model | page = Home }, Cmd.none )

        Route.Contact ->
            ( { model | page = Contact }, Cmd.none )

        Route.Ripss ->
            ( { model | page = Ripss }, Cmd.none )



-- Route.Login ->
-- loginPage model Login.init
-- loginPage : Model -> ( Login.Model, Cmd Login.Msg ) -> ( Model, Cmd Msg )
-- loginPage model ( subModel, subCmd ) =
--     ( { model | page = Login subModel }
--     , Cmd.map LoginMsg subCmd
--     )
-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            page url model



-- LoginMsg msg ->
-- case model.page of
--     Login subModel ->
--         updateLogin model (Login.update msg subModel)
--     _ ->
--         ( model, Cmd.none )
-- updateLogin : Model -> ( Login.Model, Cmd Login.Msg ) -> ( Model, Cmd Msg )
-- updateLogin model ( subModel, cmds ) =
--     ( { model | page = Login subModel }
--     , Cmd.map LoginMsg cmds
--     )
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        { title, content } =
            viewPage model
    in
    { title = title
    , body =
        [ div []
            [ content ]
        , ul []
            [ viewLink "Home"
            , viewLink "Contact"
            , viewLink "Ripss"
            ]
        ]
    }


viewPage : Model -> { title : String, content : Html Msg }
viewPage model =
    let
        { title, content } =
            case model.page of
                Home ->
                    { title = "Home", content = Home.view }

                Contact ->
                    { title = "Contact", content = Contact.view }

                Ripss ->
                    { title = "RIPSS", content = Ripss.view }

        -- Login subModel ->
        --     viewSubPage (Login.view subModel) LoginMsg
    in
    { title = title, content = content }


viewSubPage : { title : String, content : Html a } -> (a -> msg) -> { title : String, content : Html msg }
viewSubPage { title, content } toMsg =
    { title = title, content = content |> Html.map toMsg }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href (String.toLower path) ] [ text path ] ]
