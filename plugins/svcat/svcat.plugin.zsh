# Autocompletion for the Service Catalog CLI (svcat).
if (( ! $+commands[svcat] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `svcat`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_svcat" ]]; then
  typeset -g -A _comps
  autoload -Uz _svcat
  _comps[svcat]=_svcat
fi

svcat completion zsh >| "$ZSH_CACHE_DIR/completions/_svcat" &|
