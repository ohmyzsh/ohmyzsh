#!/bin/sh

current_epoch=$(($(date +%s) / 60 / 60 / 24))

if [ -f ~/.zsh-update ]
then
  . ~/.zsh-update
  epoch_diff=$(($current_epoch - $LAST_EPOCH))
  if [ $epoch_diff -gt 6 ]
  then
    echo "[Oh My Zsh] Would you like to check for updates?"
    echo "Type Y to update oh-my-zsh: \c"
    read line
    if [ "$line" = Y ] || [ "$line" = y ]
    then
      /bin/sh $ZSH/tools/upgrade.sh
    fi

    # Set the last epoch to the current so that we don't ask for another week
    echo "LAST_EPOCH=${current_epoch}" > ~/.zsh-update
  fi
else
  # TODO: refactor this so remove duplicates
  # Create the ~/.zsh-update file with the current epoch info
  echo "LAST_EPOCH=${current_epoch}" > ~/.zsh-update
fi


