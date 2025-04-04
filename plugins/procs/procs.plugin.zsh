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

# Check which flag is supported by the installed version of procs
if procs --help 2>&1 | grep -q -- "--gen-completion-out"; then
  procs --gen-completion-out zsh >| "$ZSH_CACHE_DIR/completions/_procs" &|
else
  procs --completion-out zsh >| "$ZSH_CACHE_DIR/completions/_procs" &|
fi