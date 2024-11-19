# Completion
if (( ! $+commands[vault] )); then
  return
fi

autoload -Uz bashcompinit && bashcompinit
complete -o nospace -C vault vault
