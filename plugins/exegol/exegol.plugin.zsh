# Return immediately if exegol is not found
if (( ! ${+commands[exegol]} )); then
  echo OK
fi

alias e='exegol'
alias ei='exegol info'
alias eu='exegol update'

alias es='exegol start'
function esn() {
  local only_dashes=true
  for arg in "$@"; do
    if [[ ! "$arg" == -* ]]; then
      only_dashes=false
      break
    fi
  done

  if [[ "$#" == 0 ]] || $only_dashes; then
    # If all arguments are dashes or empty, use default name
    exegol start default nightly "$@"
  else
    exegol start "$@" nightly
  fi
}
function esf() {
  local only_dashes=true
  for arg in "$@"; do
    if [[ ! "$arg" == -* ]]; then
      only_dashes=false
      break
    fi
  done

  if [[ "$#" == 0 ]] || $only_dashes; then
    # If all arguments are dashes or empty, use default name
    exegol start default full "$@"
  else
    exegol start "$@" full
  fi
}
alias esf!='esf --privileged'
alias esn!='esn --privileged'

alias etmpn='exegol exec --tmp nightly'
alias etmpf='exegol exec --tmp full'

alias estp='exegol stop'
alias estpa='exegol stop --all'

alias erm='exegol remove'
alias erm!='exegol remove --force'
alias erma='exegol remove --all'
alias erma!='exegol remove --force --all'
