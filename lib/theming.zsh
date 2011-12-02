set_theme() {
  local themes
  themes=({$OMZ,$ZSH}/themes/$1.zsh-theme(N))
  source $themes[1]
}

random_theme() {
  local themes
  themes=({$OMZ,$ZSH}/themes/*.zsh-theme(N))
  source $themes[$RANDOM%$#themes+1]
}

# compdef "_files -g '*.zsh'" set_theme
