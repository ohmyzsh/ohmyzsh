if ! (( $+commands[eza] )); then
  print "zsh eza plugin: eza not found. Please install eza before using this plugin." >&2
  return 1
fi

typeset -a _EZA_HEAD
typeset -a _EZA_TAIL

function _configure_eza() {
  local _val
  # Get the head flags
  if zstyle -T ':omz:plugins:eza' 'show-group'; then
    _EZA_HEAD+=("g")
  fi
  if zstyle -t ':omz:plugins:eza' 'header'; then
    _EZA_HEAD+=("h")
  fi
  zstyle -s ':omz:plugins:eza' 'size-prefix' _val
  case "${_val:l}" in
    binary)
      _EZA_HEAD+=("b")
      ;;
    none)
      _EZA_HEAD+=("B")
      ;;
  esac
  # Get the tail long-options
  if zstyle -t ':omz:plugins:eza' 'dirs-first'; then
    _EZA_TAIL+=("--group-directories-first")
  fi
  if zstyle -t ':omz:plugins:eza' 'git-status'; then
    _EZA_TAIL+=("--git")
  fi
  zstyle -s ':omz:plugins:eza' 'time-style' _val
  if [[ $_val ]]; then
    _EZA_TAIL+=("--time-style='$_val'")
  fi
}

_configure_eza

function _alias_eza() {
  local _head="${(j::)_EZA_HEAD}$2"
  local _tail="${(j: :)_EZA_TAIL}"
  alias "$1"="eza${_head:+ -}${_head}${_tail:+ }${_tail}${3:+ }$3"
}

_alias_eza la   la
_alias_eza ldot ld ".*"
_alias_eza lD   lD
_alias_eza lDD  lDa
_alias_eza ll   l
_alias_eza ls
_alias_eza lsd  d
_alias_eza lsdl dl
_alias_eza lS   "l -ssize"
_alias_eza lT   "l -snewest"

unfunction _alias_eza
unfunction _configure_eza
unset _EZA_HEAD
unset _EZA_TAIL
