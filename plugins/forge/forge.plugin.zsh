# Foundry Forge plugin for oh-my-zsh

# Aliases for common Foundry Forge commands
alias finit='forge init'
alias fb='forge build'
alias fcmp='forge compile'
alias ft='forge test'
alias fdoc='forge doc'
alias ffmt='forge fmt'
alias fl='forge lint'
alias fsnap='forge snapshot'
alias fcov='forge coverage'
alias ftree='forge tree'
alias fcl='forge clean'
alias fgeiger='forge geiger'
alias fcfg='forge config'
alias fupd='forge update'
alias fbind='forge bind'

# COMPLETION FUNCTION
if (( ! $+commands[forge] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `forge`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_forge" ]]; then
  typeset -g -A _comps
  autoload -Uz _forge
  _comps[forge]=_forge
fi

# Generate completion file in the background
forge completions zsh >| "$ZSH_CACHE_DIR/completions/_forge" &|