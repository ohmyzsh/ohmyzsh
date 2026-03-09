if (( ! $+commands[zellij] )); then
  return
fi

if [[ -n ${ZSH_ZELLIJ_PREFIX_Z:-} ]]; then
  _zellij_prefix=z
else
  _zellij_prefix=zj
fi


if [[ -n ${ZSH_ZELLIJ_PREFIX_Z:-} ]] && (( ! $+aliases[z] && ! $+functions[z] && ! $+commands[z] )); then
  alias z='zellij'
else
  alias zj='zellij'
fi

# alias ${_zellij_prefix}='zellij'
alias ${_zellij_prefix}l='zellij list-sessions'
alias ${_zellij_prefix}s='zellij -s'
alias ${_zellij_prefix}da='zellij delete-all-sessions'
alias ${_zellij_prefix}ka='zellij kill-all-sessions'
[[ $_zellij_prefix != z ]] && alias ${_zellij_prefix}r='zellij run'

eval "${_zellij_prefix}a() { command zellij attach \"\$@\"; }"
eval "${_zellij_prefix}d() { command zellij delete-session \"\$@\"; }"
eval "${_zellij_prefix}k() { command zellij kill-session \"\$@\"; }"

(( $+functions[zr] || $+aliases[zr] || $+commands[zr] )) || zr() { command zellij run -- "$@"; }
(( $+functions[zrf] || $+aliases[zrf] || $+commands[zrf] )) || zrf() { command zellij run --floating -- "$@"; }
(( $+functions[ze] || $+aliases[ze] || $+commands[ze] )) || ze() { command zellij edit "$@"; }

_ZELLIJ_COMP_FILE="${ZSH_CACHE_DIR}/completions/_zellij"
mkdir -p "${_ZELLIJ_COMP_FILE:h}"

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
  sessions=("${(@f)$(printf '%s\n' "$out" | LC_ALL=C sed -nE '/EXITED/!s/^([^[:space:]]+).*/\1/p')}")
  (( ${#sessions[@]} )) && compadd -Q -a sessions
}

_omz_zellij_exited_sessions() {
  emulate -L zsh
  local out
  local -a sessions
  out="$(_omz_zellij_ls_raw)"
  sessions=("${(@f)$(printf '%s\n' "$out" | LC_ALL=C sed -nE '/EXITED/s/^([^[:space:]]+).*/\1/p')}")
  (( ${#sessions[@]} )) && compadd -Q -a sessions
}

if (( $+functions[compdef] )); then
  autoload -Uz _zellij
  compdef _zellij zellij ${_zellij_prefix} ${_zellij_prefix}l ${_zellij_prefix}s
  [[ $_zellij_prefix != z ]] && compdef _zellij ${_zellij_prefix}r
  compdef _omz_zellij_all_sessions ${_zellij_prefix}a
  compdef _omz_zellij_running_sessions ${_zellij_prefix}k
  compdef _omz_zellij_exited_sessions ${_zellij_prefix}d
fi

unset _ZELLIJ_COMP_FILE
unset _zellij_prefix
