read -r -p "Are you sure you want to remove Oh My Zsh? [y/N] " confirmation
<<<<<<< HEAD
if [ "$confirmation" != y ] && [ "$confirmation" != Y ]
then
  echo "Uninstall cancelled"
  exit
=======
if ! [[ $confirmation =~ ^[yY]$ ]]
then
    echo "Uninstall cancelled"
    exit
>>>>>>> c0134a9450e486251b247735e022d7efeb496b9c
fi

echo "Removing ~/.oh-my-zsh"
if [ -d ~/.oh-my-zsh ]
then
  rm -rf ~/.oh-my-zsh
fi

echo "Looking for original zsh config..."
if [ -f ~/.zshrc.pre-oh-my-zsh ] || [ -h ~/.zshrc.pre-oh-my-zsh ]
then
  echo "Found ~/.zshrc.pre-oh-my-zsh -- Restoring to ~/.zshrc";

  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]
  then
    ZSHRC_SAVE=".zshrc.omz-uninstalled-`date +%Y%m%d%H%M%S`";
    echo "Found ~/.zshrc -- Renaming to ~/${ZSHRC_SAVE}";
    mv ~/.zshrc ~/${ZSHRC_SAVE};
  fi

  mv ~/.zshrc.pre-oh-my-zsh ~/.zshrc;

  source ~/.zshrc;
else
  if hash chsh >/dev/null 2>&1
  then
    echo "Switching back to bash"
    chsh -s /bin/bash
  else
    echo "You can edit /etc/passwd to switch your default shell back to bash"
  fi
fi

echo "Thanks for trying out Oh My Zsh. It's been uninstalled."
