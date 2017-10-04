# Autocompletion for kops
#
# Author: https://github.com/mstuparu

if [ $commands[kops] ]; then
  source <(kops completion zsh)
fi
