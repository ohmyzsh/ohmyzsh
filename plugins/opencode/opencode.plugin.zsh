if ! (( $+commands[opencode] )); then
  print "zsh opencode plugin: opencode not found. Please install opencode before using this plugin." >&2
  return 1
fi

# See `opencode completion`
_opencode_yargs_completions() {
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" opencode --get-yargs-completions "${words[@]}"))
  IFS=$si
  if [[ ${#reply} -gt 0 ]]; then
    _describe 'values' reply
  else
    _default
  fi
}

if [[ "'${zsh_eval_context[-1]}" == "loadautofunc" ]]; then
  _opencode_yargs_completions "$@"
else
  compdef _opencode_yargs_completions opencode
fi

# Aliases
alias oc="opencode"
alias ocr="opencode run"
