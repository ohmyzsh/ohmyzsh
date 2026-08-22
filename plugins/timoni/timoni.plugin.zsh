# Autocompletion for the Timoni CLI (timoni).
if (( ! $+commands[timoni] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `timoni`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_timoni" ]]; then
  typeset -g -A _comps
  autoload -Uz _timoni
  _comps[timoni]=_timoni
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_timoni" tmp
  tmp=$(command mktemp -t _omz_comp.XXXXXXXX) || exit
  timoni completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
