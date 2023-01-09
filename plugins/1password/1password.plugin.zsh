# Do nothing if op is not installed
(( ${+commands[op]} )) || return

# Load op completion
eval "$(op completion zsh)"
compdef _op op

# Load opswd function
autoload -Uz opswd
