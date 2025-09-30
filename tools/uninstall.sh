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

echo "Removing ~/.oh-my-zsh"
if [ -d ~/.oh-my-zsh ]; then
  rm -rf ~/.oh-my-zsh
fi

if [ -e ~/.zshrc ]; then
  BACKUP=~/.zshrc.backup-$(date +%Y-%m-%d_%H-%M-%S)
  echo "Backing up your current ~/.zshrc to ${BACKUP}"
  cp ~/.zshrc "${BACKUP}"

  # Remove only oh-my-zsh related lines
  if grep -q 'oh-my-zsh.sh' ~/.zshrc; then
    sed -i '/oh-my-zsh.sh/d' ~/.zshrc
    echo "Removed Oh My Zsh initialization from ~/.zshrc"
  fi

  if grep -q 'plugins=(' ~/.zshrc; then
    sed -i '/plugins=(/d' ~/.zshrc
    echo "Removed Oh My Zsh plugin line from ~/.zshrc"
  fi

  if grep -q 'ZSH_THEME=' ~/.zshrc; then
    sed -i '/ZSH_THEME=/d' ~/.zshrc
    echo "Removed Oh My Zsh theme setting from ~/.zshrc"
  fi
fi

echo "Looking for original zsh config..."
ZSHRC_ORIG=~/.zshrc.pre-oh-my-zsh
if [ -e "$ZSHRC_ORIG" ]; then
  echo "Found $ZSHRC_ORIG (not restoring automatically)."
  echo "You can restore it manually if needed: cp $ZSHRC_ORIG ~/.zshrc"
else
  echo "No original zsh config found. Your current ~/.zshrc was cleaned."
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
echo "Don't forget to restart your terminal!"
