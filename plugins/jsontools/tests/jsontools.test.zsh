#!/usr/bin/env zsh

# Run with: zsh -df plugins/jsontools/tests/jsontools.test.zsh
emulate -L zsh
setopt err_return

(( $+commands[node] )) || {
  print -u2 'These tests require Node.js.'
  exit 1
}

JSONTOOLS_METHOD=node
source "${0:A:h:h}/jsontools.plugin.zsh"
local test_dir=$(mktemp -d)

check_output() {
  local tool=$1 description=$2 expected_status=${3:-0}
  local -i result=0
  $tool < "$test_dir/input" > "$test_dir/actual" || result=$?
  if (( result != expected_status )) \
      || ! cmp -s "$test_dir/expected" "$test_dir/actual"; then
    print -u2 -r -- "FAIL: $description ($tool exited $result)"
    return 1
  fi
  print -r -- "PASS: $description"
}

{
  print -rn -- '{"value":42}' > "$test_dir/input"
  printf '{\n    "value": 42\n}\n' > "$test_dir/expected"
  check_output pp_json 'pretty-print a small document'

  # Larger than the 128 KiB limit for a single command-line argument.
  local large_value=${(l:262144::x:):-}
  print -rn -- '{"value":"'"$large_value"'"}' > "$test_dir/input"
  printf '{\n    "value": "%s"\n}\n' "$large_value" > "$test_dir/expected"
  check_output pp_json 'pretty-print a large document'
  print -r -- true > "$test_dir/expected"
  check_output is_json 'validate a large document'

  print -r -- '%7B%22value%22%3A%22'"$large_value"'%22%7D' \
    > "$test_dir/expected"
  check_output urlencode_json 'encode a large document'
  local encoded=$(< "$test_dir/expected")
  print -rn -- "$encoded" > "$test_dir/input"
  print -r -- '{"value":"'"$large_value"'"}' > "$test_dir/expected"
  check_output urldecode_json 'decode a large document'

  # Passed as an argument, node used to parse this as its own option.
  print -rn -- '--version' > "$test_dir/input"
  print -r -- '--version' > "$test_dir/expected"
  check_output urlencode_json 'encode input that starts with --'

  print -rn -- '{invalid}' > "$test_dir/input"
  print -r -- false > "$test_dir/expected"
  check_output is_json 'reject invalid JSON' 1

  printf '1\0002' > "$test_dir/input"
  check_output is_json 'reject input with NUL bytes' 1

  print 'All jsontools Node.js tests passed.'
} always {
  rm -rf -- "$test_dir"
}
