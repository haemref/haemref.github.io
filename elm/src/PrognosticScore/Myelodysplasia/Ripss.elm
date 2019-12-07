module PrognosticScore.Myelodysplasia.Ripss exposing (featureTable)

import Element as Element
import Element.Background as Background
import Element.Font as Font
import Html exposing (Html)


type alias Feature =
    { score : String
    , cytogeneticCategory : String
    , marrowBlasts : String
    , haemoglobin : String
    , platelets : String
    , neutrophils : String
    }


features : List Feature
features =
    [ { score = "0"
      , cytogeneticCategory = "Very good"
      , marrowBlasts = "≤ 2"
      , haemoglobin = "≥ 100"
      , platelets = "≥ 100"
      , neutrophils = "≥ 0.8"
      }
    , { score = "0.5"
      , cytogeneticCategory = "-"
      , marrowBlasts = "-"
      , haemoglobin = "-"
      , platelets = "50 - 99"
      , neutrophils = "< 0.8"
      }
    , { score = "1.0"
      , cytogeneticCategory = "Good"
      , marrowBlasts = "2.1 - 4.9"
      , haemoglobin = "80 - 99"
      , platelets = "< 50"
      , neutrophils = "-"
      }
    , { score = "1.5"
      , cytogeneticCategory = "-"
      , marrowBlasts = "-"
      , haemoglobin = "< 80"
      , platelets = "-"
      , neutrophils = "-"
      }
    , { score = "2.0"
      , cytogeneticCategory = "Intermediate"
      , marrowBlasts = "5 - 10"
      , haemoglobin = "-"
      , platelets = "-"
      , neutrophils = "-"
      }
    , { score = "3.0"
      , cytogeneticCategory = "Poor"
      , marrowBlasts = "> 10"
      , haemoglobin = "-"
      , platelets = "-"
      , neutrophils = "-"
      }
    , { score = "4.0"
      , cytogeneticCategory = "Very poor"
      , marrowBlasts = "-"
      , haemoglobin = "-"
      , platelets = "-"
      , neutrophils = "-"
      }
    ]


volume label =
    Html.span []
        [ Html.text label
        , Html.text " (10"
        , Html.sup [] [ Html.text "9" ]
        , Html.text "/L)"
        ]
        |> Element.html


featureTable : Element.Element msg
featureTable =
    Element.table [ Element.spacing 30, Background.color (Element.rgb255 220 220 220), Element.padding 20 ]
        { data = features
        , columns =
            [ { header = Element.el [] (Element.text "Score")
              , width = Element.px 80
              , view =
                    \f -> Element.text f.score
              }
            , { header = Element.text "Cytogenetic Category*"
              , width = Element.fill
              , view =
                    \f -> Element.text f.cytogeneticCategory
              }
            , { header = Element.text "Haemoglobin (g/L)"
              , width = Element.fill
              , view =
                    \f -> Element.text f.haemoglobin
              }
            , { header = volume "Platelets"
              , width = Element.fill
              , view =
                    \f -> Element.text f.platelets
              }
            , { header = volume "Neutrophils"
              , width = Element.fill
              , view =
                    \f -> Element.text f.neutrophils
              }
            ]
        }



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



-- Cytogenetic categories:
--     Very good: -Y, del(11q)
--     Good: normal, del(5q), del(12p), del(20q), double including del(5q)
--     Intermediate: del(7q), +8, +19, i(17q), any other single or double independent clones
--     Poor: −7, inv(3)/t(3q)/del(3q), double including −7/del(7q), complex with 3 abnormalities
--     Very poor: complex with >3 abnormalities
-- Score	Risk category	Median OS
-- (years)	Median time to 25% AML risk (years)
-- ≤ 1.5	Very low	8.8	NR
-- 2.0 - 3.0	Low	5.3	10.8
-- 3.5 - 4.5	Intermediate	3.0	3.2
-- 5.0 - 6.0	High	1.6	1.4
-- > 6.0	Very high	0.8	0.73
