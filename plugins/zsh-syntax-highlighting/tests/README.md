zsh-syntax-highlighting / tests
===============================

Utility scripts for testing zsh-syntax-highlighting highlighters.

The tests harness expects the highlighter directory to contain a `test-data`
directory with test data files.
See the [main highlighter](../highlighters/main/test-data) for examples.

Tests should set the following variables:

1.
Each test should define the string `$BUFFER` that is to be highlighted and the
array parameter `$expected_region_highlight`.
The value of that parameter is a list of strings of the form  `"$i $j $style"`.
or `"$i $j $style $todo"`.
Each string specifies the highlighting that `$BUFFER[$i,$j]` should have;
that is, `$i` and `$j` specify a range, 1-indexed, inclusive of both endpoints.
`$style` is a key of `$ZSH_HIGHLIGHT_STYLES`.
If `$todo` exists, the test point is marked as TODO (the failure of that test
point will not fail the test), and `$todo` is used as the explanation.

2. 
If a test sets `$skip_test` to a non-empty string, the test will be skipped
with the provided string as the reason.

3. 
If a test sets `$fail_test` to a non-empty string, the test will be skipped
with the provided string as the reason.

4.
If a test sets `unsorted=1` the order of highlights in `$expected_region_highlight`
need not match the order in `$region_highlight`.

5.
Normally, tests fail if `$expected_region_highlight` and `$region_highlight`
have different numbers of elements.  To mark this check as expected to fail,
tests may set `$expected_mismatch` to an explanation string (like `$todo`);
this is useful when the only difference between actual and expected is that actual
has some additional, superfluous elements.  This check is skipped if the
`$todo` component is present in any regular test point.

**Note**: `$region_highlight` uses the same `"$i $j $style"` syntax but
interprets the indexes differently.

**Note**: Tests are run with `setopt NOUNSET WARN_CREATE_GLOBAL`, so any
variables the test creates must be declared local.

**Isolation**: Each test is run in a separate subshell, so any variables,
aliases, functions, etc., it defines will be visible to the tested code (that
computes `$region_highlight`), but will not affect subsequent tests.  The
current working directory of tests is set to a newly-created empty directory,
which is automatically cleaned up after the test exits. For example:

```zsh
setopt PATH_DIRS
mkdir -p foo/bar
touch foo/bar/testing-issue-228
chmod  +x foo/bar/testing-issue-228
path+=( "$PWD"/foo )

BUFFER='bar/testing-issue-228'

expected_region_highlight=(
  "1 21 command" # bar/testing-issue-228
)
```


Writing new tests
-----------------

An experimental tool is available to generate test files:

```zsh
zsh -f tests/generate.zsh 'ls -x' acme newfile
```

This generates a `highlighters/acme/test-data/newfile.zsh` test file based on
the current highlighting of the given `$BUFFER` (in this case, `ls -x`).

_This tool is experimental._  Its interface may change.  In particular it may
grow ways to set `$PREBUFFER` to inject free-form code into the generated file.


Highlighting test
-----------------

[`test-highlighting.zsh`](tests/test-highlighting.zsh) tests the correctness of
the highlighting. Usage:

```zsh
zsh test-highlighting.zsh <HIGHLIGHTER NAME>
```

All tests may be run with

```zsh
make test
```

which will run all highlighting tests and report results in [TAP format][TAP].
By default, the results of all tests will be printed; to show only "interesting"
results (tests that failed but were expected to succeed, or vice-versa), run
`make quiet-test` (or `make test QUIET=y`).

[TAP]: https://testanything.org/


Performance test
----------------

[`test-perfs.zsh`](tests/test-perfs.zsh) measures the time spent doing the
highlighting. Usage:

```zsh
zsh test-perfs.zsh <HIGHLIGHTER NAME>
```

All tests may be run with

```zsh
make perf
```
