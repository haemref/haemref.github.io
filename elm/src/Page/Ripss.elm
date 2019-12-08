module Page.Ripss exposing (view)

import Element as Element exposing (Element)
import PrognosticScore.Myelodysplasia.Ripss as Ripss


view : Element msg
view =
    Element.column [ Element.centerX ]
        [ Element.row []
            [ Ripss.featureTable
            ]
        ]
