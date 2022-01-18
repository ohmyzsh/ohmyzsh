# Return immediately if poetry is not found
if ! $(command -v poetry >/dev/null) ; then
  return
fi

comp_file="$ZSH_CACHE_DIR/completions/_poetry"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `poetry`. Otherwise, compinit will have already done that.
if [[ ! -f "$comp_file" ]]; then
  typeset -g -A _comps
  autoload -Uz _poetry
  _comps[gh]=_poetry
fi

poetry completions zsh >| "$comp_file" &|

unset comp_file
