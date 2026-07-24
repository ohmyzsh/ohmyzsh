if (( ! $+commands[mise] )); then
  return
fi

# Load mise hooks
eval "$(mise activate zsh)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `mise`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_mise" ]]; then
  typeset -g -A _comps
  autoload -Uz _mise
  _comps[mise]=_mise
fi


if [[ "$ZSH_MISE_AUTOEXPORT_VERSIONS" != true ]]; then
  _updateMiseVersions() {
    unset -m "MISE_TOOL_*"
    eval $(mise ls -c --no-header \
      | sed 's/^\(\S\+\)\s\+\(\S\+\).*$/export MISE_TOOL_\U\1=\2/')
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd _updateMiseVersions
  _updateMiseVersions # Initial call to check the current directory at shell startup
fi

# Generate and load mise completion
mise completion zsh >| "$ZSH_CACHE_DIR/completions/_mise" &|
