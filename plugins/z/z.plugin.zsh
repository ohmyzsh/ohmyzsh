<<<<<<< HEAD
_load_z() {
  source $1/z.sh
}

[[ -f $ZSH_CUSTOM/plugins/z/z.plugin.zsh ]] && _load_z $ZSH_CUSTOM/plugins/z
[[ -f $ZSH/plugins/z/z.plugin.zsh ]] && _load_z $ZSH/plugins/z
=======
# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

source "${0:h}/z.sh"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
