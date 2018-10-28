# Autocompletion for doctl, the command line tool for DigitalOcean service
#
# doctl project: https://github.com/digitalocean/doctl
#
# Author: https://github.com/HalisCz

if [ $commands[doctl] ]; then
  source <(doctl completion zsh)
fi
