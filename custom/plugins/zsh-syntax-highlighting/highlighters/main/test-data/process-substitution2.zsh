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

BUFFER='echo =(:) a=(:) =(echo foo'

expected_region_highlight=(
  '1 4 builtin' # echo
  '6 9 default' # =(:)
  '6 9 process-substitution' # =(:)
  '6 7 process-substitution-delimiter' # =(
  '8 8 builtin' # :
  '9 9 process-substitution-delimiter' # )
  '11 15 default' # a=(:)
  '17 26 default' # =(echo foo
  '17 26 process-substitution' # =(echo foo
  '17 18 process-substitution-delimiter' # =(
  '19 22 builtin' # echo
  '24 26 default' # foo
)

if [[ ${(z):-'$('} == '$( ' ]]; then # ignore zsh 5.0.8 bug
  expected_region_highlight[8]='17 27 default' # =(echo foo
  expected_region_highlight[9]='17 27 process-substitution' # =(echo foo
fi
