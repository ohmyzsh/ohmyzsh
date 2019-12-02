# `copybuffer` plugin

This plugin binds the ctrl-o keyboard shortcut to a command that copies the text
that is currently typed in the command line ($BUFFER) to the system clipboard.

This is useful if you type a command - and before you hit enter to execute it - want
to copy it maybe so you can paste it into a script, gist or whatnot.

```zsh
plugins=(... copybuffer)
```
