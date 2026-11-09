#!/usr/bin/env zsh -df

set -u

export ZSH="${0:A:h:h:h}"
export HOME="$(mktemp -d)"
export ZDOTDIR="$HOME"
export TERM=xterm

trap 'rm -rf "$HOME"' EXIT

source "$ZSH/oh-my-zsh.sh"

[[ "$SHORT_HOST" == "${HOST/.*/}" ]] || exit 1
git_prompt_info
git_prompt_status
