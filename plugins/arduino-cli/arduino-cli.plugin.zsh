if (( ! $+commands[arduino-cli] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `arduino-cli`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_arduino-cli" ]]; then
  typeset -g -A _comps
  autoload -Uz _arduino-cli
  _comps[arduino-cli]=_arduino-cli
fi

# Generate and load arduino-cli completion
{
  local completion="$ZSH_CACHE_DIR/completions/_arduino-cli" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  arduino-cli completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
