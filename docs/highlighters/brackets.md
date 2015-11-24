zsh-syntax-highlighting / highlighters / brackets
-------------------------------------------------

This is the `brackets` highlighter, that highlights brackets and parentheses, and
matches them.


### How to tweak it

This highlighter defines the following styles:

* `bracket-error` - unmatched brackets
* `bracket-level-N` - brackets with nest level N
* `cursor-matchingbracket` - the matching bracket, if cursor is on a bracket

To override one of those styles, change its entry in `ZSH_HIGHLIGHT_STYLES`,
for example in `~/.zshrc`:

    # To define styles for nested brackets up to level 4
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=magenta,bold'

The syntax for values is the same as the syntax of "types of highlighting" of
the zsh builtin `$zle_highlight` array, which is documented in [the `zshzle(1)`
manual page][zshzle-Character-Highlighting].

[zshzle-Character-Highlighting]: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
