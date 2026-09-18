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
alias cz="chezmoi"
alias cza="chezmoi apply"
alias czr="chezmoi re-apply"
alias czc="chezmoi cd"
alias czd="chezmoi diff"
alias cze="chezmoi edit"
alias czg="chezmoi git"
alias czi="chezmoi init"
alias czs="chezmoi status"
alias czu="chezmoi update"
