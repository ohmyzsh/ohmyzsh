# Autocompletion for kubectl, the command line interface for Kubernetes
#
# Author: https://github.com/pstadler

if [ $commands[kubectl] ]; then
  source <(kubectl completion zsh)
fi
