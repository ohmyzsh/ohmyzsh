(( ! $+commands[asdf] )) && return

# TODO(roeniss): 2025-03-31 - remove this warning and related README section after enough grace period.
if [[ -d "$HOME/.asdf" ]]; then
  echo "[omz] You have enabled asdf plugin, but your asdf version seems too low. Please upgrade to at least 0.16.0 to use completion. See omz asdf plugin README for more details."
fi

export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
path=("$ASDF_DATA_DIR/shims" $path)

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `asdf`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_asdf" ]]; then
  typeset -g -A _comps
  autoload -Uz _asdf
  _comps[asdf]=_asdf
fi
asdf completion zsh >| "$ZSH_CACHE_DIR/completions/_asdf" &|
