#!/usr/bin/env zsh
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et

# Copyleft 2011 zsh-syntax-highlighting contributors
# http://github.com/nicoulaj/zsh-syntax-highlighting
# All wrongs reserved.


source $(dirname $0)/../zsh-syntax-highlighting.zsh

TIMEFMT="%*Es"
for buffer in $(dirname $0)/data/*.zsh; do
  echo -n "${buffer:t:r}: "
  time ( BUFFER="`cat $buffer`" && _zsh_highlight-zle-buffer )
done
