#!/usr/bin/zsh -df

# Tests for the git pending branch name (stale/unbolded) feature

local -i failures=0
local ZSH=${0:A:h:h:h}

run_test() {
  local description="$1"
  local actual="$2"
  local expected="$3"

  print -u2 "Test: $description"

  if [[ "$actual" == "$expected" ]]; then
    print -u2 "\e[32mSuccess\e[0m"
  else
    print -u2 "\e[31mError\e[0m: output does not match expected"
    print -u2 "  expected: ${(q+)expected}"
    print -u2 "  actual:   ${(q+)actual}"
    (( failures++ ))
  fi
  print -u2 ""
}

# Reset theme variables to a known state between tests
reset_theme_vars() {
  unset ZSH_THEME_GIT_PROMPT_PREFIX ZSH_THEME_GIT_PROMPT_SUFFIX
  unset ZSH_THEME_GIT_PROMPT_DIRTY ZSH_THEME_GIT_PROMPT_CLEAN
  unset ZSH_THEME_GIT_PROMPT_STALE_PREFIX ZSH_THEME_GIT_PROMPT_STALE_SUFFIX
  unset ZSH_THEME_GIT_SHOW_UPSTREAM
  unset _OMZ_ASYNC_OUTPUT _OMZ_ASYNC_PENDING
  # Force async-prompt mode so we test the _omz_render_git_prompt_info path
  zstyle ':omz:alpha:lib:git' async-prompt yes
}

() {
  local description="git_prompt_info - when pending=1 with bold prefix - then ref is wrapped with stale styling"
  reset_theme_vars
  autoload -Uz is-at-least

  ZSH_THEME_GIT_PROMPT_PREFIX="%B("
  ZSH_THEME_GIT_PROMPT_SUFFIX=")%b"
  unset ZSH_THEME_GIT_PROMPT_STALE_PREFIX
  unset ZSH_THEME_GIT_PROMPT_STALE_SUFFIX

  source "$ZSH/lib/git.zsh"

  typeset -gA _OMZ_ASYNC_OUTPUT _OMZ_ASYNC_PENDING

  # Async output format: ref + Unit Separator (U+001F) + dirty
  _OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]="main"$'\x1f'" *"
  _OMZ_ASYNC_PENDING[_omz_git_prompt_info]=1

  local actual
  actual=$(git_prompt_info)

  local stale_prefix=$'%{\e[22m%}'
  local stale_suffix=$'%{\e[1m%}'
  local expected="%B(${stale_prefix}main *${stale_suffix})%b"

  run_test "$description" "$actual" "$expected"
}

() {
  local description="git_prompt_info - when pending=1 with non-bold prefix - then no stale styling is applied"
  reset_theme_vars
  autoload -Uz is-at-least

  ZSH_THEME_GIT_PROMPT_PREFIX="("
  ZSH_THEME_GIT_PROMPT_SUFFIX=")"
  unset ZSH_THEME_GIT_PROMPT_STALE_PREFIX
  unset ZSH_THEME_GIT_PROMPT_STALE_SUFFIX

  source "$ZSH/lib/git.zsh"

  typeset -gA _OMZ_ASYNC_OUTPUT _OMZ_ASYNC_PENDING

  # Async output format: ref + Unit Separator (U+001F) + dirty
  _OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]="main"$'\x1f'" *"
  _OMZ_ASYNC_PENDING[_omz_git_prompt_info]=1

  local actual
  actual=$(git_prompt_info)

  run_test "$description" "$actual" "(main *)"
}

() {
  local description="git_prompt_info - when pending=0 - then formatted output is returned as-is"
  reset_theme_vars
  autoload -Uz is-at-least

  ZSH_THEME_GIT_PROMPT_PREFIX="%B("
  ZSH_THEME_GIT_PROMPT_SUFFIX=")%b"
  unset ZSH_THEME_GIT_PROMPT_STALE_PREFIX
  unset ZSH_THEME_GIT_PROMPT_STALE_SUFFIX

  source "$ZSH/lib/git.zsh"

  typeset -gA _OMZ_ASYNC_OUTPUT _OMZ_ASYNC_PENDING

  # Async output format: ref + Unit Separator (U+001F) + dirty
  _OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]="main"$'\x1f'" *"
  _OMZ_ASYNC_PENDING[_omz_git_prompt_info]=0

  local actual
  actual=$(git_prompt_info)

  run_test "$description" "$actual" "%B(main *)%b"
}

() 
  local description="git_prompt_info - when pending=1 with custom stale vars - then ref uses custom stale prefix/suffix"{
  reset_theme_vars
  autoload -Uz is-at-least

  ZSH_THEME_GIT_PROMPT_PREFIX="("
  ZSH_THEME_GIT_PROMPT_SUFFIX=")"
  ZSH_THEME_GIT_PROMPT_STALE_PREFIX="%{dim%}"
  ZSH_THEME_GIT_PROMPT_STALE_SUFFIX="%{/dim%}"

  source "$ZSH/lib/git.zsh"

  typeset -gA _OMZ_ASYNC_OUTPUT _OMZ_ASYNC_PENDING

  # Async output format: ref + Unit Separator (U+001F) + dirty (empty dirty here)
  _OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]="develop"$'\x1f'
  _OMZ_ASYNC_PENDING[_omz_git_prompt_info]=1

  local actual
  actual=$(git_prompt_info)
  local expected="(%{dim%}develop%{/dim%})"

  run_test "$description" "$actual" "$expected"
}

() {
  local description="git_prompt_info - when old single-line format (no ref line) - then output is passed through as-is"
  reset_theme_vars
  autoload -Uz is-at-least

  ZSH_THEME_GIT_PROMPT_PREFIX="%B("
  ZSH_THEME_GIT_PROMPT_SUFFIX=")%b"

  source "$ZSH/lib/git.zsh"

  typeset -gA _OMZ_ASYNC_OUTPUT _OMZ_ASYNC_PENDING

  # Simulate old-format output with no newline (single line, no ref header)
  _OMZ_ASYNC_OUTPUT[_omz_git_prompt_info]="%B(main *)%b"
  _OMZ_ASYNC_PENDING[_omz_git_prompt_info]=0

  local actual
  actual=$(git_prompt_info)

  run_test "$description" "$actual" "%B(main *)%b"
}

# Summary
if (( failures > 0 )); then
  print -u2 "\e[31m${failures} test(s) failed\e[0m"
  return 1
else
  print -u2 "\e[32mAll tests passed\e[0m"
  return 0
fi
