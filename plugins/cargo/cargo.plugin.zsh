if (( $+commands[rustup] && $+commands[cargo] )); then
  # remove old generated completion file
  command rm -f "${0:A:h}/_cargo"

  # generate new completion file
  ver="$(cargo --version)"
  ver_file="$ZSH_CACHE_DIR/cargo_version"
  comp_file="$ZSH_CACHE_DIR/completions/_cargo"

  mkdir -p "${comp_file:h}"
  (( ${fpath[(Ie)${comp_file:h}]} )) || fpath=("${comp_file:h}" $fpath)

  if [[ ! -f "$comp_file" || ! -f "$ver_file" || "$ver" != "$(< "$ver_file")" ]]; then
    rustup completions zsh cargo >| "$comp_file"
    echo "$ver" >| "$ver_file"
  fi

  declare -A _comps
  autoload -Uz _cargo
  _comps[cargo]=_cargo

  unset ver ver_file comp_file
fi
