Hacking on zsh-syntax-highlighting itself
=========================================

This document includes information for people working on z-sy-h itself: on the
core driver (`zsh-syntax-highlighting.zsh`), on the highlighters in the
distribution, and on the test suite.  It does not target third-party
highlighter authors (although they may find it an interesting read).

The `main` highlighter
----------------------

The following function `pz` is useful when working on the `main` highlighting:

```zsh
pq() {
  (( $#argv )) || return 0
  print -r -l -- ${(qqqq)argv}
}
pz() {
  local arg
  for arg; do
    pq ${(z)arg}
  done
}
```

It prints, for each argument, its token breakdown, similar to how the main
loop of the `main` highlighter sees it.

Testing the `brackets` highlighter
----------------------------------

Since the test harness empties `ZSH_HIGHLIGHT_STYLES` and the `brackets`
highlighter interrogates `ZSH_HIGHLIGHT_STYLES` to determine how to highlight,
tests must set the `bracket-level-#` keys themselves.  For example:

```zsh
ZSH_HIGHLIGHT_STYLES[bracket-level-1]=
ZSH_HIGHLIGHT_STYLES[bracket-level-2]=

BUFFER='echo ({x})'

expected_region_highlight=(
  "6  6  bracket-level-1" # (
  "7  7  bracket-level-2" # {
  "9  9  bracket-level-2" # }
  "10 10 bracket-level-1" # )
)
```

Testing the `pattern` and `regexp` highlighters
-----------------------------------------------

Because the `pattern` and `regexp` highlighters modifies `region_highlight`
directly instead of using `_zsh_highlight_add_highlight`, the test harness
cannot get the `ZSH_HIGHLIGHT_STYLES` keys.  Therefore, when writing tests, use
the style itself as third word (cf. the
[documentation for `expected_region_highlight`](docs/highlighters.md)).  For example:

```zsh
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

BUFFER='rm -rf /'

expected_region_highlight=(
  "1 8 fg=white,bold,bg=red" # rm -rf /
)
```

Miscellany
----------

If you work on the driver (`zsh-syntax-highlighting.zsh`), you may find the following zstyle useful:

```zsh
zstyle ':completion:*:*:*:*:globbed-files' ignored-patterns {'*/',}zsh-syntax-highlighting.plugin.zsh
```

IRC channel
-----------

We're on #zsh-syntax-highlighting on freenode.

