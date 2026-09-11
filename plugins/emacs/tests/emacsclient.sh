#!/bin/sh
set -eu

launcher="${1:-$(dirname "$0")/../emacsclient.sh}"
launcher="$(cd "$(dirname "$launcher")" && pwd)/$(basename "$launcher")"
test_shell="${TEST_SHELL:-/bin/sh}"
fixture_dir="$(mktemp -d "${TMPDIR:-/tmp}/omz-emacs-test.XXXXXX")"
trap 'rm -r -- "$fixture_dir"' EXIT
export EMACS_TEST_LOG="$fixture_dir/args"
export PATH="$fixture_dir:$PATH"

cat > "$fixture_dir/emacsclient" <<'STUB'
#!/bin/sh
if [ "$#" -eq 5 ] && [ "$1" = -a ] && [ "$3" = -n ] && [ "$4" = -e ]; then
  printf '%s\n' "$EMACS_TEST_FRAMES"
  exit 0
fi
printf '<%s>\n' "$@" > "$EMACS_TEST_LOG"
exit "${EMACS_TEST_EXIT:-0}"
STUB
chmod +x "$fixture_dir/emacsclient"

check() {
  description="$1"
  export EMACS_TEST_FRAMES="$2"
  expected="$3"
  shift 3
  "$test_shell" "$launcher" "$@"
  actual="$(cat "$EMACS_TEST_LOG")"
  if [ "$actual" != "$expected" ]; then
    printf 'FAIL: %s\nexpected:\n%s\nactual:\n%s\n' \
      "$description" "$expected" "$actual" >&2
    exit 1
  fi
  printf 'PASS: %s\n' "$description"
}

create_frame='<--alternate-editor=>
<--create-frame>'
reuse_frame='<--alternate-editor=>'

check 'bare emacs/e alias with a GUI frame' '(x)' "$create_frame
<--no-wait>" --no-wait
check 'empty launcher with a GUI frame' '(x)' "$create_frame"
check 'empty launcher without a frame' nil "$create_frame"
check 'bare emacs/e alias without a frame' nil "$create_frame
<--no-wait>" --no-wait
check 'file arguments reuse an existing GUI frame' '(x)' "$reuse_frame
<--no-wait>
<path with spaces [1].txt>
<second.txt>" --no-wait 'path with spaces [1].txt' second.txt
check 'file arguments create a missing GUI frame' nil "$create_frame
<--no-wait>
<file.txt>" --no-wait file.txt
check 'eeval reuses an existing frame' '(x)' "$reuse_frame
<--eval>
<(+ 1 2)>" --eval '(+ 1 2)'
check 'empty file operand stays unchanged' '(x)' "$reuse_frame
<--no-wait>
<>" --no-wait ''
check 'explicit terminal frame drops no-wait' '(t)' "$reuse_frame
<-nw>
<file.txt>" --no-wait -nw file.txt
check 'terminal alias without files stays unchanged' '(t)' "$reuse_frame
<-nw>" -nw
check 'tty flag drops no-wait' '(t)' "$reuse_frame
<-t>
<file.txt>" --no-wait -t file.txt
check 'missing terminal frame is created' nil "$create_frame
<--tty>
<file.txt>" --no-wait --tty file.txt

export EMACS_TEST_FRAMES='(x)'
export EMACS_TEST_EXIT=23
if "$test_shell" "$launcher" --no-wait; then
  printf 'FAIL: client exit status was lost\n' >&2
  exit 1
else
  result=$?
  [ "$result" -eq 23 ] || exit 1
fi
printf 'PASS: client exit status is preserved\n'
