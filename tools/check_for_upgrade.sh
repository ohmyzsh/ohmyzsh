#!/bin/sh

function _current_epoch() {
  echo $(($(date +%s) / 60 / 60 / 24))
}

function _update_zsh_update() {
  echo "LAST_EPOCH=$(_current_epoch)" > ~/.zsh-update
}

if [ -f ~/.zsh-update ]
then
  . ~/.zsh-update

  if [[ -z "$LAST_EPOCH" ]]; then
    _update_zsh_update && return 0;
  fi

  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
  if [ $epoch_diff -gt 6 ]
  then
    echo "[Oh My Zsh] Would you like to check for updates?"
    echo "Type Y to update oh-my-zsh: \c"
    read line
    if [ "$line" = Y ] || [ "$line" = y ]
    then
      /usr/bin/env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh
      # update the zsh file
      _update_zsh_update
    fi
  fi
else
  # create the zsh file
  _update_zsh_update
fi
