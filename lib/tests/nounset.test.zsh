#!/usr/bin/env zsh -df

set -u

export ZSH="${0:A:h:h:h}"
export HOME="$(mktemp -d)"
export ZDOTDIR="$HOME"
plugins=()

trap 'rm -rf "$HOME"' EXIT

source "$ZSH/oh-my-zsh.sh"
