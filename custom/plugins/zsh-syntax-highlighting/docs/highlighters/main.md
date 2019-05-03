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
* `path_pathseparator` - path separators in filenames (`/`); if unset, `path` is used (default)
* `path_prefix` - prefixes of existing filenames
* `path_prefix_pathseparator` - path separators in prefixes of existing filenames (`/`); if unset, `path_prefix` is used (default)
* `globbing` - globbing expressions (`*.txt`)
* `history-expansion` - history expansion expressions (`!foo` and `^foo^bar`)
* `command-substitution` - command substitutions (`$(echo foo)`)
* `command-substitution-unquoted` - an unquoted command substitution (`$(echo foo)`)
* `command-substitution-quoted` - a quoted command substitution (`"$(echo foo)"`)
* `command-substitution-delimiter` - command substitution delimiters (`$(` and `)`)
* `command-substitution-delimiter-unquoted` - an unquoted command substitution delimiters (`$(` and `)`)
* `command-substitution-delimiter-quoted` - a quoted command substitution delimiters (`"$(` and `)"`)
* `process-substitution` - process substitutions (`<(echo foo)`)
* `process-substitution-delimiter` - process substitution delimiters (`<(` and `)`)
* `single-hyphen-option` - single-hyphen options (`-o`)
* `double-hyphen-option` - double-hyphen options (`--option`)
* `back-quoted-argument` - backtick command substitution (`` `foo` ``)
* `back-quoted-argument-unclosed` - unclosed backtick command substitution (`` `foo ``)
* `back-quoted-argument-delimiter` - backtick command substitution delimiters (`` ` ``)
* `single-quoted-argument` - single-quoted arguments (`` 'foo' ``)
* `single-quoted-argument-unclosed` - unclosed single-quoted arguments (`` 'foo ``)
* `double-quoted-argument` - double-quoted arguments (`` "foo" ``)
* `double-quoted-argument-unclosed` - unclosed double-quoted arguments (`` "foo ``)
* `dollar-quoted-argument` - dollar-quoted arguments (`` $'foo' ``)
* `dollar-quoted-argument-unclosed` - unclosed dollar-quoted arguments (`` $'foo ``)
* `rc-quote` - two single quotes inside single quotes when the `RC_QUOTES` option is set (`` 'foo''bar' ``)
* `dollar-double-quoted-argument` - parameter expansion inside double quotes (`$foo` inside `""`)
* `back-double-quoted-argument` -  backslash escape sequences inside double-quoted arguments (`\"` in `"foo\"bar"`)
* `back-dollar-quoted-argument` -  backslash escape sequences inside dollar-quoted arguments (`\x` in `$'\x48'`)
* `assign` - parameter assignments (`x=foo` and `x=( )`)
* `redirection` - redirection operators (`<`, `>`, etc)
* `comment` - comments, when `setopt INTERACTIVE_COMMENTS` is in effect (`echo # foo`)
* `named-fd` - named file descriptor (`echo foo {fd}>&2`)
* `arg0` - a command word other than one of those enumerated above (other than a command, precommand, alias, function, or shell builtin command).
* `default` - everything else

To override one of those styles, change its entry in `ZSH_HIGHLIGHT_STYLES`,
for example in `~/.zshrc`:

```zsh
# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES

# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

# To have paths colored instead of underlined
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# To disable highlighting of globbing expressions
ZSH_HIGHLIGHT_STYLES[globbing]='none'
```

The syntax for values is the same as the syntax of "types of highlighting" of
the zsh builtin `$zle_highlight` array, which is documented in [the `zshzle(1)`
manual page][zshzle-Character-Highlighting].

#### Parameters

To avoid partial path lookups on a path, add the path to the `X_ZSH_HIGHLIGHT_DIRS_BLACKLIST` array.
This interface is still experimental.

```zsh
X_ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/slow_share)
```

### Useless trivia

#### Forward compatibility.

zsh-syntax-highlighting attempts to be forward-compatible with zsh.
Specifically, we attempt to facilitate highlighting _command word_ types that
had not yet been invented when this version of zsh-syntax-highlighting was
released.

A _command word_ is something like a function name, external command name, et
cetera.  (See
[Simple Commands & Pipelines in `zshmisc(1)`][zshmisc-Simple-Commands-And-Pipelines]
for a formal definition.)

If a new _kind_ of command word is ever added to zsh — something conceptually
different than "function" and "alias" and "external command" — then command words
of that (new) kind will be highlighted by the style `arg0_$kind`,
where `$kind` is the output of `type -w` on the new kind of command word.  If that
style is not defined, then the style `arg0` will be used instead.

[zshmisc-Simple-Commands-And-Pipelines]: http://zsh.sourceforge.net/Doc/Release/Shell-Grammar.html#Simple-Commands-_0026-Pipelines

[zshzle-Character-Highlighting]: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
