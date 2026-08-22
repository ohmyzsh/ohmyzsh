if (( $+commands[nsc] )); then
  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `nsc`. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_nsc" ]]; then
    typeset -g -A _comps
    autoload -Uz _nsc
    _comps[nsc]=_nsc
  fi

  {
    local completion="$ZSH_CACHE_DIR/completions/_nsc" tmp
    tmp=$(command mktemp "$completion.XXXXXX") || exit
    nsc completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
    command rm -f "$tmp"
  } &|
fi

if (( $+commands[nats] )); then
  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `nats`. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_nats" ]]; then
    typeset -g -A _comps
    autoload -Uz _nats
    _comps[nats]=_nats
  fi

  {
    local completion="$ZSH_CACHE_DIR/completions/_nats" tmp
    tmp=$(command mktemp "$completion.XXXXXX") || exit
    nats --completion-script-zsh >| "$tmp" && command mv -f "$tmp" "$completion"
    command rm -f "$tmp"
  } &|
fi
