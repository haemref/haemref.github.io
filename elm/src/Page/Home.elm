module Page.Home exposing (view)

import Html exposing (Html, div, text)


view : Html msg
view =
    div []
        [ text "HOME"
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
