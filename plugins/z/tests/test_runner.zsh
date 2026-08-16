# Contract tests for tests/run.zsh. Each test builds a minimal isolated tree
# containing a copied runner, a stub plugin/helper, and one fixture test where
# needed. This keeps deliberate source failures away from the real suite.

_runner_fixture_setup() {
  local root="$TESTDIR/runner-fixture"
  mkdir -p "$root/tests"
  cp "$TESTS_DIR/run.zsh" "$root/tests/run.zsh"
  print 'return 0' > "$root/zsh-z.plugin.zsh"
  print '_xargs_supports_P() { return 1; }' > "$root/tests/test_helpers.zsh"
  REPLY=$root
}

test_runner_reports_plugin_source_failure() {
  _runner_fixture_setup
  local root=$REPLY out rc
  print 'return 17' > "$root/zsh-z.plugin.zsh"

  out=$(zsh "$root/tests/run.zsh" 2>&1)
  rc=$?

  assert_eq "2" "$rc" "plugin source failure should be a runner error"
  assert_contains "Failed to source $root/zsh-z.plugin.zsh" "$out" \
    "plugin source failure should name the file"
}

test_runner_reports_helper_source_failure() {
  _runner_fixture_setup
  local root=$REPLY out rc
  print 'return 17' > "$root/tests/test_helpers.zsh"

  out=$(zsh "$root/tests/run.zsh" 2>&1)
  rc=$?

  assert_eq "2" "$rc" "helper source failure should be a runner error"
  assert_contains "Failed to source $root/tests/test_helpers.zsh" "$out" \
    "helper source failure should name the file"
}

test_runner_reports_test_file_source_failure() {
  _runner_fixture_setup
  local root=$REPLY out rc
  print 'return 17' > "$root/tests/test_broken.zsh"

  out=$(zsh "$root/tests/run.zsh" 2>&1)
  rc=$?

  assert_eq "2" "$rc" "test-file source failure should be a runner error"
  assert_contains "Failed to source $root/tests/test_broken.zsh" "$out" \
    "test-file source failure should name the file"
}

test_runner_reports_explicit_skip() {
  _runner_fixture_setup
  local root=$REPLY out rc
  cat > "$root/tests/test_fixture.zsh" <<'FIXTURE'
test_fixture_skip() {
  print "skip: fixture capability unavailable"
  return 0
}
FIXTURE

  out=$(zsh "$root/tests/run.zsh" 2>&1)
  rc=$?

  assert_eq "0" "$rc" "a skipped fixture should not fail the runner"
  assert_contains "SKIP  test_fixture_skip (fixture capability unavailable)" \
    "$out" "the runner should display the explicit skip reason"
  assert_contains "Results: 0 passed, 1 skipped, 0 failed of 1" "$out" \
    "the skipped fixture should be counted separately"
}

test_runner_failure_takes_precedence_over_skip_marker() {
  _runner_fixture_setup
  local root=$REPLY out rc
  cat > "$root/tests/test_fixture.zsh" <<'FIXTURE'
test_fixture_failure_precedes_skip() {
  print "skip: deliberately misleading marker"
  return 7
}
FIXTURE

  out=$(zsh "$root/tests/run.zsh" 2>&1)
  rc=$?

  assert_eq "1" "$rc" "a failing fixture should fail the runner"
  assert_contains "FAIL  test_fixture_failure_precedes_skip (rc=7)" "$out" \
    "a nonzero status should take precedence over a skip marker"
  assert_not_contains "SKIP  test_fixture_failure_precedes_skip" "$out" \
    "a failing fixture must not be classified as skipped"
  assert_contains "Results: 0 passed, 0 skipped, 1 failed of 1" "$out" \
    "the failing fixture should be counted only as a failure"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
