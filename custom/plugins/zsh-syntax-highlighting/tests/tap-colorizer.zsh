#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2015, 2017 zsh-syntax-highlighting contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list of conditions
#    and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of
#    conditions and the following disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of the zsh-syntax-highlighting contributors nor the names of its contributors
#    may be used to endorse or promote products derived from this software without specific prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------

# This is a stdin-to-stdout filter that takes TAP output (such as 'make test')
# on stdin and passes it, colorized, to stdout.

emulate -LR zsh

if [[ ! -t 1 ]] ; then
  exec cat
fi

while read -r line;
do
  case $line in
    # comment (filename header) or plan
    (#* | <->..<->)
      print -nP %F{blue}
      ;;
    # SKIP
    (*# SKIP*)
      print -nP %F{yellow}
      ;;
    # XPASS
    (ok*# TODO*)
      print -nP %F{red}
      ;;
    # XFAIL
    (not ok*# TODO*)
      print -nP %F{yellow}
      ;;
    # FAIL
    (not ok*)
      print -nP %F{red}
      ;;
    # PASS
    (ok*)
      print -nP %F{green}
      ;;
  esac
  print -nr - "$line"
  print -nP %f
  echo "" # newline
done
