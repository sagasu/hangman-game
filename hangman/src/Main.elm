module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (src)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder)
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
    |NewPhrase (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Guess char -> 
            ( {model | guesses = Set.insert char model.guesses }, Cmd.none)
        Restart -> 
            ({model | guesses = Set.empty}, fetchWord)

        NewPhrase result -> case result of
            Ok phrase -> ({model | phrase = phrase }, Cmd.none)
            Err _ -> (model, Cmd.none)

fetchWord: Cmd Msg
fetchWord = Http.get {
           url = "https://snapdragon-fox.glitch.me/word",
           expect = Http.expectJson NewPhrase wordDecoder
           }

wordDecoder : Decoder String
wordDecoder = Decode.field "word" Decode.string
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
