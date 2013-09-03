#!/usr/bin/env zsh
# plugin from tmuxinator project:
# https://github.com/tmuxinator/tmuxinator/blob/v0.6.7/completion/tmuxinator.zsh

if [[ ! -o interactive ]]; then
    return
fi

compctl -K _tmuxinator tmuxinator mux

_tmuxinator() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(tmuxinator commands)"
  else
    completions="$(tmuxinator completions ${words[2,-2]})"
  fi

  reply=("${(ps:\n:)completions}")
}
