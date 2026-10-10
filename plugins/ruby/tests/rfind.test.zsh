#!/usr/bin/env zsh

emulate -LR zsh

source "${1:-${0:A:h:h}/ruby.plugin.zsh}"

test_dir=$(mktemp -d) || exit 1
trap 'command rm -rf -- "$test_dir"' EXIT

typeset -i failures=0 tests=0
typeset filename output

for filename in plain.rb 'file with spaces.rb' "single'quote.rb" 'double"quote.rb' $'line\nbreak.rb' 'unicode-ą.rb'; do
  print -r -- 'needle' >| "$test_dir/$filename"
  output=$(cd "$test_dir" && rfind needle 2> "$test_dir/stderr")
  actual_status=$?
  (( tests++ ))

  if [[ $actual_status == 0 && $output == '1:needle' && ! -s "$test_dir/stderr" ]]; then
    print -r -- "PASS: ${(qqq)filename}"
  else
    print -u2 -r -- "FAIL: ${(qqq)filename} (status $actual_status)"
    print -u2 -r -- "  stdout: ${(qqq)output}"
    print -u2 -r -- "  stderr: $(<"$test_dir/stderr")"
    (( failures++ ))
  fi

  command rm -- "$test_dir/$filename"
done

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))
