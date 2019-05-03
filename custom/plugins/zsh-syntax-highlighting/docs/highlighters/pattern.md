zsh-syntax-highlighting / highlighters / pattern
------------------------------------------------

This is the `pattern` highlighter, that highlights user-defined patterns.


### How to tweak it

To use this highlighter, associate patterns with styles in the
`ZSH_HIGHLIGHT_PATTERNS` associative array, for example in `~/.zshrc`:

```zsh
# Declare the variable
typeset -A ZSH_HIGHLIGHT_PATTERNS

# To have commands starting with `rm -rf` in red:
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
```

The syntax for values is the same as the syntax of "types of highlighting" of
the zsh builtin `$zle_highlight` array, which is documented in [the `zshzle(1)`
manual page][zshzle-Character-Highlighting].

[zshzle-Character-Highlighting]: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
