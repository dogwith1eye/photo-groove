module PhotoGroove exposing (main)

import Browser
import Html exposing (div, figure, h1, img, section, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List.Extra as ListE


urlPrefix =
    "http://elm-in-action.com/"


initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    }


viewThumbnailCols selectedUrl thumbs =
    let
        column a =
            div
                [ classList
                    [ ( "column", True )
                    , ( "is-half", List.length thumbs == 1 )
                    , ( "has-background-primary", a.url == selectedUrl )
                    ]
                ]
                [ viewThumbnail a ]
    in
    div [ class "columns" ]
        (List.map column thumbs)


viewThumbnail thumb =
    figure [ class "image is-200by267 is-marginless" ]
        [ img
            [ src (urlPrefix ++ thumb.url)
            , onClick { description = "ClickedPhoto", data = thumb.url }
            ]
            []
        ]


view model =
    section [ class "section" ]
        [ div [ class "content" ]
            [ h1 [] [ text "Photo Groove" ]
            , div [ class "columns" ]
                [ div [ class "column" ] (model.photos |> ListE.greedyGroupsOf 2 |> List.map (viewThumbnailCols model.selectedUrl))
                , div [ class "column" ] [ img [ src (urlPrefix ++ model.selectedUrl), class "image is-fullwidth" ] [] ]
                ]
            ]
        ]


update msg model =
    if msg.description == "ClickedPhoto" then
        { model | selectedUrl = msg.data }

    else
        model


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
