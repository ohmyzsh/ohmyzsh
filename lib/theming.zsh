set_theme() {
  local themes
  themes=({$OMZ,$ZSH}/themes/$1.zsh-theme(N))
  if ! source $themes[1] 2> /dev/null; then
    omz_log_msg "theme: $1 was not found. falling back to default."
    source $ZSH/themes/default.zsh-theme
  fi
}

random_theme() {
  local themes
  themes=({$OMZ,$ZSH}/themes/*.zsh-theme(N))
  source $themes[$RANDOM%$#themes+1]
}

# compdef "_files -g '*.zsh'" set_theme
