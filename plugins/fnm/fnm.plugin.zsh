if (( ! $+commands[fnm] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `fnm`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fnm" ]]; then
  typeset -g -A _comps
  autoload -Uz _fnm
  _comps[fnm]=_fnm
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_fnm"
  zf_mv -f -- =( fnm completions --shell=zsh ) "$TMPPREFIX"
} &|

if zstyle -t ':omz:plugins:fnm' autostart; then
  local -a fnm_env_cmd
  if zstyle -T ':omz:plugins:fnm' use-on-cd; then
    fnm_env_cmd+=("--use-on-cd")
  fi
  eval "$(fnm env --shell=zsh $fnm_env_cmd)"
fi
