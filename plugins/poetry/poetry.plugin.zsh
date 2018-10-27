# Return immediately if poetry is not found
if ! $(command -v poetry >/dev/null) ; then
  return
fi

version="$(poetry -V)"
version_file="$ZSH_CACHE_DIR/poetry_version"
comp_file="$ZSH_CACHE_DIR/completions/_poetry"

# Create completion file if it does not exist, or if poetry version changes
if ! [[ -e "$comp_file" && 
        -e "$version_file" &&
        "$version" == "$(<$version_file)" ]]; then
  echo "$version" >| "$version_file"
  poetry completions zsh >| "$comp_file"

  # Manually load the new completion file for this shell session.
  # In future shells, compinit will handle this automatically.
  autoload -Uz _poetry
  typeset -A _comps
  _comps[poetry]=_poetry
fi

unset version version_file comp_file
