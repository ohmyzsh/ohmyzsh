# Autocompletion for hcloud, the command line interface for Hetzner Cloud
#
# Author: https://github.com/patricks

if [ $commands[hcloud] ]; then
  source <(hcloud completion zsh)
fi
