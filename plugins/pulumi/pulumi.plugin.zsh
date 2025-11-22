if (( ! $+commands[pulumi] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `pulumi`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_pulumi" ]]; then
  typeset -g -A _comps
  autoload -Uz _pulumi
  _comps[pulumi]=_pulumi
fi

pulumi gen-completion zsh >| "$ZSH_CACHE_DIR/completions/_pulumi" &|

# Aliases
alias p='pulumi'
alias pu='pulumi up'
alias pp='pulumi preview'
alias pd='pulumi destroy'
alias pr='pulumi refresh'
alias ps='pulumi stack'
alias pss='pulumi stack select'
alias psh='pulumi stack history'
alias psi='pulumi stack init'
alias psl='pulumi stack ls'
alias pso='pulumi stack output'
alias plog='pulumi logs -f'
alias pcs='pulumi config set'


