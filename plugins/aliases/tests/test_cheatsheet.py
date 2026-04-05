#!/usr/bin/env python3
"""Tests for cheatsheet.py - regression tests for known bugs."""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from cheatsheet import parse

_failures = 0

def run_test(description, got, expected):
    global _failures
    if got == expected:
        print(f"\033[32mSuccess\033[0m: {description}\n")
    else:
        print(f"\033[31mError\033[0m: {description}")
        print(f"  expected: {expected!r}")
        print(f"  got:      {got!r}\n", file=sys.stderr)
        _failures += 1


# Bug #13637: als drops trailing double quote from alias value.
# alias now='date +"%T"' was being rendered as `now = date +"%T` (missing closing ").
# Root cause: strip('\'"\n ') stripped " from both ends of the value string.

_, right, _ = parse("now='date +\"%T\"'")
run_test(
    "trailing double quote preserved in single-quoted alias (bug #13637)",
    right,
    'date +"%T"',
)

_, right, _ = parse("foo='echo \"hello world\"'")
run_test(
    "both double quotes preserved when alias value contains a quoted word",
    right,
    'echo "hello world"',
)

# Unrelated to the bug - verify basic parsing still works correctly.
_, right, _ = parse('bar="simple command"')
run_test(
    "double-quoted alias value parsed correctly",
    right,
    "simple command",
)

_, right, _ = parse("baz='no quotes inside'")
run_test(
    "single-quoted alias with no inner quotes parsed correctly",
    right,
    "no quotes inside",
)

sys.exit(_failures)
