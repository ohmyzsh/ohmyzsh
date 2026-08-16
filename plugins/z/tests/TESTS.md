# Zsh-z test suite

Aimed at contributors authoring or reviewing tests for `zsh-z`.

The suite lives on the `tests` branch of the repository (it is merged
into branches that need to run CI against it). Everything under
`tests/` is sourced into a single zsh process per run, with each test
function executed inside an isolated subshell.

## Running the suite

```sh
zsh tests/run.zsh                              # everything (fast tests)
zsh tests/run.zsh test_concurrent_add_no_lost_updates  # one test
zsh tests/run.zsh 'test_concurrent_*'          # glob match
ZSHZ_HEAVY_TESTS=1 zsh tests/run.zsh 'test_large_*'    # opt-in heavy tests
PATH=~/zsh/4.3.11/bin:$PATH zsh tests/run.zsh  # against an alternate zsh (see note)
tests/stress.sh ~/bin/zsh-4.3.11               # cross-process stress driver
```

The runner itself uses whichever `zsh` invoked it, so to exercise both
supported versions locally you run it twice. CI covers both versions
plus the Windows POSIX layers as separate jobs — see the
`.github/workflows/test.yml` section below.

**Put the zsh under test on `PATH`, not just in the command.** Several
tests spawn *child* `zsh` processes — `zshz_in_fresh_shell`, and the
concurrency and lock-timeout tests — and invoke them as a bare `zsh`
resolved through `PATH`. So `~/zsh/4.3.11/bin/zsh tests/run.zsh` runs
4.3.11 only for the in-process tests; the spawned children fall back to
whatever `zsh` is first on `PATH` (or fail outright if none is
installed). Prepend the build so the runner and its children are the
same interpreter — `PATH=~/zsh/4.3.11/bin:$PATH zsh tests/run.zsh` —
which is what the 4.3.11 CI job does.

The suite has been verified on WSL2 Ubuntu (zsh 5.9 and 4.3.11),
Solaris 11.4, FreeBSD, and MSYS2. Cygwin runs cleanly modulo one
test that skips because `zpty -b` can't acquire a pty there.
MobaXterm's Cygwin doesn't ship `zsh/system` at all, so the five
flock-dependent concurrency tests also skip there — the plugin's
no-lock fallback genuinely can't serialize cross-process writers,
so the tests gate on `(( ZSHZ[USE_FLOCK] ))`. MSYS2 reports
`$OSTYPE=cygwin` but ignores `chmod` on its Windows-backed
filesystem, so the four mode-checking tests in `test_permissions.zsh`
skip there via a runtime probe rather than an `$OSTYPE` match.
macOS's default case-insensitive volumes (APFS, HFS+) likewise skip
the one case-sensitive tie-break test in `test_case.zsh`, again via a
filesystem probe rather than an `$OSTYPE` match. MSYS2 without
native-symlink support (e.g. a stock GitHub Actions runner) makes
`ln -s` produce a copy or a Windows stub rather than a resolvable
POSIX symlink, so the six symlink-*resolution* tests in
`test_symlinks.zsh` and `test_symlink_realpath.zsh` skip via the
`_test_skip_no_symlinks` probe — they still run wherever symlinks
actually resolve, including MSYS2 with Developer Mode.

## How `tests/run.zsh` runs a test

1. The zsh glob `"$TESTS_DIR"/test_*.zsh(.N)` collects every test
   file in sorted order; `run.zsh` then sources each in turn. (zsh
   globs are sorted by default, so no separate `sort` is needed.
   The previous `find -maxdepth 1` form isn't portable to
   AT&T-derived `find` on Solaris.)
2. Every function whose name starts with `test_` becomes a test. They
   are sorted by name so execution order is stable.
3. Optional command-line arguments are treated as **globs against
   function names** (each arg is matched independently, ANY-match
   semantics).
4. For each test the runner does:
   - `mktemp -d` to a fresh `$TESTDIR`, then canonicalizes it with
     `cd && pwd -P` so the path matches what Zsh-z stores. On macOS
     `$TMPDIR` lives under `/var` (a symlink to `/private/var`) and
     carries a trailing slash, so the raw `mktemp` path would differ
     from the symlink- and slash-normalized form tests assert against.
   - exports `ZSHZ_DATA="$TESTDIR/.z"`,
   - runs the function inside `( ZSHZ_DEBUG=1; cd "$TESTDIR"; "$fn" )`
     so cd / env / option changes never leak,
   - captures stdout to `$STDOUT_LOG`, stderr to `$STDERR_LOG`,
   - removes the tempdir afterward.
5. A test is reported `PASS` if and only if **both** are true:
   - the function returned 0,
   - **stderr is empty**.

The "stderr is empty" rule is doing real work. `WARN_CREATE_GLOBAL`,
`NO_UNSET` warnings, "parameter not set" messages, accidental
`echo >&2`s, and external-command errors all surface as test failures
without any explicit assertion. Tests that legitimately call commands
which write to stderr must redirect that stderr away (`2>/dev/null`)
or capture it (`2>&1` inside `$(...)`).

A test sets `ZSHZ_DEBUG=1`, which causes `zshz()` to additionally
`setopt LOCAL_OPTIONS WARN_CREATE_GLOBAL`. Any code path that
accidentally creates a global from inside `zshz` will print a
warning, which then fails the test under the stderr rule.

## Environment a test sees

| Variable | Set by | What it points at |
|---|---|---|
| `$TESTDIR` | runner, per test | A fresh tempdir; cleaned up afterwards |
| `$ZSHZ_DATA` | runner, per test | `$TESTDIR/.z`; auto-created by the plugin on first call |
| `$PLUGIN_DIR` | runner, once at startup | The repository root (parent of `tests/`) |
| `$TESTS_DIR` | runner, once at startup | The directory containing `run.zsh` |
| `$PWD` | runner, per test | `$TESTDIR` (the test runs after `cd "$TESTDIR"`) |
| `$ZSHZ_DEBUG` | runner, per test | `1` |
| `setopt EXTENDED_GLOB` | runner, globally | On (so glob qualifiers like `(N)` work in tests) |

The plugin is sourced **once** by `run.zsh` before any test runs, so
its functions (`zshz`, `_zshz_precmd`, `_zshz_chpwd`,
`_zshz_zle_completion_widget`) and globals (`ZSHZ`, `ZSHZ_*`) are
visible to every test. Tests that need to verify *sourcing* behavior
(e.g. emulation modes, strict options) explicitly spawn a child shell
and source the plugin there.

## Helpers in `test_helpers.zsh`

Always available in every test (sourced by `run.zsh`).

### Assertions

All assertions use `fail` to write a single indented line to stderr
on failure (which the runner reports under `--- stderr ---`).

- `fail MESSAGE` — write to stderr, return 1.
- `assert_eq EXPECTED ACTUAL [MSG]` — string equality.
- `assert_ne UNEXPECTED ACTUAL [MSG]` — string inequality.
- `assert_contains NEEDLE HAYSTACK [MSG]` — substring match.
- `assert_not_contains NEEDLE HAYSTACK [MSG]` — substring absence.
- `assert_file_exists PATH` — `[[ -f PATH ]]`.

### Datafile inspection

- `zshz_rank_of PATH` — print the rank field for PATH from
  `$ZSHZ_DATA`, or empty string if the path isn't there or the
  datafile doesn't exist. Implemented as `awk -F'|'`.
- `zshz_dump` — print the entire datafile sorted by path (stable
  output for diffing).

### Datafile seeding

- `zshz_seed PATH RANK [SECONDS_AGO]` — append a synthetic
  `PATH|RANK|TIMESTAMP` line to `$ZSHZ_DATA`. `SECONDS_AGO` defaults
  to 0 (now). Useful for setting up scenarios that would take many
  real `--add` calls to produce.

### Spawning fresh shells

- `zshz_in_fresh_shell BODY` — run BODY in `zsh --no-rcs -c "..."`
  with Tab pre-bound to `expand-or-complete` and the plugin sourced.
  Used by tests that need to observe behavior at source time, or
  that need a clean ZSHZ-internal state.

### Parallel command spawning

- `xargs_P NPROC CMD ARGS...` — drop-in replacement for
  `xargs -P NPROC -I {} CMD ARGS...`. Reads stdin, substitutes
  `{}` in each arg with the line, and runs up to NPROC in parallel.
  Where the system `xargs` supports `-P` (GNU on Linux, modern
  BSDs), `xargs_P` execs straight into xargs. Where it doesn't
  (Solaris, AT&T xargs), it falls back to backgrounded `zsh -c`
  + `wait`.

  **Callers must wrap the invocation in `( ... )` on the right side
  of the pipe:**

  ```zsh
  producer | ( xargs_P 4 \
      env ZSHZ_LOCK_TIMEOUT=30 zsh -c \
        "source '$PLUGIN_DIR/zsh-z.plugin.zsh'; zshz --add '{}'" )
  ```

  Two reasons for the call-site parens: (1) zsh does not fork the
  right side of a pipe when it's a function or block, so the
  `exec` inside `xargs_P` would otherwise replace the *caller's*
  shell; the parens force a real subshell for the exec to consume.
  (2) An equivalent `( ... )` inside the function body triggers
  SIGBUS on zsh 4.3.11 at higher fork counts — the parens must be
  at the call site, not in the function.

- `_xargs_supports_P` — probes whether the system `xargs` supports
  `-P`. Caches the result in `_XARGS_P_OK` (exported, so per-test
  subshells inherit it). `run.zsh` calls this once at startup so
  each test subshell skips the re-probe.

### Capability probes

- `_test_skip_no_symlinks` — returns 0 (skip) when the filesystem
  can't create a real POSIX symlink that resolves to its target — as
  on MSYS2 without native-symlink support, where `ln -s` yields a copy
  or a Windows stub — and 1 (run) when it can. A runtime probe, not an
  `$OSTYPE` match. Gates the symlink-resolution tests in
  `test_symlinks.zsh` and `test_symlink_realpath.zsh`; callers skip
  with `_test_skip_no_symlinks && { print "skip: ..."; return 0 }`.

## Cross-file helpers

Helpers defined in one test file but used elsewhere. Defined as
top-level functions so they live in the same global namespace as
the test functions themselves.

