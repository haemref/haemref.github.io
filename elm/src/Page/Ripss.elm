module Page.Ripss exposing (view)

import Element as El
import Html exposing (Html)



-- *Greenberg, Tuechler, Schanz et al, Revised International Prognostic Scoring System (IPSS-R) for Myelodysplastic Syndrome, Blood 120: 2454, 2012.


type Cytogenetics
    = VeryGood
    | Good
    | Intermediate
    | Poor
    | VeryPoor


type alias BmBlast =
    Int


type alias Haemoglobin =
    Float


type alias Platelet =
    Float


type alias Neutrophil =
    Float


type alias Model =
    { cytogenetic : Maybe Cytogenetics
    , bmblast : Maybe BmBlast
    , platelet : Maybe Platelet
    , neutrophil : Maybe Neutrophil
    , haemoglobin : Maybe Haemoglobin
    }


type RIPPS
    = Cytogenetics Haemoglobin BmBlast Platelet Neutrophil


view : Html msg
view =
    El.layout [] <| El.el [] (El.text "RIPSS")
