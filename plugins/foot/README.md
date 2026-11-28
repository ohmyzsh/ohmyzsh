# foot

This plugin adds shell integration for [foot, a fast, lightweight and
minimalistic Wayland terminal emulator](https://codeberg.org/dnkl/foot).

To use, add `foot` to the list of plugins in your `.zshrc` file:

```zsh
plugins=(... foot)
```

## Spawning new terminal instances in the current working directory

When spawning a new terminal instance (with `ctrl+shift+n` by default), the new
instance will start in the current working directory.

## Jumping between prompts

Foot can move the current viewport to focus prompts of already executed
commands (bound to ctrl+shift+z/x by default).

## Piping last command's output

The key binding `pipe-command-output` can pipe the last command's output to an
application of your choice (similar to the other `pipe-*` key bindings):

```
[key-bindings]
pipe-command-output=[sh -c "f=$(mktemp); cat - > $f; footclient emacsclient -nw $f; rm $f"] Control+Shift+g
```

When pressing ctrl+shift+g, the last command's output is written to a
temporary file, then an emacsclient is started in a new footclient instance.
The temporary file is removed after the footclient instance has closed.

