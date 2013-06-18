zsh-syntax-highlighting / highlighters / cursor
=================================================

This is the ***cursor*** highlighter, that highlights the cursor.


How to activate it
------------------
To activate it, add it to `ZSH_HIGHLIGHT_HIGHLIGHTERS`:

    ZSH_HIGHLIGHT_HIGHLIGHTERS=( [...] cursor)


How to tweak it
---------------
This highlighter defines the following styles:

* `cursor` - the style for the current cursor position

To override one of those styles, change its entry in `ZSH_HIGHLIGHT_STYLES`, for example in `~/.zshrc`:

    ZSH_HIGHLIGHT_STYLES[cursor]='bg=blue'

The syntax for declaring styles is [documented here](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135).
