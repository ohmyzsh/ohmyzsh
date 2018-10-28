# Autocompletion for Minikube.
#

if [ $commands[minikube] ]; then
  source <(minikube completion zsh)
fi
