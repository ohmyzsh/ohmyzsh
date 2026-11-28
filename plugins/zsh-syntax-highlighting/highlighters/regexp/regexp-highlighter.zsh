# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2016 zsh-syntax-highlighting contributors
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


# List of keyword and color pairs.
typeset -gA ZSH_HIGHLIGHT_REGEXP

# Whether the pattern highlighter should be called or not.
_zsh_highlight_highlighter_regexp_predicate()
{
  _zsh_highlight_buffer_modified
}

# Pattern syntax highlighting function.
_zsh_highlight_highlighter_regexp_paint()
{
  setopt localoptions extendedglob
  local pattern
  for pattern in ${(k)ZSH_HIGHLIGHT_REGEXP}; do
    _zsh_highlight_regexp_highlighter_loop "$BUFFER" "$pattern"
  done
}

_zsh_highlight_regexp_highlighter_loop()
{
  local buf="$1" pat="$2"
  integer OFFSET=0
  local MATCH; integer MBEGIN MEND
  local -a match mbegin mend
  while true; do
    [[ "$buf" =~ "$pat" ]] || return;
    region_highlight+=("$((MBEGIN - 1 + OFFSET)) $((MEND + OFFSET)) $ZSH_HIGHLIGHT_REGEXP[$pat], memo=zsh-syntax-highlighting")
    buf="$buf[$(($MEND+1)),-1]"
    OFFSET=$((MEND+OFFSET));
  done
}
