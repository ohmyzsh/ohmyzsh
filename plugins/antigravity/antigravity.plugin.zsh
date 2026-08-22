# Autocompletion for the Google Antigravity CLI (antigravity).
if (( ! $+commands[antigravity] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `antigravity`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_antigravity" ]]; then
  typeset -g -A _comps
  autoload -Uz _antigravity
  _comps[antigravity]=_antigravity
fi

antigravity completion zsh >| "$ZSH_CACHE_DIR/completions/_antigravity" &|

# Aliases
alias agv='antigravity'
alias agvi='antigravity init'
alias agvb='antigravity build'
alias agvd='antigravity deploy'
