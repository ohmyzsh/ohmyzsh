# Pulumi oh-my-zsh plugin (short aliases)

if ! command -v pulumi &> /dev/null; then
  return
fi

# Load completion if available
if pulumi gen-completion zsh &> /dev/null; then
  autoload -U +X compinit && compinit
  pulumi gen-completion zsh >! "${ZSH_CACHE_DIR:-$HOME/.zsh_cache}/_pulumi"
  fpath=("${ZSH_CACHE_DIR:-$HOME/.zsh_cache}" $fpath)
fi

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


