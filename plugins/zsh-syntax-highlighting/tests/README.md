zsh-syntax-highlighting / tests
===============================

Utility scripts for testing zsh-syntax-highlighting highlighters.

The tests expect the highlighter directory to contain a `test-data` directory with test data files. See the [main highlighter](../highlighters/main/test-data) for examples.


highlighting test
-----------------
[`test-highlighting.zsh`](tests/test-highlighting.zsh) tests the correctness of the highlighting. Usage:

    zsh test-highlighting.zsh <HIGHLIGHTER NAME>


performance test
----------------
[`test-perfs.zsh`](tests/test-perfs.zsh) measures the time spent doing the highlighting. Usage:

    zsh test-perfs.zsh <HIGHLIGHTER NAME>
