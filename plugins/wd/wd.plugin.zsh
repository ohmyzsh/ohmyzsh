#!/bin/zsh

# WARP DIRECTORY
# ==============
# Jump to custom directories in terminal
# because `cd` takes too long...
#
# @github.com/mfaerevaag/wd

# Handle $0 according to the standard:
# # https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

eval "wd() { source '${0:A:h}/wd.sh' }"
wd > /dev/null
# Register the function as a Zsh widget
zle -N wd_browse
# Bind the widget to a key combination
bindkey '^G' wd_browse
