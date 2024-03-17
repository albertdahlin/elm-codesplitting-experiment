module UI_Page_Checkout exposing (..)
import Browser
import Html exposing (Html)
import Html.Attributes as HA
import Html.Events as Events


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
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Html.main_
        [ HA.class "constrained py-4"
        ]
        [ Html.h1 [] [ Html.text "Checkout page" ]
        ]

