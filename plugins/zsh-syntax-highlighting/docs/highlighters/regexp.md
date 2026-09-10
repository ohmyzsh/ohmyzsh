zsh-syntax-highlighting / highlighters / regexp
------------------------------------------------

This is the `regexp` highlighter, that highlights user-defined regular
expressions. It's similar to the `pattern` highlighter, but allows more complex
patterns.

### How to tweak it

To use this highlighter, associate regular expressions with styles in the
`ZSH_HIGHLIGHT_REGEXP` associative array, for example in `~/.zshrc`:

```zsh
typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_REGEXP+=('^rm .*' fg=red,bold)
```

This will highlight lines that start with a call to the `rm` command.

The regular expressions flavour used is [PCRE][pcresyntax] when the
`RE_MATCH_PCRE` option is set and POSIX Extended Regular Expressions (ERE),
as implemented by the platform's C library, otherwise.  For details on the
latter, see [the `zsh/regex` module's documentation][MAN_ZSH_REGEX] and the
`regcomp(3)` and `re_format(7)` manual pages on your system.

For instance, to highlight `sudo` only as a complete word, i.e., `sudo cmd`,
but not `sudoedit`, one might use:

* When the `RE_MATCH_PCRE` is set:

    ```zsh
    typeset -A ZSH_HIGHLIGHT_REGEXP
    ZSH_HIGHLIGHT_REGEXP+=('\bsudo\b' fg=123,bold)
    ```

* When the `RE_MATCH_PCRE` is unset, on platforms with GNU `libc` (e.g., many GNU/Linux distributions):

    ```zsh
    typeset -A ZSH_HIGHLIGHT_REGEXP
    ZSH_HIGHLIGHT_REGEXP+=('\<sudo\>' fg=123,bold)
    ```

* When the `RE_MATCH_PCRE` is unset, on BSD-based platforms (e.g., macOS):

    ```zsh
    typeset -A ZSH_HIGHLIGHT_REGEXP
    ZSH_HIGHLIGHT_REGEXP+=('[[:<:]]sudo[[:>:]]' fg=123,bold)
    ```

Note, however, that PCRE and POSIX ERE have a large common subset:
for instance, the regular expressions `[abc]`, `a*`, and `(a|b)` have the same
meaning in both flavours.

The syntax for values is the same as the syntax of "types of highlighting" of
the zsh builtin `$zle_highlight` array, which is documented in [the `zshzle(1)`
manual page][zshzle-Character-Highlighting].

See also: [regular expressions tutorial][perlretut], zsh regexp operator `=~`
in [the `zshmisc(1)` manual page][zshmisc-Conditional-Expressions]

[zshzle-Character-Highlighting]: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
[perlretut]: https://perldoc.perl.org/perlretut
[zshmisc-Conditional-Expressions]: https://zsh.sourceforge.io/Doc/Release/Conditional-Expressions.html#Conditional-Expressions
[MAN_ZSH_REGEX]: https://zsh.sourceforge.io/Doc/Release/Zsh-Modules.html#The-zsh_002fregex-Module
[pcresyntax]: https://www.pcre.org/original/doc/html/pcresyntax.html
