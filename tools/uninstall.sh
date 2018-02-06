read -r -p "Are you sure you want to remove Oh My Zsh? [y/N] " confirmation
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]; then
  echo "Uninstall cancelled"
  exit
fi

echo "Removing ~/.oh-my-zsh"
if [ -d ~/.oh-my-zsh ]; then
  rm -rf ~/.oh-my-zsh
fi

# if we had zsh previously 
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
fi

echo "Restoring default shell..."
if [ -f ~/.shell.pre-oh-my-zsh ] ; then
  if hash chsh >/dev/null 2>&1; then
    echo "Found ~/.shell.pre-oh-my-zsh -- Restoring your default shell to" $(cat ~/.shell.pre-oh-my-zsh)
    chsh -s $(cat ~/.shell.pre-oh-my-zsh)
    rm ~/.shell.pre-oh-my-zsh
  else
    echo "Switching back to bash"
    chsh -s /bin/bash
  fi
else
  echo "You can edit /etc/passwd to switch your default shell back to bash"
fi
echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
