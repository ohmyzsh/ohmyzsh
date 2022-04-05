#!/bin/zsh

# WARP DIRECTORY
# ==============
<<<<<<< HEAD
# oh-my-zsh plugin
#
# @github.com/mfaerevaag/wd

wd() {
    . $ZSH/plugins/wd/wd.sh
}
=======
# Jump to custom directories in terminal
# because `cd` takes too long...
#
# @github.com/mfaerevaag/wd

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

eval "wd() { source '${0:A:h}/wd.sh' }"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
