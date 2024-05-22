#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2017 zsh-syntax-highlighting contributors
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


setopt NO_UNSET WARN_CREATE_GLOBAL

# Required for add-zle-hook-widget.
zmodload zsh/zle

local -r root=${0:h:h}
local -a anon_argv; anon_argv=("$@")

(){
set -- "${(@)anon_argv}"
# Check an highlighter was given as argument.
[[ -n "$1" ]] || {
  echo >&2 "Bail out! You must provide the name of a valid highlighter as argument."
  exit 2
}

# Check the highlighter is valid.
[[ -f $root/highlighters/$1/$1-highlighter.zsh ]] || {
  echo >&2 "Bail out! Could not find highlighter ${(qq)1}."
  exit 2
}

# Check the highlighter has test data.
[[ -d $root/highlighters/$1/test-data ]] || {
  echo >&2 "Bail out! Highlighter ${(qq)1} has no test data."
  exit 2
}

# Set up results_filter
local results_filter
if [[ ${QUIET-} == y ]]; then
  if type -w perl >/dev/null; then
    results_filter=$root/tests/tap-filter
  else
    echo >&2 "Bail out! quiet mode not supported: perl not found"; exit 2
  fi
else
  results_filter=cat
fi
[[ -n $results_filter ]] || { echo >&2 "Bail out! BUG setting \$results_filter"; exit 2 }

# Load the main script.
# While here, test that it doesn't eat aliases.
print > >($results_filter | $root/tests/tap-colorizer.zsh) -r -- "# global (driver) tests"
print > >($results_filter | $root/tests/tap-colorizer.zsh) -r -- "1..1"
alias -- +plus=plus
alias -- _other=other
local original_alias_dash_L_output="$(alias -L)"
. $root/zsh-syntax-highlighting.zsh
if [[ $original_alias_dash_L_output == $(alias -L) ]]; then
  print -r -- "ok 1 # 'alias -- +foo=bar' is preserved"
else
  print -r -- "not ok 1 # 'alias -- +foo=bar' is preserved"
  exit 1
fi > >($results_filter | $root/tests/tap-colorizer.zsh)

# Overwrite _zsh_highlight_add_highlight so we get the key itself instead of the style
_zsh_highlight_add_highlight()
{
  region_highlight+=("$1 $2 $3")
}

# Activate the highlighter.
ZSH_HIGHLIGHT_HIGHLIGHTERS=($1)

# In zsh<5.3, 'typeset -p arrayvar' emits two lines, so we use this wrapper instead.
typeset_p() {
  for 1 ; do
    if [[ ${(tP)1} == *array* ]]; then
      print -r -- "$1=( ${(@qqqqP)1} )"
    else
      print -r -- "$1=${(qqqqP)1}"
    fi
  done
}

# Escape # as ♯ and newline as ↵ they are illegal in the 'description' part of TAP output
# The string to escape is «"$@"»; the result is returned in $REPLY.
tap_escape() {
  local s="${(j. .)@}"
  REPLY="${${s//'#'/♯}//$'\n'/↵}"
}

# Runs a highlighting test
# $1: data file
run_test_internal() {

  local tests_tempdir="$1"; shift
  local srcdir="$PWD"
  builtin cd -q -- "$tests_tempdir" || { echo >&2 "Bail out! On ${(qq)1}: cd failed: $?"; return 1 }

  # Load the data and prepare checking it.
  local BUFFER CURSOR MARK PENDING PREBUFFER REGION_ACTIVE WIDGET REPLY skip_test fail_test unsorted=0
  local expected_mismatch
  local skip_mismatch
  local -a expected_region_highlight region_highlight

  local ARG="$1"
  local RETURN=""
  () {
    setopt localoptions

    # WARNING: The remainder of this anonymous function will run with the test's options in effect
    if { ! . "$srcdir"/"$ARG" } || (( $#fail_test )); then
      print -r -- "1..1"
      print -r -- "## ${ARG:t:r}"
      tap_escape $fail_test; fail_test=$REPLY
      print -r -- "not ok 1 - failed setup: $fail_test"
      return ${RETURN:=0}
    fi

    (( $#skip_test )) && {
      print -r -- "1..0 # SKIP $skip_test"
      print -r -- "## ${ARG:t:r}"
      return ${RETURN:=0}
    }

    # Check the data declares $PREBUFFER or $BUFFER.
    [[ -z $PREBUFFER && -z $BUFFER ]] && { echo >&2 "Bail out! On ${(qq)ARG}: Either 'PREBUFFER' or 'BUFFER' must be declared and non-blank"; return ${RETURN:=1}; }
    [[ $PREBUFFER == (''|*$'\n') ]] || { echo >&2 "Bail out! On ${(qq)ARG}: PREBUFFER=${(qqqq)PREBUFFER} doesn't end with a newline"; return ${RETURN:=1}; }

    # Set sane defaults for ZLE variables
    : ${CURSOR=$#BUFFER} ${PENDING=0} ${WIDGET=z-sy-h-test-harness-test-widget}

    # Process the data.
    _zsh_highlight
  }; [[ -z $RETURN ]] || return $RETURN
  unset ARG

  integer print_expected_and_actual=0

  if (( unsorted )); then
    region_highlight=("${(@n)region_highlight}")
    expected_region_highlight=("${(@n)expected_region_highlight}")
  fi

  # Print the plan line, and some comments for human readers
  echo "1..$(( $#expected_region_highlight + 1))"
  echo "## ${1:t:r}" # note: tests/edit-failed-tests looks for the "##" emitted by this line
  [[ -n $PREBUFFER ]] && printf '# %s\n' "$(typeset_p PREBUFFER)"
  [[ -n $BUFFER ]] && printf '# %s\n' "$(typeset_p BUFFER)"

  local i
  for ((i=1; i<=$#expected_region_highlight; i++)); do
    local -a expected_highlight_zone; expected_highlight_zone=( ${(z)expected_region_highlight[i]} )
    integer exp_start=$expected_highlight_zone[1] exp_end=$expected_highlight_zone[2]
    local todo=
    if (( $+expected_highlight_zone[4] )); then
      todo="# TODO $expected_highlight_zone[4]"
      skip_mismatch="cardinality check disabled whilst regular test points are expected to fail"
    fi
    if ! (( $+region_highlight[i] )); then
      print -r -- "not ok $i - unmatched expectation ($exp_start $exp_end $expected_highlight_zone[3])" \
         "${skip_mismatch:+"# TODO ${(qqq)skip_mismatch}"}"
      if [[ -z $skip_mismatch ]]; then (( ++print_expected_and_actual )); fi
      continue
    fi
    local -a highlight_zone; highlight_zone=( ${(z)region_highlight[i]} )
    integer start=$(( highlight_zone[1] + 1 )) end=$highlight_zone[2]
    local desc="[$start,$end] «${BUFFER[$start,$end]}»"
    tap_escape $desc; desc=$REPLY
    if
      [[ $start != $exp_start ]] ||
      [[ $end != $exp_end ]] ||
      [[ ${highlight_zone[3]%,} != ${expected_highlight_zone[3]} ]] # remove the comma that's before the memo field
    then
      print -r -- "not ok $i - $desc - expected ($exp_start $exp_end ${(qqq)expected_highlight_zone[3]}), observed ($start $end ${(qqq)highlight_zone[3]}). $todo"
      if [[ -z $todo ]]; then (( ++print_expected_and_actual )); fi
    else
      print -r -- "ok $i - $desc${todo:+ - }$todo"
    fi
    unset expected_highlight_zone
    unset exp_start exp_end
    unset todo
    unset highlight_zone
    unset start end
    unset desc
  done

  # If both $skip_mismatch and $expected_mismatch are set, that means the test
  # has some XFail test points, _and_ explicitly sets $expected_mismatch as
  # well.  Explicit settings should have priority, so we ignore $skip_mismatch
  # if $expected_mismatch is set.
  if [[ -n $skip_mismatch && -z $expected_mismatch ]]; then
    tap_escape $skip_mismatch; skip_mismatch=$REPLY
    print "ok $i - cardinality check" "# SKIP $skip_mismatch"
  else
    local todo
    if [[ -n $expected_mismatch ]]; then
      tap_escape $expected_mismatch; expected_mismatch=$REPLY
      todo="# TODO $expected_mismatch"
    fi
    if (( $#expected_region_highlight == $#region_highlight )); then
      print -r -- "ok $i - cardinality check${todo:+ - }$todo"
    else
      local details
      details+="have $#expected_region_highlight expectations and $#region_highlight region_highlight entries: "
      details+="«$(typeset_p expected_region_highlight)» «$(typeset_p region_highlight)»"
      tap_escape $details; details=$REPLY
      print -r -- "not ok $i - cardinality check - $details${todo:+ - }$todo"
      if [[ -z $todo ]]; then (( ++print_expected_and_actual )); fi
    fi
  fi
  if (( print_expected_and_actual )); then
      () {
        local -a left_column right_column
        left_column=( "expected_region_highlight" "${(qq)expected_region_highlight[@]}" )
        right_column=( "region_highlight" "${(qq)region_highlight[@]}" )
        integer difference=$(( $#right_column - $#left_column ))
        repeat $difference do left_column+=(.); done
        paste \
          =(print -rC1 -- $left_column) \
          =(print -rC1 -- $right_column) \
          | if type column >/dev/null; then column -t -s $'\t'; else cat; fi \
          | sed 's/^/# /'
      }
  fi
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
    {
      # These braces are so multios don't come into play.
      { (run_test_internal "$__tests_tempdir" "$@") 3>&1 >&2 2>&3 } | grep \^
      local ret=$pipestatus[1] stderr=$pipestatus[2]
      if (( ! stderr )); then
        # stdout will become stderr
        echo "Bail out! On ${(qq)1}: output on stderr"; return 1
      else
        return $ret
      fi
    } 3>&1 >&2 2>&3
  } always {
    rm -rf -- "$__tests_tempdir"
  }
}

# Process each test data file in test data directory.
integer something_failed=0
ZSH_HIGHLIGHT_STYLES=()
local data_file
for data_file in $root/highlighters/$1/test-data/*.zsh; do
  run_test "$data_file" | tee >($results_filter | $root/tests/tap-colorizer.zsh) | grep -v '^not ok.*# TODO' | grep -Eq '^not ok|^ok.*# TODO' && (( something_failed=1 ))
  (( $pipestatus[1] )) && exit 2
done

exit $something_failed
}