- `_wait_for_add TARGET` (in `test_hooks.zsh`) — poll `$ZSHZ_DATA`
  up to 2 s for `TARGET` to appear. Necessary because
  `_zshz_precmd` backgrounds `zshz --add "$PWD"` with `&!` (fork +
  disown), so `wait` can't see it.
- `_wait_for_remove TARGET` (in `test_hooks.zsh`) — symmetric: poll
  for absence.
- `_zshz_test_zsh_bin` (in `test_emulate.zsh`,
  `test_strict_options.zsh`, `test_config_errors.zsh`) — print the
  same zsh binary the runner is using by reading
  `/proc/$$/exe`, falling back to `${commands[zsh]}`. Lets a
  child-shell-spawning test exercise the running zsh, including
  4.3.11 when the runner is invoked under it.
- `_seed_n_entries N` (in `test_scale.zsh`) — bulk-seed N entries
  into `$ZSHZ_DATA` in a single redirected block. Calling
  `zshz_seed` in a loop is much slower at large N because each
  call opens the datafile; this writes once.

## Conventions for new tests

- **Name with a `test_` prefix.** Anything else is treated as a
  helper.
- **Use `$TESTDIR` and `$ZSHZ_DATA` as given.** Don't `unset` them or
  point them somewhere else; the runner relies on them for cleanup.
  If a test needs an isolated datafile, create a sub-tempdir under
  `$TESTDIR`.
- **No stderr noise.** If a test legitimately invokes commands that
  emit to stderr, redirect or capture it explicitly. The "no stderr"
  rule is the suite's primary safety net against silent regressions.
- **`local` everything.** With `ZSHZ_DEBUG=1` active in tests,
  `WARN_CREATE_GLOBAL` will flag any accidental global from inside
  `zshz` itself; tests don't get the same protection automatically,
  but `local` is still the right discipline.
- **Use `xargs_P` for concurrent writers.** zsh 4.3.11's `&`/`wait`
  machinery segfaults under fork load (rc 135), and Solaris `xargs`
  doesn't support `-P`. The `xargs_P` helper papers over both;
  the call must be wrapped in `( ... )` on the right side of the
  pipe (see the helper docs for why). Related patterns:
  - `_zshz_precmd` uses `&!` (fork + disown) instead of `&`, both
    to dodge the 4.3.11 segfault and to suppress the "Done"
    notification at the next prompt.
  - `test_lock_timeout.zsh` uses `&!` for its lock-holder so no
    `wait` is needed. Apply the same pattern in any new
    contention test.
- **Linux-only path inspection is allowed but should fall back
  gracefully.** Child-shell tests read `/proc/$$/exe` and fall
  back to `${commands[zsh]}` when that's missing (Solaris,
  Cygwin). Tests that rely on `/proc/self/fd/*` or `zsh/zpty`
  print `skip: ...` and `return 0` when the prerequisite isn't
  available rather than failing.
- **Heavy or expensive tests must be gated.** See the
  `ZSHZ_HEAVY_TESTS=1` gate in `test_scale.zsh`. The default run
  is meant to be fast (a few seconds).
- **Pin behavior, don't reproduce it.** Each test should encode an
  invariant the project commits to keeping. If a test is just
  exercising code paths without an assertion, the runner has nothing
  to fail against.

## Commit-message style for test changes

Subject-line only — body optional, only when the change has more
context than fits in a subject. The subject follows this shape:

```
tests: <verb> <what the test checks>
```

Conventions:

- **`tests:` prefix**, lowercase, single colon.
- **Verb choices**, in rough order of precision: `assert`, `pin`,
  `confirm`, `cover`, `extend`, `add`. Prefer the verb that
  describes what the suite *now guarantees* — `assert` and `pin`
  are usually right for a single test; `cover` and `extend` fit
  when the change broadens coverage of an existing area; `add`
  is the fallback for a brand-new file with no clearer single-line
  framing.
- **Plain English over jargon.** "opt-in via `ZSHZ_HEAVY_TESTS`"
  reads better than "gated on `ZSHZ_HEAVY_TESTS`"; "shrinks ranks
  rather than removing entries" reads better than "scales not
  deletes." Literal symbol names (`--add`, `&!`, `ZSHZ_LOCK_TIMEOUT`)
  are fine when they're the most precise referent.
- **Describe what the test pins, not the activity of adding it.**
  Bad: `tests: add aging test`. Better: `tests: confirm
  ZSHZ_MAX_SCORE shrinks ranks rather than removing entries`.
- **Keep it under ~70 characters** when reasonable; ~80 is fine if
  the precision is worth it.

Examples from this suite:

```
tests: assert &! precmd emits no Done line in interactive shell
tests: assert ZSHZ_LOCK_TIMEOUT bails out and leaves the datafile alone
tests: assert pre-existing entries survive concurrent --add calls
tests: pin _zshz_find_common_root behaviour across input orderings
tests: pin manual --add defenses against $HOME and excluded dirs
tests: confirm ZSHZ_MAX_SCORE shrinks ranks rather than removing entries
tests: cover symlink realpath edge cases beyond same-link round-trip
tests: cover ZSHZ_KEEP_DIRS edge cases beyond simple subtree protection
tests: extend datafile-robustness coverage
tests: add a scale-smoke suite, opt-in via ZSHZ_HEAVY_TESTS
```

## File-by-file index

Each section lists every `test_*` function in the file with one
sentence describing what it pins. Helpers (`_*` functions) appear
after the tests when they're file-local; cross-file helpers are
documented in the section above.

### `test_aging.zsh` — frecency aging at the `ZSHZ_MAX_SCORE` threshold

`_zshz_update_datafile` divides every rank by 0.99 once the total
crosses `ZSHZ_MAX_SCORE`. The transition is easy to break with off-by-
one or boolean errors.

- `test_no_aging_below_max_score` — with `ZSHZ_MAX_SCORE=1000`, five
  consecutive `--add`s leave the rank at exactly 5 (no aging).
- `test_aging_kicks_in_above_max_score` — with `ZSHZ_MAX_SCORE=5`,
  seven `--add`s push the running total over the threshold; the rank
  ends in (6, 7) — short of the literal 7 because the seventh write
  triggers aging by 0.99.
- `test_aging_drops_entries_below_rank_1` — entries already below
  rank 1 (seeded directly) are dropped from the rewritten datafile,
  not preserved.

### `test_aging_threshold.zsh` — aging is a scale, not a delete

Fills the small gaps between `test_aging.zsh` (single-entry
threshold transition) and `test_scale.zsh` (aging at scale): aging
must scale every entry, not just the added one; entries above the
sub-1 drop threshold survive aging; the time field is preserved.

- `test_aging_scales_all_existing_entries` — three pre-seeded
  entries (ranks 100/200/300); after one `--add` past the
  threshold, each is scaled to roughly 0.99 × original. Catches a
  bug that aged only the `--add`-ed entry's rank.
- `test_aging_does_not_delete_entries_above_drop_threshold` — a
  rank-5 and a rank-50 entry both survive aging, ruling out a
  regression where aging was implemented as deletion.
- `test_aging_preserves_timestamps` — the aging branch rewrites
  each entry as `path|0.99*rank|time`; the time field must pass
  through verbatim.

### `test_basic.zsh` — smoke tests for `--add`, `-x`, `-l`, `-e`

- `test_add_creates_entry_with_rank_1` — first `--add` to a path
  produces rank 1.
- `test_add_same_path_twice_increments_rank` — repeated adds bump the
  rank linearly.
- `test_add_skips_HOME` — `zshz --add $HOME` is silently rejected.
- `test_add_skips_excluded_dir` — `ZSHZ_EXCLUDE_DIRS` rejection on
  the manual `--add` path.
- `test_add_skips_subtree_of_excluded_dir` — exclusion applies to
  subdirectories too.
- `test_add_nonexistent_path_returns_nonzero` — adding a path that
  doesn't exist on disk fails cleanly.
- `test_remove_drops_entry` — `zshz -x` removes an exact-match path.
- `test_remove_R_drops_subtree` — `zshz -xR` removes a directory and
  all of its descendants.
- `test_remove_R_missing_path_leaves_database_alone` — `-xR` on a
  path that does not exist reports failure and leaves every entry
  alone. An unresolved target left `$xdir` empty, and `${xdir%/}/**`
  then collapsed to `/**`, which matches every line in the datafile:
  the call wiped the whole database and reported success.
- `test_remove_deleted_dir_entry` — a stale entry whose directory has
  since been deleted is exactly the one a user most wants gone, so
  `-x` must not require the target to still be on disk.
- `test_remove_R_deleted_dir_drops_subtree` — the same for `-xR`: a
  deleted directory and its recorded descendants go, while a sibling
  entry stays.
- `test_remove_missing_toplevel_path_does_not_segfault` — `${x:A}`
  segfaults Zsh 4.3.11 when the top-level component of the path does
  not exist, so `z -x /gone/sub` used to kill the interactive shell
  there. `_zshz_realpath` keeps such paths away from `:A`. The
  removal runs in a disposable shell of the same Zsh and prints a
  sentinel afterwards, so a regression reports as a missing sentinel
  rather than as a dead test subshell; the entry must also be gone.
- `test_list_shows_added_paths` — `zshz -l` prints each added path
  on its own line.
- `test_echo_returns_best_match` — `zshz -e <substr>` prints the
  matched path without changing directories.

### `test_c_flag.zsh` — `-c` restricts matches to subdirectories of `$PWD`

- `test_c_flag_picks_match_under_pwd` — `zshz -c <substr>` from a
  parent directory matches a child entry.
- `test_c_flag_excludes_paths_outside_pwd` — entries outside `$PWD`
  are filtered out even when their name would otherwise match.

A mirrored tree — an `rsync --relative` backup root, say — stores
paths that contain `$PWD` as an interior substring. `-c` prefixes the
query with `"$PWD "` and anchors the pattern at the start of each
candidate, so those mirrors match nothing.

- `test_c_flag_excludes_mirror_embedding_pwd` — a mirror that embeds
  `$PWD` mid-path is not matched, and the call reports failure when
  it is the only candidate.
- `test_c_flag_prefers_real_subdir_over_higher_ranked_mirror` — the
  mirror is deliberately given the higher rank, so anchoring rather
  than frecency has to be what excludes it; the real subdirectory
  still wins.
