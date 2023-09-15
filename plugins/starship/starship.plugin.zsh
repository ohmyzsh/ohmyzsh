# ignore oh-my-zsh theme
unset ZSH_THEME

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  echo '[oh-my-zsh] starship not found, please install it from https://starship.rs'
fi
