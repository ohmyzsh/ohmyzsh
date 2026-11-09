#!/usr/bin/env zsh
# Tests for the vi-mode plugin's cursor/visual-mode handling.
#
# These simulate the ZLE state the plugin reacts to (the KEYMAP and
# REGION_ACTIVE special parameters and the hooks it defines) outside of an
# interactive editor, and assert on the DECSCUSR escape sequences the plugin
# emits and on the value of VI_KEYMAP.
#
# Run with: zsh -f plugins/vi-mode/tests/vi-mode.tests.zsh

# Note: `set -u` is deliberately not enabled because the plugin is sourced as
# in a regular interactive shell, where parameters such as RPS1 are only
# referenced.

# Use distinct cursor styles per mode so the emitted escape sequences can be
# unambiguously attributed to a mode (must be set before sourcing the plugin,
# which respects pre-existing values via ${VAR:=default}).
typeset -g VI_MODE_SET_CURSOR=true
typeset -g VI_MODE_CURSOR_NORMAL=2    # block, used by vicmd
typeset -g VI_MODE_CURSOR_VISUAL=4    # steady underline, used by visual modes
typeset -g VI_MODE_CURSOR_INSERT=6    # steady bar, used by insert-like modes
typeset -g VI_MODE_CURSOR_OPPEND=5    # blinking bar, used by viopp

# Expected DECSCUSR sequences for the styles above.
readonly EXPECTED_BLOCK=$'\e[2 q'
readonly EXPECTED_UNDERLINE=$'\e[4 q'
readonly EXPECTED_BAR=$'\e[6 q'
readonly EXPECTED_BLINK_BAR=$'\e[5 q'

source "${0:A:h:h}/vi-mode.plugin.zsh"

CAPTURE=$(mktemp)
trap 'rm -f "$CAPTURE"' EXIT

# Run the plugin's pre-redraw hook (the code under test) in the current shell,
# capturing what it prints to the terminal.
cursor_output=''
run_hook() {
  zle-line-pre-redraw > "$CAPTURE"
  cursor_output=$(<"$CAPTURE")
}

tests=0
failures=0

# Compare both the emitted escape sequence and VI_KEYMAP after a hook run.
assert_state() {
  local description="$1" expected_cursor="$2" expected_keymap="$3"
  (( ++tests ))
  if [[ "$cursor_output" != "$expected_cursor" || "$VI_KEYMAP" != "$expected_keymap" ]]; then
    (( ++failures ))
    print -u2 "not ok - $description"
    print -u2 "#   expected cursor ${(q)expected_cursor} keymap $expected_keymap"
    print -u2 "#   got      cursor ${(q)cursor_output} keymap $VI_KEYMAP (KEYMAP=$KEYMAP REGION_ACTIVE=$REGION_ACTIVE)"
  else
    print -u2 "ok - $description"
  fi
}

# Compare the escape sequence emitted by the standalone cursor-shape helper.
assert_cursor_for_keymap() {
  local description="$1" expected_cursor="$2"
  (( ++tests ))
  local actual
  actual=$(_vi-mode-set-cursor-shape-for-keymap)
  if [[ "$actual" != "$expected_cursor" ]]; then
    (( ++failures ))
    print -u2 "not ok - $description"
    print -u2 "#   expected ${(q)expected_cursor}, got ${(q)actual}"
  else
    print -u2 "ok - $description"
  fi
}

# The visual-mode widget must no longer be wrapped: wrapping it only detected
# *entering* visual mode (and leaked the `visual` keymap when leaving it), see
# https://github.com/ohmyzsh/ohmyzsh/issues/11705.
(( ++tests ))
if [[ -n "${functions[_visual-mode]:-}" ]]; then
  (( ++failures ))
  print -u2 "not ok - visual-mode widget is not wrapped anymore"
else
  print -u2 "ok - visual-mode widget is not wrapped anymore"
fi

# Redraws in command mode with no selection must not touch anything.
KEYMAP=vicmd REGION_ACTIVE=0 VI_KEYMAP=vicmd
run_hook
assert_state "command mode emits no cursor change when nothing changed" '' vicmd

