# Autocompletion for the GitHub CLI (gh).
if (( $+commands[gh] )); then
  # remove old generated completion file
  command rm -f "${0:A:h}/_gh"

  ver="$(gh --version)"
  ver_file="$ZSH_CACHE_DIR/gh_version"
  comp_file="$ZSH_CACHE_DIR/completions/_gh"

  mkdir -p "${comp_file:h}"
  (( ${fpath[(Ie)${comp_file:h}]} )) || fpath=("${comp_file:h}" $fpath)

  if [[ ! -f "$comp_file" || ! -f "$ver_file" || "$ver" != "$(< "$ver_file")" ]]; then
    gh completion --shell zsh >| "$comp_file"
    echo "$ver" >| "$ver_file"
  fi

  declare -A _comps
  autoload -Uz _gh
  _comps[gh]=_gh

  unset ver ver_file comp_file
fi

