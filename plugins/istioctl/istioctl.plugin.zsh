if [ $commands[istioctl] ]; then
  source <(istioctl completion zsh)
  compdef _istioctl istioctl
fi
