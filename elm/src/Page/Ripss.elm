module Page.Ripss exposing (view)

import Element as El



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


type Ripps
    = Ripps
        { cytogenetics : Cytogenetics
        , bmBlast : BmBlast
        , platelet : Platelet
        , neutrophil : Neutrophil
        , haemoglobin : Haemoglobin
        , score : Float
        }


bmBlastScore : BmBlast -> Float
bmBlastScore bmBlast =
    if bmBlast > 2 && bmBlast < 5 then
        1

    else if bmBlast >= 5 && bmBlast <= 10 then
        2

    else if bmBlast > 10 then
        3

    else
        0


haemoglobinScore : Haemoglobin -> Float
haemoglobinScore haemoglobin =
    if haemoglobin >= 8 && haemoglobin < 10 then
        1

    else if haemoglobin < 8 then
        1.5

    else
        0


plateletScore : Platelet -> Float
plateletScore platelet =
    if platelet >= 50 && platelet < 100 then
        0.5

    else if platelet < 50 then
        1

    else
        0


neutrophilScore : Neutrophil -> Float
neutrophilScore neutrophil =
    if neutrophil < 0.8 then
        0.5

    else
        0


cytogeneticsScore : Cytogenetics -> Float
cytogeneticsScore cytogenetics =
    case cytogenetics of
        VeryGood ->
            0

        Good ->
            1

        Intermediate ->
            2

        Poor ->
            3

        VeryPoor ->
            4


init : Cytogenetics -> BmBlast -> Platelet -> Neutrophil -> Haemoglobin -> Ripps
init cytogenetics bmBlast platelet neutrophil haemoglobin =
    let
        score =
            cytogeneticsScore cytogenetics
                + bmBlastScore bmBlast
                + plateletScore platelet
                + neutrophilScore neutrophil
                + haemoglobinScore haemoglobin
    in
    Ripps
        { cytogenetics = cytogenetics
        , bmBlast = bmBlast
        , platelet = platelet
        , neutrophil = neutrophil
        , haemoglobin = haemoglobin
        , score = score
        }


view =
    El.el [] (El.text "RIPSS")
