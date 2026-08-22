(( ! $+commands[asdf] )) && return

export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"

# Add shims to the front of the path, removing if already present.
path=("$ASDF_DATA_DIR/shims" ${path:#$ASDF_DATA_DIR/shims})

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `asdf`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_asdf" ]]; then
  typeset -g -A _comps
  autoload -Uz _asdf
  _comps[asdf]=_asdf
fi
{
  local completion="$ZSH_CACHE_DIR/completions/_asdf" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  asdf completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
