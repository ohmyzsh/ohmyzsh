if [ $commands[operator-sdk] ]; then
  source <(operator-sdk completion zsh)
  compdef _operator-sdk operator-sdk
fi
