zsh-syntax-highlighting / highlighters / main
---------------------------------------------

This is the `main` highlighter, that highlights:

* Commands
* Options
* Arguments
* Paths
* Strings

This highlighter is active by default.


### How to tweak it

This highlighter defines the following styles:

* `unknown-token` - unknown tokens / errors
* `reserved-word` - shell reserved words (`if`, `for`)
* `alias` - aliases
* `suffix-alias` - suffix aliases (requires zsh 5.1.1 or newer)
* `builtin` - shell builtin commands (`shift`, `pwd`, `zstyle`)
* `function` - function names
* `command` - command names
* `precommand` - precommand modifiers (e.g., `noglob`, `builtin`)
* `commandseparator` - command separation tokens (`;`, `&&`)
* `hashed-command` - hashed commands
* `path` - existing filenames
* `path_prefix` - prefixes of existing filenames
* `globbing` - globbing expressions (`*.txt`)
* `history-expansion` - history expansion expressions (`!foo` and `^foo^bar`)
* `single-hyphen-option` - single hyphen options (`-o`)
* `double-hyphen-option` - double hyphen options (`--option`)
* `back-quoted-argument` - backquoted expressions (`` `foo` ``)
* `single-quoted-argument` - single quoted arguments (`` 'foo' ``)
* `double-quoted-argument` - double quoted arguments (`` "foo" ``)
* `dollar-quoted-argument` - dollar quoted arguments (`` $'foo' ``)
* `dollar-double-quoted-argument` - parameter expansion inside double quotes (`$foo` inside `""`)
* `back-double-quoted-argument` -  back double quoted arguments (`\x` inside `""`)
* `back-dollar-quoted-argument` -  back dollar quoted arguments (`\x` inside `$''`)
* `assign` - parameter assignments
* `redirection` - redirection operators (`<`, `>`, etc)
* `comment` - comments, when `setopt INTERACTIVE_COMMENTS` is in effect (`echo # foo`)
* `default` - everything else

To override one of those styles, change its entry in `ZSH_HIGHLIGHT_STYLES`,
for example in `~/.zshrc`:

    # Declare the variable
    typeset -A ZSH_HIGHLIGHT_STYLES

    # To differentiate aliases from other command types
    ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
    
    # To have paths colored instead of underlined
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
    
    # To disable highlighting of globbing expressions
    ZSH_HIGHLIGHT_STYLES[globbing]='none'

The syntax for values is the same as the syntax of "types of highlighting" of
the zsh builtin `$zle_highlight` array, which is documented in [the `zshzle(1)`
manual page][zshzle-Character-Highlighting].

[zshzle-Character-Highlighting]: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
