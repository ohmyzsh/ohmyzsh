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
if [ -f ~/.zshrc.pre-oh-my-zsh ] || [ -h ~/.zshrc.pre-oh-my-zsh ]; then
  echo "Found ~/.zshrc.pre-oh-my-zsh -- Restoring to ~/.zshrc";

  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
    ZSHRC_SAVE=".zshrc.omz-uninstalled-$(date +%Y%m%d%H%M%S)";
    echo "Found ~/.zshrc -- Renaming to ~/${ZSHRC_SAVE}";
    mv ~/.zshrc ~/"${ZSHRC_SAVE}";
  fi

  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc;

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
