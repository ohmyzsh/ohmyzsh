# Autocompletion for kubectl, the command line interface for Kubernetes
#
# Author: https://github.com/whithajess

if [ $commands[kops] ]; then
  source <(kops completion zsh)
fi
