#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2011 zsh-syntax-highlighting contributors
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


# Check an highlighter was given as argument.
[[ -n "$1" ]] || {
  echo "You must provide the name of a valid highlighter as argument." >&2
  exit 1
}

# Check the highlighter is valid.
[[ -f ${0:h:h}/highlighters/$1/$1-highlighter.zsh ]] || {
  echo "Could not find highlighter '$1'." >&2
  exit 1
}

# Check the highlighter has test data.
[[ -d ${0:h:h}/highlighters/$1/test-data ]] || {
  echo "Highlighter '$1' has no test data." >&2
  exit 1
}

local -a errors highlight_zone
local -A observed_result

# Load the main script.
. ${0:h:h}/zsh-syntax-highlighting.zsh

# Activate the highlighter.
ZSH_HIGHLIGHT_HIGHLIGHTERS=($1)

# Process each test data file in test data directory.
for data_file in ${0:h:h}/highlighters/$1/test-data/*; do

  # Load the data and prepare checking it.
  BUFFER= ; expected_region_highlight=(); errors=()
  echo -n "* ${data_file:t:r}: "
  . $data_file

  # Check the data declares $BUFFER.
  if [[ ${#BUFFER} -eq 0 ]]; then
    errors+=("'BUFFER' is not declared or blank.")
  else

    # Check the data declares $expected_region_highlight.
    if [[ ${#expected_region_highlight} -eq 0 ]]; then
      errors+=("'expected_region_highlight' is not declared or empty.")
    else

      # Process the data.
      region_highlight=()
      _zsh_highlight

      # Overlapping regions can be declared in region_highlight, so we first build an array of the
      # observed highlighting.
      observed_result=()
      for i in {1..${#region_highlight}}; do
        highlight_zone=${(z)region_highlight[$i]}
        for j in {$highlight_zone[1]..$highlight_zone[2]}; do
          observed_result[$j]=$highlight_zone[3]
        done
      done

      # Then we compare the observed result with the expected one.
      for i in {1..${#expected_region_highlight}}; do
        highlight_zone=${(z)expected_region_highlight[$i]}
        for j in {$highlight_zone[1]..$highlight_zone[2]}; do
          if [[ "$observed_result[$j]" != "$highlight_zone[3]" ]]; then
            errors+=("'$BUFFER[$highlight_zone[1],$highlight_zone[2]]' [$highlight_zone[1],$highlight_zone[2]]: expected '$highlight_zone[3]', observed '$observed_result[$j]'.")
            break
          fi
        done
      done

    fi
  fi

  # Format result/errors.
  if [[ ${#errors} -eq 0 ]]; then
    echo "OK"
  else
    echo "KO"
    for error in $errors; do
      echo "   - $error"
    done
  fi

done
