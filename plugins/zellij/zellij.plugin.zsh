if (( ! $+commands[zellij] )); then
  return
fi

# Dynamic prefix: use "z" if no conflict, fall back to "zj"
if (( $+aliases[z] )); then
  _zellij_prefix="zj"
else
  _zellij_prefix="z"
fi

# Aliases
alias ${_zellij_prefix}='zellij'
alias ${_zellij_prefix}a='zellij attach'
alias ${_zellij_prefix}d='zellij delete-session'
alias ${_zellij_prefix}da='zellij delete-all-sessions'
alias ${_zellij_prefix}k='zellij kill-session'
alias ${_zellij_prefix}ka='zellij kill-all-sessions'
alias ${_zellij_prefix}l='zellij list-sessions'
alias ${_zellij_prefix}r='zellij run'
alias ${_zellij_prefix}s='zellij -s'

unset _zellij_prefix

# Completion caching (same pattern as gh plugin)
# On first load, _zellij may not exist in fpath — autoload fails silently.
# The background command generates the cache file for subsequent sessions.
# Load order: plugin loads → compinit runs → next session picks up cached file.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_zellij" ]]; then
  typeset -g -A _comps
  autoload -Uz _zellij
  _comps[zellij]=_zellij
fi

zellij setup --generate-completion zsh >| "$ZSH_CACHE_DIR/completions/_zellij" &|
