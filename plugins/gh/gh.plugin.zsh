# Autocompletion for the GitHub CLI (gh).
if (( ! $+commands[gh] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `gh`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_gh" ]]; then
  typeset -g -A _comps
  autoload -Uz _gh
  _comps[gh]=_gh
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_gh" tmp
  tmp=$(command mktemp -t _omz_comp.XXXXXXXX) || exit
  gh completion --shell zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
