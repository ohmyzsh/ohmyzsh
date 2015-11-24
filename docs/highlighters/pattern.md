zsh-syntax-highlighting / highlighters / pattern
------------------------------------------------

This is the `pattern` highlighter, that highlights user defined patterns.


### How to tweak it

To use this highlighter, associate patterns with styles in the
`ZSH_HIGHLIGHT_PATTERNS` array, for example in `~/.zshrc`:

    # To have commands starting with `rm -rf` in red:
    ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

The syntax for declaring styles is documented in [the `zshzle(1)` manual
page](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135).
