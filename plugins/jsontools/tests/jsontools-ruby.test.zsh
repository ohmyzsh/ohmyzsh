#!/usr/bin/env zsh

# Run with: zsh -df plugins/jsontools/tests/jsontools-ruby.test.zsh
emulate -L zsh
setopt err_return

(( $+commands[ruby] )) || {
  print -u2 'These tests require Ruby.'
  exit 1
}

JSONTOOLS_METHOD=ruby
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
  # pp_json prints JSON with the same 4-space indent as the node and python3 methods.
  print -rn -- '{"value":42}' > "$test_dir/input"
  printf '{\n    "value": 42\n}\n' > "$test_dir/expected"
  check_output pp_json 'pretty-print a small document'

  print -rn -- '{"list":[1,"two"],"nested":{"a":null,"b":true}}' > "$test_dir/input"
  printf '{\n    "list": [\n        1,\n        "two"\n    ],\n    "nested": {\n        "a": null,\n        "b": true\n    }\n}\n' \
    > "$test_dir/expected"
  check_output pp_json 'pretty-print a nested document'

  printf '{"a":1}\n[2]\n' > "$test_dir/input"
  printf '{\n    "a": 1\n}\n[\n    2\n]\n' > "$test_dir/expected"
  check_output pp_ndjson 'pretty-print NDJSON'

  print -rn -- '{"value":42}' > "$test_dir/input"
  print -r -- true > "$test_dir/expected"
  check_output is_json 'validate a document'

  print -rn -- '{invalid}' > "$test_dir/input"
  print -r -- false > "$test_dir/expected"
  check_output is_json 'reject invalid JSON' 1

  print 'All jsontools Ruby tests passed.'
} always {
  rm -rf -- "$test_dir"
}
