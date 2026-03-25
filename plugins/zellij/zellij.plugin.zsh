if (( ! $+commands[zellij] )); then
  return
fi

_omz_zellij_taken() {
  (( $+aliases[$1] || $+functions[$1] || $+commands[$1] ))
}

typeset -ga _zellij_comp_targets _zellij_all_session_targets _zellij_running_session_targets _zellij_exited_session_targets
_zellij_comp_targets=()
_zellij_all_session_targets=()
_zellij_running_session_targets=()
_zellij_exited_session_targets=()

if [[ -n ${ZSH_ZELLIJ_PREFIX_Z:-} ]]; then
  _zellij_short_prefix=z
  if _omz_zellij_taken z; then
    _zellij_root_alias=zj
  else
    _zellij_root_alias=z
  fi
else
  _zellij_short_prefix=zj
  _zellij_root_alias=zj
fi

if ! _omz_zellij_taken "$_zellij_root_alias"; then
  alias ${_zellij_root_alias}='zellij'
  _zellij_comp_targets+=("$_zellij_root_alias")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}l"; then
  alias ${_zellij_short_prefix}l='zellij list-sessions'
  _zellij_comp_targets+=("${_zellij_short_prefix}l")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}s"; then
  alias ${_zellij_short_prefix}s='zellij -s'
  _zellij_comp_targets+=("${_zellij_short_prefix}s")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}da"; then
  alias ${_zellij_short_prefix}da='zellij delete-all-sessions'
  _zellij_comp_targets+=("${_zellij_short_prefix}da")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}ka"; then
  alias ${_zellij_short_prefix}ka='zellij kill-all-sessions'
  _zellij_comp_targets+=("${_zellij_short_prefix}ka")
fi

if [[ $_zellij_short_prefix != z ]] && ! _omz_zellij_taken "${_zellij_short_prefix}r"; then
  alias ${_zellij_short_prefix}r='zellij run'
  _zellij_comp_targets+=("${_zellij_short_prefix}r")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}a"; then
  eval "${_zellij_short_prefix}a() { command zellij attach \"\$@\"; }"
  _zellij_all_session_targets+=("${_zellij_short_prefix}a")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}d"; then
  eval "${_zellij_short_prefix}d() { command zellij delete-session \"\$@\"; }"
  _zellij_exited_session_targets+=("${_zellij_short_prefix}d")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}k"; then
  eval "${_zellij_short_prefix}k() { command zellij kill-session \"\$@\"; }"
  _zellij_running_session_targets+=("${_zellij_short_prefix}k")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}ad"; then
  alias ${_zellij_short_prefix}ad='zellij action detach'
  _zellij_comp_targets+=("${_zellij_short_prefix}ad")
fi

if ! _omz_zellij_taken "${_zellij_short_prefix}as"; then
  eval "${_zellij_short_prefix}as() { command zellij action switch-session \"\$@\"; }"
  _zellij_all_session_targets+=("${_zellij_short_prefix}as")
fi

(( $+functions[zr] || $+aliases[zr] || $+commands[zr] )) || zr() { command zellij run -- "$@"; }
(( $+functions[zrf] || $+aliases[zrf] || $+commands[zrf] )) || zrf() { command zellij run --floating -- "$@"; }
(( $+functions[ze] || $+aliases[ze] || $+commands[ze] )) || ze() { command zellij edit "$@"; }

_ZELLIJ_COMP_DIR="${ZSH_CACHE_DIR}/completions"
_ZELLIJ_COMP_FILE="${_ZELLIJ_COMP_DIR}/_zellij"

mkdir -p "$_ZELLIJ_COMP_DIR"
(( ${fpath[(I)$_ZELLIJ_COMP_DIR]} )) || fpath=("$_ZELLIJ_COMP_DIR" $fpath)

if [[ ! -s $_ZELLIJ_COMP_FILE ]]; then
  command zellij setup --generate-completion zsh >| "$_ZELLIJ_COMP_FILE" 2>/dev/null
elif [[ $commands[zellij] -nt $_ZELLIJ_COMP_FILE ]]; then
  command zellij setup --generate-completion zsh >| "$_ZELLIJ_COMP_FILE" 2>/dev/null &!
fi

_omz_zellij_ls_raw() {
  command zellij list-sessions --no-formatting 2>/dev/null || command zellij list-sessions 2>/dev/null
}

_omz_zellij_all_sessions() {
  emulate -L zsh
  local out
  local -a sessions
  out="$(_omz_zellij_ls_raw)"
  sessions=("${(@f)$(printf '%s\n' "$out" | LC_ALL=C sed -nE 's/^([^[:space:]]+).*/\1/p')}")
  (( ${#sessions[@]} )) && compadd -Q -a sessions
}

_omz_zellij_running_sessions() {
  emulate -L zsh
  local out
  local -a sessions
  out="$(_omz_zellij_ls_raw)"
  sessions=("${(@f)$(printf '%s\n' "$out" | LC_ALL=C sed -nE '/\(EXITED/!s/^([^[:space:]]+).*/\1/p')}")
  (( ${#sessions[@]} )) && compadd -Q -a sessions
}

_omz_zellij_exited_sessions() {
  emulate -L zsh
  local out
  local -a sessions
  out="$(_omz_zellij_ls_raw)"
  sessions=("${(@f)$(printf '%s\n' "$out" | LC_ALL=C sed -nE '/\(EXITED/s/^([^[:space:]]+).*/\1/p')}")
  (( ${#sessions[@]} )) && compadd -Q -a sessions
}

if (( $+functions[compdef] )); then
  autoload -Uz _zellij
  compdef _zellij zellij ${_zellij_comp_targets[@]}
  (( ${#_zellij_all_session_targets[@]} )) && compdef _omz_zellij_all_sessions ${_zellij_all_session_targets[@]}
  (( ${#_zellij_running_session_targets[@]} )) && compdef _omz_zellij_running_sessions ${_zellij_running_session_targets[@]}
  (( ${#_zellij_exited_session_targets[@]} )) && compdef _omz_zellij_exited_sessions ${_zellij_exited_session_targets[@]}
fi

unset _ZELLIJ_COMP_DIR
unset _ZELLIJ_COMP_FILE
unset _zellij_root_alias
unset _zellij_short_prefix
unset _zellij_comp_targets
unset _zellij_all_session_targets
unset _zellij_running_session_targets
unset _zellij_exited_session_targets
