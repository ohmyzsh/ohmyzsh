# Do nothing if op is not installed
(( ${+commands[op]} )) || return

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `op`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_op" ]]; then
  typeset -g -A _comps
  autoload -Uz _op
  _comps[op]=_op
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_op" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  op completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|

# Load opswd function
autoload -Uz opswd
