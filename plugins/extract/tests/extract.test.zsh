#!/usr/bin/env zsh

# Run with: zsh -df plugins/extract/tests/extract.test.zsh
emulate -L zsh
setopt err_return

for tool in lzma unlzma uncompress; do
  (( $+commands[$tool] )) || {
    print -u2 -r -- "These tests require $tool."
    exit 1
  }
done

source "${0:A:h:h}/extract.plugin.zsh"
local test_dir=$(mktemp -d) original_dir=$PWD

check_extract() {
  local extension=$1 mode=$2
  local case_dir="$test_dir/$extension-$mode"
  mkdir -p "$case_dir/source files" "$case_dir/work/target dir"
  local archive="$case_dir/source files/sample.txt.$extension"
  cp "$test_dir/fixture.$extension" "$archive"
  builtin cd "$case_dir/work"

  local output="$PWD/sample.txt"
  local -a args
  case "$mode" in
    target)
      args=(-t 'target dir')
      output="$PWD/target dir/sample.txt"
      ;;
    remove) args=(-r) ;;
  esac

  # Run the plugin without the test's ERR_RETURN option.
  () {
    emulate -L zsh
    extract "${args[@]}" "$archive"
  } || return 1
  cmp "$test_dir/plain" "$output"
  if [[ $mode == remove ]]; then
    [[ ! -e $archive ]]
  else
    [[ -f $archive ]]
  fi
  print -r -- "PASS: $extension ($mode)"
}

{
  print -r -- hello > "$test_dir/plain"
  lzma -c "$test_dir/plain" > "$test_dir/fixture.lzma"
  # "hello\n" as a .Z stream, since many systems only ship uncompress.
  printf '\037\235\220\150\312\260\141\363\106\001' \
    > "$test_dir/fixture.Z"

  for extension in lzma Z; do
    for mode in default target remove; do
      check_extract "$extension" "$mode"
    done
  done
  print 'All extract compressed-file tests passed.'
} always {
  builtin cd "$original_dir"
  rm -rf -- "$test_dir"
}
