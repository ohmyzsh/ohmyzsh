# Check if the 'cdk' command is available in the system's PATH
if ! command -v cdk >/dev/null 2>&1; then
  cdk() { npx -- cdk "$@" }
fi

###-begin-cdk-completions-###
_cdk_yargs_completions()
{
  local completion_suggestions
  local si=$IFS
  IFS=$'
' completion_suggestions=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" cdk --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' completion_suggestions
}
compdef _cdk_yargs_completions cdk
###-end-cdk-completions-###

export ZSH_AUTOSUGGEST=true



autoload -U compinit
compinit