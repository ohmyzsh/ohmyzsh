#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2019 zsh-syntax-highlighting contributors
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

# Test an external command that does not exist as a builtin.
# The spaces in $BUFFER are to align precommand-type*.zsh test files.
BUFFER=$'ls    ; builtin ls    ; builtin command ls    ; nice ls    '

# Verify that the 'ls' command isn't shadowed.
if [[ $(type -w ls) != "ls: command" ]]; then
  echo >&2 "precommand-type3: error: the 'ls' command is shadowed (or possibly missing altogether)"
fi

expected_region_highlight=(
  '1 2 command' # ls
  '7 7 commandseparator' # ;

  '9 15 precommand' # builtin
  '17 18 unknown-token "issue #608"' # ls
  '23 23 commandseparator' # ;

  '25 31 precommand' # builtin
  '33 39 precommand' # command
  '41 42 command' # ls
  '47 47 commandseparator' # ;

  '49 52 precommand' # nice
  '54 55 command' # ls
)
