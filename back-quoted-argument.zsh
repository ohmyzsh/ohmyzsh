# -------------------------------------------------------------------------------------------------
# Copyright (c) 2015 zsh-syntax-highlighting contributors
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

BUFFER='echo `echo \`42\`` "is `echo equal` to" `echo 6 times 9'

expected_region_highlight=(
  "1 4 builtin" # echo
  "6 18 default" # `echo \`42\``
  "6 18 back-quoted-argument" # `echo \`42\``
  "6 6 back-quoted-argument-delimiter" # `
  "7 10 builtin" # echo
  "12 17 default" # \`42\`
  "12 17 back-quoted-argument" # \`42\`
  "12 13 back-quoted-argument-delimiter" # \`
  "14 15 unknown-token" # 42
  "16 17 back-quoted-argument-delimiter" # \`
  "18 18 back-quoted-argument-delimiter" # `
  "20 39 default" # "is `echo equal` to"
  "20 39 double-quoted-argument" # "is `echo equal` to"
  "24 35 back-quoted-argument" # `echo equal`
  "24 24 back-quoted-argument-delimiter" # `
  "25 28 builtin" # echo
  "30 34 default" # equal
  "35 35 back-quoted-argument-delimiter" # `
  "41 55 default" # `echo 6 times 9
  "41 55 back-quoted-argument-unclosed" # `echo 6 times 9
  "41 41 back-quoted-argument-delimiter" # `
  "42 45 builtin" # echo
  "47 47 default" # 6
  "49 53 default" # times
  "55 55 default" # 9
)
