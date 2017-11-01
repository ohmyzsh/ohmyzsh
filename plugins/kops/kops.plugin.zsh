# Autocompletion for kops, the command line interface for creating/managing Kubernetes clusters
#
# Author: https://github.com/whithajess

if [ $commands[kops] ]; then
  source <(kops completion zsh)
fi
