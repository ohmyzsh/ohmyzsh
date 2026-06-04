#!/usr/bin/zsh -df

# Regression tests for lib/git.zsh

local -i _failures=0

run_test() {
  local description="$1"
  local got="$2"
  local expected="$3"

  print -u2 "Test: $description"
  if [[ "$got" == "$expected" ]]; then
    print -u2 "\e[32mSuccess\e[0m"
  else
    print -u2 "\e[31mError\e[0m"
    print -u2 "  expected: ${(q)expected}"
    print -u2 "  got:      ${(q)got}"
    (( _failures++ ))
  fi
  print -u2 ""
}

# ---------------------------------------------------------------------------
# Set up: source git.zsh and override __git_prompt_git with a controllable mock
# ---------------------------------------------------------------------------

source "${0:h:h}/git.zsh" 2>/dev/null

# The mock returns canned `git status --porcelain -b` output and denies stash.
# Callers set _mock_status_output before calling _omz_git_prompt_status.
_mock_status_output=""
function __git_prompt_git() {
  case "$*" in
    "config --get oh-my-zsh.hide-status") return 1 ;;
    "rev-parse --verify refs/stash")       return 1 ;;
    "status --porcelain -b")               printf "%s\n" "$_mock_status_output" ;;
    *)                                     return 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# Bug #13330: _omz_git_prompt_status emits "regex matching error: illegal byte
# sequence" when the git branch name contains non-ASCII characters (e.g. Chinese).
# Root cause: zsh's =~ operator with [^ ]+ is locale-aware and rejects multibyte
# sequences unless LC_ALL=C is set for the match.
# ---------------------------------------------------------------------------

# Chinese branch with upstream tracking info
_mock_status_output="## 中文-1.0.0-中文...origin/中文-1.0.0-中文 [ahead 1]"
stderr_output=$( { _omz_git_prompt_status } 2>&1 1>/dev/null )
run_test \
  "no 'illegal byte sequence' error with Chinese branch name (bug #13330)" \
  "${stderr_output}" \
  ""

# Chinese branch with no tracking info (the regex should simply not match)
_mock_status_output="## 中文-branch"
stderr_output=$( { _omz_git_prompt_status } 2>&1 1>/dev/null )
run_test \
  "no error when Chinese branch has no tracking info" \
  "${stderr_output}" \
  ""

# Regression: ASCII branch names must still be parsed correctly
_mock_status_output="## main...origin/main [behind 3]"
ZSH_THEME_GIT_PROMPT_BEHIND="<"
output=$( _omz_git_prompt_status 2>/dev/null )
run_test \
  "ASCII branch with 'behind' tracking info still detected" \
  "${output}" \
  "<"

exit $_failures
