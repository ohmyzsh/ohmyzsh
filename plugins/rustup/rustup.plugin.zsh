if (( $+commands[rustup] )); then
  # Handle $0 according to the standard:
  # https://z-shell.github.io/zsh-plugin-assessor/Zsh-Plugin-Standard#zero-handling
  0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
  0="${${(M)0:#/*}:-$PWD/$0}"

  # remove old generated completion file
  command rm -f "${0:A:h}/_rustup"

  ver="$(rustup --version 2>/dev/null)"
  ver_file="$ZSH_CACHE_DIR/rustup_version"
  comp_file="$ZSH_CACHE_DIR/completions/_rustup"

  mkdir -p "${comp_file:h}"
  (( ${fpath[(Ie)${comp_file:h}]} )) || fpath=("${comp_file:h}" $fpath)

  if [[ ! -f "$comp_file" || ! -f "$ver_file" || "$ver" != "$(< "$ver_file")" ]]; then
    rustup completions zsh >| "$comp_file"
    echo "$ver" >| "$ver_file"
  fi

  declare -A _comps
  autoload -Uz _rustup
  _comps[rustup]=_rustup

  unset ver ver_file comp_file
fi
