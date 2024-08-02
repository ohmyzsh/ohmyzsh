function toolbox_prompt_info() {
  [[ -f /run/.toolboxenv ]] && echo "⬢"
}

function toolbox_prompt_name() {
  [[ -f /run/.containerenv ]] || return
  local _to_print="$(cat /run/.containerenv | awk -F\" '/name/ { print$2 }')"
  echo ${_to_print:gs/%/%%}
}

alias tbe="toolbox enter"
alias tbr="toolbox run"
