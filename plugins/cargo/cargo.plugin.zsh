if (( $+commands[rustup] && $+commands[cargo] )); then
  # remove old generated completion files
  command rm -f "${0:A:h}/_rustup"
  command rm -f "${0:A:h}/_cargo"

  # generate new completion files

  # rustup
  ver1="$(rustup --version 2>/dev/null)"
  ver_file1="$ZSH_CACHE_DIR/rustup_version"
  comp_file1="$ZSH_CACHE_DIR/completions/_rustup"

  mkdir -p "${comp_file1:h}"
  (( ${fpath[(Ie)${comp_file1:h}]} )) || fpath=("${comp_file1:h}" $fpath)

  if [[ ! -f "$comp_file1" || ! -f "$ver_file1" || "$ver1" != "$(< "$ver_file1")" ]]; then
    rustup completions zsh >| "$comp_file1"
    echo "$ver1" >| "$ver_file1"
  fi

  # cargo
  ver2="$(cargo --version)"
  ver_file2="$ZSH_CACHE_DIR/cargo_version"
  comp_file2="$ZSH_CACHE_DIR/completions/_cargo"
  mkdir -p "${comp_file2:h}"
  (( ${fpath[(Ie)${comp_file2:h}]} )) || fpath=("${comp_file2:h}" $fpath)

  if [[ ! -f "$comp_file2" || ! -f "$ver_file2" || "$ver2" != "$(< "$ver_file2")" ]]; then
    rustup completions zsh cargo >| "$comp_file2"
    echo "$ver2" >| "$ver_file2"
  fi

  declare -A _comps
  autoload -Uz _rustup
  _comps[rustup]=_rustup
  autoload -Uz _cargo
  _comps[cargo]=_cargo

  unset ver1 ver_file1 comp_file1
  unset ver2 ver_file2 comp_file2
fi
