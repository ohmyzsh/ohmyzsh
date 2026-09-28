# Autocompletion for the GitHub CLI (gh).
if (( ! $+commands[gh] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `gh`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_gh" ]]; then
  typeset -g -A _comps
  autoload -Uz _gh
  _comps[gh]=_gh
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_gh"
  local tmp
  tmp=$(mktemp "${TMPPREFIX}.XXXXXX") \
    || return

  if gh completion --shell zsh >| "$tmp"; then
    zf_mv -f -- "$tmp" "$TMPPREFIX"
  else
    command rm -f -- "$tmp"
  fi
} &|
