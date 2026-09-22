if (( ! $+commands[hermes] )); then
  return
fi

if [[ ! -f "$ZSH_CACHE_DIR/completions/_hermes" ]]; then
  typeset -g -A _comps
  autoload -Uz _hermes
  _comps[hermes]=_hermes
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_hermes"
  zf_mv -f -- =( hermes completion zsh < /dev/null 2> /dev/null ) "$TMPPREFIX"
} &|
