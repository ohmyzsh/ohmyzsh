set_theme() {
  source "$ZSH/themes/$ZSH_THEME.zsh-theme"
}

random_theme() {
  local themes
  themes=($ZSH/themes/*zsh-theme)
  source "$themes[$RANDOM%$#themes+1]"
}
