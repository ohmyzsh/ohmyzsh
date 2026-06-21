# AWS CDK plugin for Oh My Zsh
# Provides aliases and autocompletion for the AWS Cloud Development Kit (CDK) CLI

# Aliases
alias cdkl='cdk list'
alias cdksynth='cdk synth'
alias cdkdiff='cdk diff'
alias cdkdeploy='cdk deploy'
alias cdkdestroy='cdk destroy'
alias cdkboot='cdk bootstrap'
alias cdkdoc='cdk docs'
alias cdkinit='cdk init'
alias cdkwatch='cdk watch'
alias cdkctx='cdk context'
alias cdkack='cdk acknowledge'
alias cdkver='cdk --version'

# Autocompletion
if command -v cdk &>/dev/null; then
  _cdk_completion() {
    local -a completions
    completions=($(cdk completion 2>/dev/null))
    compadd -a completions
  }
  compdef _cdk_completion cdk
fi