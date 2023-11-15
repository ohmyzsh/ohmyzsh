# Don't continue if direnv is not found
command -v direnv &>/dev/null || return

eval "$(direnv hook zsh)"

