#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2015 zsh-syntax-highlighting contributors
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
  echo >&2 "Bail out! You must provide the name of a valid highlighter as argument."
  exit 2
}

# Check the highlighter is valid.
[[ -f ${0:h:h}/highlighters/$1/$1-highlighter.zsh ]] || {
  echo >&2 "Bail out! Could not find highlighter ${(qq)1}."
  exit 2
}

# Check the highlighter has test data.
[[ -d ${0:h:h}/highlighters/$1/test-data ]] || {
  echo >&2 "Bail out! Highlighter ${(qq)1} has no test data."
  exit 2
}

# Load the main script.
. ${0:h:h}/zsh-syntax-highlighting.zsh

# Activate the highlighter.
ZSH_HIGHLIGHT_HIGHLIGHTERS=($1)

# Runs a highlighting test
# $1: data file
run_test_internal() {
  local -a highlight_zone
  local unused_highlight='bg=red,underline' # a style unused by anything else, for tests to use

  local tests_tempdir="$1"; shift
  local srcdir="$PWD"
  builtin cd -q -- "$tests_tempdir" || { echo >&2 "Bail out! cd failed: $?"; return 1 }

  echo "# ${1:t:r}"

  # Load the data and prepare checking it.
  PREBUFFER= BUFFER= ;
  . "$srcdir"/"$1"

  # Check the data declares $PREBUFFER or $BUFFER.
  [[ -z $PREBUFFER && -z $BUFFER ]] && { echo >&2 "Bail out! Either 'PREBUFFER' or 'BUFFER' must be declared and non-blank"; return 1; }
  # Check the data declares $expected_region_highlight.
  (( ${#expected_region_highlight} == 0 )) && { echo >&2 "Bail out! 'expected_region_highlight' is not declared or empty."; return 1; }

  # Process the data.
  region_highlight=()
  _zsh_highlight

  # Overlapping regions can be declared in region_highlight, so we first build an array of the
  # observed highlighting.
  local -A observed_result
  for ((i=1; i<=${#region_highlight}; i++)); do
    highlight_zone=${(z)region_highlight[$i]}
    integer start=$highlight_zone[1] end=$highlight_zone[2]
    if (( start < end )) # region_highlight ranges are half-open
    then
      (( --end )) # convert to closed range, like expected_region_highlight
      (( ++start, ++end )) # region_highlight is 0-indexed; expected_region_highlight is 1-indexed
      for j in {$start..$end}; do
        observed_result[$j]=$highlight_zone[3]
      done
    else
      # noop range; ignore.
    fi
  done

  # Then we compare the observed result with the expected one.
  echo "1..${#expected_region_highlight}"
  for ((i=1; i<=${#expected_region_highlight}; i++)); do
    local todo=
    highlight_zone=${(z)expected_region_highlight[$i]}
    [[ -n "$highlight_zone[4]" ]] && todo=" # TODO $highlight_zone[4]"
    for j in {$highlight_zone[1]..$highlight_zone[2]}; do
      if [[ "$observed_result[$j]" != "$highlight_zone[3]" ]]; then
        echo "not ok $i ${(qqq)BUFFER[$highlight_zone[1],$highlight_zone[2]]} [$highlight_zone[1],$highlight_zone[2]]: expected ${(qqq)highlight_zone[3]}, observed ${(qqq)observed_result[$j]}.$todo"
        continue 2
      fi
    done
    echo "ok $i$todo"
  done
}

# Run a single test file.  The exit status is 1 if the test harness had
# an error and 0 otherwise.  The exit status does not depend on whether
# test points succeeded or failed.
run_test() {
  # Do not combine the declaration and initialization: «local x="$(false)"» does not set $?.
  local __tests_tempdir
  __tests_tempdir="$(mktemp -d)" && [[ -d $__tests_tempdir ]] || {
    echo >&2 "Bail out! mktemp failed"; return 1
  }
  typeset -r __tests_tempdir # don't allow tests to override the variable that we will 'rm -rf' later on

  {
    # Use a subshell to isolate tests from each other.
    # (So tests can alter global shell state using 'cd', 'hash', etc)
    (run_test_internal "$__tests_tempdir" "$@")
  } always {
    rm -rf -- "$__tests_tempdir"
  }
}

# Set up results_filter
local results_filter
if [[ $QUIET == y ]]; then
  if type -w perl >/dev/null; then
    results_filter=${0:A:h}/tap-filter
  else
    echo >&2 "Bail out! quiet mode not supported: perl not found"; exit 2
  fi
else
  results_filter=cat
fi
[[ -n $results_filter ]] || { echo >&2 "Bail out! BUG setting \$results_filter"; exit 2 }

# Process each test data file in test data directory.
integer something_failed=0
for data_file in ${0:h:h}/highlighters/$1/test-data/*.zsh; do
  run_test "$data_file" | tee >($results_filter | ${0:A:h}/tap-colorizer.zsh) | grep -v '^not ok.*# TODO' | grep -q '^not ok\|^ok.*# TODO' && (( something_failed=1 ))
  (( $pipestatus[1] )) && exit 2
done

exit $something_failed
