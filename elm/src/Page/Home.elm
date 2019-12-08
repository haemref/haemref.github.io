module Page.Home exposing (Model, Msg(..), init, update, view)

import Browser.Navigation as Nav
import Element as El
import Element.Font as Font
import Element.Region as Region
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
    El.column [ El.centerX ]
        [ El.row [ El.centerX ]
            [ El.column [ El.paddingXY 100 100, El.spacing 50, El.width El.fill ]
                [ El.el [ Region.heading 2, El.centerX, Font.variant (Font.feature "sups" True) ] (El.text "Haematology Reference")
                , TextField.init UserChangedSearch model.search "Search"
                    |> TextField.withFieldType (TextField.Search UserClickedSearch)
                    |> TextField.withFocus True
                    |> TextField.toHtml
                ]
            ]
        ]


marie : Person
marie =
    { firstname = "Marie", lastname = "Blake" }


michael : Person
michael =
    { firstname = "Michael", lastname = "Blake" }


a : { firstname : String, lastname : String }
a =
    { firstname = "a", lastname = "b" }


type alias Person =
    { firstname : String
    , lastname : String
    }



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
