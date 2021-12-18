if (( $+commands[fnm] )); then
  # Handle $0 according to the standard:
  # # https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
  0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
  0="${${(M)0:#/*}:-$PWD/$0}"

  # remove old generated completion file
  command rm -f "${0:A:h}/_fnm"

  ver="$(fnm --version)"
  ver_file="$ZSH_CACHE_DIR/fnm_version"
  comp_file="$ZSH_CACHE_DIR/completions/_fnm"

  mkdir -p "${comp_file:h}"
  (( ${fpath[(Ie)${comp_file:h}]} )) || fpath=("${comp_file:h}" $fpath)

  if [[ ! -f "$comp_file" || ! -f "$ver_file" || "$ver" != "$(< "$ver_file")" ]]; then
    fnm completions --shell=zsh >| "$comp_file"
    echo "$ver" >| "$ver_file"
  fi

  declare -A _comps
  autoload -Uz _fnm
  _comps[fnm]=_fnm

  unset ver ver_file comp_file
fi

