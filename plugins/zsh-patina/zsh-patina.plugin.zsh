if (( $+ZSH_HIGHLIGHT_VERSION )) || (( ${plugins[(Ie)zsh-syntax-highlighting]} )); then
  echo '[oh-my-zsh] zsh-patina conflicts with zsh-syntax-highlighting, please enable only one of them'
elif [[ -x ${ZSH_PATINA_BINARY:-$commands[zsh-patina]} ]]; then
  eval "$(${ZSH_PATINA_BINARY:-$commands[zsh-patina]} activate)"
else
  echo '[oh-my-zsh] zsh-patina not found, please install it from https://github.com/michel-kraemer/zsh-patina'
fi
