#!/usr/bin/env zsh

# Run with: zsh -df plugins/extract/tests/extract.test.zsh
emulate -L zsh
setopt err_return

for tool in ar lzma unlzma uncompress; do
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

# Extracting a .deb must place the control members directly in <name>/control
# and the data members directly in <name>/data, whatever their member count.
check_deb_extract() {
  local mode=$1
  local case_dir="$test_dir/deb-$mode"
  mkdir -p "$case_dir/source files" "$case_dir/work/target dir" \
    "$case_dir/src/ctl" "$case_dir/src/data/usr/bin"
  print -r -- "postinst script" > "$case_dir/src/ctl/postinst"
  print -r -- "conf:1" > "$case_dir/src/ctl/conffiles"
  print -r -- "app main" > "$case_dir/src/data/usr/bin/app"
  tar czf "$case_dir/src/control.tar.gz" -C "$case_dir/src/ctl" conffiles postinst
  tar czf "$case_dir/src/data.tar.gz" -C "$case_dir/src/data" usr
  print -r -- "2.0" > "$case_dir/src/debian-binary"
  (
    builtin cd "$case_dir/src"
    rm -f "$case_dir/source files/pkg.deb"
    ar rS "$case_dir/source files/pkg.deb" debian-binary control.tar.gz data.tar.gz
  )
  local archive="$case_dir/source files/pkg.deb"

  builtin cd "$case_dir/work"
  local base="$PWD/pkg"
  local -a args
  case "$mode" in
    target)
      args=(-t 'target dir')
      base="$PWD/target dir/pkg"
      ;;
    remove) args=(-r) ;;
  esac

  () {
    emulate -L zsh
    extract "${args[@]}" "$archive"
  } || return 1

  [[ -f "$base/control/conffiles" && -f "$base/control/postinst" ]] ||
    { print -u2 -r -- "$mode: control members not extracted into $base/control"; return 1 }
  [[ -f "$base/data/usr/bin/app" ]] ||
    { print -u2 -r -- "$mode: data members not extracted into $base/data"; return 1 }
  [[ ! -d "$base/control/control" && ! -d "$base/data/data" ]] ||
    { print -u2 -r -- "$mode: deb extraction double-nested the member directories"; return 1 }
  [[ ! -e "$base/control.tar.gz" && ! -e "$base/data.tar.gz" && ! -e "$base/debian-binary" ]] ||
    { print -u2 -r -- "$mode: deb member debris left behind"; return 1 }
  if [[ $mode == remove ]]; then
    [[ ! -e $archive ]]
  else
    [[ -f $archive ]]
  fi
  print -r -- "PASS: deb ($mode)"
}

# An unexpected member must be reported and left on disk for inspection, and
# the cleanup must not delete the other members around it either.
check_deb_unexpected_member() {
  local case_dir="$test_dir/deb-unexpected"
  mkdir -p "$case_dir/src/ctl" "$case_dir/src/data/usr/bin"
  print -r -- "postinst script" > "$case_dir/src/ctl/postinst"
  print -r -- "app main" > "$case_dir/src/data/usr/bin/app"
  tar czf "$case_dir/src/control.tar.gz" -C "$case_dir/src/ctl" postinst
  print -r -- "unknown compression" > "$case_dir/src/control.tar.weird"
  tar czf "$case_dir/src/data.tar.gz" -C "$case_dir/src/data" usr
  print -r -- "2.0" > "$case_dir/src/debian-binary"
  (
    builtin cd "$case_dir/src"
    ar rS "$case_dir/pkg.deb" debian-binary control.tar.weird data.tar.gz
  )

  builtin cd "$case_dir"
  () {
    emulate -L zsh
    extract "$case_dir/pkg.deb"
  } || return 1

  [[ -f "$case_dir/pkg/data/usr/bin/app" ]] ||
    { print -u2 -r -- "deb-unexpected: known members were not extracted"; return 1 }
  [[ -f "$case_dir/pkg/control.tar.weird" && -f "$case_dir/pkg/data.tar.gz" &&
     -f "$case_dir/pkg/debian-binary" ]] ||
    { print -u2 -r -- "deb-unexpected: archive members were deleted"; return 1 }
  print -r -- "PASS: deb (unexpected member)"
}

# Passing more than one .deb in a single call must not leak the loop variables
# between archives; the stale `member`/`dest` locals used to be printed by the
# second archive.
check_deb_multiple() {
  local case_dir="$test_dir/deb-multiple"
  mkdir -p "$case_dir/src/ctl" "$case_dir/src/data/usr/bin"
  print -r -- "postinst script" > "$case_dir/src/ctl/postinst"
  print -r -- "app main" > "$case_dir/src/data/usr/bin/app"
  tar czf "$case_dir/src/control.tar.gz" -C "$case_dir/src/ctl" postinst
  tar czf "$case_dir/src/data.tar.gz" -C "$case_dir/src/data" usr
  print -r -- "2.0" > "$case_dir/src/debian-binary"
  (
    builtin cd "$case_dir/src"
    ar rS "$case_dir/one.deb" debian-binary control.tar.gz data.tar.gz
    ar rS "$case_dir/two.deb" debian-binary control.tar.gz data.tar.gz
  )

  builtin cd "$case_dir"
  local output
  output=$( () {
    emulate -L zsh
    extract one.deb two.deb
  } 2>&1 ) || return 1

  [[ $output != *member=* && $output != *dest=* ]] ||
    { print -u2 -r -- "deb-multiple: stale loop variables were printed"; return 1 }
  [[ -f one/control/postinst && -f one/data/usr/bin/app &&
     -f two/control/postinst && -f two/data/usr/bin/app ]] ||
    { print -u2 -r -- "deb-multiple: both archives were not extracted"; return 1 }
  print -r -- "PASS: deb (multiple archives)"
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
  check_deb_extract default
  check_deb_extract target
  check_deb_extract remove
  check_deb_unexpected_member
  check_deb_multiple
  print 'All extract compressed-file tests passed.'
} always {
  builtin cd "$original_dir"
  rm -rf -- "$test_dir"
}