# Regression test for #11705: entering visual mode changes the cursor shape...
KEYMAP=vicmd REGION_ACTIVE=1
run_hook
assert_state "entering visual mode sets the visual cursor shape" \
  "$EXPECTED_UNDERLINE" visual

# ...and, the part that used to be broken, leaving visual mode (e.g. by
# pressing escape, which keeps us in the vicmd keymap so zle-keymap-select
# never fires) restores the block cursor.
KEYMAP=vicmd REGION_ACTIVE=0
run_hook
assert_state "leaving visual mode restores the normal cursor shape" \
  "$EXPECTED_BLOCK" vicmd

# Same for visual-line-mode, which the previous widget-wrapping fix missed
# entirely.
KEYMAP=vicmd REGION_ACTIVE=2
run_hook
assert_state "entering visual-line mode sets the visual cursor shape" \
  "$EXPECTED_UNDERLINE" visual-line
KEYMAP=vicmd REGION_ACTIVE=0
run_hook
assert_state "leaving visual-line mode restores the normal cursor shape" \
  "$EXPECTED_BLOCK" vicmd

# Redrawing while staying in visual mode must not re-emit the sequence.
KEYMAP=vicmd REGION_ACTIVE=1
run_hook
assert_state "first redraw in visual mode emits the visual cursor" \
  "$EXPECTED_UNDERLINE" visual
run_hook
assert_state "subsequent redraws in visual mode emit nothing" '' visual
KEYMAP=vicmd REGION_ACTIVE=0
run_hook

# An active region outside command mode (e.g. an emacs-mode region, or vi
# insert bindings that temporarily highlight a region) must not be reported
# as visual mode, and the hook must not interfere with transitions owned by
# zle-keymap-select.
KEYMAP=viins REGION_ACTIVE=0 VI_KEYMAP=viins
run_hook
assert_state "insert mode with no region emits nothing" '' viins
KEYMAP=viins REGION_ACTIVE=1
run_hook
assert_state "insert mode with an active region is not treated as visual" '' viins
KEYMAP=main REGION_ACTIVE=1 VI_KEYMAP=main
run_hook
assert_state "main keymap with an active region is left untouched by the hook" '' main

# The mode keymap is still tracked when cursor changes are disabled, so the
# prompt mode indicator keeps working, but nothing is printed.
KEYMAP=vicmd REGION_ACTIVE=0 VI_KEYMAP=vicmd VI_MODE_SET_CURSOR=false
run_hook
KEYMAP=vicmd REGION_ACTIVE=1
run_hook
assert_state "visual mode updates VI_KEYMAP without cursor changes enabled" '' visual
KEYMAP=vicmd REGION_ACTIVE=0
run_hook
assert_state "leaving visual mode without cursor changes enabled emits nothing" '' vicmd
VI_MODE_SET_CURSOR=true

# The standalone cursor-shape helper must understand every mode keymap the
# plugin can set, including visual-line (unknown names fall back to shape 0).
for km_keymap in main viins isearch command; do
  VI_KEYMAP=$km_keymap
  assert_cursor_for_keymap "$km_keymap keymap maps to the insert cursor shape" "$EXPECTED_BAR"
done
VI_KEYMAP=vicmd
assert_cursor_for_keymap "vicmd keymap maps to the normal cursor shape" "$EXPECTED_BLOCK"
for km_keymap in visual visual-line; do
  VI_KEYMAP=$km_keymap
  assert_cursor_for_keymap "$km_keymap keymap maps to the visual cursor shape" "$EXPECTED_UNDERLINE"
done
VI_KEYMAP=viopp
assert_cursor_for_keymap "viopp keymap maps to the operation-pending cursor shape" "$EXPECTED_BLINK_BAR"

if (( failures )); then
  print -u2 "$failures/$tests vi-mode tests failed"
  exit 1
fi
print -u2 "All $tests vi-mode tests passed"
