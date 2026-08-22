#!/usr/bin/env zsh
# Test suite for semver-tag.plugin.zsh
# Run: zsh test.zsh
set -uo pipefail

PLUGIN_DIR="${0:A:h}"
PLUGIN="$PLUGIN_DIR/semver-tag.plugin.zsh"

pass_count=0
fail_count=0
typeset -a tmp_dirs

cleanup() {
  local d
  for d in "${tmp_dirs[@]}"; do
    rm -rf "$d"
  done
}
trap cleanup EXIT

# --- test harness -----------------------------------------------------

# make_repo [tag ...]  -> creates a fresh temp git repo, cds into it,
# and creates any given tags (all pointing at the same initial commit).
make_repo() {
  local dir
  dir=$(mktemp -d)
  tmp_dirs+=("$dir")
  cd "$dir"
  git init -q >/dev/null
  git commit --allow-empty -q -m "init"
  local t
  for t in "$@"; do
    git tag "$t"
  done
}

# run <stdin-line> <command...> -> sources the plugin and runs command
# with the given line piped to stdin. Sets $OUT and $STATUS.
run() {
  local stdin_line="$1"; shift
  # Newline (not `;`) between source and command: zsh parses a `;`-joined
  # -c line as one unit before executing any of it, so aliases defined by
  # `source` wouldn't yet be recognized when the rest of that line parses.
  OUT=$(print -r -- "$stdin_line" | zsh -c "source '$PLUGIN'
$*" 2>&1)
  STATUS=$?
}

assert_contains() {
  local desc="$1" haystack="$2" needle="$3"
  if [[ "$haystack" == *"$needle"* ]]; then
    pass_count=$((pass_count + 1))
  else
    fail_count=$((fail_count + 1))
    echo "FAIL: $desc"
    echo "  expected to contain: $needle"
    echo "  actual output: $haystack"
  fi
}

assert_not_contains() {
  local desc="$1" haystack="$2" needle="$3"
  if [[ "$haystack" != *"$needle"* ]]; then
    pass_count=$((pass_count + 1))
  else
    fail_count=$((fail_count + 1))
    echo "FAIL: $desc"
    echo "  expected NOT to contain: $needle"
    echo "  actual output: $haystack"
  fi
}

assert_tag_exists() {
  local desc="$1" tag="$2"
  if git rev-parse "$tag" >/dev/null 2>&1; then
    pass_count=$((pass_count + 1))
  else
    fail_count=$((fail_count + 1))
    echo "FAIL: $desc - tag '$tag' does not exist"
    echo "  tags present: $(git tag)"
  fi
}

assert_tag_absent() {
  local desc="$1" tag="$2"
  if ! git rev-parse "$tag" >/dev/null 2>&1; then
    pass_count=$((pass_count + 1))
  else
    fail_count=$((fail_count + 1))
    echo "FAIL: $desc - tag '$tag' should not exist"
  fi
}

assert_tag_type() {
  local desc="$1" tag="$2" expected_type="$3"
  local actual_type
  actual_type=$(git cat-file -t "$tag" 2>/dev/null)
  if [[ "$actual_type" == "$expected_type" ]]; then
    pass_count=$((pass_count + 1))
  else
    fail_count=$((fail_count + 1))
    echo "FAIL: $desc - expected tag type '$expected_type', got '$actual_type'"
  fi
}

assert_status() {
  local desc="$1" expected="$2" actual="$3"
  if [[ "$actual" == "$expected" ]]; then
    pass_count=$((pass_count + 1))
  else
    fail_count=$((fail_count + 1))
    echo "FAIL: $desc - expected exit $expected, got $actual"
  fi
}

# --- tests --------------------------------------------------------------

# Alias definitions (checked via the alias table directly, not by invoking
# them in the same non-interactive buffer - see note on `run()` above;
# in a real interactive shell these invoke fine, as already confirmed live).
alias_defs=$(zsh -c "source '$PLUGIN'
alias gtvM gtvm gtvp" 2>&1)
assert_contains "gtvM alias is gtM -v" "$alias_defs" "gtvM='gtM -v'"
assert_contains "gtvm alias is gtm -v" "$alias_defs" "gtvm='gtm -v'"
assert_contains "gtvp alias is gtp -v" "$alias_defs" "gtvp='gtp -v'"

# Not a git repo
tmpdir=$(mktemp -d)
tmp_dirs+=("$tmpdir")
cd "$tmpdir"
run "y" gtM
assert_contains "gtM outside a git repo errors" "$OUT" "Not inside a git repository."
assert_status "gtM outside a git repo exits 1" 1 "$STATUS"

# Decline aborts, creates nothing
make_repo
run "n" gtM
assert_contains "decline shows Aborted" "$OUT" "Aborted."
assert_status "decline exits 1" 1 "$STATUS"
assert_tag_absent "decline creates no tag" "1.0.0"

# Bootstrap: no tags
make_repo
run "y" gtM
assert_tag_exists "gtM bootstrap creates 1.0.0" "1.0.0"
assert_tag_type "gtM bootstrap is lightweight" "1.0.0" "commit"
assert_not_contains "bootstrap prompt has no 'latest tag' line (nothing to show)" "$OUT" "The latest tag is"

make_repo
run "y" gtm
assert_tag_exists "gtm bootstrap creates 0.1.0" "0.1.0"

make_repo
run "y" gtp
assert_tag_exists "gtp bootstrap creates 0.0.1" "0.0.1"

make_repo
run "y" gtM -v
assert_tag_exists "gtvM (gtM -v) bootstrap creates v1.0.0" "v1.0.0"

# Extra args are forwarded straight to `git tag` after the computed name
make_repo
run "y" gtM --annotate -m '"passthrough message"'
assert_tag_exists "gtM --annotate -m creates 1.0.0" "1.0.0"
assert_tag_type "gtM --annotate produces a real annotated tag object" "1.0.0" "tag"
assert_contains "annotated tag carries the forwarded message" "$(git cat-file -p 1.0.0)" "passthrough message"

# -v and passthrough args compose together
make_repo "v0.1.1"
run "y" gtM -v --annotate -m '"combo message"'
assert_tag_exists "gtM -v --annotate keeps v prefix" "v1.0.0"
assert_tag_type "gtM -v --annotate still produces an annotated tag object" "v1.0.0" "tag"

# No mismatch: gtM on non-v tags
make_repo "0.1.1"
run "y" gtM
assert_not_contains "gtM on non-v tags shows no mismatch warning" "$OUT" "are you sure"
assert_contains "prompt shows the latest tag before confirming" "$OUT" "The latest tag is 0.1.1"
assert_tag_exists "gtM bumps major on non-v tags" "1.0.0"

# Mismatch: gtM on v-tags
make_repo "v0.1.1"
run "y" gtM
assert_contains "gtM on v-tags shows mismatch warning" "$OUT" "are you sure"
assert_contains "mismatch warning names existing format" "$OUT" "The latest tag is v0.1.1"
assert_tag_exists "gtM on v-tags still bumps using real v prefix" "v1.0.0"

# No mismatch: gtvM (gtM -v) on v-tags
make_repo "v0.1.1"
run "y" gtM -v
assert_not_contains "gtvM (gtM -v) on v-tags shows no mismatch warning" "$OUT" "are you sure"
assert_tag_exists "gtvM (gtM -v) bumps major keeping v prefix" "v1.0.0"

# Mismatch: gtvM (gtM -v) on non-v tags
make_repo "0.1.1"
run "y" gtM -v
assert_contains "gtvM (gtM -v) on non-v tags shows mismatch warning" "$OUT" "are you sure"
assert_tag_exists "gtvM (gtM -v) on non-v tags still bumps using real (no) prefix" "1.0.0"

# Invalid tag format on latest -> refuse to guess
make_repo "release-42"
run "y" gtM
assert_contains "non-semver latest tag refuses to guess" "$OUT" "refusing to guess"
assert_status "non-semver latest tag exits 1" 1 "$STATUS"

# Latest-by-creation-date selection with multiple tags: the higher version
# number (5.0.0) is created first; the lower one (1.0.0) is created after,
# so it should win as "latest" despite being numerically smaller.
# Explicit dates avoid a same-second tie between the two commits.
make_repo
GIT_COMMITTER_DATE="2020-01-01T00:00:00" GIT_AUTHOR_DATE="2020-01-01T00:00:00" \
  git commit --allow-empty -q -m "c1" --amend --date="2020-01-01T00:00:00"
git tag 5.0.0
GIT_COMMITTER_DATE="2021-01-01T00:00:00" GIT_AUTHOR_DATE="2021-01-01T00:00:00" \
  git commit --allow-empty -q -m "c2"
git tag 1.0.0
run "y" gtM
assert_tag_exists "bumps from the most recently created tag, not highest version" "2.0.0"
assert_tag_absent "does not bump the numerically-higher but older tag" "6.0.0"

# --- summary --------------------------------------------------------------

echo
echo "Passed: $pass_count, Failed: $fail_count"
[[ "$fail_count" -eq 0 ]]
