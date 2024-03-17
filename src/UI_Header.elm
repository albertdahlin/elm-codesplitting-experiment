module UI_Header exposing (..)

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
    = GotHeader Port.Header


type alias Model =
    { header : Maybe Port.Header
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { header = Nothing
            }
    in
    ( model
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Port.recv_Header GotHeader


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotHeader header ->
            ( { model | header = Just header }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Html.header
        [ HA.class "constrained flex flex-row items-center space-x-4"
        ]
        (case model.header of
            Just header ->
                view_Header header

            Nothing ->
                []
        )


view_Header : Port.Header -> List (Html msg)
view_Header header =
    header.menu
        |> List.map
            (\link ->
                Html.a
                    [ HA.href link.href
                    ]
                    [ Html.text link.title
                    ]
            )
