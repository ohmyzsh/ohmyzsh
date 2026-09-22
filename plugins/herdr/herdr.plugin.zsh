# Aliases, helpers and completion for herdr (https://herdr.dev), the runtime for coding agents.

# PROMPT
# Defined before the herdr check so themes can reference it on machines without herdr.
function herdr_prompt_info {
  [[ "$HERDR_ENV" == 1 ]] || return
  echo "${ZSH_THEME_HERDR_PROMPT_PREFIX}${HERDR_PANE_ID:gs/%/%%}${ZSH_THEME_HERDR_PROMPT_SUFFIX}"
}

if (( ! $+commands[herdr] )); then
  return
fi

# ALIASES
alias hrdr='herdr'
alias hrdrst='herdr status'
alias hrdrup='herdr update'
alias hrdrsl='herdr session list'
alias hrdrsa='herdr session attach'
alias hrdrr='herdr --remote'
alias hrdral='herdr agent list'
alias hrdrwl='herdr workspace list'
alias hrdrwc='herdr workspace create'
alias hrdrwt='herdr worktree create'
alias hrdrps='herdr pane split'
alias hrdrrc='herdr server reload-config'

# FUNCTIONS
# Pick a session and attach to it, with fzf if available or a numbered menu otherwise.
function hrdrs {
  setopt localoptions extendedglob
  local -a lines
  lines=("${(@f)$(herdr session list 2>/dev/null)}")
  lines=("${(@)lines%%[[:space:]]#[^[:space:]]#}")  # drop the socket column
  if (( $#lines < 2 )); then
    print "hrdrs: no herdr sessions found" >&2
    return 1
  fi

  local choice
  if (( $+commands[fzf] )); then
    choice=$(print -l -- "${lines[@]}" | fzf --header-lines=1 --prompt='herdr session> ') || return
  else
    print -- "${lines[1]}"
    local PS3="Attach to session: "
    select choice in "${lines[@]:1}"; do
      [[ -n "$choice" ]] && break
    done
  fi
  [[ -n "$choice" ]] || return 1

  herdr session attach "${${(z)choice}[1]}"
}

# COMPLETION
# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `herdr`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_herdr" ]]; then
  typeset -g -A _comps
  autoload -Uz _herdr
  _comps[herdr]=_herdr
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_herdr"
  zf_mv -f -- =( herdr completion zsh < /dev/null 2> /dev/null ) "$TMPPREFIX"
} &|