- `test_c_flag_at_root_matches_like_a_plain_query` — at `/` every
  path is already under `$PWD`, so no `"$PWD "` prefix is prepended
  and `-c` has nothing to exclude. Anchoring the bare query there
  would match nothing whatever the search term, since no absolute
  path begins with one.

### `test_case.zsh` — `ZSHZ_CASE` controls case-sensitivity

- `test_case_default_falls_back_to_insensitive` — default mode tries
  case-sensitive first, then case-insensitive when nothing matched.
- `test_case_default_prefers_sensitive_when_both_available` — given
  both a case-matching and a case-folded match, default mode picks
  the case-matching one. Skips on case-insensitive volumes (macOS's
  default APFS, HFS+), where `Foo/Bar` and `foo/bar` collapse to one
  directory and the tie-break can't be set up. The guard
  (`_test_skip_case_insensitive_fs`) probes the live filesystem
  rather than matching `$OSTYPE`, since case sensitivity is a
  per-volume property, not a per-OS one.
- `test_case_ignore_always_insensitive` — `ZSHZ_CASE=ignore` matches
  regardless of case.
- `test_case_smart_lowercase_query_is_insensitive` — `smart` with
  an all-lowercase query matches case-insensitively.
- `test_case_smart_uppercase_query_is_strict` — `smart` with any
  uppercase character in the query is case-sensitive.

### `test_cd.zsh` — `ZSHZ_CD` substitutes the directory-changer

- `test_jump_uses_default_cd_without_ZSHZ_CD` — without
  `ZSHZ_CD`, jumps use the builtin `cd`.
- `test_jump_uses_ZSHZ_CD_when_set` — with `ZSHZ_CD=pushd`, jumps
  push onto the directory stack.
- `test_ZSHZ_CD_supports_multi_word_command` — `ZSHZ_CD` may contain
  multiple words (e.g. wrapped in a logger).

### `test_cleanup.zsh` — stale-entry pruning and `ZSHZ_KEEP_DIRS`

`_zshz_update_datafile` drops entries whose directories no longer
exist when it rewrites; `ZSHZ_KEEP_DIRS` exempts matching paths.

- `test_stale_entry_pruned_on_next_write` — an entry whose backing
  directory was removed disappears the next time anything triggers a
  rewrite.
- `test_keep_dirs_protects_subtree` — entries under a `KEEP_DIRS`
  prefix survive even after the directory is gone.
- `test_keep_dirs_protects_exact_match` — the literal `KEEP_DIRS`
  path itself survives.

### `test_cli.zsh` — help and invalid-option handling

- `test_help_short_prints_usage` — `zshz -h` prints the usage block.
- `test_help_long_prints_usage` — `zshz --help` does the same.
- `test_invalid_option_prints_error_and_usage` — unknown options
  print an error and the usage.
- `test_complete_does_not_trigger_add_side_effect` — using `--complete`
  doesn't end up calling `--add` as a side effect.
- `test_complete_does_not_trigger_remove_side_effect` — same but for
  `-x`.
- `test_complete_help_combo_is_silent` — `--complete --help` together
  must not surface output through the completion path.

Option processing loops over `${(k)opts}`, i.e. in hash-bucket order,
so where two options write the same result variable the winner used
to be arbitrary. These pin the resolutions.

- `test_rank_and_recent_combo_is_rejected` — `-r` (rank) and `-t`
  (recent) name mutually exclusive sort keys, so combining them is
  contradictory and is refused rather than settled by option order.
  All four spellings are checked — spaced and clustered, either way
  round — and each must fail and explain the conflict.
- `test_rank_or_recent_alone_still_works` — the control: the
  rejection must not catch a single sort option, so `-r` and `-t`
  each still succeed and find the match.
- `test_complete_list_combo_yields_completion_format` — completing
  `z -l foo<TAB>` reaches `zshz` as `zshz --complete -l foo`, so
  `--complete` has to beat `-l` whichever order the options are
  visited in. Asserts the output is byte-identical to plain
  `--complete` — bare paths, not rank-padded list rows.
- `test_complete_rank_recent_combo_is_not_rejected` — the `-r`/`-t`
  rejection is deliberately suppressed under `--complete`, where
  ordering is cosmetic and an error must never reach the terminal
  mid-completion. Asserts status 0, empty stderr, and that
  completions are still produced.

### `test_common_root.zsh` — `_zshz_find_common_root` ordering

`_zshz_find_common_root` is nested inside `zshz()` so we drive it
through `zshz -e` against datafiles seeded in deliberate orders.
Pins behavior across array-iteration orderings so a future rewrite
preserves them.

- `test_common_root_seeded_root_first` — three siblings + their root,
  root seeded first, root is returned.
- `test_common_root_seeded_root_middle` — same content, root seeded
  between the siblings, same outcome.
- `test_common_root_seeded_root_last` — same content, root seeded
  last, same outcome.
- `test_common_root_no_root_entry_picks_highest_ranked` — siblings
  only (no root entry), the function returns nothing and the highest-
  ranked sibling wins.
- `test_common_root_mixed_depth_under_one_root` — depths 1/2/3 under
  one root, the shortest entry wins regardless of rank.
- `test_common_root_deep_with_irrelevant_high_rank_neighbour` — a
  high-rank entry that doesn't match the query must not influence
  the choice.
- `test_common_root_single_match_returns_full_path` — degenerate
  single-match case.

### `test_complete_aliases.zsh` — tab completion under `setopt COMPLETE_ALIASES`

`compinit` parses the static `#compdef` tag in `_zshz` literally, so the
`${ZSHZ_CMD:-...}` part of the tag is never expanded and only the literal
`zshz` command gets registered. Without `COMPLETE_ALIASES` that's fine
(zsh expands the alias to `zshz` before looking up `_comps[zshz]`); under
`COMPLETE_ALIASES` the lookup is verbatim and would miss `_zshz`. The
widget compensates by populating `_comps[$cmd]` on first invocation,
guarded so a user-defined completer for the same name isn't clobbered.

Tests stub `zle` to a no-op and invoke `_zshz_zle_completion_widget`
directly (same pattern as `test_widget.zsh`) so the registration branch
can be exercised without a real ZLE session.

- `test_alias_is_defined_after_sourcing` — sanity: `aliases[z]` is
  `zshz 2>&1` after the plugin is sourced.
- `test_static_compdef_registers_zshz_literal` — sanity: `compinit`
  picks up the literal `zshz` from the `#compdef` tag, which is what
  makes completion work in the common no-`COMPLETE_ALIASES` case.
- `test_widget_registers_alias_on_first_invocation` — without
  `COMPLETE_ALIASES`, one widget call still binds `_comps[z]` to
  `_zshz` (the registration runs regardless of the option).
- `test_widget_registers_alias_under_complete_aliases` — the headline
  scenario: `COMPLETE_ALIASES` set, one widget call leaves
  `_comps[z] = _zshz`.
- `test_widget_registers_alias_for_custom_ZSHZ_CMD` — with
  `ZSHZ_CMD=zoo`, the widget binds `_comps[zoo]`, not `_comps[z]`.
- `test_widget_does_not_overwrite_existing_comps_entry` — if the user
  has pre-set `_comps[z]` to another completer, the
  `(( ${+_comps[$cmd]} )) ||` guard must defer rather than clobber.

### `test_completion.zsh` — frecent completion ordering

- `test_completion_orders_near_equal_ranks_by_value` — the completion
  list sorts on an integer key, so near-equal ranks whose fractional
  tails differ in width (100.5 vs 100.25) order by value, not by a
  raw-float digit-run comparison.

### `test_completion_legacy.zsh` — legacy completion mode

- `test_legacy_complete_returns_matches` — `ZSHZ_COMPLETION=legacy`
  surfaces alphabetic matches via the completion path.
- `test_legacy_complete_trailing_slash_matches_directory_end` —
  `ZSHZ_TRAILING_SLASH` tightens the match boundary at the end of
  paths.

### `test_concurrency.zsh` — concurrent `--add` correctness

The original concurrency suite. Spawns writers via `xargs_P` (see
the helper docs above) so the children belong to xargs rather than
to the test shell, avoiding zsh 4.3.11's `&`/`wait` segfault under
fork load. On systems without `xargs -P` (Solaris, AT&T xargs),
`xargs_P` falls back to backgrounded `zsh -c` + `wait`. Tests bump
`ZSHZ_LOCK_TIMEOUT=30` so honest contention isn't mistaken for a
regression. Each test gates on `(( ZSHZ[USE_FLOCK] ))` and skips
when `zsh/system` isn't available — the no-lock fallback can't
serialize cross-process writers, so the contract isn't testable
there.

- `test_concurrent_add_no_lost_updates` — 20 writers add the same
  path in parallel; the final rank is exactly 20 (none lost). Retries
  up to three times, starting from an empty datafile each attempt, and
  passes if any attempt reaches the full count. On real POSIX locks the
  first attempt yields 20 every run; MSYS2's emulated locks (over a
  Windows filesystem) very rarely drop one update under contention — a
  ~3% environmental flake. An honest locking regression loses updates
  on essentially every run, so it fails all three attempts, while the
  emulation hiccup clears on a re-run.
- `test_lock_fd_does_not_leak_across_repeated_adds` — two synchronous
  `--add`s in the runner shell, then an external probe with a 1 s
  timeout that would fail if the runner had leaked an open lock fd
  (POSIX advisory locks are per-process; a leaked fd would silently
  hold the lock until shell exit).
- `test_concurrent_add_two_paths_each_independent` — 30 writers
  alternating between two paths; each path ends at its expected
  count, neither's updates are lost to the other's rewrite.

### `test_concurrent_mixed.zsh` — concurrent `--add` and `-x` interleaved

- `test_concurrent_add_and_remove_interleaved` — 23 deliberately
  mixed ops across four paths via `xargs_P 4`. Doesn't assert exact
  ranks (order-dependent) but pins (a) every datafile line still
  matches `/path|rank|time`, (b) no `${datafile}.${RANDOM}` tempfile
  is left behind, (c) D — added but never removed — is present at
  the end. All three are asserted on every platform: writes are
  serialized by `zsystem flock` where it exists and by the `mkdir`
  fallback where it does not. (b) and (c) were briefly gated on flock,
  back when the fallback path had no lock and D went missing in 7 of 10
  MobaXterm runs; with the fallback lock this is one of the few places
  that would notice it regressing.

