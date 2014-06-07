zsh-syntax-highlighting / highlighters / line
=================================================

This is the ***line*** highlighter, that highlights the whole line.


How to activate it
------------------
To activate it, add it to `ZSH_HIGHLIGHT_HIGHLIGHTERS`:

    ZSH_HIGHLIGHT_HIGHLIGHTERS=( [...] line)


How to tweak it
---------------
This highlighter defines the following styles:

* `line` - the style for the whole line

To override one of those styles, change its entry in `ZSH_HIGHLIGHT_STYLES`, for example in `~/.zshrc`:

    ZSH_HIGHLIGHT_STYLES[line]='bold'

The syntax for declaring styles is [documented here](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135).
