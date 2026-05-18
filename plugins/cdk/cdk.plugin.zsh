# AWS CDK plugin
#
# Adds completion for the AWS CDK CLI. If `cdk` is not installed globally but
# `npx` is available, define a wrapper so project-local CDK installations work.

if (( ! $+commands[cdk] )); then
  if (( ! $+commands[npx] )); then
    return
  fi

  function cdk() {
    npx -- cdk "$@"
  }
fi

function _cdk_yargs_completions() {
  local -a reply
  reply=(${(f)"$(COMP_CWORD="$((CURRENT - 1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" cdk --get-yargs-completions "${words[@]}")"})
  _describe 'values' reply
}

compdef _cdk_yargs_completions cdk
