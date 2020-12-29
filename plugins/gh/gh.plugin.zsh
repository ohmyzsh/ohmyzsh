# Autocompletion for the GitHub CLI (gh).

if (( $+commands[gh] )); then
    eval "$(gh completion -s zsh)"
    compdef _gh gh
fi
