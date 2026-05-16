# zbell plugin

This plugin prints a bell character when a command finishes if it has been
running for longer than a specified duration.

To use it, add `zbell` to the plugins array in your zshrc file:

```zsh
plugins=(... zbell)
```

## Settings

These settings need to be set in your zshrc file, before Oh My Zsh is sourced.

- `zbell_duration`: duration in seconds after which to consider notifying
  the end of a command. Default: 15 seconds.

- `zbell_ignore`: if there are programs that you know run long that you
  don't want to bell after, then add them to the `zbell_ignore` array.
  By default, `$EDITOR` and `$PAGER` are ignored:

  ```zsh
  zbell_ignore=($EDITOR $PAGER)
  ```

- `zbell_use_notify_send`: If set to `true`, `notify-send` tool is used -- if
  available -- to display a popup on the screen. Default: `true` (enabled).

## Author

Adapted from an original version by [Jean-Philippe Ouellet](https://github.com/jpouellet).
Made available under the ISC license.
