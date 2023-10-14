# Check if the 'cdk' command is available in the system's PATH
if ! command -v cdk >/dev/null 2>&1; then
  cdk() { npx -- cdk "$@" }
fi

###-begin-cdk-completions-###
_cdk_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" cdk --get-yargs-completions "${words[@]}"))
  IFS=$si
  # Loop through the reply array and append "tomato" to each value
  _describe 'values' reply
}
compdef _cdk_yargs_completions cdk
###-end-cdk-completions-###

export ZSH_AUTOSUGGEST=true



autoload -U compinit
compinit