set_theme() {
  local theme

  theme=({$OMZ,$ZSH}/themes/$1-theme(N))
  source $theme[1]
}

random_theme() {
  local themes
  themes=($ZSH/themes/*zsh-theme(N))
  source "$themes[$RANDOM%$#themes+1]"
}

# compdef "_files -g '*.zsh'" set_theme
