# AWS CDK plugin for Oh My Zsh

# aliases
alias cdkls='cdk ls'
alias cdkd='cdk deploy'
alias cdks='cdk synth'
alias cdkdiff='cdk diff'

# load CDK completion if available
if command -v cdk >/dev/null 2>&1; then
  eval "$(cdk completion zsh)"
fi
