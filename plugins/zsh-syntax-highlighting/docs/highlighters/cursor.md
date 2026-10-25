zsh-syntax-highlighting / highlighters / cursor
-----------------------------------------------

This is the `cursor` highlighter, that highlights the cursor.


### How to tweak it

This highlighter defines the following styles:

* `cursor` - the style for the current cursor position

To override one of those styles, change its entry in `ZSH_HIGHLIGHT_STYLES`,
for example in `~/.zshrc`:

```zsh
ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'
```

The syntax for values is the same as the syntax of "types of highlighting" of
the zsh builtin `$zle_highlight` array, which is documented in [the `zshzle(1)`
manual page][zshzle-Character-Highlighting].

[zshzle-Character-Highlighting]: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
