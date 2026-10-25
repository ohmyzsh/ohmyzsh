#!/usr/bin/env zsh

emulate -LR zsh

source "${1:-${0:A:h:h}/copyfile.plugin.zsh}"

test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT

typeset -i clipboard_status=0 failures=0 tests=0
typeset output expected_output

clipcopy() {
  print -r -- "$#" "$1" >| "$test_dir/call"
  if (( clipboard_status )); then
    print -u2 -r -- "clipboard backend failed"
    return $clipboard_status
  fi
  command cat -- "$1" >| "$test_dir/clipboard"
}

check_copyfile() {
  local description="$1" expected_status="$2" expected_stdout="$3" expected_stderr="$4"
  shift 4

  output=$(copyfile "$@" 2> "$test_dir/stderr")
  local actual_status=$?
  (( tests++ ))

  if [[ $actual_status == $expected_status && $output == "$expected_stdout" && $(<"$test_dir/stderr") == "$expected_stderr" ]]; then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    print -u2 -r -- "  status: $actual_status (expected $expected_status)"
    print -u2 -r -- "  stdout: ${(qqq)output} (expected ${(qqq)expected_stdout})"
    print -u2 -r -- "  stderr: $(<"$test_dir/stderr") (expected $expected_stderr)"
    (( failures++ ))
  fi
}

for filename in plain.txt 'file with spaces.txt' 'unicode-ą.txt' empty.txt; do
  if [[ $filename == empty.txt ]]; then
    : >| "$test_dir/$filename"
  else
    print -r -- "contents of $filename" >| "$test_dir/$filename"
  fi

  expected_output=${(%):-"%B$test_dir/$filename%b copied to clipboard."}
  clipboard_status=0
  check_copyfile "successful copy of $filename" 0 "$expected_output" '' "$test_dir/$filename"

  if [[ $(<"$test_dir/call") != "1 $test_dir/$filename" ]] || ! command cmp -s -- "$test_dir/$filename" "$test_dir/clipboard"; then
    print -u2 -r -- "FAIL: clipboard received a different argument or contents for $filename"
    (( failures++ ))
  fi

  for clipboard_status in 1 42 127; do
    check_copyfile "clipboard exit $clipboard_status for $filename" 1 '' 'clipboard backend failed' "$test_dir/$filename"
  done
done

command rm -f -- "$test_dir/call"
check_copyfile 'missing argument' 1 'Usage: copyfile <file>' ''
check_copyfile 'empty argument' 1 'Usage: copyfile <file>' '' ''
check_copyfile 'nonexistent file' 1 "Error: '$test_dir/missing.txt' is not a valid file." '' "$test_dir/missing.txt"
check_copyfile 'directory argument' 1 "Error: '$test_dir' is not a valid file." '' "$test_dir"

if [[ -e "$test_dir/call" ]]; then
  print -u2 -r -- 'FAIL: invalid input invoked the clipboard backend'
  (( failures++ ))
fi

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))
