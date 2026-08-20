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

chezmoi completion zsh >| "$ZSH_CACHE_DIR/completions/_chezmoi" &|

#
# Aliases
# (sorted alphabetically by alias name)
#

alias cm='chezmoi'
alias cma='chezmoi add'
alias cmap='chezmoi apply'
alias cmcd='chezmoi cd'
alias cmd='chezmoi diff'
alias cme='chezmoi edit'
alias cmg='chezmoi git'
alias cmi='chezmoi init'
alias cmia='chezmoi init --apply'
alias cmm='chezmoi merge'
alias cmma='chezmoi merge-all'
alias cmra='chezmoi re-add'
alias cmst='chezmoi status'
alias cmu='chezmoi update'
