#!/usr/bin/env zsh

#
# serve-autocompletion-zsh
#
# Autocompletion for `serve` static HTTP server
#
# Copyright(c) 2016 Alexander Krivoshhekov <SuperPaintmanDeveloper@gmail.com>
# MIT Licensed
#

#
# Alexander Krivoshhekov
# Github: https://github.com/SuperPaintman
#

if [[ -z $commands[serve] ]] || ! serve --completion=zsh >/dev/null 2>&1; then
  echo 'serve is not installed, you should install "https://github.com/SuperPaintman/serve" first'
  return -1
fi

eval "$(serve --completion=zsh)"
