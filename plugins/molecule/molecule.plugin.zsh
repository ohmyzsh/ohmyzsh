# Completion
if (( ! $+commands[molecule] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `molecule`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_molecule" ]]; then
  typeset -g -A _comps
  autoload -Uz _molecule
  _comps[molecule]=_molecule
fi

_MOLECULE_COMPLETE=zsh_source molecule >| "$ZSH_CACHE_DIR/completions/_molecule" &|