### `test_config_errors.zsh` — config errors `return`, never `exit`

Stronger version of the existing `test_datafile.zsh` checks: those
asserted that `zshz -l && print SENTINEL` doesn't print SENTINEL,
which can't tell "zshz returned non-zero" from "the whole shell
exited." These tests place a sentinel **after** the failing call and
assert it *does* appear, which only happens if the calling shell
survived.

- `test_old_zsh_version_check_returns_does_not_exit` — shims
  `is-at-least` to return false and `autoload` to a no-op;
  source-with-failed-version prints its error and the calling shell
  continues.
- `test_bare_ZSHZ_DATA_returns_does_not_exit` — `ZSHZ_DATA=barefile`
  fails cleanly, calling shell intact.
- `test_directory_ZSHZ_DATA_returns_does_not_exit` — `ZSHZ_DATA`
  pointing at a real directory fails cleanly, calling shell intact.
- `test_missing_toplevel_ZSHZ_DATA_returns_does_not_exit` — the
  datafile path is canonicalized on every call, including the
  backgrounded precmd add, and `${x:A}` on a path whose top-level
  component is missing segfaults Zsh 4.3.11 — so such a `ZSHZ_DATA`
  used to kill a shell there at every prompt. Only survival is
  asserted: the file cannot be created either way, so the call still
  fails loudly, like the other bad-datafile cases.

The remaining tests cover the other half of issue #103: the pre-prompt
add must not repeat a datafile complaint at every prompt, without
that silence costing the user a diagnostic they asked for. Because
the add is a disowned `&!` fork that `wait` cannot see — and a
misconfigured datafile leaves no file to poll — these give the forks
`_ZSHZ_FORK_SETTLE` (0.5 s) to produce output they should not
produce. Generous rather than tight: a false PASS from sampling too
early costs more than half a second, and forks are slow on
Cygwin/MSYS2.

- `test_precmd_add_is_silent_when_ZSHZ_DATA_is_a_directory` — five
  prompts' worth of `_zshz_precmd` against a directory `ZSHZ_DATA`
  must produce nothing at all, and the shell must survive.
- `test_precmd_add_is_silent_when_ZSHZ_DATA_is_a_bare_filename` —
  the same for a `ZSHZ_DATA` with no directory component.
- `test_manual_add_still_reports_a_bad_ZSHZ_DATA` — the counterpart:
  only the hook's add is quiet. A hand-typed `z --add` is a direct
  request and must still explain why it failed.
- `test_precmd_quiet_marker_does_not_leak_into_the_shell` —
  `_zshz_quiet_add` is a `local` in `_zshz_precmd` reached by dynamic
  scope. Were it ever to become a global, the first prompt would
  silence every later `zshz` call in that shell, including the
  interactive ones this file exists to protect. Runs the hook against
  a *good* datafile, then asserts the marker reads back unset and a
  subsequent bad-datafile call still reports.

### `test_datafile.zsh` — datafile robustness

The malformed-line filter
(`${(M)lines:#/*\|[[:digit:]]##[.,]#[[:digit:]]#\|[[:digit:]]##}`)
should drop any line that doesn't match the canonical shape, both
on read and on rewrite.

- `test_malformed_lines_are_filtered` — a hand-crafted datafile with
  random text, missing-pipe lines, non-numeric ranks, missing-path
  lines, trailing-junk lines, blank lines, and embedded-newline
  fragments; `zshz -l` shows only the well-formed entry.
- `test_add_preserves_valid_entries_amid_malformed_ones` — same
  shape but verified through `--add`: garbage is dropped on rewrite,
  valid entries preserved.
- `test_malformed_datafile_does_not_break_add` — `--add` succeeds
  even when the prior datafile is entirely garbage.
- `test_empty_datafile` — zero-byte datafile, `--add` lands rank 1.
- `test_missing_datafile_is_created` — datafile absent, plugin
  auto-creates it.
- `test_list_on_missing_datafile_is_clean_and_empty` — `zshz -l`
  produces empty output and auto-creates the datafile.
- `test_search_on_missing_datafile_matches_nothing` — search returns
  empty without error.
- `test_remove_on_missing_datafile_does_not_crash` — `zshz -x` on a
  never-created datafile is a no-op without writing to stderr.
- `test_list_on_zero_byte_datafile_is_clean_and_empty` — same as
  list-on-missing but for an existing 0-byte file.
- `test_whitespace_only_datafile_is_treated_as_empty` — `\n\n\n`
  content is split into empty array elements by `${(f)...}`,
  filtered out by the malformed-line filter; `--add` then lands
  normally.
- `test_precmd_on_missing_datafile_creates_and_populates` — the
  fresh-install path: `_zshz_precmd` creates the datafile and adds
  PWD.
- `test_ZSHZ_DATA_without_directory_prints_error_and_exits` — bare
  filename `ZSHZ_DATA` fails with a user-facing error.
- `test_ZSHZ_DATA_directory_prints_error_and_exits` — `ZSHZ_DATA`
  pointing at a directory fails with a user-facing error.

### `test_echo.zsh` — `ZSHZ_ECHO`

- `test_echo_off_no_print_on_jump` — without `ZSHZ_ECHO`, jumps are
  silent.
- `test_echo_prints_destination_path` — with `ZSHZ_ECHO`, the
  destination prints after a successful jump.
- `test_echo_combined_with_tilde` — `ZSHZ_ECHO` + `ZSHZ_TILDE`
  prints `~`-collapsed paths.

### `test_emulate.zsh` — sourcing under `emulate sh`/`bash`/`ksh`

The plugin uses zsh-only syntax in function bodies; under non-zsh
emulation those constructs fail to parse. The plugin's gate at the
top of the file detects non-zsh emulation via
`[[ -o KSH_ARRAYS || -o SH_WORD_SPLIT ]]` and re-sources itself with
`emulate zsh -c "source ${(%):-%N}"`. (`${(%):-%N}` is necessary
because under emulate sh `$0` is the zsh binary, not the script.)

- `test_source_under_emulate_sh` — basic round-trip after
  `emulate sh`.
- `test_source_under_emulate_sh_R` — same with `emulate sh -R`
  (more aggressive option reset).
- `test_source_under_emulate_bash` — same under `emulate bash`.
- `test_source_under_emulate_ksh` — same under `emulate ksh`.
- `test_source_from_path_with_spaces_under_emulate_sh` — the gate
  re-sources with `emulate zsh -c "source ${(q)${(%):-%N}}"`, and
  without the `${(q)}` the script's own path is word-split, so an
  install directory containing a space hands `source` several
  arguments and the plugin silently fails to load. Copies the plugin
  into a spaced directory and confirms a full round-trip under
  `emulate sh`.
- `test_emulate_gate_does_not_fire_under_pure_zsh` — control:
  pure zsh path still works, gate doesn't accidentally trigger.

### `test_external_writer.zsh` — read-after-lock under contention

Pins the develop-branch lockfile semantics: an external writer
running between our read and our `mv` must not lose pre-existing
entries, and both writers' new adds must land. Deliberately commits
to develop's design (would fail under `optimistic_concurrency`).
Spawns writers via `xargs_P`. Both tests skip when
`ZSHZ[USE_FLOCK]` is 0 (no `zsh/system`).

- `test_external_writer_during_our_add_serializes` — pre-seeded
  entry at rank 5 survives two concurrent writers each adding a
  different new path; both new adds land at rank 1.
- `test_many_concurrent_writers_preserve_seeded_entries` — stronger
  variant: 10 pre-seeded entries with ranks 1..10, 10 concurrent
  writers; every seeded rank is intact. A writer's own add may fail
  *honestly* (nonzero exit status — e.g. a Windows sharing violation
  outlasting the `ZSHZ[MV_RETRIES]` budget, a known MSYS2 CI flake);
  that is tolerated iff the same add lands when retried serially.
  What always fails: a lost seed, a writer that reported success but
  whose add is missing (silent loss — the lock didn't serialize),
  a writer that never logged a result, or a serial retry that
  doesn't land. On Cygwin and MSYS2 *only*, the whole batch is retried
  from a clean datafile up to three times before those are reported:
  their emulated fcntl locking can rarely fail to exclude rather than
  fail to acquire, which is indistinguishable from the bug being gated
  (`test_concurrency.zsh` documents the same hiccup). The tolerance is
  deliberately not applied elsewhere — master's bug shows up in only
  about 1 run in 12 of this fleet on Linux, so retrying everywhere
  would cut the odds of catching it by another order of magnitude.

### `test_fallback.zsh` — path fallback with no database match

When no entry matches the query, the search code falls through to
treating the argument as a literal path.

- `test_relative_path_fallback_changes_directory` — relative path
  fallback works.
- `test_parent_relative_path_fallback_changes_directory` — `..`-style
  paths work.
- `test_absolute_path_fallback_changes_directory` — absolute path
  fallback works.
- `test_relative_path_fallback_does_not_apply_with_echo_or_list` —
  `-e` and `-l` don't trigger the fallback (they're query modes,
  not jump modes).
- `test_absolute_path_fallback_does_not_apply_with_echo` — same for
  absolute paths via `-e`.

### `test_helpers.zsh` — see [Helpers in `test_helpers.zsh`](#helpers-in-test_helpersh)

Not a test file proper; the runner explicitly skips it during the
"collect tests" pass.

### `test_hooks.zsh` — `precmd` / `chpwd` integration

`_zshz_precmd` backgrounds `zshz --add` via `&!`, so tests use
`_wait_for_add` (cross-file helper) to wait for the disowned write
to land before asserting.

- `test_precmd_adds_pwd` — `_zshz_precmd` adds the current `$PWD`.
- `test_precmd_skips_home_and_excluded_dirs` — `$HOME` and excluded
  subtrees are short-circuited before reaching the backgrounded write.
- `test_removed_directory_is_not_readded_until_chpwd` — the
  `DIRECTORY_REMOVED` guard suppresses re-add until the user `cd`s.
