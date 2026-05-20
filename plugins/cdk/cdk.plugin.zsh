if (( ! $+commands[cdk] )); then
  return
fi

_cdk_yargs_completions() {
  local reply
  local si=$IFS
  IFS=$' '
  reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" cdk --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _cdk_yargs_completions cdk

# Aliases
alias cdkc="cdk context"
alias cdkd="cdk deploy"
alias cdkdiff="cdk diff"
alias cdki="cdk init"
alias cdkl="cdk list"
alias cdks="cdk synth"
alias cdkx="cdk destroy"
