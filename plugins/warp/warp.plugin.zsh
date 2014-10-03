#!/bin/bash
#https://github.com/jpalardy/warp
warp() {
  # ensure SOURCE file exists
  local SOURCE="$HOME/.warp"
  if [ ! -f "$SOURCE" ]; then
    echo "$SOURCE does not exist..."
    return 1
  fi

  # cleanup TARGET file
  local TARGET=$HOME/.picked
  if [ -e "$TARGET" ]; then
    rm "$TARGET"
  fi

  # make a selection, with vim
  cat "$SOURCE" | vim -c "setlocal noreadonly" \
                      -c "setlocal cursorline" \
                      -c "setlocal number" \
                      -c "nnoremap <buffer> <CR> V:w! ~/.picked<CR>:qa!<CR>" \
                      -c "vnoremap <buffer> <CR>  :w! ~/.picked<CR>:qa!<CR>" \
                      -R -
  # nothing was selected, abort
  if [ ! -e "$TARGET" ]; then
    return
  fi

  # transform seletion in ssh command
  local SSH=${SSH:-ssh}
  local COMMAND=""
  if [ $(cat "$TARGET" | wc -l) -gt 1 ]; then
    # determine which clusterssh to use based on os
    unamestr=`uname`
    if [[ "$unamestr" == 'Linux' ]]; then
      SSH=${MULTISSH:-cssh}
    elif [[ "$unamestr" == 'Darwin' ]]; then
      SSH=${MULTISSH:-csshX}
    fi
    COMMAND="$(awk -v cmd=$SSH 'BEGIN {printf cmd} {printf " " $1} END { print "" }' "$TARGET")"
  else
    COMMAND="$(awk -v cmd=$SSH '{ n = split($1, parts, ":"); if (n == 2) { print cmd, "-p", parts[2], parts[1] } else { print cmd, $1 } }' "$TARGET")"
  fi

  # add the command to the bash history as if we had typed it, will only work if sourced
  # Determine which history command to use based on shell
  if [ -n "$BASH_VERSION" ]; then
    eval "history -s $COMMAND"
  elif [ -n "$ZSH_VERSION" ]; then
    eval "print -s $COMMAND"
  fi

  # run the command
  eval $COMMAND
}

# allow warp to be sourced without running
if [[ $_ == $0 ]]; then
  warp
else
  # Hide warp from history if using zsh and setopt histignorespace
  alias warp=" warp"
fi
