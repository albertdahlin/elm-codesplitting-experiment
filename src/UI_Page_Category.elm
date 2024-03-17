module UI_Page_Category exposing (..)

import Browser
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as Events
import Port


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type Msg
    = None


type alias Model =
    { data : Port.Page_Category
    }


type alias Flags =
    { data : Port.Page_Category
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { data = flags.data
            }
    in
    ( model
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.main_
        [ HA.class "constrained py-4 fade-in"
        ]
        [ Html.h1 [] [ Html.text model.data.title ]
        , model.data.products
            |> List.map
                (\productCard ->
                    Html.a
                        [ HA.href productCard.href
                        ]
                        [ Html.div
                            [ HA.class "aspect-square bg-gray-200"
                            ]
                            []
                        , Html.div
                            []
                            [ Html.text productCard.name
                            ]
                        ]
                )
            |> Html.div
                [ HA.class "grid product-grid gap-4"
                ]
        ]
