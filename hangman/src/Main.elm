module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (..)
import Set exposing (Set)


---- MODEL ----


type alias Model =
    {guesses: Set String,
    phrase: String}


init : ( Model, Cmd Msg )
init =
    ( {
        phrase = "hangman in elm",
        guesses = Set.empty
    }, Cmd.none )


---- UPDATE ----


type Msg
    = Guess String
    |Restart


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Guess char -> 
            ( {model | guesses = Set.insert char model.guesses }, Cmd.none)
        Restart -> 
            ({model | guesses = Set.empty}, Cmd.none)



---- VIEW ----


view : Model -> Html Msg
view model =
    let 
        phraseHtml = 
            model.phrase
            |> String.split ""
            |> List.map(\char -> 
                if char == " " then
                    " "
                else if Set.member char model.guesses then
                    char
                else
                    "_"
                )
            |> List.map 
                (\char ->
                    span [] [text char]
                )
            |> div []

        phraseSet = 
            model.phrase
            |> String.split ""
            |> Set.fromList

        failuresHtml = 
            model.guesses
            |> Set.toList
            |> List.filter (\char -> not <| Set.member char phraseSet)
            |> List.map (\char -> span [] [text char])
            |> div []

        buttonsHtml = "abcdefghijklmnopqrstuvwxyz"
                      |> String.split ""
                      |> List.map (\char ->
                        button[onClick <| Guess char] [text char]
                       )
                      |> div []
    in
    div []
        [
            phraseHtml,
            buttonsHtml,
            failuresHtml,
            button [onClick Restart] [text "Restart"]
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
