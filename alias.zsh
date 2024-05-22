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

alias alias1="ls"
alias -s alias2="echo"
function alias1() {} # to check that it's highlighted as an alias, not as a function

BUFFER='x.alias2; alias1; alias2'

# Set expected_region_highlight as a function of zsh version.
#
# Highlight of suffix alias requires zsh-5.1.1 or newer; see issue #126,
# and commit 36403 to zsh itself.  Therefore, check if the requisite zsh
# functionality is present, and skip verifying suffix-alias highlighting
# if it isn't.
expected_region_highlight=()
if zmodload -e zsh/parameter || [[ "$(type -w x.alias2)" == *suffix* ]]; then
  expected_region_highlight+=(
    "1 8 suffix-alias" # x.alias2
  )
fi
expected_region_highlight+=(
  "9 9 commandseparator" # ;
  "11 16 alias" # alias1
  "17 17 commandseparator" # ;
  "19 24 unknown-token" # alias2
)
