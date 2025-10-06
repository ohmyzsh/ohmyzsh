if (( ! $+commands[scw] )); then
  return
fi

_scw () {
  output=($(scw autocomplete complete zsh -- ${CURRENT} ${words}))
  opts=('-S' ' ')
  if [[ $output == *= ]]; then
    opts=('-S' '')
  fi
  compadd "${opts[@]}" -- "${output[@]}"
}

compdef _scw scw
