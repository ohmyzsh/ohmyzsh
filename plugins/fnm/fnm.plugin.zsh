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

{
  local completion="$ZSH_CACHE_DIR/completions/_fnm" tmp
  tmp=$(command mktemp -t _omz_comp.XXXXXXXX) || exit
  fnm completions --shell=zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|

if zstyle -t ':omz:plugins:fnm' autostart; then
  local -a fnm_env_cmd
  if zstyle -T ':omz:plugins:fnm' use-on-cd; then
    fnm_env_cmd+=("--use-on-cd")
  fi
  eval "$(fnm env --shell=zsh $fnm_env_cmd)"
fi
