function install_autocompletion {
  if (( ! $+commands[$1] )); then
    return
  fi

  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `$1` (cosign, sget, rekor-cli). Otherwise, compinit will
  # have already done that
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_$1" ]]; then
    autoload -Uz _$1
    typeset -g -A _comps
    _comps[$1]=_$1
  fi

  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/_$1"
    zf_mv -f -- =( $1 completion zsh ) "$TMPPREFIX"
  } "$1" &|
}

install_autocompletion cosign
install_autocompletion sget
install_autocompletion rekor-cli

unfunction install_autocompletion
