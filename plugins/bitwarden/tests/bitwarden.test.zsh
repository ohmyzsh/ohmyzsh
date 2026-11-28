#!/usr/bin/env zsh

# Run the completion generator from a pseudo-terminal, where stdio is a real TTY.
emulate -LR zsh
zmodload zsh/zpty
zmodload zsh/zselect

test_dir=$(mktemp -d) || exit 1
trap 'zpty -d bitwarden-test 2>/dev/null; command rm -rf -- "$test_dir"' EXIT
mkdir -p "$test_dir/bin" "$test_dir/completions" || exit 1

export BITWARDEN_TEST_PLUGIN=${1:-${0:A:h:h}/bitwarden.plugin.zsh}
export BITWARDEN_TEST_TTY_FDS=$test_dir/tty-fds
export ZSH_CACHE_DIR=$test_dir

typeset -i failures=0 tests=0

cat > "$test_dir/bin/bw" <<'BW'
#!/bin/sh
for fd in 0 1 2; do [ -t "$fd" ] && echo "$fd" >> "$BITWARDEN_TEST_TTY_FDS"; done
echo '#compdef bw'
BW
chmod +x "$test_dir/bin/bw"

cat > "$test_dir/setup.zsh" <<'SETUP'
zmodload zsh/zselect
typeset -gA _comps
source "$BITWARDEN_TEST_PLUGIN"
for i in {1..500}; do
  [[ -s $ZSH_CACHE_DIR/completions/_bw ]] && break
  zselect -t 1
done
SETUP

zpty bitwarden-test "PATH=${(q)test_dir}/bin:/usr/bin:/bin ${(q)commands[zsh]} -dfi ${(q)test_dir}/setup.zsh"
typeset -i deadline=$(( SECONDS + 5 ))
while [[ ! -s "$test_dir/completions/_bw" ]] && (( SECONDS < deadline )); do
  zselect -t 1
done

(( tests++ ))
if [[ -s "$test_dir/completions/_bw" ]]; then
  print -r -- 'PASS: completion cache is generated'
else
  print -u2 -r -- 'FAIL: completion cache is generated'
  (( failures++ ))
fi

(( tests++ ))
if [[ ! -e "$BITWARDEN_TEST_TTY_FDS" ]]; then
  print -r -- 'PASS: generator does not inherit the TTY'
else
  print -u2 -r -- 'FAIL: generator does not inherit the TTY'
  print -u2 -r -- "  TTY fds: ${(f)$(<"$BITWARDEN_TEST_TTY_FDS")} (expected none)"
  (( failures++ ))
fi

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))
