zsh-syntax-highlighting / highlighters / pattern
================================================

This is the ***pattern*** highlighter, that highlights user defined patterns.


How to activate it
------------------
To activate it, add it to `ZSH_HIGHLIGHT_HIGHLIGHTERS`:

    ZSH_HIGHLIGHT_HIGHLIGHTERS=( [...] pattern)


How to tweak it
---------------
To use this highlighter, associate patterns with styles in the `ZSH_HIGHLIGHT_PATTERNS` array, for example in `~/.zshrc`:

    # To have commands starting with `rm -rf` in red:
    ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

The syntax for declaring styles is [documented here](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135).
