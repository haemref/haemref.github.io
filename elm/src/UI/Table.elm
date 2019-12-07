module UI.Table exposing (..)

import Debug
import Dict exposing (Dict)
import Element exposing (Attribute, Element)
import Element.Background as Background


type alias Attributes msg =
    List (Attribute msg)


type alias Header =
    String


type alias Width =
    Int


type alias Index =
    Int


type alias View a msg =
    Index -> a -> Element msg


type alias TableConfig a msg =
    { data : List a
    , attributes : Attributes msg
    , columns : List (Column a msg)
    }


type alias Table a msg =
    TableConfig a msg


type alias ColumnConfig a msg =
    { header : Header
    , width : Width
    , attributes : Attributes msg
    , view : View a msg
    }


type alias Column a msg =
    ColumnConfig a msg


init : List a -> Table a msg
init data =
    { data = data
    , attributes = []
    , columns = []
    }


withColumn : Header -> Width -> Attributes msg -> View a msg -> Table a msg -> Table a msg
withColumn header width attributes view options =
    let
        column =
            [ { header = header
              , width = width
              , attributes = attributes
              , view = view
              }
            ]
    in
    { options | columns = List.concat [ options.columns, column ] }


toHtml : Table a msg -> Element msg
toHtml tableOptions =
    let
        headers =
            Element.row [ Element.padding 10, Background.color (Element.rgb255 123 123 123) ]
                (List.map
                    toHeaderColumn
                    tableOptions.columns
                )

        rows =
            toRows tableOptions.data tableOptions.columns
    in
    Element.column []
        [ Element.row tableOptions.attributes
            [ headers
            ]
        , rows
        ]


toRows : List a -> List (Column a msg) -> Element msg
toRows data columnOptions =
    let
        rows =
            List.map (\a -> toRowColumn columnOptions a) data
    in
    Element.column []
        rows


toRowColumn : List (Column a msg) -> a -> Element msg
toRowColumn columnConfig a =
    let
        rowColumns =
            List.indexedMap (\i -> \c -> Element.row [ Element.width (Element.px c.width) ] [ c.view i a ]) columnConfig
    in
    Element.row
        [ Element.padding 10 ]
        rowColumns


toHeaderColumn : Column a msg -> Element msg
toHeaderColumn columnOptions =
    Element.column
        [ Element.width (Element.px columnOptions.width)
        ]
        [ Element.text columnOptions.header ]
