#!/bin/zsh

source_env() {
  if [[ -f .env ]]; then
    source .env
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env
