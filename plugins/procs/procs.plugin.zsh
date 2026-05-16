if (( ! $+commands[procs] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `procs`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_procs" ]]; then
  typeset -g -A _comps
  autoload -Uz _procs
  _comps[procs]=_procs
fi

{
  autoload -Uz is-at-least
  local _version=$(procs --version)
  if is-at-least "0.14" "${_version#procs }"; then
    procs --gen-completion-out zsh >| "$ZSH_CACHE_DIR/completions/_procs"
  else
    procs --completion-out zsh >| "$ZSH_CACHE_DIR/completions/_procs"
  fi
} &|
