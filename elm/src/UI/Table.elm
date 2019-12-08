module UI.Table exposing (init, toHtml, withColumn, withHeading)

import Element exposing (Attribute, Element)
import Element.Background as Background
import Element.Font as Font
import UI.Heading as Heading


type alias Attributes msg =
    List (Attribute msg)


type alias Header msg =
    Element msg


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
    , heading : Heading.Heading
    }


type alias Table a msg =
    TableConfig a msg


type alias ColumnConfig a msg =
    { header : Header msg
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
    , heading = Heading.init ""
    }


withHeading : String -> Table a msg -> Table a msg
withHeading heading options =
    { options | heading = Heading.init heading }


withColumn : Header msg -> Width -> Attributes msg -> View a msg -> Table a msg -> Table a msg
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
            Element.row
                [ Element.padding rowPadding
                , Background.color (Element.rgb255 200 205 205)
                ]
                (List.map
                    toHeaderColumn
                    tableOptions.columns
                )

        rows =
            toRows tableOptions.data tableOptions.columns
    in
    Element.column [ Font.size 12 ]
        [ Element.row tableOptions.attributes
            [ tableOptions.heading |> Heading.toHtml
            ]
        , Element.row []
            [ headers
            ]
        , rows
        ]


toRows : List a -> List (Column a msg) -> Element msg
toRows data columnOptions =
    let
        rows =
            List.indexedMap (\i -> \a -> toRowColumn columnOptions a i) data
    in
    Element.column []
        rows


toRowColumn : List (Column a msg) -> a -> Index -> Element msg
toRowColumn columnConfig a index =
    let
        rowColumns =
            List.map
                (\c ->
                    Element.row
                        [ Element.width (Element.px c.width)
                        ]
                        [ c.view index a ]
                )
                columnConfig
    in
    Element.row
        [ Element.padding rowPadding
        , Background.color (rowBackgroundColor index)
        ]
        rowColumns


rowPadding : Int
rowPadding =
    10


rowBackgroundColor : Index -> Element.Color
rowBackgroundColor i =
    if modBy 2 i == 0 then
        Element.rgb255 240 240 240

    else
        Element.rgb255 255 255 255


toHeaderColumn : Column a msg -> Element msg
toHeaderColumn columnOptions =
    Element.column
        [ Element.width (Element.px columnOptions.width)
        ]
        [ columnOptions.header ]
