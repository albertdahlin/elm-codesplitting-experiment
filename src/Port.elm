port module Port exposing (..)

-- FOOTER


type alias Footer =
    { columns : List Column
    }


type alias Column =
    { title : String
    , links : List { title : String, href : String }
    }


port sendTo_Footer : Footer -> Cmd msg


port recv_Footer : (Footer -> msg) -> Sub msg



-- HEADER


type alias Header =
    { menu : List { title : String, href : String }
    }


port sendTo_Header : Header -> Cmd msg


port recv_Header : (Header -> msg) -> Sub msg



-- PAGE


type alias Page_Product =
    { sku : String
    , name : String
    , price : Int
    }


port sendTo_Page_Product : Page_Product -> Cmd msg


type alias Page_Category =
    { title : String
    , products : List { name : String, href : String, price : Int }
    }


port sendTo_Page_Category : Page_Category -> Cmd msg


port sendTo_Page_NotFound : () -> Cmd msg


type alias Page_Checkout =
    {}


port sendTo_Page_Checkout : Page_Checkout -> Cmd msg



--WORKER


port recv_UrlChange : (String -> msg) -> Sub msg
