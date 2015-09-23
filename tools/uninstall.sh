read -r -p "Are you sure you want to remove Oh My Zsh? [y/N] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  echo "Uninstall cancelled"
  exit
fi

echo "Removing ~/.oh-my-zsh"
if [ -d ~/.oh-my-zsh ]; then
  rm -rf ~/.oh-my-zsh
fi

echo "Looking for original zsh config..."
ZSHRC_ORIG=~/.zshrc.pre-oh-my-zsh
if [ -e "$ZSHRC_ORIG" ]; then
  echo "Found $ZSHRC_ORIG -- Restoring to ~/.zshrc"

  if [ -e ~/.zshrc ]; then
    ZSHRC_SAVE=~/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H-%M-%S)
    echo "Found ~/.zshrc -- Renaming to ${ZSHRC_SAVE}"
    mv ~/.zshrc "${ZSHRC_SAVE}"
  fi

  mv "$ZSHRC_ORIG" ~/.zshrc

  echo "Your original zsh config was restored. Please restart your session."
else
  if hash chsh >/dev/null 2>&1; then
    echo "Switching back to bash"
    chsh -s /bin/bash
  else
    echo "You can edit /etc/passwd to switch your default shell back to bash"
  fi
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
