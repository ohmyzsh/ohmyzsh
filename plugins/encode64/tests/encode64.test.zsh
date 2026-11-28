#!/usr/bin/env zsh

emulate -LR zsh

source "${1:-${0:A:h:h}/encode64.plugin.zsh}"

test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT
cd "$test_dir" || exit 1

typeset -i failures=0 tests=0
typeset output expected_output

check_result() {
  local description="$1" expected_status="$2" expected_stdout="$3" expected_stderr="$4"
  shift 4

  output=$("$@" 2> "$test_dir/stderr")
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

check_encode_arg() { encode64 'oh-my-zsh'; }
check_encode_empty() { encode64 ''; }
check_decode_arg() { decode64 'b2gtbXktenNo'; }

expected_output=$(printf '%s' 'oh-my-zsh' | base64)
check_result 'encode argument' 0 "$expected_output" '' check_encode_arg
check_result 'encode empty argument' 0 '' '' check_encode_empty
check_result 'decode argument' 0 'oh-my-zsh' '' check_decode_arg

file="$test_dir/file with spaces.txt"
print -r -- 'file contents' >| "$file"
encodefile64 "$file" > "$test_dir/stdout" 2> "$test_dir/stderr"
file_status=$?
expected_output=$(base64 < "$file")
(( tests++ ))
if [[ $file_status == 0 && $(<"${file}.txt") == "$expected_output" && $(<"$test_dir/stdout") == "$file's content encoded in base64 and saved as ${file}.txt" && ! -s "$test_dir/stderr" ]]; then
  print -r -- 'PASS: encode file with spaces'
else
  print -u2 -r -- 'FAIL: encode file with spaces'
  (( failures++ ))
fi

check_invalid_file() { encodefile64 ''; }
check_result 'empty filename' 1 '' 'Usage: encodefile64 <file>' check_invalid_file
if [[ -e .txt ]]; then
  print -u2 -r -- 'FAIL: empty filename created .txt'
  (( failures++ ))
  command rm -f .txt
fi

print -r -- 'preserve existing output' >| "${file}.txt"
base64() { return 42; }
encodefile64 "$file" > "$test_dir/stdout" 2> "$test_dir/stderr"
file_status=$?
unset -f base64
(( tests++ ))
if [[ $file_status != 0 && $(<"${file}.txt") == 'preserve existing output' && ! -s "$test_dir/stdout" ]]; then
  print -r -- 'PASS: failed encoding preserves existing output'
else
  print -u2 -r -- 'FAIL: failed encoding preserves existing output'
  (( failures++ ))
fi

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))
