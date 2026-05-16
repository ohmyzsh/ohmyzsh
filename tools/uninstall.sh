if hash chsh >/dev/null 2>&1 && [ -f ~/.shell.pre-oh-my-zsh ]; then
  old_shell=$(cat ~/.shell.pre-oh-my-zsh)
  echo "Switching your shell back to '$old_shell':"
  if chsh -s "$old_shell"; then
    rm -f ~/.shell.pre-oh-my-zsh
  else
    echo "Could not change default shell. Change it manually by running chsh"
    echo "or editing the /etc/passwd file."
    exit
  fi
fi

read -r -p "Are you sure you want to remove Oh My Zsh? [y/N] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  echo "Uninstall cancelled"
  exit
fi

# Use $ZSH if set, otherwise fall back to ~/.oh-my-zsh
: ${ZSH:=~/.oh-my-zsh}
# Use $ZDOTDIR if set, otherwise fall back to $HOME
: ${ZDOTDIR:=$HOME}

echo "Removing $ZSH"
if [ -d "$ZSH" ]; then
  rm -rf "$ZSH"
fi

if [ -e "$ZDOTDIR/.zshrc" ]; then
  ZSHRC_SAVE="$ZDOTDIR/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H-%M-%S)"
  echo "Found $ZDOTDIR/.zshrc -- Renaming to ${ZSHRC_SAVE}"
  mv "$ZDOTDIR/.zshrc" "${ZSHRC_SAVE}"
fi

echo "Looking for original zsh config..."
ZSHRC_ORIG="$ZDOTDIR/.zshrc.pre-oh-my-zsh"
if [ -e "$ZSHRC_ORIG" ]; then
  echo "Found $ZSHRC_ORIG -- Restoring to $ZDOTDIR/.zshrc"
  mv "$ZSHRC_ORIG" "$ZDOTDIR/.zshrc"
  echo "Your original zsh config was restored."
else
  echo "No original zsh config found"
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
echo "Don't forget to restart your terminal!"
