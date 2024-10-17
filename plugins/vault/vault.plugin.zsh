if (( ! $+commands[vault] )); then
  return
fi

complete -o nospace -C vault vault
