#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
# Simple ZLE widget that binds F5 to "source ~/.zshrc".
#
# You can bind it to another key by setting the REFRESH_KEY
# environment variable, for example to bind F4 instead of F5:
#   export REFRESH_KEY=$terminfo[kf4]
# ------------------------------------------------------------------------------

# Default key is F5.
DEFAULT_REFRESH_KEY=$terminfo[kf5]

_refresh() { source ~/.zshrc }
zle -N _refresh
bindkey ${REFRESH_KEY:-$DEFAULT_REFRESH_KEY} _refresh

