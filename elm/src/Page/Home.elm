module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Element as El
import Element.Region as Region
import Route as Route
import UI.Button as Button
import UI.TextField as TextField



-- MODEL


type alias Model =
    { search : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )



-- UPDATE


type Msg
    = UserChangedSearch String
    | UserClickedSearch


update : Nav.Key -> Msg -> Model -> ( Model, Cmd Msg )
update key msg model =
    case msg of
        UserChangedSearch search ->
            ( { model | search = search }, Cmd.none )

        UserClickedSearch ->
            ( model, Cmd.none )



-- VIEW


view model =
    El.column [ El.centerX, El.paddingXY 100 100, El.spacing 50 ]
        [ El.el [ Region.heading 2, El.centerX, El.moveRight 20 ] (El.text "Haematology Reference")
        , TextField.init UserChangedSearch model.search "Search"
            |> TextField.withFieldType (TextField.Search UserClickedSearch)
            |> TextField.withFocus True
            |> TextField.toHtml
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
