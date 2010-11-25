#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
# Simple ZLE widget that binds F5 to "source ~/.zshrc".
# ------------------------------------------------------------------------------

_refresh() { source ~/.zshrc }
zle -N _refresh
bindkey '^[[15~' _refresh
