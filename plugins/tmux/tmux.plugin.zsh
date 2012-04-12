#!/bin/zsh
# tmux plugin
# Copyright (C) 2011 Simon Gomizelj
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

if (( $+commands[tmux] )); then
  local state

  # autoload tmux on start
  zstyle -a :omz:plugins:tmux autostart state
  [[ $state == "on" && -z $TMUX ]] && exec tmux

  t() {
    # Load the command or directory-path from config.
    zstyle -a :omz:plugins:tmux:cmd $1 cmd; cmd=${cmd:-$2}
    zstyle -a :omz:plugins:tmux:dir $1 dir
    [[ -n $cmd ]] && (( ! $+commands[$cmd] )) && return 127

    # start the command
    # if ! tmux has -t $1 2>/dev/null; then
    if ! tmux has -t $1; then
      (
        [[ -d $dir ]] && cd $dir
        TMUX= tmux new -ds $1 ${cmd:-$SHELL}
      )
    fi

    # switch or attach depending on if we're inside tmux
    [[ -n $TMUX ]] && tmux switch -t $1 \
                   || tmux attach -t $1
  }

  # For those who would like to run this script from outside of zsh.
	# ( ie, key bindings to load a prompt )
  [[ $- != *i* ]] && source ~/.zshrc && t $1
	return 0
else
  omz_log_mgs "tmux: plugin requires tmux"
fi
