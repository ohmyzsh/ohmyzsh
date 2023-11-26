# Do nothing if stripe is not installed
(( ${+commands[stripe]} )) || return

eval "$(stripe completion --shell zsh --write-to-stdout)"
compdef _stripe stripe
