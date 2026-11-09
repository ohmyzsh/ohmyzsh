#!/usr/bin/env zsh

emulate -LR zsh

source "${1:-${0:A:h:h}/encode64.plugin.zsh}"

test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT
cd "$test_dir" || exit 1

typeset -i failures=0 tests=0
typeset output expected call_status

for alias_name in e64 ef64 d64; do
  (( tests++ ))
  if [[ $+aliases[$alias_name] -eq 1 ]]; then
    print -r -- "PASS: alias $alias_name is defined"
  else
    print -u2 -r -- "FAIL: alias $alias_name is not defined"
    (( failures++ ))
  fi
done

# Run encodefile64 and check status/stdout/stderr. Redirecting stdin from
# /dev/null turns a would-be hang (invalid input read from the terminal by a
# stray `base64` call) into a plain failure.
check_encodefile64() {
  local description="$1" expected_status="$2" expected_stdout="$3" expected_stderr="$4"
  shift 4

  output=$(encodefile64 "$@" 2> "$test_dir/stderr" < /dev/null)
  local actual_status=$?
  (( tests++ ))

  if [[ $actual_status != $expected_status ]]; then
    print -u2 -r -- "FAIL: $description"
    print -u2 -r -- "  status: $actual_status (expected $expected_status)"
    (( failures++ ))
  elif [[ $output != "$expected_stdout" ]]; then
    print -u2 -r -- "FAIL: $description"
    print -u2 -r -- "  stdout: ${(qqq)output} (expected ${(qqq)expected_stdout})"
    (( failures++ ))
  elif [[ $(< "$test_dir/stderr") != "$expected_stderr" ]]; then
    print -u2 -r -- "FAIL: $description"
    print -u2 -r -- "  stderr: ${(qqq)$(< "$test_dir/stderr")} (expected ${(qqq)expected_stderr})"
    (( failures++ ))
  else
    print -r -- "PASS: $description"
  fi
}

check_absent() {
  local description="$1" file="$2"
  (( tests++ ))
  if [[ -e $file ]]; then
    print -u2 -r -- "FAIL: $description (${(qqq)file} exists)"
    (( failures++ ))
  else
    print -r -- "PASS: $description"
  fi
}

check_unchanged() {
  local description="$1" file="$2" content="$3"
  (( tests++ ))
  if [[ -e $file && $(< "$file") == "$content" ]]; then
    print -r -- "PASS: $description"
  else
    print -u2 -r -- "FAIL: $description"
    (( failures++ ))
  fi
}

usage='Usage: encodefile64 <file>'

# A sentinel .txt guards against invalid input truncating or creating stray
# files through the output redirection (e.g. an unquoted empty $1 turning the
# command into `base64 > .txt`).
print -rn -- 'SENTINEL' >| "$test_dir/.txt"
check_encodefile64 'no arguments' 1 '' "$usage"
check_encodefile64 'empty argument' 1 '' "$usage" ''
check_unchanged 'invalid calls left the sentinel .txt untouched' '.txt' 'SENTINEL'
command rm -f -- "$test_dir/.txt"

check_encodefile64 'empty argument in a clean directory' 1 '' "$usage" ''
check_absent 'empty argument created no stray .txt' '.txt'

print -rn -- 'contents' >| "$test_dir/valid.dat"
check_encodefile64 'too many arguments' 1 '' "$usage" valid.dat valid.dat
check_absent 'too many arguments created no output file' 'valid.dat.txt'

check_encodefile64 'missing file' 1 '' "$usage" missing.dat
check_absent 'missing file created no output file' 'missing.dat.txt'

check_encodefile64 'directory argument' 1 '' "$usage" "$test_dir"
check_absent 'directory argument created no output file' "$test_dir.txt"

if [[ $EUID -ne 0 ]]; then
  print -rn -- 'secret' >| "$test_dir/unreadable.dat"
  chmod 000 "$test_dir/unreadable.dat"
  check_encodefile64 'unreadable file' 1 '' "$usage" unreadable.dat
  check_absent 'unreadable file created no output file' 'unreadable.dat.txt'
  chmod 600 "$test_dir/unreadable.dat"
  command rm -f -- "$test_dir/unreadable.dat"
fi

# An encoder that dies half way must not claim success nor leave the partial
# file the output redirection created. `base64` is stubbed through PATH for
# these calls only: it writes bytes to stdout (the output file) and fails.
mkdir -p "$test_dir/failbin"
print -r -- '#!/bin/sh
printf partial
exit 1' >| "$test_dir/failbin/base64"
chmod +x "$test_dir/failbin/base64"
saved_path=$PATH
PATH="$test_dir/failbin:$PATH"
rehash
check_encodefile64 'failing encoder returns non-zero' 1 '' '' valid.dat
PATH=$saved_path
rehash
check_absent 'failing encoder left no partial output file' 'valid.dat.txt'

