#!/usr/bin/env zsh

# Run with: zsh -df lib/tests/git-unmerged.test.zsh
emulate -LR zsh

zstyle ':omz:alpha:lib:git' async-prompt false
source "${1:-${0:A:h:h}/git.zsh}"
ZSH_THEME_GIT_PROMPT_UNMERGED='CONFLICT'

# Keep user configuration from changing the fixture's status output.
export GIT_CONFIG_NOSYSTEM=1 GIT_CONFIG_GLOBAL=/dev/null
test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT
command git init -q "$test_dir/repo" || exit 1
cd "$test_dir/repo" || exit 1
blob=$(print -r -- content | command git hash-object -w --stdin) || exit 1

typeset -i tests=0 failures=0

check_status() {
  local description="$1" expected_status="$2" expected_prompt="$3"
  local actual_status actual_prompt
  actual_status=$(command git status --porcelain) || exit 1
  actual_prompt=$(git_prompt_status 2> "$test_dir/stderr")
  local prompt_status=$?
  (( tests++ ))

  if [[ $actual_status == "$expected_status" \
     && $actual_prompt == "$expected_prompt" \
     && $prompt_status == 0 && ! -s "$test_dir/stderr" ]]; then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    print -u2 -r -- "  status: ${(qqq)actual_status}"
    print -u2 -r -- "  prompt: ${(qqq)actual_prompt}"
    print -u2 -r -- "  stderr: $(<"$test_dir/stderr")"
    (( failures++ ))
  fi
}

# The seven nonempty combinations of index stages 1 (base), 2 (ours)
# and 3 (theirs) produce all unmerged states documented by git-status.
typeset -a conflict_codes=(DD AU UD UA DU AA UU)
typeset -i mask stage
for mask in {1..7}; do
  command git read-tree --empty || exit 1
  for stage in {1..3}; do
    if (( mask & (1 << (stage - 1)) )); then
      print -r -- "100644 $blob $stage"$'\t'file
    fi
  done | command git update-index --index-info || exit 1

  check_status "$conflict_codes[mask] conflict" \
    "$conflict_codes[mask] file" 'CONFLICT'
done

command git read-tree --empty || exit 1
check_status 'clean repository' '' ''

print -r -- content > file
check_status 'untracked file' '?? file' ''
command git add file || exit 1
check_status 'staged addition' 'A  file' ''
print -r -- modified >> file
check_status 'staged addition with worktree changes' 'AM file' ''
command rm file || exit 1
# AD is not a conflict, even though both letters occur in conflict codes.
check_status 'staged addition deleted from the worktree' 'AD file' ''

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))
