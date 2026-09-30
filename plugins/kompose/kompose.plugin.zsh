# Autocompletion for the Kompose CLI (kompose).
if (( ! $+commands[kompose] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `kompose`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kompose" ]]; then
  typeset -g -A _comps
  autoload -Uz _kompose
  _comps[kompose]=_kompose
fi

kompose completion zsh >| "$ZSH_CACHE_DIR/completions/_kompose" &|
