#!/bin/sh

source ./common

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
    note '[Oh My Zsh] Would you like to check for updates?'
    query 'Type Y to update oh-my-zsh:'
    read line
    if [ "$line" = Y ] || [ "$line" = y ]
    then
      ./upgrade.sh
      # update the zsh file
      _update_zsh_update
    fi
  else
    proclaim 'Updated recently.'
  fi
else
  # create the zsh file
  _update_zsh_update
fi
