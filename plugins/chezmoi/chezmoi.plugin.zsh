# COMPLETION FUNCTION
if (( ! $+commands[chezmoi] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `chezmoi`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_chezmoi" ]]; then
  typeset -g -A _comps
  autoload -Uz _chezmoi
  _comps[chezmoi]=_chezmoi
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_chezmoi"
  zf_mv -f -- =( chezmoi completion zsh ) "$TMPPREFIX"
} &|

# Chezmoi aliases
alias cm="chezmoi"
alias cma="chezmoi apply"
alias cmr="chezmoi re-apply"
alias cmc="chezmoi cd"
alias cmd="chezmoi diff"
alias cme="chezmoi edit"
alias cmg="chezmoi git"
alias cmi="chezmoi init"
alias cms="chezmoi status"
alias cmu="chezmoi update"
