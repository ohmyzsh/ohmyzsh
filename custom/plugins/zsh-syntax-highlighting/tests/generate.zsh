#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2016 zsh-syntax-highlighting contributors
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

emulate -LR zsh
setopt localoptions extendedglob

# Argument parsing.
if (( $# != 3 )) || [[ $1 == -* ]]; then
  print -r -- >&2 "$0: usage: $0 BUFFER HIGHLIGHTER BASENAME"
  print -r -- >&2 ""
  print -r -- >&2 "Generate highlighters/HIGHLIGHTER/test-data/BASENAME.zsh based on the"
  print -r -- >&2 "current highlighting of BUFFER."
  exit 1
fi
buffer=$1
ZSH_HIGHLIGHT_HIGHLIGHTERS=( $2 )
fname=${0:A:h:h}/highlighters/$2/test-data/${3%.zsh}.zsh

# Load the main script.
. ${0:A:h:h}/zsh-syntax-highlighting.zsh

# Overwrite _zsh_highlight_add_highlight so we get the key itself instead of the style
_zsh_highlight_add_highlight()
{
  region_highlight+=("$1 $2 $3")
}


# Copyright block
year="`LC_ALL=C date +%Y`"
if ! read -q "?Set copyright year to $year? "; then
  year="YYYY"
fi
exec >$fname
<$0 sed -n -e '1,/^$/p' | sed -e "s/2[0-9][0-9][0-9]/${year}/"
# Assumes stdout is line-buffered
git add -- $fname

# Buffer
print -n 'BUFFER='
if [[ $buffer != (#s)[$'\t -~']#(#e) ]]; then
  print -r -- ${(qqqq)buffer}
else
  print -r -- ${(qq)buffer}
fi
echo ""

# Expectations
print 'expected_region_highlight=('
() {
  local i
  local PREBUFFER
  local BUFFER
  
  PREBUFFER=""
  BUFFER="$buffer"
  region_highlight=()
  # TODO: use run_test() from tests/test-highlighting.zsh (to get a tempdir)
  _zsh_highlight

  for ((i=1; i<=${#region_highlight}; i++)); do
    local -a highlight_zone; highlight_zone=( ${(z)region_highlight[$i]} )
    integer start=$highlight_zone[1] end=$highlight_zone[2]
    if (( start < end )) # region_highlight ranges are half-open
    then
      (( --end )) # convert to closed range, like expected_region_highlight
      (( ++start, ++end )) # region_highlight is 0-indexed; expected_region_highlight is 1-indexed
    fi
    printf "  %s # %s\n" ${(qq):-"$start $end $highlight_zone[3]"} ${${(qqqq)BUFFER[start,end]}[3,-2]}
  done
}
print ')'
