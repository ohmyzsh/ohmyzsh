if (( ! $+commands[fnm] )); then
  return
fi

# CONFIGURATION VARIABLES
# Automatically start the fnm multishell
: ${ZSH_FNM_AUTOSTART:=false} # opt-in to avoid duplicated sessions
: ${ZSH_FNM_USE_ON_CD:=true} # upstream recommendation

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `fnm`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fnm" ]]; then
  typeset -g -A _comps
  autoload -Uz _fnm
  _comps[fnm]=_fnm
fi

fnm completions --shell=zsh >| "$ZSH_CACHE_DIR/completions/_fnm" &|

if [[ "$ZSH_FNM_AUTOSTART" == "true" ]]; then
  local -a fnm_env_cmd
  [[ "$ZSH_FNM_USE_ON_CD" == "true" ]] && fnm_env_cmd+=("--use-on-cd")
  eval "$(fnm env --shell=zsh $fnm_env_cmd)"
fi
