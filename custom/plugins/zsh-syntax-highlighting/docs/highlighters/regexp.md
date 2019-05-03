zsh-syntax-highlighting / highlighters / regexp
------------------------------------------------

This is the `regexp` highlighter, that highlights user-defined regular
expressions. It's similar to the `pattern` highlighter, but allows more complex
patterns.

### How to tweak it

To use this highlighter, associate regular expressions with styles in the
`ZSH_HIGHLIGHT_REGEXP` associative array, for example in `~/.zshrc`:

```zsh
typeset -A ZSH_HIGHLIGHT_PATTERNS
ZSH_HIGHLIGHT_REGEXP+=('\bsudo\b' fg=123,bold)
```

This will highlight "sudo" only as a complete word, i.e., "sudo cmd", but not
"sudoedit"

The syntax for values is the same as the syntax of "types of highlighting" of
the zsh builtin `$zle_highlight` array, which is documented in [the `zshzle(1)`
manual page][zshzle-Character-Highlighting].

See also: [regular expressions tutorial][perlretut], zsh regexp operator `=~`
in [the `zshmisc(1)` manual page][zshmisc-Conditional-Expressions]

[zshzle-Character-Highlighting]: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
[perlretut]: http://perldoc.perl.org/perlretut.html
[zshmisc-Conditional-Expressions]: http://zsh.sourceforge.net/Doc/Release/Conditional-Expressions.html#Conditional-Expressions
