# hangman-game

# How to install elm w/o installing it globaly.
run this in folder where this README.md is, it will add only in a scope of a given `cmd` session bin tools from node modules. No other application will be affected, the scope is a single `cmd` session.  

`mkdir hangman-game`
`cd hangman-game`
`npm init`
`npm -i --save-dev create-elm-app elm-format`
`set PATH=%PATH%;D:\worek\repos\hangman-game\node_modules\.bin;`  
`create-elm-app hangman`
`cd hangman`
`elm-app start`