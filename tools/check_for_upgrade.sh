#!/usr/bin/env zsh

zmodload zsh/datetime

function _current_epoch() {
  echo $(( $EPOCHSECONDS / 60 / 60 / 24 ))
}

function _update_zsh_update() {
  echo "LAST_EPOCH=$(_current_epoch)" >! ~/.zsh-update
}

function _upgrade_zsh() {
  # Skip when no internet connectivity, depends on curl
  REMOTE=$(cd "$ZSH" && git remote get-url --all origin)
  echo "$REMOTE" | grep -qa 'git@'
  if [ $? -eq 0 ]
  then
    # convert the remote protocol to https
    REMOTE=$(echo $REMOTE | tr ':' '/' | sed -e "s#git@#https://#")
  fi

  # -L follow redirect, -s silent,
  # --max-time overall operation timeout, -I only download headers
  whence curl > /dev/null && curl -L -s --max-time 3 -I ${REMOTE} > /dev/null || return 0
  # the curl call could be replaced by:
  # `ping -q -c 1 -W 1 8.8.8.8 >/dev/null` without DNS resolution
  # or `ping -q -c 1 -W 1 github.com >/dev/null`
  env ZSH=$ZSH sh $ZSH/tools/upgrade.sh
  # update the zsh file
  _update_zsh_update
}

epoch_target=$UPDATE_ZSH_DAYS
if [[ -z "$epoch_target" ]]; then
  # Default to old behavior
  epoch_target=13
fi

# Cancel upgrade if the current user doesn't have write permissions for the
# oh-my-zsh directory.
[[ -w "$ZSH" ]] || return 0

# Cancel upgrade if git is unavailable on the system
whence git >/dev/null || return 0

if mkdir "$ZSH/log/update.lock" 2>/dev/null; then
  if [ -f ~/.zsh-update ]; then
    . ~/.zsh-update

    if [[ -z "$LAST_EPOCH" ]]; then
      _update_zsh_update && return 0;
    fi

    epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
    if [ $epoch_diff -gt $epoch_target ]; then
      if [ "$DISABLE_UPDATE_PROMPT" = "true" ]; then
        _upgrade_zsh
      else
        echo "[Oh My Zsh] Would you like to check for updates? [Y/n]: \c"
        read line
        if [[ "$line" == Y* ]] || [[ "$line" == y* ]] || [ -z "$line" ]; then
          _upgrade_zsh
        else
          _update_zsh_update
        fi
      fi
    fi
  else
    # create the zsh file
    _update_zsh_update
  fi

  rmdir $ZSH/log/update.lock
fi
