if (( $+commands[linkerd] )); then
  source <(linkerd completion zsh)
  compdef _linkerd linkerd
fi
