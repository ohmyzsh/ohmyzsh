#!/usr/bin/env zsh

# Run with: zsh -df tools/tests/changelog.test.zsh
emulate -L zsh
setopt err_return

local changelog="${0:A:h:h}/changelog.sh"
local test_dir=$(mktemp -d) original_dir=$PWD

# Isolate the test repository from the user's git configuration.
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
export GIT_AUTHOR_NAME=test GIT_AUTHOR_EMAIL=test@example.com
export GIT_COMMITTER_NAME=test GIT_COMMITTER_EMAIL=test@example.com

# check_changelog <description> <until> <since> <patterns...>
# Each pattern must match a line of the output; a leading ! means no line may match it.
check_changelog() {
  local description=$1 until=$2 since=$3 pattern
  shift 3
  local -a lines
  lines=("${(@f)$(zsh -f "$changelog" "$until" "$since" --raw)}")
  for pattern; do
    if [[ $pattern = !* ]]; then
      (( ! ${lines[(I)${~pattern#!}]} )) && continue
    else
      (( ${lines[(I)${~pattern}]} )) && continue
    fi
    print -u2 -r -- "FAIL: $description (pattern: $pattern)"
    print -u2 -rl -- $lines
    return 1
  done
  print -r -- "PASS: $description"
}

{
  builtin cd "$test_dir"
  command git init -q
  command git commit -q --allow-empty -m 'chore: initial commit'
  print demo > demo && command git add demo
  command git commit -q -m 'feat(demo): add a demo feature'
  print core > core && command git add core
  command git commit -q -m 'fix(core): fix an unrelated bug'
  command git revert --no-edit HEAD~1 >/dev/null

  check_changelog 'hide a reverted commit and its revert' HEAD HEAD~3 \
    '*Fix an unrelated bug' '!*Add a demo feature' '!*Revert *'

  check_changelog 'keep a revert whose reverted commit is not in the range' HEAD HEAD~2 \
    '*Fix an unrelated bug' '*Revert "feat\(demo\): add a demo feature"'

  check_changelog 'keep a commit that has not been reverted yet' HEAD~1 HEAD~3 \
    '*Add a demo feature' '*Fix an unrelated bug'

  print 'All changelog tests passed.'
} always {
  builtin cd "$original_dir"
  rm -rf -- "$test_dir"
}
