zsh-syntax-highlighting / highlighters / main
=============================================

This is the ***main*** highlighter, that highlights:

* Commands
* Options
* Arguments
* Paths
* Strings

How to activate it
------------------
To activate it, add it to `ZSH_HIGHLIGHT_HIGHLIGHTERS`:

    ZSH_HIGHLIGHT_HIGHLIGHTERS=( [...] main)

This highlighter is active by default.


How to tweak it
---------------
This highlighter defines the following styles:

* `unknown-token` - unknown tokens / errors
* `reserved-word` - shell reserved words
* `alias` - aliases
* `builtin` - shell builtin commands
* `function` - functions
* `command` - commands
* `precommand` - precommands (i.e. exec, builtin, ...)
* `commandseparator` - command separation tokens
* `hashed-command` - hashed commands
* `path` - paths
* `globbing` - globbing expressions
* `history-expansion` - history expansion expressions
* `single-hyphen-option` - single hyphen options
* `double-hyphen-option` - double hyphen options
* `back-quoted-argument` - backquoted expressions
* `single-quoted-argument` - single quoted arguments
* `double-quoted-argument` - double quoted arguments
* `dollar-double-quoted-argument` -  dollar double quoted arguments
* `back-double-quoted-argument` -  back double quoted arguments
* `assign` - variable assignments
* `default` - parts of the buffer that do not match anything

To override one of those styles, change its entry in `ZSH_HIGHLIGHT_STYLES`, for example in `~/.zshrc`:

    # To differentiate aliases from other command types
    ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
    
    # To have paths colored instead of underlined
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
    
    # To disable highlighting of globbing expressions
    ZSH_HIGHLIGHT_STYLES[globbing]='none'

The syntax for declaring styles is [documented here](http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135).
