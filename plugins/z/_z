#compdef zshz ${ZSHZ_CMD:-${_Z_CMD:-z}}
#
# Zsh-z - jump around with Zsh - A native Zsh version of z without awk, sort,
# date, or sed
#
# https://github.com/agkozak/zsh-z
#
# Copyright (c) 2018-2023 Alexandros Kozak
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# z (https://github.com/rupa/z) is copyright (c) 2009 rupa deadwyler and
# licensed under the WTFPL license, Version 2.a
#
# shellcheck shell=ksh

############################################################
# Zsh-z COMPLETIONS
############################################################
emulate -L zsh
(( ZSHZ_DEBUG )) &&
  setopt LOCAL_OPTIONS WARN_CREATE_GLOBAL NO_WARN_NESTED_VAR 2> /dev/null

# TODO: This routine currently reproduces z's feature of allowing spaces to be
# used as wildcards in completions, so that
#
#   z us lo bi
#
# can expand to
#
#   z /usr/local/bin
#
# but it also reproduces z's buggy display on the commandline, viz.
#
#   z us lo /usr/local/bin
#
# Address.

local completions expl completion
local -a completion_list

completions=$(zshz --complete ${(@)words:1})
[[ -z $completions ]] && return 1

for completion in ${(f)completions[@]}; do
  if (( ZSHZ_TILDE )) && [[ $completion == ${HOME}* ]]; then
    completion="~${(q)${completion#${HOME}}}"
  else
    completion="${(q)completion}"
  fi
  completion_list+=( $completion )
done

_description -V completion_list expl 'directories'

if [[ $ZSHZ_COMPLETION == 'legacy' ]]; then
  compadd "${expl[@]}" -QU -- "${completion_list[@]}"
else
  compadd "${expl[@]}" -QU -V zsh-z -- "${completion_list[@]}"
fi

compstate[insert]=menu

return 0

# vim: ft=zsh:fdm=indent:ts=2:et:sts=2:sw=2:
