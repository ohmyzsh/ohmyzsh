if (( $+commands[nsc] )); then
  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `nsc`. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_nsc" ]]; then
    typeset -g -A _comps
    autoload -Uz _nsc
    _comps[nsc]=_nsc
  fi

  nsc completion zsh >| "$ZSH_CACHE_DIR/completions/_nsc" &|
fi

if (( $+commands[nats] )); then
  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `nats`. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_nats" ]]; then
    typeset -g -A _comps
    autoload -Uz _nats
    _comps[nats]=_nats
  fi

  nats --completion-script-zsh >| "$ZSH_CACHE_DIR/completions/_nats" &|
fi
