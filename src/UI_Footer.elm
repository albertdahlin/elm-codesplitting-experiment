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
    { footer : Maybe Port.Footer
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { footer = Nothing
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
            ( { model | footer = Just footer }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    Html.footer
        [ HA.class "constrained py-8 flex flex-row space-x-8"
        ]
        (case model.footer of
            Just footer ->
                view_Footer footer

            Nothing ->
                []
        )


view_Footer : Port.Footer -> List (Html msg)
view_Footer footer =
    footer.columns
        |> List.map
            (\col ->
                Html.div
                    [ HA.class "flex flex-col space-y-2"
                    ]
                    (Html.h3
                        [ HA.class "text-lg font-bold mb-2"
                        ]
                        [ Html.text col.title ]
                        :: List.map
                            (\link ->
                                Html.a
                                    [ HA.href link.href
                                    ]
                                    [ Html.text link.title
                                    ]
                            )
                            col.links
                    )
            )
