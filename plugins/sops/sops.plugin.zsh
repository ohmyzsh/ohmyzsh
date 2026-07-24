# Completion
if (( ! $+commands[sops] )); then
  return
fi

_sops() {
  local -a opts
  local cur
  cur=${words[-1]}
  if [[ "$cur" == "-"* ]]; then
    opts=("${(@f)$(${words[@]:0:#words[@]-1} ${cur} --generate-shell-completion)}")
  else
    opts=("${(@f)$(${words[@]:0:#words[@]-1} --generate-shell-completion)}")
  fi

  if [[ "${opts[1]}" != "" ]]; then
    _describe 'values' opts
  else
    _files
  fi
}

compdef _sops sops
