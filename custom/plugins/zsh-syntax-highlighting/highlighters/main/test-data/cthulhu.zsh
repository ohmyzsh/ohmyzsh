#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2018 zsh-syntax-highlighting contributors
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

#        0000000 0 01111111111222222 222233333 3 333344 4 4 444444555555555 5 6 6666 6 6 6667777777777888 8 8 88888999 9 9999 9 9 00 00 0000001111
#        1234567 8 90123456789012345 678901234 5 678901 2 3 456789012345678 9 0 1234 5 6 7890123456789012 3 4 56789012 3 4567 8 9 01 23 4567890123
BUFFER=$'echo Ph\\\'ng`echo lui "mg"\\`echo lw\\\'nafh \\\\\\`echo Cthu"lhu\\\\\\` R\\\\\'ly$(echo eh wag\\\\\\`echo h\\\'nag\\\\\\`\'l\' fht)agn`'

expected_region_highlight=(
  '1 4 builtin' # echo
  '6 113 default' # Ph\'ng`echo lui "mg"\`echo lw\'nafh \\\`echo Cthu"lhu\\\` R\\'ly$(echo eh wag\\\`echo h\'nag\\\`'l' fht)agn`
  '12 113 back-quoted-argument' # `echo lui "mg"\`echo lw\'nafh \\\`echo Cthu"lhu\\\` R\\'ly$(echo eh wag\\\`echo h\'nag\\\`'l' fht)agn`
  '12 12 back-quoted-argument-delimiter' # `
  '13 16 builtin' # echo
  '18 20 default' # lui
  '22 112 default' # "mg"\`echo lw\'nafh \\\`echo Cthu"lhu\\\` R\\'ly$(echo eh wag\\\`echo h\'nag\\\`'l' fht)agn
  '22 25 double-quoted-argument' # "mg"
  '26 112 back-quoted-argument-unclosed' # \`echo lw\'nafh \\\`echo Cthu"lhu\\\` R\\'ly$(echo eh wag\\\`echo h\'nag\\\`'l' fht)agn
  '26 27 back-quoted-argument-delimiter' # \`
  '28 31 builtin' # echo
  '33 40 default' # lw\'nafh
  '42 62 default' # \\\`echo Cthu"lhu\\\`
  '42 62 back-quoted-argument' # \\\`echo Cthu"lhu\\\`
  '42 45 back-quoted-argument-delimiter' # \\\`
  '46 49 builtin' # echo
  '51 58 default' # Cthu"lhu
  '55 58 double-quoted-argument-unclosed' # "lhu
  '59 62 back-quoted-argument-delimiter' # \\\`
  '64 112 default' # R\\'ly$(echo eh wag\\\`echo h\'nag\\\`'l' fht)agn
  '70 109 command-substitution-unquoted' # $(echo eh wag\\\`echo h\'nag\\\`'l' fht)
  '70 71 command-substitution-delimiter-unquoted' # $(
  '72 75 builtin' # echo
  '77 78 default' # eh
  '80 104 default' # wag\\\`echo h\'nag\\\`'l'
  '83 101 back-quoted-argument' # \\\`echo h\'nag\\\`
  '83 86 back-quoted-argument-delimiter' # \\\`
  '87 90 builtin' # echo
  '92 97 default' # h\'nag
  '98 101 back-quoted-argument-delimiter' # \\\`
  '102 104 single-quoted-argument' # 'l'
  '106 108 default' # fht
  '109 109 command-substitution-delimiter-unquoted' # )
  '113 113 unknown-token' # `
)
