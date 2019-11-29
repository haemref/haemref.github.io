module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Element as El
import Route as Route
import UI.Button as Button



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )



-- UPDATE


type Msg
    = UserClickedButton


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update key msg model =
    case msg of
        UserClickedButton ->
            ( model, Route.pushUrl key Route.Ripss )



-- VIEW


view model =
    El.row []
        [ Button.init UserClickedButton "RIPSS"
            |> Button.toHtml
        ]



-- view : Model -> { title : String, content : Html Msg }
-- view model =
--     { title = "Login"
--     , content =
--         div []
--             [ Html.form [ onSubmit SubmitForm ]
--                 [ div []
--                     [ input [ type_ "text", placeholder "Email", onInput UpdateEmail, value model.form.email ] []
--                     , input [ type_ "password", placeholder "Password", onInput UpdatePassword, value model.form.password ] []
--                     , button [] [ text "Sign in" ]
--                     ]
--                 ]
--             ]
--     }
