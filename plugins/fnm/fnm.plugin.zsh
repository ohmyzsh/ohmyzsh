# COMPLETION FUNCTION
if (( $+commands[fnm] )); then
  if [[ ! -f $ZSH_CACHE_DIR/fnm_version ]] \
    || [[ "$(fnm --version)" != "$(< "$ZSH_CACHE_DIR/fnm_version")" ]] \
    || [[ ! -f $ZSH/plugins/fnm/_fnm ]]; then
      fnm completions --shell=zsh > $ZSH/plugins/fnm/_fnm
      fnm --version > $ZSH_CACHE_DIR/fnm_version
  fi
  autoload -Uz _fnm
  _comps[fnm]=_fnm
fi