- `test_precmd_does_not_emit_done_line_in_interactive_shell` —
  uses `zsh/zpty` to drive a real pty-backed interactive zsh and
  confirms the disowned write produces no `[N]  + done` notification
  at the next prompt. The function-call boundary alone is **not**
  enough to suppress the line when MONITOR is on; `&!` is what
  actually does it. Gated on `$OSTYPE == linux*`: the fixed sleeps
  in the sequence assume Linux pty timing, and on Solaris the inner
  pty isn't ready quickly enough -- the first character of `PS1=`
  gets eaten and the subsequent `cd` falls into a `>>>` continuation
  prompt. Also skips when `zsh/zpty` isn't loadable or when
  `zpty -b` can't acquire a pty. Polls for up to 5 s for the
  disowned `zshz --add` to land; on failure, dumps the datafile
  contents and the inner zsh's pty output so a path-canonicalization
  mismatch is distinguishable from a missed-write timeout.
- `test_repeated_precmd_under_prompt_spam` — calls `_zshz_precmd`
  30 times in tight succession and checks `/proc/self/fd/*` for any
  `.z.lock` fd; resolves entries via zsh's `:A` modifier rather than
  external `readlink`/`lsof` because `zsystem flock` opens its fd
  with `FD_CLOEXEC` and a forked inspector would see those fds as
  already closed. It also requires several of the disowned writes to
  land, on every platform — writes are serialized by `zsystem flock`
  where it exists and by the `mkdir` fallback where it does not. The
  floor was briefly relaxed without flock, when that path had no lock
  at all and MobaXterm landed 4 of the 30; with the fallback lock it
  keeps up.

### `test_keep_dirs.zsh` — `ZSHZ_KEEP_DIRS` edge cases

`test_cleanup.zsh` already covers the simple cases (subtree
protection, exact-match protection). This file covers the
boundaries: multiple entries under one root, the `/` root
shorthand, the prefix-sibling boundary, multiple KEEP_DIRS roots,
and read-time listing — both `_zshz_update_datafile` (rewrite) and
`_zshz_find_matches` (read) run the same prune-with-keep-list loop
and must honour KEEP_DIRS the same way.

- `test_keep_dirs_protects_many_entries_under_one_root` — three
  seeded entries under a single `KEEP_DIRS` root all survive at
  their original ranks after the dir is deleted and a rewrite is
  forced.
- `test_keep_dirs_root_slash_protects_everything` — the
  `$dir == '/'` branch: `KEEP_DIRS=( / )` keeps every missing
  entry. (`test_scale.zsh` relies on this; the contract had no
  dedicated test before.)
- `test_keep_dirs_does_not_protect_prefix_sibling` — boundary:
  `KEEP_DIRS=(/foo)` must not also keep `/foobar` (same shape as
  the `EXCLUDE_DIRS` boundary in `test_manual_add.zsh`).
- `test_keep_dirs_with_multiple_entries_each_protects_independently`
  — three different KEEP_DIRS roots; each protects its own
  matching entries, and an entry not under any root is still
  pruned.
- `test_keep_dirs_affects_read_time_listing` — pins the read-side
  branch in `_zshz_find_matches`: a missing-dir entry is filtered
  from `-l` without KEEP_DIRS, surfaces with it.

### `test_legacy_env.zsh` — `_Z_*` legacy variables

The plugin reads `${ZSHZ_*:-${_Z_*}}` so legacy `_Z_*` configs from
the original `z` continue to work.

- `test__Z_DATA_selects_legacy_datafile` — `_Z_DATA` controls
  the datafile when `ZSHZ_DATA` is unset.
- `test__Z_CMD_defines_legacy_alias_name` — `_Z_CMD` controls the
  alias name when `ZSHZ_CMD` is unset.
- `test__Z_MAX_SCORE_controls_aging` — `_Z_MAX_SCORE` triggers aging
  the same way `ZSHZ_MAX_SCORE` does.
- `test__Z_NO_RESOLVE_SYMLINKS_stores_link_path` — `_Z_NO_RESOLVE_SYMLINKS`
  controls symlink behavior.

### `test_listing.zsh` — listing output and ordering

Listings are produced by two formatters: a fast path for a bare
`z -l`, and `_zshz_output` for everything with a query. Several of
the tests below come in pairs that assert the two agree, since a fix
applied to one of them is easy to forget in the other.

- `test_no_args_matches_list_output` — `zshz` with no arguments
  produces the same output as `zshz -l`.
- `test_list_rank_and_time_modes_order_entries` — `-l -r` and `-l -t`
  sort by rank and time respectively.
- `test_lt_rank_longer_than_ten_chars_not_truncated_bare_list` — a
  `-t` rank is (visit time - now), so it runs to a sign plus ten
  digits once the time field sits more than ~31.7 years in the past,
  as a zeroed or hand-imported field does. The formatters used to
  right-pad with a bare `${(r:10:)}`, which *truncates* an
  11-character rank to 10 — misprinting the figure and sorting the
  entry as though it were far newer. Seeds one entry with a time
  field of about 0 and asserts it lists first with an 11-character
  rank token. Exercises the bare `z -lt` fast path.
- `test_lt_rank_longer_than_ten_chars_not_truncated_query_list` —
  the same assertions with a query (`z -lt i`, matching both
  entries), so the listing goes through `_zshz_output` instead.
- `test_list_prints_common_root_line` — when matches share a common
  root, `-l` includes a synthesized common-root line.
- `test_zero_rank_entry_does_not_create_phantom_common_root` —
  rank-0 entries are hidden from listings, but the general formatter
  once folded them into the `common:` summary anyway, so `z -lr proj`
  could print a root that none of the visible entries share while
  bare `z -lr` printed none. Asserts neither form prints a `common:`
  line for a root belonging only to the hidden entry, and that just
  the two ranked entries are listed. Each formatter must describe
  only what it actually lists.
- `test_bare_list_prints_common_root_line` — the positive half of
  that parity check: when every listed entry is ranked and one of
  them roots the rest, bare `z -l` prints the same `common:` summary
  the query form does (the query half being
  `test_list_prints_common_root_line`, above).
- `test_list_with_query_does_not_change_directory` — `-l` with a
  query lists and does nothing else, both when the matches share a
  common root and when a single match is its own root. `_zshz_output`
  computes the common root into `REPLY`, and the caller reads `REPLY`
  as its jump target, so a value left behind there sends the shell
  somewhere after the listing. The call deliberately runs in the test
  shell rather than inside a `$( )` capture: that is a subshell, and
  it could never observe the move.

### `test_lock_timeout.zsh` — `ZSHZ_LOCK_TIMEOUT`

Holder is started with `&!` (fork + disown) rather than `&` because
`wait` segfaults the test shell on 4.3.11. The holder self-terminates
after its sleep; `kill $holder` is best-effort cleanup.

- `test_lock_timeout_fires_when_lock_held_externally` — external
  holder takes the lock; our `--add` with `ZSHZ_LOCK_TIMEOUT=1`
  returns non-zero in (0.5, 3) s, and the datafile is unchanged
  (target not added, pre-existing seed rank preserved).
- `test_lock_timeout_succeeds_when_lock_free` — control: with no
  contender, the same `--add` succeeds in well under the timeout.

### `test_manual_add.zsh` — manual `zshz --add` defenses

Pins the rejection block in `_zshz_add_or_remove_path` (lines
210-224) which guards against `zshz --add $HOME` and
`zshz --add /excluded/path`. Same checks live in `_zshz_precmd` for
the prompt path; this file covers the user-typed entry point.

- `test_manual_add_of_HOME_is_rejected` — `local HOME=$TESTDIR/home`
  + `zshz --add "$HOME"` lands no entry.
- `test_manual_add_of_exact_excluded_dir_is_rejected` — exclude
  matched against itself.
- `test_manual_add_of_subdir_of_excluded_dir_is_rejected` — both
  immediate child and a deeper descendant rejected.
- `test_manual_add_of_prefix_sibling_of_excluded_is_allowed` — the
  glob alternation `${exclude}|${exclude}/*` ensures excluding `/foo`
  doesn't reject `/foobar`.
- `test_manual_add_of_unrelated_path_is_added` — control: with
  defenses active, an unrelated path round-trips.
- `test_manual_add_legacy_Z_EXCLUDE_DIRS_also_rejects` — covers the
  `${ZSHZ_EXCLUDE_DIRS:-${_Z_EXCLUDE_DIRS}}` legacy fallback.
- `test_manual_add_of_multiple_excludes_each_rejects` — three
  exclude entries, each independently rejects.

### `test_matching.zsh` — frecency, `-r`, and `-t` matching

Synthetic ranks/times via `zshz_seed`; paths must exist on disk
or stale-cleanup would prune them.

- `test_frecency_higher_rank_wins_at_equal_time` — at equal time,
  rank decides.
- `test_frecency_recent_wins_at_equal_rank` — at equal rank, recency
  decides.
- `test_frecency_high_rank_old_beats_low_rank_recent` — high-rank-
  but-old beats low-rank-but-recent under default frecency.
- `test_frecency_recent_low_rank_beats_old_higher_rank` — the reverse
  threshold: recent + slightly-low rank beats old + slightly-higher
  rank.
- `test_rank_match_picks_highest_rank_ignoring_time` — `-r` mode
  ignores time.
- `test_time_match_picks_most_recent_ignoring_rank` — `-t` mode
  ignores rank.

### `test_no_flock.zsh` — fallback when `zsh/system` is unavailable

- `test_add_works_without_flock` — single-process `--add` works with
  `ZSHZ[USE_FLOCK]=0`.
- `test_remove_works_without_flock` — `-x` works in the no-flock
  mode.
- `test_no_lockfile_created_without_flock` — no `${datafile}.lock`
  is created in the no-flock mode.

Where `zsystem flock` is missing, writes are serialized by an atomic
`mkdir` on `${datafile}.lock.d` instead. That path used to run with
nothing coordinating it: 4 to 9 of 10 concurrent adds were lost per run
on MobaXterm, occasionally taking every pre-seeded entry with them.
These force `ZSHZ[USE_FLOCK]=0` so the fallback is exercised everywhere,
not only where flock is genuinely absent.

