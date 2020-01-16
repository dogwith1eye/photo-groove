module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (Html, a, div, figure, h1, img, input, label, p, section, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import List.Extra as ListE
import Random


urlPrefix : String
urlPrefix =
    "http://elm-in-action.com/"


type Msg
    = ClickedPhoto String
    | ClickedColor ThumbnailColor
    | ClickedSurpriseMe
    | GotSelectedIndex Int


view : Model -> Html Msg
view model =
    section [ class "section" ]
        [ div [ class "content" ]
            [ h1 [] [ text "Photo Groove" ]
            , div [ class "columns" ]
                [ div [ class "column" ]
                    [ div [ class "field is-horizontal" ]
                        [ div [ class "field-label" ]
                            [ label [ class "label" ] [ text "Color:" ] ]
                        , div [ class "field-body" ]
                            [ div [ class "field" ]
                                [ div [ class "control" ] (List.map viewColorChooser [ Primary, Info, Danger ]) ]
                            ]
                        ]
                    ]
                , div [ class "column" ]
                    [ div [ class "field" ]
                        [ p [ class "control" ]
                            [ a [ class "button is-primary", onClick ClickedSurpriseMe ] [ text "Surprise Me!" ] ]
                        ]
                    ]
                ]
            , div [ class "columns" ]
                [ div [ class "column" ] (model.photos |> ListE.greedyGroupsOf 2 |> List.map (viewThumbnailCols model.chosenColor model.selectedUrl))
                , div [ class "column" ] [ img [ src (urlPrefix ++ model.selectedUrl), class "image is-fullwidth" ] [] ]
                ]
            ]
        ]


viewThumbnailCols : ThumbnailColor -> String -> List Photo -> Html Msg
viewThumbnailCols color selectedUrl thumbs =
    let
        column a =
            div
                [ classList
                    [ ( "column", True )
                    , ( "is-half", List.length thumbs == 1 )
                    , ( colorClass, a.url == selectedUrl )
                    ]
                ]
                [ viewThumbnail a ]

        colorClass =
            colorToClass color
    in
    div [ class "columns" ]
        (List.map column thumbs)


viewThumbnail : Photo -> Html Msg
viewThumbnail thumb =
    figure [ class "image is-200by267 is-marginless" ]
        [ img
            [ src (urlPrefix ++ thumb.url), onClick (ClickedPhoto thumb.url) ]
            []
        ]


viewColorChooser : ThumbnailColor -> Html Msg
viewColorChooser color =
    label [ class "radio" ]
        [ input [ type_ "radio", name "color", onClick (ClickedColor color) ] []
        , text ("\n" ++ colorToString color)
        ]


type ThumbnailColor
    = Primary
    | Info
    | Danger


colorToString : ThumbnailColor -> String
colorToString size =
    case size of
        Primary ->
            "Primary"

        Info ->
            "Info"

        Danger ->
            "Danger"


colorToClass : ThumbnailColor -> String
colorToClass size =
    case size of
        Primary ->
            "has-background-primary"

        Info ->
            "has-background-info"

        Danger ->
            "has-background-danger"


type alias Photo =
    { url : String }


type alias Model =
    { photos : List Photo
    , selectedUrl : String
    , chosenColor : ThumbnailColor
    }


initialModel : Model
initialModel =
    { photos =
        [ { url = "1.jpeg" }
        , { url = "2.jpeg" }
        , { url = "3.jpeg" }
        ]
    , selectedUrl = "1.jpeg"
    , chosenColor = Primary
    }


photoArray : Array Photo
photoArray =
    Array.fromList initialModel.photos


getPhotoUrl : Int -> String
getPhotoUrl index =
    case Array.get index photoArray of
        Just photo ->
            photo.url

        Nothing ->
            ""


randomPhotoPicker : Random.Generator Int
randomPhotoPicker =
    Random.int 0 (Array.length photoArray - 1)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedPhoto url ->
            ( { model | selectedUrl = url }, Cmd.none )

        ClickedColor color ->
            ( { model | chosenColor = color }, Cmd.none )

        ClickedSurpriseMe ->
            ( model, Random.generate GotSelectedIndex randomPhotoPicker )

        GotSelectedIndex index ->
            ( { model | selectedUrl = getPhotoUrl index }, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
