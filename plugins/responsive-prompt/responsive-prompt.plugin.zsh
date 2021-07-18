#!/usr/env/bin zsh
# Make your Terminal Prompt responsive :)
#
# Author: Nikhil Gupta <me@nikhgupta.com>
# Version: 0.0.1
#
# Please, read the README.md
#
[[ -n "${PROMPT_FILE}" ]]          || PROMPT_FILE="${HOME}/.zshrc"
[[ -n "${PROMPT_BREAKPOINTS}" ]]   || PROMPT_BREAKPOINTS=(120 90 60 0)
[[ -n "${PROMPT_NEWLINE_AFTER}" ]] || PROMPT_NEWLINE_AFTER=40


# Calculate length of the prompt being rendered. Additionally, set
# a variable that adds a newline character when prompt length exceeds
# $PROMPT_NEWLINE_AFTER
_calculate_prompt_length() {
  local prompt_exp="${(%%)PROMPT}"
  local prompt_stripped="$(echo $prompt_exp | sed -r 's/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g')"
  local prompt_length="${#prompt_stripped}"

  unset prompt_newline
  if [[ $prompt_length -gt $PROMPT_NEWLINE_AFTER ]]; then
    prompt_newline=$'\n'
  else
    prompt_newline=$''
  fi
}

# Look for change in $COLUMNS, and loop through all breakpoints to setup
# the appropriate prompt for the new column size.
_responsive_prompt(){
  _calculate_prompt_length
  [[ $COLUMNS -eq $last_columns ]] && return
  for breakpoint in $PROMPT_BREAKPOINTS; do
    [[ $COLUMNS -lt $breakpoint ]] && continue
    if which "_prompt_$breakpoint" &>/dev/null; then
      eval "_prompt_$breakpoint"
      break
    else
      source $PROMPT_FILE
    fi
  done
  _calculate_prompt_length
  last_columns=$COLUMNS
}

# this function should run when prompt is about to be rendered.
precmd_functions+=( _responsive_prompt )