- `test_no_flock_releases_its_lock_directory` — the directory is gone
  after a write and a later write can still take it. A directory
  outlives the process that made it, so a missed release wedges the
  database rather than leaking a descriptor.
- `test_no_flock_breaks_a_stale_lock_directory` — `mkdir` gives no
  release-on-death, so a lock backdated past the 30-second threshold is
  swept and the write lands. Skips where a directory's mtime can't be
  backdated.
- `test_no_flock_lock_timeout_returns_2` — a held but *fresh* lock is
  waited on, not stolen, and reports the `2` the README documents for
  contention; the write must not have landed.
- `test_no_flock_concurrent_writes_do_not_lose_updates` — 10 external
  writers, each forcing `USE_FLOCK=0` for itself, must all survive.
  Linux is too fast for this to discriminate on its own, but against a
  plugin without the fallback lock it fails every run on MobaXterm,
  losing 8 or 9 of the 10.

### `test_owner.zsh` — `ZSHZ_OWNER` chown behavior

`zsystem flock` opens the lockfile O_RDWR, so root creating it under
`sudo -s` and the unprivileged `$ZSHZ_OWNER` user later flocking on
it would fail with EACCES that is silently swallowed. Both the
datafile and the lockfile must be chowned together.

- `test_owner_set_chowns_both_datafile_and_lockfile` — mocks
  `${ZSHZ[CHOWN]}` with a logger; asserts the chown call covers
  both files.
- `test_owner_unset_does_not_chown` — without `ZSHZ_OWNER`, no
  chown happens.
- `test_owner_set_chowns_lockfile_at_creation` — the handoff happens
  when the lockfile is created, not only after a successful write.

Symlink hardening. Under `ZSHZ_OWNER` every one of these operations runs
with root's authority on paths inside a directory the unprivileged owner
controls, so following a link there redirects them.

- `test_owner_refuses_a_symlinked_datafile` — the resolution in
  `zshz()` dereferences a symlinked datafile, which under `ZSHZ_OWNER`
  would write the database wherever the link points, with no race
  required; it must be refused, loudly, and the target left untouched.
- `test_owner_refuses_a_symlinked_parent_directory` — resolution walks
  the whole path, so a symlinked *parent* redirects it just as well:
  `link/passwd` with `link` → `/etc` resolves to `/etc/passwd`. Every
  component is checked, and the error names the offending link. Links
  owned by `root` (`/home` → `/usr/home`, `/var` → `/private/var`) are
  still followed, which is why ownership rather than mere presence
  decides.
- `test_symlinked_datafile_is_dereferenced_when_no_owner_is_set` —
  the counterpart: unprivileged use keeps the documented dereference,
  and the lockfile is derived from the *resolved* path.
- `test_owner_chown_never_dereferences_symlinks` — every chown passes
  `-h`, so a link planted since the last check is retitled rather than
  followed onto its target.
- `test_owner_refuses_symlinked_lockfile` — unlike the datafile, the
  lockfile is never replaced, so a link planted there would persist and
  be acted on at every write.
- `test_symlinked_lockfile_allowed_when_owner_unset` — that refusal is
  gated on `ZSHZ_OWNER`; with no owner set no privilege is crossed and a
  user's own symlinked lockfile keeps working.

### `test_permissions.zsh` — datafile permission hardening

`~/.z` records every directory the user visits, so it must not be
readable by other users on a shared host. The plugin lands `.z` at
mode 0600 by calling `${ZSHZ[CHMOD]} 600` after every file creation
— the in-process `zf_chmod` builtin on Zsh 5+, and the external
`chmod` on Zsh 4.3.11. `mv` then atomically replaces `.z` with the
tempfile and preserves its 0600.

Mode-checking tests probe at runtime whether the underlying
filesystem honors `chmod` (writing a probe file, chmodding it,
reading back the mode via `zstat`). This skips MSYS2 — which
reports `$OSTYPE=cygwin` but ignores chmod on its Windows-backed
filesystem — while still running on real Cygwin, where POSIX modes
are honored.

- `test_initial_creation_is_0600` — a fresh `.z` is born at mode
  0600.
- `test_add_clamps_preexisting_world_readable_file_to_0600` — a
  preexisting 0644 `.z` ends up at 0600 after the first `--add`,
  because the tempfile-rename inherits the tempfile's 0600.
- `test_remove_keeps_0600` — `-x` rewrites the datafile and
  preserves mode 0600.
- `test_repeated_writes_keep_0600` — repeated `--add`s don't drift
  the mode.
- `test_initial_creation_chowns_when_ZSHZ_OWNER_set` — under
  `sudo -s` with `ZSHZ_OWNER=user`, a query-only first call hands
  `.z` off to the right user immediately rather than leaving a
  root-owned file the normal-user shell can't read. Mocks
  `${ZSHZ[CHOWN]}` with a logger.
- `test_initial_creation_does_not_chown_when_ZSHZ_OWNER_unset` —
  without `ZSHZ_OWNER`, no chown happens on initial creation.
- `test_lockfile_created_at_0600` — the lockfile is born 0600 too,
  not created under the ambient umask.

Failure-path coverage. The tempfile is born under the ambient umask and
it is *that* inode the rename publishes, so when `zf_chmod` is the only
thing standing between 0666 and 0600, an unchecked failure publishes a
world-readable `.z` and still reports success. Both shadow the
`zf_chmod` builtin with a failing function — `${ZSHZ[CHMOD]}` has to keep
the *name* `zf_chmod`, since that string selects the branch — and skip
where `zf_chmod` is unavailable (Zsh 4.3.11 takes the umask-subshell path,
which needs no chmod).

- `test_add_fails_closed_when_the_tempfile_cannot_be_secured` — a
  failed chmod fails the write: nonzero status, `.z` still 0600, the
  entry absent, and no tempfile left behind.
- `test_remove_fails_closed_when_the_tempfile_cannot_be_secured` — the
  same on the `-x` path, with the database left as it was.

### `test_resource.zsh` — re-sourcing safety and Tab binding

When the plugin is sourced it captures the current Tab binding into
`ZSHZ[TAB_BINDING]` so its own widget can chain to it. If sourced
again it must NOT recapture (else it would record its own widget
name and recurse infinitely on Tab; see commit 62569dd).

- `test_first_source_captures_existing_tab_binding` — first source
  records the prior binding.
- `test_first_source_binds_tab_to_widget` — Tab is bound to the
  plugin widget after sourcing.
- `test_resource_does_not_capture_own_widget` — re-source must not
  recapture its own widget name.
- `test_resource_keeps_tab_bound_to_widget` — re-source preserves
  the Tab binding to the widget.
- `test_first_source_preserves_non_default_tab_binding` — a user's
  custom Tab binding (e.g. `menu-complete`) is captured verbatim.

### `test_runner.zsh` — test-runner contract fixtures

Builds isolated minimal runner trees under each test's temporary
directory, so deliberate source failures cannot interfere with the
real suite.

- `test_runner_reports_plugin_source_failure` — a nonzero plugin
  source status exits 2 and names the plugin.
- `test_runner_reports_helper_source_failure` — the same contract
  for `test_helpers.zsh`.
- `test_runner_reports_test_file_source_failure` — the same contract
  for a discovered `test_*.zsh` file.
- `test_runner_reports_explicit_skip` — an explicit `skip: ` marker
  produces a SKIP line and increments only the skipped count.
- `test_runner_failure_takes_precedence_over_skip_marker` — a
  nonzero test that also prints a skip marker remains a failure.

### `test_scale.zsh` — large-datafile smoke tests (gated)

Run with `ZSHZ_HEAVY_TESTS=1`. Catches accidental quadratic blowups,
memory issues, or array-handling bugs that only surface at scale.
Uses `ZSHZ_KEEP_DIRS=( / )` so the missing-directory prune doesn't
require `mkdir`-ing 5000 stub directories.

- `test_large_datafile_list_completes` — `zshz -l` against 5000
  seeded entries returns at least N − 100 lines.
- `test_large_datafile_add_preserves_entries` — with aging disabled
  via a high `ZSHZ_MAX_SCORE`, an `--add` to a new path lands
  cleanly and the first/last seeded entries survive verbatim.
- `test_large_datafile_search_returns_a_match` — search through
  5000 entries finds `dir_4242`.
- `test_large_datafile_aging_triggers_at_scale` — ranks 1..5000 sum
  far above the default `MAX_SCORE`; one more `--add` ages all 5000
  entries by 0.99, sampled `dir_1` lands in (1.9, 2), `dir_5000`
  in (4940, 5000).

### `test_special_chars.zsh` — paths with shell-special characters

Round-trip through `--add`, `zshz -e <substr>`, `zshz -l`, and
`zshz -x` for each kind of special character. Exercises `${(q)2}`
quoting in `_zshz_update_datafile` and the escape list in
`_zshz_find_matches`.

