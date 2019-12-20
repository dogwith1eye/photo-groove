module PhotoGroove exposing (main)

import Html exposing (div, figure, h1, img, section, text)
import Html.Attributes exposing (..)
import List.Extra as ListE


urlPrefix =
    "http://elm-in-action.com/"


thumbnails =
    [ { url = "1.jpeg" }
    , { url = "2.jpeg" }
    , { url = "3.jpeg" }
    ]


viewThumbnailCols thumbs =
    let
        column a =
            div [ classList [ ( "column", True ), ( "is-half", List.length thumbs == 1 ) ] ] [ a ]
    in
    div [ class "columns" ]
        (List.map (viewThumbnail >> column) thumbs)


viewThumbnail thumb =
    figure [ class "image is-200by267 is-marginless" ]
        [ img [ src (urlPrefix ++ thumb.url) ] []
        ]


view model =
    section [ class "section" ]
        [ div [ class "content " ]
            [ h1 [] [ text "Photo Groove" ]
            , div [] (model |> ListE.greedyGroupsOf 2 |> List.map viewThumbnailCols)
            ]
        ]


main =
    view thumbnails
