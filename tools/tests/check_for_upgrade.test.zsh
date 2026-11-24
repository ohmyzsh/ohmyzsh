#!/usr/bin/env zsh

# Run with: zsh -df tools/tests/check_for_upgrade.test.zsh
emulate -L zsh
setopt err_return

local updater="${0:A:h:h}/check_for_upgrade.sh"
local test_dir=$(mktemp -d)

_check_update() (
  local mode=$1 vscode=$2 intellij=$3 instant_prompt=$4 expect_skip=$5
  local actual_mode
  export HOME="$test_dir" ZSH="$test_dir" ZSH_CACHE_DIR="$test_dir/cache"
  export PATH="$test_dir/bin:$PATH" GIT_PROBE_LOG="$test_dir/git.log"
  export VSCODE_RESOLVING_ENVIRONMENT=$vscode
  export INTELLIJ_ENVIRONMENT_READER=$intellij
  # Terminal identity alone must not disable updates.
  export TERM_PROGRAM=vscode TERMINAL_EMULATOR=JetBrains-JediTerm
  export POWERLEVEL9K_INSTANT_PROMPT=$instant_prompt
  unset DISABLE_AUTO_UPDATE DISABLE_UPDATE_PROMPT
  zstyle -d ':omz:update'
  [[ $mode == default ]] || zstyle ':omz:update' mode "$mode"
  zstyle ':omz:update' frequency 0
  local -a precmd_functions=()

  rm -f "$GIT_PROBE_LOG" "$ZSH_CACHE_DIR/.zsh-update"
  print 'LAST_EPOCH=0' > "$HOME/.zsh-update"

  source "$updater" > "$test_dir/output" 2>&1

  [[ ! -s "$test_dir/output" ]] || {
    print -u2 -r -- 'FAIL: updater produced unexpected output:'
    cat "$test_dir/output" >&2
    return 1
  }
  if [[ $expect_skip == yes ]]; then
    [[ ! -e "$GIT_PROBE_LOG" \
      && "$(<"$ZSH_CACHE_DIR/.zsh-update")" == LAST_EPOCH=0 ]]
  else
    [[ ! -e "$HOME/.zsh-update" \
      && -f "$ZSH_CACHE_DIR/.zsh-update" \
      && -s "$GIT_PROBE_LOG" ]]
  fi || {
    print -u2 -r -- "FAIL: mode=$mode vscode=$vscode intellij=$intellij" \
      "instant_prompt=$instant_prompt expect_skip=$expect_skip"
    return 1
  }
  [[ ${#precmd_functions} == 0 && ! -v update_mode ]] || {
    print -u2 -r -- 'FAIL: updater left hooks or update_mode behind'
    return 1
  }
  if [[ $mode == default ]]; then
    if zstyle -s ':omz:update' mode actual_mode; then
      print -u2 -r -- "FAIL: updater set an update mode: $actual_mode"
      return 1
    fi
  else
    if ! zstyle -s ':omz:update' mode actual_mode \
      || [[ $actual_mode != $mode ]]; then
      print -u2 -r -- "FAIL: updater changed the configured mode: $mode"
      return 1
    fi
  fi
)

{
  # Fail at the first Git probe without accessing the network.
  mkdir "$test_dir/bin" "$test_dir/cache"
  print -r -- '#!/bin/sh
printf "%s\n" "$*" >> "$GIT_PROBE_LOG"
exit 1' > "$test_dir/bin/git"
  chmod +x "$test_dir/bin/git"

  local mode instant_prompt
  for mode in default prompt auto reminder background-alpha disabled; do
    for instant_prompt in off quiet; do
      _check_update "$mode" 1 '' "$instant_prompt" yes
      _check_update "$mode" '' true "$instant_prompt" yes
      _check_update "$mode" 1 true "$instant_prompt" yes
    done
  done
  # Enable instant prompt so non-TTY test output does not skip the normal path.
  for mode in default prompt auto reminder background-alpha; do
    _check_update "$mode" '' '' quiet no
    _check_update "$mode" 0 false quiet no
  done
  print 'All update discovery tests passed.'
} always {
  rm -rf -- "$test_dir"
}