- `test_path_with_spaces_round_trip` — paths with literal spaces.
- `test_path_with_brackets_round_trip` — `[`, `]`.
- `test_path_with_star_round_trip` — `*` in a path.
- `test_path_with_question_mark_round_trip` — `?` in a path.
- `test_path_with_backtick_round_trip` — backtick in a path.
- `test_path_with_single_quote_round_trip` — single quote in a path.
- `test_path_with_dollar_sign_round_trip` — `$` in a path. Originally
  failed because `_zshz_find_matches` accessed
  `(( matches[$escaped_path_field] ))` in math context (which re-
  expands `$` in the subscript); the plugin now escapes `$` in the
  same place it escapes \, ` , ( , ) , [ , ].
- `test_path_with_mixed_special_chars_round_trip` — all seven specials
  in one path; pins the quoting machinery rather than the
  search-side handling of metas in queries (the search query uses
  `mixed`, an ASCII non-meta substring).

A literal backslash is the acid test for the `print -r` discipline.
The datafile stores literal paths, so any emission without `-r`
quietly collapses an escape — `\t` becoming a real tab — either on
the way out or at the next rewrite. Throughout these, `\there` is a
backslash followed by "there", not a tab. All four skip via
`_test_skip_no_backslash_in_filename`, since Cygwin and MSYS2 treat
backslash as a path separator and cannot hold such a directory.
`zshz_rank_of` is unusable here — its own `awk -v` turns a `\t` in
the path into a tab — so the on-disk checks read the datafile
directly and compare against quoted literals.

- `test_path_with_backslash_round_trip` — add, search, remove. The
  entry is the only one, so a correct remove empties the datafile,
  where a corrupting one would leave mangled residue.
- `test_path_with_backslash_survives_rewrite` — adding a second
  directory rewrites the whole datafile through
  `_zshz_update_datafile`; the backslash entry must come out
  byte-identical.
- `test_path_with_backslash_survives_unrelated_remove` — `z -x` of a
  *different* directory carries every other line through the remove
  path; a backslash entry that is merely a bystander must survive
  verbatim.
- `test_path_with_backslash_listed_verbatim` — `zshz -l` is a
  separate emission path from `-e`, and must print the backslash
  literally too.

Two further `$`-path tests cover arithmetic context rather than
quoting. The `rank`/`time` keys in `_zshz_update_datafile` are
`${(q)}`-quoted, and a bare math subscript runs the key through the
arithmetic lexer, which strips a backslash level and misses any key
containing a `$`.

- `test_dollar_sign_path_rank_increments_on_readd` — re-adding must
  raise the rank, so the increment needs a scalar assignment rather
  than `(( rank[$key]++ ))`, which left the rank stuck at 1 and
  persisted a malformed duplicate line. Asserts rank 2 and exactly
  one matching line. The duplicate count is done in Zsh rather than
  with `grep -c -F`: Solaris's SVR4 `grep` has no `-F`, and a quoted
  parameter on the right of `==` matches literally, so the test needs
  neither escaping nor an external command.
- `test_dollar_sign_path_survives_aging` — aging rewrites each entry
  as `0.99 * rank`, and that multiplication must read the rank
  through an expansion (`${rank[$x]}`). A bare subscript evaluates a
  `$`-containing key to 0, which the `rank_field < 1` drop then
  erases on the next write — silent data loss. A `$`-path seeded well
  above the threshold must survive at a positive rank.

### `test_strict_options.zsh` — sourcing under `NO_UNSET`/`WARN_CREATE_GLOBAL`/`NO_NOMATCH`

- `test_source_with_NO_UNSET` — sources under `NO_UNSET`, runs
  `--add` + `_zshz_precmd` + `-l`. No "parameter not set" warnings.
- `test_source_with_WARN_CREATE_GLOBAL` — same under
  `WARN_CREATE_GLOBAL`. The plugin's careful `local` discipline
  must keep stderr clean.
- `test_source_with_NO_NOMATCH` — same under `NO_NOMATCH`.
- `test_source_with_combined_strict_options` — all three at once,
  the realistic strict-rc scenario.

### `test_symlink_realpath.zsh` — realpath edge cases for symlinks

Covers cases `test_symlinks.zsh` doesn't reach: two distinct
symlinks resolving to the same target, target/symlink asymmetry,
chained symlinks, `..` traversal collapsing, and the negative case
under `ZSHZ_NO_RESOLVE_SYMLINKS=1` where two symlinks to the same
target are *not* the same database key.

The four resolution-dependent tests below skip via
`_test_skip_no_symlinks` where `ln -s` can't produce a resolvable
symlink (MSYS2 without native symlinks). `test_dotdot_traversal_is_canonicalised`
and `test_no_resolve_keeps_two_symlinks_distinct` don't need real
symlinks and always run.

- `test_two_symlinks_to_same_target_share_a_db_entry` — under
  default mode, `--add` via `link1/inner` and `-x` via
  `link2/inner` round-trip via the canonical resolved target.
- `test_add_via_symlink_remove_via_target` — adding through a
  symlink and removing via the underlying target works.
- `test_add_via_target_remove_via_symlink` — the inverse: adding
  via the target and removing via a symlink also works.
- `test_chained_symlinks_resolve_to_final_target` — `link_outer ->
  link_inner -> target`; `:A` walks the whole chain.
- `test_dotdot_traversal_is_canonicalised` — `--add foo/../foo/bar`
  lands as `foo/bar`; the literal traversal form is not preserved.
- `test_remove_deleted_dir_via_symlinked_parent` — the removal target
  no longer has to exist, but symlinks in whatever prefix of it
  *does* exist must still resolve; otherwise an entry added through a
  symlink could not be removed by the same name once its directory
  was deleted. `_zshz_realpath` resolves the deepest existing
  ancestor with `:A` and carries the missing tail verbatim, which is
  what `:A` itself does with a missing non-top-level tail.
- `test_no_resolve_keeps_two_symlinks_distinct` — under
  `ZSHZ_NO_RESOLVE_SYMLINKS=1`, removing via `link2` does *not*
  remove the entry added via `link1`; the user has to remove via
  the same path that added it.

### `test_symlinks.zsh` — symlink add/remove parity

`--add` and `-x` must treat the same path the same way regardless of
symlink resolution mode.

- `test_symlink_add_remove_parity_default` — default mode (resolve
  symlinks): adding through the link removes through the link.
- `test_symlink_add_remove_parity_no_resolve` — same with
  `ZSHZ_NO_RESOLVE_SYMLINKS=1`.
- `test_symlink_add_default_stores_resolved_target` — the stored
  path is the symlink target under default mode. Skips via
  `_test_skip_no_symlinks` where `ln -s` can't make a resolvable
  symlink; the two parity tests and the no-resolve test don't need
  real symlinks and always run.
- `test_symlink_add_no_resolve_does_not_store_target` — the stored
  path is the symlink itself when resolution is off.

### `test_tempfile_cleanup.zsh` — no leftover `${datafile}.NNNNN`

Pins single-process tempfile-cleanup paths in
`_zshz_add_or_remove_path`. Each rewrite uses
`${datafile}.${RANDOM}` and atomically `mv`s it over the datafile;
every failure path must `rm -f` the tempfile before returning.
`test_concurrent_mixed.zsh` already pins the same invariant under
concurrent ops; this file pins the synchronous failure paths.

- `test_no_tempfile_after_normal_add` — sanity: a single successful
  `--add` leaves no `${datafile}.<N>` behind.
- `test_no_tempfile_after_many_sequential_adds` — 20 consecutive
  adds; catches the case where each leaks one (accumulation), not
  just the first.
- `test_no_tempfile_after_mv_failure` — `ZSHZ[MV]=false` to make
  the rename always fail; the post-mv cleanup branch must run, the
  datafile is unchanged, the new entry didn't land. Helper
  `_no_tempfile_in DIR` (defined in the file) does the glob check.
- `test_mv_retry_with_inherited_err_return` and
  `test_mv_retry_with_inherited_err_exit` verify a mocked move that
  fails once and then succeeds while the corresponding caller option
  is enabled. The retry and its nonzero delay status must not activate
  the option; the update must land and leave no tempfile. The `zshz`
  call is deliberately not wrapped in a conditional, which would
  suppress the inherited option and mask the regression.
- `test_mv_retry_transient_failure_succeeds_without_flock` forces two
  failures followed by success and pins three move attempts, two
  between-attempt delays, the persisted update, and tempfile cleanup.
- `test_mv_retry_exhaustion_resets_budget_without_flock` forces
  permanent failure twice. Each call must make five attempts and four
  delays, preserve status 23, leave the original datafile untouched,
  remove its tempfile, and start the second call with a fresh budget.
- `test_mv_retry_with_inherited_err_return_releases_flock` exercises
  the flock branch under `ERR_RETURN`, then performs another write to
  prove the lock descriptor was released for reuse. It skips explicitly
  where flock is unavailable or Docker selects the non-rename path.
- `test_no_tempfile_after_lock_timeout` — lock held externally,
  `ZSHZ_LOCK_TIMEOUT=1`. The timeout path returns before opening
  the tempfile, so there's nothing to clean up; a future refactor
  that moved tempfile creation before `flock` would surface as a
  leak here.

Two failure scenarios are intentionally *not* covered, with
reasons spelled out in the file's header:

- *Read-only parent dir mid-write*: once the dir is read-only,
  the plugin's own `mkdir -p`/`touch` to ensure the datafile
  exists also fails and writes to stderr ahead of where we want
  to test. The mocked-MV test exercises the same cleanup branch
  more cleanly.
- *Kill the writer mid-write*: SIGKILL admits no shell-level
  cleanup; the plugin doesn't trap signals so SIGTERM also
  leaks. That's a "should we add a trap?" item, not a contract
  we currently enforce.

### `test_tilde.zsh` — `ZSHZ_TILDE`

- `test_tilde_replaces_home_in_list_output` — `-l` shows `~/foo`
  instead of `/home/user/foo` when `ZSHZ_TILDE` is set.
- `test_tilde_off_shows_full_home_path` — with `ZSHZ_TILDE` unset,
  the full path appears.
- `test_tilde_in_echo_output` — `-e` likewise honors `ZSHZ_TILDE`.

### `test_uncommon.zsh` — `ZSHZ_UNCOMMON`

`ZSHZ_UNCOMMON=1` shrinks the chosen destination to the shortest
ancestor that still contains the same number of search-pattern
matches as the original entry.

- `test_uncommon_shrinks_to_keep_pattern_count` — `/foo/bar/foo/bar`
  with query `foo` shrinks to `/foo/bar/foo`.
- `test_uncommon_trim_terminates_at_root` — with `/` in the database,
  `z -e /` trimmed the destination down to `/` and then spun forever:
  `${cd:h}` of `/` is `/`, so the trim made no progress while the
  loop's stop condition never flipped. The call runs in a
  backgrounded subshell behind a 10-second watchdog, so a regression
  fails this test by timeout instead of hanging the whole suite.
- `test_uncommon_case_sensitive_winner_trims_case_sensitively` —
  `ZSHZ[CASE_INSENSITIVE]` was set *during* the scan by any leading
  case-insensitive candidate, even when a case-sensitive match went
  on to win, and under `ZSHZ_UNCOMMON` that stale flag forced the
  trim through the case-insensitive branch and shortened by the wrong
  amount. `$TESTDIR/foo/Foo` wins case-sensitively for query `foo`
  while `$TESTDIR/FOO` is a case-insensitive-only decoy; the correct
  trim drops the trailing `Foo` and yields `$TESTDIR/foo`. Skips via
  `_test_skip_case_insensitive_fs`.
- `test_default_with_single_match_returns_full_path` — without
  `UNCOMMON`, a single match returns its full path.
- `test_default_returns_common_root_when_one_exists` — without
  `UNCOMMON`, when matches share a common root that's in the
  database, the root is returned (as a single line).

### `test_unicode.zsh` — non-ASCII paths

- `test_path_with_latin_extended_round_trip` — `café/résumé` round-
  trips, search by `café`.
- `test_path_with_cjk_round_trip` — `日本語/プロジェクト` round-trips,
  search by `日本語`.
- `test_path_with_cyrillic_round_trip` — `привет/мир` round-trips,
  search by `привет`.
- `test_ascii_substring_finds_path_with_unicode` — ASCII substring
  search across UTF-8 byte boundaries (`proj-café-2026/notes`
  searched by `proj`).
- `test_issue_48_cjk_echo_returns_byte_exact_path` — direct
  regression for issue #48. `zshz -e TW` against a CJK path returned
  a corrupted string — `TW4791主僣` for the real `TW4791主包内容` —
  because Zsh's `print -v REPLY <arg>` mangled multibyte strings
  until late 2020. `_zshz_printv` works around it with
  `print -v REPLY -f %s <arg>`; simplify the helper back to the plain
  form and this fails.
- `test_common_root_line_preserves_multibyte_prefix` —
  `_zshz_find_common_root` funnels the shared prefix through
  `_zshz_printv`, a separate callsite from the `-e` path above, and
  the `common:` line in `-l` output is what surfaces it. The parent
  `プロジェクト` directory has to be in the database too, since the
  line is only emitted when the common prefix is itself one of the
  matched paths.
- `test_cjk_path_with_escape_special_chars_round_trips` — a path that
  is both multibyte and full of escape-targeted characters
  (`project(主包)/notes`) must survive add and search together, since
  it hits #48's concern and the escape chain in `_zshz_find_matches`
  at once.
- `test_cjk_substring_matches_at_start_middle_and_end` — the same
  multibyte component at the start, middle, and end of three
  different paths, checking that the `*$fnd*` glob does not split on
  byte rather than character boundaries.
- `test_case_insensitive_mode_does_not_corrupt_cjk` —
  `ZSHZ_CASE=ignore` lowercases both sides with `:l`, which is a
  no-op for characters without case, as most CJK are. Pins that the
  no-op stays a no-op instead of mangling the bytes.

### `test_unload.zsh` — plugin unload / reload contract

Per the Zsh Plugin Standard, `zsh-z_plugin_unload` must drop functions
and the widget, restore the prior Tab binding, remove precmd/chpwd
hooks, and unset `ZSHZ`. Re-sourcing should bring everything back.

- `test_unload_removes_zshz_function` — `zshz` function gone after
  unload.
- `test_unload_unsets_ZSHZ_global` — `ZSHZ` associative array gone
  after unload.
- `test_unload_removes_widget` — `_zshz_zle_completion_widget` gone.
- `test_unload_restores_prior_tab_binding` — Tab is re-bound to the
  binding the plugin captured at source time.
- `test_unload_leaves_user_rebound_tab_alone` — if the user re-bound
  Tab themselves *between* source and unload, unload doesn't
  clobber that.
- `test_unload_removes_hooks` — `_zshz_precmd` and `_zshz_chpwd` are
  removed from `precmd_functions` / `chpwd_functions`.
- `test_unload_leaves_no_plugin_functions_behind` — `zshz` defines
  its helpers (`zshz_cd`, `_zshz_echo` among them) the first time it
  runs, so the test runs it once before unloading, then sweeps the
  function table for anything matching `zshz*`, `_zshz*` or `zsh-z*`
  that unload failed to remove.
- `test_unload_removes_plugin_dir_from_fpath` — the plugin directory
  is gone from `$fpath` afterwards.
- `test_unload_keeps_fpath_entry_matching_pwd` — inside a function
  `$0` is the function name, which `:A` resolves relative to `$PWD`,
  so an unload that recomputes `${0:A:h}` strips the *current*
  directory from `$fpath` rather than the plugin's. An entry that
  merely equals `$PWD` must survive.
- `test_unload_then_reload_restores_function_and_widget` — sourcing
  again after unload restores the plugin to a clean state.
- `test_reload_after_unload_captures_current_tab_binding` — re-source
  captures whatever Tab is bound to *now* (not the original
  `expand-or-complete`).

Completion mappings. The widget registers `_comps[$cmd]=_zshz` on its
first Tab; that entry outlives the function it names, since unload
unfunctions `_zshz` and drops the plugin directory from `$fpath`. These
need compinit and a real widget call, so they use raw `zsh -c`.

- `test_unload_removes_the_completion_mapping_it_registered` — the
  entry the widget added is gone after unload.
- `test_unload_leaves_the_static_compdef_registration_alone` —
  `_comps[zshz]` comes from compinit reading the `#compdef` tag, and
  nothing re-runs compinit on a reload, so removing it would break
  completion for the literal `zshz` command.
