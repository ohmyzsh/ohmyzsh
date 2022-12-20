# Autocompletion for doctl, the command line tool for DigitalOcean service
#
# doctl project: https://github.com/digitalocean/doctl
#
# Author: https://github.com/HalisCz

if (( ! $+commands[doctl] )); then
  return
fi

if [[ ! -f "$ZSH_CACHE_DIR/completions/_doctl" ]]; then
  typeset -g -A _comps
  autoload -Uz _doctl
  _comps[doctl]=_doctl
fi

doctl completion zsh >| "$ZSH_CACHE_DIR/completions/_doctl" &|
