if [ $commands[dapr] ]; then
  source <(dapr completion zsh)
  compdef _dapr dapr
fi