# A failed output redirection must not remove a pre-existing output file the
# plugin never wrote. Root ignores file permissions, so skip it there.
if [[ $EUID -ne 0 ]]; then
  print -rn -- 'contents' >| "$test_dir/guard.dat"
  print -rn -- 'PRECIOUS' >| "$test_dir/guard.dat.txt"
  chmod 444 "$test_dir/guard.dat.txt"
  encodefile64 guard.dat < /dev/null >| "$test_dir/guard.log" 2>&1
  call_status=$?
  (( tests++ ))
  if (( call_status == 0 )) || [[ $(< "$test_dir/guard.dat.txt") != 'PRECIOUS' ]]; then
    print -u2 -r -- 'FAIL: unwritable existing output was overwritten or deleted'
    (( failures++ ))
  else
    print -r -- 'PASS: unwritable existing output was left intact'
  fi
  chmod 644 "$test_dir/guard.dat.txt"
  command rm -f -- "$test_dir/guard.dat" "$test_dir/guard.dat.txt"

  # A directory sitting in the output slot is refused, and not deleted.
  print -rn -- 'contents' >| "$test_dir/dirout.dat"
  mkdir "$test_dir/dirout.dat.txt"
  encodefile64 dirout.dat < /dev/null >| "$test_dir/dirout.log" 2>&1
  call_status=$?
  (( tests++ ))
  if (( call_status == 0 )) || [[ ! -d "$test_dir/dirout.dat.txt" ]]; then
    print -u2 -r -- 'FAIL: directory output slot was accepted or removed'
    (( failures++ ))
  else
    print -r -- 'PASS: directory output slot refused and left alone'
  fi
  command rmdir -- "$test_dir/dirout.dat.txt"
  command rm -f -- "$test_dir/dirout.dat" "$test_dir/guard.log" "$test_dir/dirout.log"
fi

# Valid encodes: output must match the platform's own `base64 < file` byte for
# byte (GNU wraps at 76 columns, BSD does not) and must decode back to the
# original bytes. File names probe quoting: spaces, quotes, a leading dash.
for filename in plain.dat 'file with spaces.dat' "single'quote.dat" 'double"quote.dat' --version unicode-ą.dat; do
  printf 'line one\nline two %s\n%s' "$filename" "$(printf 'x%.0s' {1..300})" >| "$test_dir/$filename"

  expected="$filename's content encoded in base64 and saved as $filename.txt"
  check_encodefile64 "encode $filename" 0 "$expected" '' "$filename"

  (( tests++ ))
  base64 < "$test_dir/$filename" >| "$test_dir/expected.b64"
  if cmp -s -- "$test_dir/$filename.txt" "$test_dir/expected.b64"; then
    print -r -- "PASS: $filename.txt matches base64 < $filename"
  else
    print -u2 -r -- "FAIL: $filename.txt does not match base64 < $filename"
    (( failures++ ))
  fi

  (( tests++ ))
  d64 < "$test_dir/$filename.txt" >| "$test_dir/decoded"
  if cmp -s -- "$test_dir/$filename" "$test_dir/decoded"; then
    print -r -- "PASS: $filename round trips through d64"
  else
    print -u2 -r -- "FAIL: $filename does not round trip through d64"
    (( failures++ ))
  fi

  command rm -f -- "$test_dir/$filename" "$test_dir/$filename.txt"
done

# String encode/decode round trips through the public interface.
for text in 'oh-my-zsh' 'a longer string with spaces = and +' 'unicode ą' '--version' ''; do
  (( tests++ ))
  output=$(decode64 "$(encode64 "$text")")
  if [[ $output == "$text" ]]; then
    print -r -- "PASS: round trip ${(qqq)text}"
  else
    print -u2 -r -- "FAIL: round trip ${(qqq)text} returned ${(qqq)output}"
    (( failures++ ))
  fi
done

(( tests++ ))
output=$(printf '%s' 'oh-my-zsh' | e64)
expected=$(printf '%s' 'oh-my-zsh' | base64)
if [[ $output == "$expected" ]]; then
  print -r -- 'PASS: e64 reads piped stdin'
else
  print -u2 -r -- "FAIL: e64 reads piped stdin: ${(qqq)output} (expected ${(qqq)expected})"
  (( failures++ ))
fi

(( tests++ ))
output=$(printf '%s' 'oh-my-zsh' | base64 | d64)
if [[ $output == 'oh-my-zsh' ]]; then
  print -r -- 'PASS: d64 reads piped stdin'
else
  print -u2 -r -- "FAIL: d64 reads piped stdin: ${(qqq)output} (expected 'oh-my-zsh')"
  (( failures++ ))
fi

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))
