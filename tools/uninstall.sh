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
  ZSHRC_SAVE=~/.zshrc.omz-uninstalled-$(date +%Y-%m-%d_%H-%M-%S)
  echo "Found ~/.zshrc -- Saving your current config to ${ZSHRC_SAVE}"
  echo "  (this file contains your current zsh configuration)"
  mv ~/.zshrc "${ZSHRC_SAVE}"
fi

echo "Looking for original zsh config..."
ZSHRC_ORIG=~/.zshrc.pre-oh-my-zsh
if [ -e "$ZSHRC_ORIG" ]; then
  ZSHRC_ORIG_DATE=$(date -r "$ZSHRC_ORIG" "+%Y-%m-%d" 2>/dev/null || date -d "@$(stat -c %Y "$ZSHRC_ORIG" 2>/dev/null)" "+%Y-%m-%d" 2>/dev/null || echo "unknown date")
  echo "Found $ZSHRC_ORIG (last modified: ${ZSHRC_ORIG_DATE})"
  echo "This is the zsh config that existed before Oh My Zsh was installed."
  printf "Restore it as ~/.zshrc? [y/N] "
  read -r restore_confirmation
  if [ "$restore_confirmation" = y ] || [ "$restore_confirmation" = Y ]; then
    mv "$ZSHRC_ORIG" ~/.zshrc
    echo "Your original zsh config was restored to ~/.zshrc."
    if [ -n "$ZSHRC_SAVE" ]; then
      echo "Your Oh My Zsh config is saved at ${ZSHRC_SAVE} if you need it."
    fi
  else
    echo "Skipping restore."
    if [ -n "$ZSHRC_SAVE" ]; then
      mv "${ZSHRC_SAVE}" ~/.zshrc
      echo "Your current zsh config has been kept at ~/.zshrc."
      echo "Your pre-OMZ backup is still at ${ZSHRC_ORIG} if you need it."
    fi
  fi
else
  echo "No original zsh config found."
  if [ -n "$ZSHRC_SAVE" ]; then
    mv "${ZSHRC_SAVE}" ~/.zshrc
    echo "Your current zsh config has been kept at ~/.zshrc."
  fi
fi

# Warn if the active .zshrc still sources oh-my-zsh
if [ -f ~/.zshrc ] && command grep -q 'source.*oh-my-zsh\.sh' ~/.zshrc 2>/dev/null; then
  echo ""
  echo "Note: ~/.zshrc still contains a line sourcing oh-my-zsh.sh."
  echo "Since oh-my-zsh has been removed, that line will cause an error"
  echo "on every new shell. You may want to remove or comment it out."
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
echo "Don't forget to restart your terminal!"
