# Autocompletion for the AWS CDK CLI.
#
# AWS CDK supports generating its own zsh completion script via
# `cdk --completion`. This plugin caches that output and refreshes
# it asynchronously on each shell start, following the same pattern
# used by the argocd and helm plugins.

if (( ! $+commands[cdk] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `cdk`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_cdk" ]]; then
  typeset -g -A _comps
  autoload -Uz _cdk
  _comps[cdk]=_cdk
fi

cdk --completion zsh >| "$ZSH_CACHE_DIR/completions/_cdk" &|

# ── Aliases ──────────────────────────────────────────────────────────────────

# Core workflow
alias cdkl='cdk list'
alias cdkls='cdk ls'
alias cdks='cdk synth'
alias cdkd='cdk deploy'
alias cdkda='cdk deploy --all'
alias cdkdiff='cdk diff'
alias cdkdes='cdk destroy'
alias cdkdesa='cdk destroy --all'
alias cdkw='cdk watch'
alias cdkb='cdk bootstrap'

# Faster deploys
alias cdkdf='cdk deploy --require-approval never'
alias cdkdaf='cdk deploy --all --require-approval never'
alias cdkho='cdk deploy --hotswap'

# Metadata / diagnostics
alias cdkdoc='cdk doctor'
alias cdkmeta='cdk metadata'
alias cdkctx='cdk context'
alias cdkctxr='cdk context --reset'
alias cdkack='cdk acknowledge'
