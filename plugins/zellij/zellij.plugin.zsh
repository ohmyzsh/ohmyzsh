if (( ! $+commands[zellij] )); then
  return
fi

# Aliases
alias zj='zellij'
alias zjl='zellij list-sessions'
alias zjs='zellij -s'
alias zjda='zellij delete-all-sessions'
alias zjka='zellij kill-all-sessions'
alias zjr='zellij run'
alias zjad='zellij action detach'

# Functions (with session-aware completion)
function zja  { command zellij attach "$@"; }
function zjd  { command zellij delete-session "$@"; }
function zjdf { command zellij delete-session --force "$@"; }
function zjk  { command zellij kill-session "$@"; }
function zjas { command zellij action switch-session "$@"; }

# Convenience functions
function zjrf { command zellij run --floating -- "$@"; }
function zje  { command zellij edit "$@"; }

# Completion cache: generate synchronously on first load, regenerate in the
# background when the zellij binary is newer than the cache. Write to a temp
# file in the same directory and rename it, so a partial file is never loaded.
_omz_zellij_gen_completion() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/._zellij"
  zf_mv -f -- =( command zellij setup --generate-completion zsh 2>/dev/null ) "$ZSH_CACHE_DIR/completions/_zellij"
}

zmodload -F zsh/files b:zf_mv
if [[ ! -s "$ZSH_CACHE_DIR/completions/_zellij" ]]; then
  _omz_zellij_gen_completion
elif [[ $commands[zellij] -nt "$ZSH_CACHE_DIR/completions/_zellij" ]]; then
  _omz_zellij_gen_completion &|
fi

_omz_zellij_ls_raw() {
  command zellij list-sessions --no-formatting 2>/dev/null || command zellij list-sessions 2>/dev/null
}

_omz_zellij_session_names() {
  # Use --short if available (zellij >= 0.44), fall back to sed parsing
  command zellij list-sessions --short --no-formatting 2>/dev/null \
    || _omz_zellij_ls_raw | LC_ALL=C sed -nE 's/^([^[:space:]]+).*/\1/p'
}

_omz_zellij_all_sessions() {
  emulate -L zsh
  local -a sessions
  sessions=(${(f)"$(_omz_zellij_session_names)"})
  (( ${#sessions} )) && compadd -Q -a sessions
}

_omz_zellij_running_sessions() {
  emulate -L zsh
  local -a sessions
  sessions=(${(f)"$(_omz_zellij_ls_raw | LC_ALL=C sed -nE '/\(EXITED/!s/^([^[:space:]]+).*/\1/p')"})
  (( ${#sessions} )) && compadd -Q -a sessions
}

_omz_zellij_exited_sessions() {
  emulate -L zsh
  local -a sessions
  sessions=(${(f)"$(_omz_zellij_ls_raw | LC_ALL=C sed -nE '/\(EXITED/s/^([^[:space:]]+).*/\1/p')"})
  (( ${#sessions} )) && compadd -Q -a sessions
}

if (( $+functions[compdef] )); then
  autoload -Uz _zellij
  compdef _zellij zellij
  compdef _omz_zellij_all_sessions zja zjdf zjas
  compdef _omz_zellij_running_sessions zjk
  compdef _omz_zellij_exited_sessions zjd
fi
