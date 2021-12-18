# Handle $0 according to the standard:
# https://z-shell.github.io/zsh-plugin-assessor/Zsh-Plugin-Standard#zero-handling
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

source "${0:h}/z.sh"
