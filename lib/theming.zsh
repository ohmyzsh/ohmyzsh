set_theme() {
  source "$ZSH/themes/$1.zsh-theme"
}

random_theme() {
  local themes
  themes=($ZSH/themes/*zsh-theme)
  source "$themes[$RANDOM%$#themes+1]"
}

# compdef "_files -g '*.zsh'" set_theme
