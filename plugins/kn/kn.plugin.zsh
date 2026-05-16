# Autocompletion for kn, the command line interface for knative
#
# Author: https://github.com/btannous

if [ $commands[kn] ]; then
  source <(kn completion zsh)
  compdef _kn kn
fi
