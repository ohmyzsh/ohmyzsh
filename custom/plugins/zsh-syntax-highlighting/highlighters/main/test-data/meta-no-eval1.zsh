#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2020 zsh-syntax-highlighting contributors
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

BUFFER=$': $(kill -9 $$) ${:-$(kill -9 $$)}'

expected_region_highlight=(
  '1 1 builtin' # :
  '3 15 default' # $(kill -9 $$)
  '3 15 command-substitution-unquoted' # $(kill -9 $$)
  '3 4 command-substitution-delimiter-unquoted' # $(
  '5 8 builtin' # kill
  '10 11 single-hyphen-option' # -9
  '13 14 default' # $$
  '15 15 command-substitution-delimiter-unquoted' # )
  '17 34 default' # ${:-$(kill -9 $$)}
  '21 33 command-substitution-unquoted' # $(kill -9 $$)
  '21 22 command-substitution-delimiter-unquoted' # $(
  '23 26 builtin' # kill
  '28 29 single-hyphen-option' # -9
  '31 32 default' # $$
  '33 33 command-substitution-delimiter-unquoted' # )
)
