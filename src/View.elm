module View (view) where

import Actions exposing (Action)
import Html exposing (div, br, Html, text, button)
import Html.Attributes exposing (style)
import Model exposing (Model)
import PathView
import WebGLView
import Box exposing (Box)


(=>) : a -> b -> (a, b)
(=>) = (,)

debug : Model -> Html
debug model =
  div
    [ style
        [ "background" => "linear-gradient(0deg, #000000 0, rgba(0,0,0,0) 2px, rgba(0,0,0,0) 100%), linear-gradient(90deg, #000000 0, rgba(0,0,0,0) 2px, rgba(0,0,0,0) 100%)"
        , "background-origin" => "padding-box"
        , "background-clip" => "border-box"
        , "background-size" => (toString model.tileSize ++ "px " ++ toString model.tileSize ++ "px")
        , "position" => "absolute"
        , "left" => "0"
        , "top" => "0"
        , "width" => "100%"
        , "height" => "100%"
        ]
    ]
    []


view : Signal.Address Action -> Model -> Html
view _ model =
  let
    (texturedBoxes, _) = Box.split model.boxes
    mapWidth = fst model.gridSize * model.tileSize
    mapHeight = snd model.gridSize * model.tileSize
    screenWidth = max (fst model.dimensions) mapWidth
    screenHeight = max (snd model.dimensions) mapHeight
  in
    div
      [ style
          [ "background-image" => ("url(" ++ model.imagesUrl ++ "/bg-tile.jpg" ++ ")")
          , "background-size" => "560px 560px"
          , "background-position" => "50% 50%"
          , "position" => "relative"
          , "width" => (toString screenWidth ++ "px")
          , "height" => (toString screenHeight ++ "px")
          ]
      ]
      [ div
          [ style
            [ "position" => "absolute"
            , "width" => (toString mapWidth ++ "px")
            , "height" => (toString mapHeight ++ "px")
            , "left" => (toString ((screenWidth - mapWidth) // 2) ++ "px")
            , "top" => (toString ((screenHeight - mapHeight) // 2) ++ "px")
            , "transform" => "scale(0.5)"
            , "transform-origin" => "left top"
            ]
          ]
          [ PathView.render model.gridSize (model.tileSize * 2) model.deliveryPerson.route
          , WebGLView.render model.gridSize (model.tileSize * 2) model.textures texturedBoxes |> Html.fromElement
          ]
      ]