module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (Html, div, figure, h1, img, section, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List.Extra as ListE


type alias Photo =
    { url : String }


type alias Model =
    { photos : List Photo
    , selectedUrl : String
    }


type alias Msg =
    { description : String
    , data : String
    }


urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"


initialModel : Model
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    }


photoArray : Array Photo
photoArray =
    Array.fromList initialModel.photos


viewThumbnailCols : String -> List Photo -> Html Msg
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


viewThumbnail : Photo -> Html Msg
viewThumbnail thumb =
    figure [ class "image is-200by267 is-marginless" ]
        [ img
            [ src (urlPrefix ++ thumb.url)
            , onClick { description = "ClickedPhoto", data = thumb.url }
            ]
            []
        ]


view : Model -> Html Msg
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
