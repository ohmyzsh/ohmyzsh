if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd ${ZOXIDE_CMD_OVERRIDE:-z} zsh)"
else
  echo '[oh-my-zsh] zoxide not found, please install it from https://github.com/ajeetdsouza/zoxide'
fi
