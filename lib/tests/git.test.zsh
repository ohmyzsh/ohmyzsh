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

source "${0:h:h}/git.zsh"

# The mock returns canned `git status --porcelain -b` output and denies stash,
# so the tests need no real git repository.
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

# The bug under test only reproduces in a multibyte locale, so find one. Any
# UTF-8 locale will do; the tests that need it are skipped if none exists.
local utf8_locale="" _candidate
for _candidate in ${(f)"$(locale -a 2>/dev/null)"}; do
  if [[ "${_candidate:l}" == *(utf-8|utf8) ]]; then
    utf8_locale="$_candidate"
    break
  fi
done

# Run _omz_git_prompt_status in a UTF-8 locale, capturing only stderr.
capture_stderr() {
  ( export LC_ALL="$utf8_locale"; _omz_git_prompt_status ) 2>&1 1>/dev/null
}

# ---------------------------------------------------------------------------
# Bug #13330: _omz_git_prompt_status emits "regex matching error: illegal byte
# sequence". zsh's =~ delegates to the C library regex, which aborts with
# REG_ILLSEQ when the subject holds bytes that are invalid in the current
# locale's encoding -- e.g. a GBK-encoded branch name or file path while the
# shell runs in a UTF-8 locale. Forcing LC_ALL=C makes every byte valid.
#
# Note that *valid* UTF-8 (Chinese characters and the like) never triggered
# this; only bytes that don't decode in the active locale do.
# ---------------------------------------------------------------------------

if [[ -z "$utf8_locale" ]]; then
  print -u2 "\e[33mSkipped\e[0m: no UTF-8 locale available for byte-sequence tests\n"
else
  # Branch name in GBK bytes (\xd6\xd0\xce\xc4 is "中文" in GBK), invalid UTF-8
  _mock_status_output=$'## \xd6\xd0\xce\xc4-1.0.0...origin/\xd6\xd0\xce\xc4-1.0.0 [ahead 1]'
  run_test \
    "no 'illegal byte sequence' error for a branch name with non-UTF-8 bytes (bug #13330)" \
    "$(capture_stderr)" \
    ""

  # Same bytes in a file path, which is matched by a different regex
  _mock_status_output=$'## main...origin/main\n M \xd6\xd0\xce\xc4.txt'
  run_test \
    "no 'illegal byte sequence' error for a file path with non-UTF-8 bytes" \
    "$(capture_stderr)" \
    ""

  # The tracking info must still be parsed, not merely fail quietly
  _mock_status_output=$'## \xd6\xd0\xce\xc4-1.0.0...origin/\xd6\xd0\xce\xc4-1.0.0 [ahead 1]'
  ZSH_THEME_GIT_PROMPT_AHEAD=">"
  run_test \
    "'ahead' tracking info still parsed for a branch name with non-UTF-8 bytes" \
    "$( ( export LC_ALL="$utf8_locale"; _omz_git_prompt_status ) 2>/dev/null )" \
    ">"
fi

# Regression: ASCII branch names must still be parsed correctly
_mock_status_output="## main...origin/main [behind 3]"
ZSH_THEME_GIT_PROMPT_BEHIND="<"
run_test \
  "ASCII branch with 'behind' tracking info still detected" \
  "$(_omz_git_prompt_status 2>/dev/null)" \
  "<"

exit $_failures
