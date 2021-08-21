module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (src)


---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )

phrase: String
phrase = "hangman in elm"

---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    let 
        phraseHtml = 
            phrase
            |> String.split ""
            |> List.map(\char -> 
                if char == " " then
                    " "
                else
                    "_"
                )
            |> List.map 
                (\char ->
                    span [] [text char]
                )
            |> div []
        buttonsHtml = "abcdefghijklmnopqrstuvwxyz"
                      |> String.split ""
                      |> List.map (\char ->
                        button[] [text char]
                       )
                      |> div []
    in
    div []
        [
            phraseHtml,
            buttonsHtml
        ]




---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
