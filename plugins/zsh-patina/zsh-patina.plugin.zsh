if (( $+ZSH_HIGHLIGHT_VERSION )) || (( ${plugins[(Ie)zsh-syntax-highlighting]} )); then
  echo '[oh-my-zsh] zsh-patina conflicts with zsh-syntax-highlighting, please enable only one of them'
elif [[ -x ${ZSH_PATINA_BINARY:-$commands[zsh-patina]} ]]; then
  eval "$(${ZSH_PATINA_BINARY:-$commands[zsh-patina]} activate)"

  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `zsh-patina`. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_zsh-patina" ]]; then
    typeset -g -A _comps
    autoload -Uz _zsh-patina
    _comps[zsh-patina]=_zsh-patina
  fi

  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._zsh-patina"
    zf_mv -f -- =( "$1" completion ) "$ZSH_CACHE_DIR/completions/_zsh-patina"
  } "${ZSH_PATINA_BINARY:-$commands[zsh-patina]}" &|
else
  echo '[oh-my-zsh] zsh-patina not found, please install it from https://github.com/michel-kraemer/zsh-patina'
fi
