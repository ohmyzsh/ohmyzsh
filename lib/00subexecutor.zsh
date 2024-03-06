## Provides auto-detection of subexecutor to use

# If in the future a new subexecuter is created, we only need to edit this array
typeset _KNOWN_SUBEXES=( "doas" "sudo" )
typeset _SUBEX

function _SetupSubexecutor() {
  local _i
  local _cmd
  zstyle -s ':omz' 'subexecutor' _SUBEX
  if [[ "$_SUBEX" ]]; then
    if command -v "$_SUBEX" > /dev/null; then
      return 0
    fi
    print "Cannot find subexecutor '${_SUBEX}'; please check your configuration!" >&2
    return 1
  fi
  for _i in "${_KNOWN_SUBEXES[@]}"; do
    if command -v "$_i" > /dev/null; then
      _SUBEX="$_i"
      break
    fi
  done
  if [[ -z $_SUBEX ]]; then
    print "oh-my-zsh: cannot auto-detect subexecutor; please specify explicitly using 'zstyle :omz subexecutor'." >&2
    return 1
  fi
  zstyle ':omz' 'subexecutor' "$_SUBEX"
}

_SetupSubexecutor
unfunction _SetupSubexecutor
unset _KNOWN_SUBEXES

# The alias provides a 'hardcoded', invariant subexecutor to use throughout the shell session
alias _="$_SUBEX "

# The function is, in contrast, modifiable by changing the :omz->subexecutor zstyle
function subex() {
  local _subex
  zstyle -s ':omz' 'subexecutor' _subex
  ${_subex} "$@"
}

