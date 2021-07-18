# Autocompletion for argocd cli.
#
if [ $commands[argocd] ]; then
  source <(argocd completion zsh)
fi
