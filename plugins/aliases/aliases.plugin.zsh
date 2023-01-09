# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

eval '
  function acs(){
    (( $+commands[python3] )) || {
      echo "[error] No python executable detected"
      return
    }
    alias | python3 "'"${0:h}"'/cheatsheet.py" "$@"
  }
'
