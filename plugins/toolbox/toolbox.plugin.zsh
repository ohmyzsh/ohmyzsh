function toolbox_prompt_info() {
  [[ -f /run/.toolboxenv ]] && echo "⬢"
}

function toolbox_prompt_name() {
  [[ -f /run/.containerenv ]] && cat /run/.containerenv | awk -F\" '/name/ { print$2 }'
}

alias tbe="toolbox enter"
alias tbr="toolbox run"
