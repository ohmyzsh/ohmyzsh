echo "Removing ~/.oh-my-zsh"
if [[ -d ~/.oh-my-zsh ]]
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
  echo "Changing default login shell from zsh back to bash ... login required."
  chsh -s /bin/bash
  if [ "$?" = "0" ]; then
    echo "Done.  All new shell windows will be bash!"
    printf "Replace this zsh window with a bash window right now? (yes/no): "
    read CHOICE
    if [ "$CHOICE" = "yes" ]; then
      echo "OK, please login again below ... if something goes wrong you can \
always close this window and start a new bash window."
      exec su - $USER
    else
      break
    fi
  else
    echo "Oops, something went wrong with the change to bash ... \
you can execute chsh -s /bin/bash manually and start a new window"
    break
  fi
fi

echo -e "\nThanks for trying out Oh My Zsh. It's been uninstalled."
