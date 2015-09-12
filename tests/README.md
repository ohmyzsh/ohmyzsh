zsh-syntax-highlighting / tests
===============================

Utility scripts for testing zsh-syntax-highlighting highlighters.

The tests expect the highlighter directory to contain a `test-data` directory with test data files. See the [main highlighter](../highlighters/main/test-data) for examples.

Each test should define the array parameter `$expected_region_highlight`.
The value of that parameter is a list of `"$i $j $style"` strings.
Each string specifies the highlighting that `$BUFFER[$i,$j]` should have;
that is, `$i` and `$j` specify a range, 1-indexed, inclusive of both endpoints.

_Note_: `$region_highlight` uses the same `"$i $j $style"` syntax but interprets the indexes differently.


highlighting test
-----------------
[`test-highlighting.zsh`](tests/test-highlighting.zsh) tests the correctness of the highlighting. Usage:

    zsh test-highlighting.zsh <HIGHLIGHTER NAME>


performance test
----------------
[`test-perfs.zsh`](tests/test-perfs.zsh) measures the time spent doing the highlighting. Usage:

    zsh test-perfs.zsh <HIGHLIGHTER NAME>