- `test_unload_leaves_a_reassigned_completion_mapping_alone` — a
  mapping someone else repointed after Zsh-z registered it survives.
- `test_reload_reregisters_the_completion_mapping_after_unload` — what
  makes the removal safe: the next Tab after a reload puts it back.
- `test_unload_removes_every_completion_mapping_it_registered` — a
  re-source with a changed `ZSHZ_CMD` registers a second command; both
  are given back, not just the most recent.

`$fpath` ownership. The plugin adds its own directory only when nothing
else has, so unload must take back only what it put there — a plugin
manager that supplied the entry owns it, and other autoloadable
functions may live in the same directory.

- `test_unload_removes_the_fpath_entry_it_added` — the entry the
  plugin added is removed.
- `test_unload_leaves_a_preexisting_fpath_entry_alone` — an entry that
  was already there is not.
- `test_unload_leaves_duplicate_preexisting_fpath_entries_alone` — the
  old filter dropped every match at once; duplicates a manager put
  there survive.
- `test_unload_removes_the_fpath_entry_after_a_re_source` — the
  ownership record survives a re-source, which finds the directory
  already present because the first source added it.
- `test_unload_removes_the_directory_it_added_not_the_one_resourced_from`
  — `$ZSHZ[PLUGIN_DIR]` is rewritten by every source, so the record
  stores paths rather than a flag; re-sourcing from a second,
  manager-owned installation must not invert which entry is removed.
- `test_unload_removes_the_fpath_entry_from_a_glob_metachar_directory`
  — the lookup matches the stored path exactly, so a directory named
  with `[`, `*` or `?` still matches itself.

### `test_widget.zsh` — ZLE completion widget logic

`_zshz_zle_completion_widget` collapses multiple search terms into
one `*`-joined token before delegating to the saved Tab binding. We
can't drive a real ZLE session non-interactively, so each test stubs
`zle` to a no-op and inspects `LBUFFER` after the call.

- `test_widget_joins_multiple_search_terms_with_asterisk` —
  `z us lo bi` becomes `z us*lo*bi`.
- `test_widget_preserves_flags_before_search_terms` — `z -e foo bar`
  becomes `z -e foo*bar` (flags stay separate from joined terms).
- `test_widget_passes_through_single_term` — single-term queries
  are unchanged.
- `test_widget_does_not_retrigger_on_completed_absolute_path` — a
  buffer ending in a trailing space after an absolute path bails
  out so a second Tab doesn't insert a duplicate.
- `test_widget_recognizes_long_flags` — `--add`, `--complete`,
  `--help` are recognized as flags.
- `test_widget_uses_custom_ZSHZ_CMD` — the widget keys off
  `ZSHZ_CMD` (or `_Z_CMD`), not a hardcoded `z`.
- `test_widget_passes_through_single_path_after_long_flag` — a
  single argument after a long flag isn't joined to anything.
- `test_widget_double_dash_terminates_option_parsing` — `--`
  terminates option parsing; subsequent tokens are positional.

## Auxiliary scripts

### `tests/stress.sh`

A standalone bash-driven cross-process stress test for concurrent
`--add`. Spawns N writers (default 100) at parallelism P (default 8),
each in its own `zsh -c` source-and-add cycle, and asserts the final
rank equals N. Sets `ZSHZ_LOCK_TIMEOUT=30` so honest contention
isn't dropped on timeout. Uses `xargs -P` where available; falls back
to bash background jobs throttled to `$PARALLEL` via batch-wait on
systems without it (Solaris, AT&T xargs).

```sh
tests/stress.sh                     # 100 writers, 8-way parallel
N=200 PARALLEL=8 tests/stress.sh    # 200 writers
N=200 tests/stress.sh ~/zsh/4.3.11/bin/zsh   # against an alternate zsh
```

Not part of the regular run; intended for one-off verification of
lock correctness under heavy load and on multiple zsh versions.

### `.github/workflows/test.yml`

Four CI jobs, all running the suite with `ZSHZ_HEAVY_TESTS=1`:

- **`test`** — `ubuntu-latest` and `macos-latest` on the system zsh
  (5.x). Installs zsh (Linux only — macOS ships it), syntax-checks
  `zsh-z.plugin.zsh` and `_zshz`, then runs the suite.
- **`test-zsh-4-3-11`** — `ubuntu-latest`. Builds Zsh 4.3.11 (the
  supported floor) from the upstream archive (`-fcommon`,
  `--with-tcsetpgrp`), caches the binary, and runs the suite with the
  build prepended to `PATH` so spawned children are 4.3.11 too. No
  `zsh -n` syntax check there — parse-only mode aborts on that old build.
- **`test-msys2`** — `windows-latest` via `msys2/setup-msys2` (zsh 5.9,
  MSYS subsystem). The symlink-resolution tests skip there: a stock
  MSYS2 has no native symlinks (see `_test_skip_no_symlinks`).
- **`test-cygwin`** — `windows-latest` via `cygwin/cygwin-install-action`
  (zsh 5.8). Same Cygwin-family layer, but its default `ln -s` resolves,
  so those symlink-resolution tests run rather than skip.

The Linux jobs complete in well under a minute; the slow-fork Windows
jobs take a few minutes. Both Windows jobs set `core.autocrlf input`
before checkout so the plugin and tests arrive with LF endings.

<!-- vim: ft=markdown:tw=72: -->
