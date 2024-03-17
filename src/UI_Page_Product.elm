module UI_Page_Product exposing (..)

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
    { data : Port.Page_Product
    }


type alias Flags =
    { data : Port.Page_Product
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
        [ HA.class "constrained fade-in py-4 grid grid-cols-2 gap-8"
        ]
        [ Html.div
            [ HA.class "aspect-square bg-gray-200"
            ]
            []
        , Html.div
            []
            [ Html.h1 [] [ Html.text model.data.name ]
            , Html.p [] [ Html.text <| String.fromInt model.data.price ]
            , Html.button [] [ Html.text "Add to cart" ]
            ]
        ]
