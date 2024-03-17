module Worker exposing (..)

import Port


type Route
    = Product String
    | Category String
    | Checkout
    | Home


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


type Msg
    = OnUrlChange String


type alias Model =
    { val : String
    }


type alias Flags =
    { url : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { val = ""
            }
    in
    ( model
    , Cmd.batch
        [ Port.sendTo_Header test_Header
        , Port.sendTo_Footer test_Footer
        , parseRoute flags.url
            |> Maybe.map sendPage
            |> Maybe.withDefault (Port.sendTo_Page_NotFound ())
        ]
    )


test_Header =
    { menu =
        [ { title = "Dresses", href = "#category/dress" }
        , { title = "T-Shirts", href = "#category/t-shirt" }
        , { title = "Checkout", href = "#checkout" }
        ]
    }


test_Footer =
    { columns =
        [ { title = "Popular products"
          , links =
                [ { title = "White dress", href = "#product/white-dress" }
                , { title = "Black T-Shirt", href = "#product/black-t-shirt" }
                ]
          }
        , { title = "Customer Service"
          , links =
                [ { title = "About us", href = "#about-us" }
                , { title = "Privacy Policy", href = "#privacy-policy" }
                , { title = "Terms & Conditions", href = "#terms-and-conditions" }
                ]
          }
        ]
    }


test_Page_Product sku =
    { sku = sku
    , name = String.replace "-" " " sku
    , price = 199
    }


test_Page_Category slug =
    { title = slug
    , products =
        List.range 1 9
            |> List.map
                (\n ->
                    let
                        s =
                            String.fromInt n
                    in
                    { name = slug ++ " " ++ s
                    , href = "#product/" ++ slug ++ "-" ++ s
                    , price = 199
                    }
                )
    }


subscriptions : Model -> Sub Msg
subscriptions model =
    Port.recv_UrlChange OnUrlChange


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnUrlChange url ->
            case parseRoute url of
                Just route ->
                    ( model
                    , sendPage route
                    )

                Nothing ->
                    ( model
                    , Port.sendTo_Page_NotFound ()
                    )


sendPage : Route -> Cmd msg
sendPage route =
    case route of
        Product sku ->
            Port.sendTo_Page_Product (test_Page_Product sku)

        Category slug ->
            Port.sendTo_Page_Category (test_Page_Category slug)

        Checkout ->
            Port.sendTo_Page_Checkout {}

        Home ->
            Port.sendTo_Page_NotFound ()


parseRoute : String -> Maybe Route
parseRoute hash =
    case String.split "/" hash of
        [ "#product", sku ] ->
            Just (Product sku)

        [ "#category", slug ] ->
            Just (Category slug)

        [ "#checkout" ] ->
            Just Checkout

        [] ->
            Just Home

        _ ->
            Nothing
