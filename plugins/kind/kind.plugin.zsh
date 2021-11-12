if [ $commands[kind] ]; then
  source <(kind completion zsh)
  compdef _kind kind
fi
