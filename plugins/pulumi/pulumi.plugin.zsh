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
alias pul='pulumi'
alias pulcs='pulumi config set'
alias puld='pulumi destroy'
alias pullog='pulumi logs -f'
alias pulp='pulumi preview'
alias pulr='pulumi refresh'
alias puls='pulumi stack'
alias pulsh='pulumi stack history'
alias pulsi='pulumi stack init'
alias pulsl='pulumi stack ls'
alias pulso='pulumi stack output'
alias pulss='pulumi stack select'
alias pulu='pulumi up'
