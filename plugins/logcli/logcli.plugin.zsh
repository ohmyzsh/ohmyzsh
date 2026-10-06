# Autocompletion for Grafana Loki's CLI (logcli).
if (( ! $+commands[logcli] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `logcli`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_logcli" ]]; then
  typeset -g -A _comps
  autoload -Uz _logcli
  _comps[logcli]=_logcli
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/._logcli"
  zf_mv -f -- =( logcli --completion-script-zsh ) "$ZSH_CACHE_DIR/completions/_logcli"
} &|
