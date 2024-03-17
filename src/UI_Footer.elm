module UI_Footer exposing (..)

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
    = GotFooter Port.Footer


type alias Model =
    { val : String
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { val = ""
            }
    in
    ( model
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Port.recv_Footer GotFooter


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotFooter footer ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.footer
        [ HA.class "constrained py-4"
        ]
        [ Html.text "Footer"
        ]
