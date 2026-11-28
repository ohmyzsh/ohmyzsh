# fnm plugin

This plugin adds autocompletion for [fnm](https://github.com/Schniz/fnm) - a Node.js version manager.

To use it, add `fnm` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... fnm)
```

## Configuration

These settings should go in your `.zshrc` file, before Oh My Zsh is sourced.

### Autostart

If set, the plugin will automatically start fnm for the session, running the `fnm env`:

```zsh
zstyle ':omz:plugins:fnm' autostart yes
```

Default: `no` (disabled)

### Use on cd

If set, the Node.js version will be switched based on the requirements of the current directory (recommended):

```zsh
zstyle ':omz:plugins:fnm' use-on-cd yes
```

Default: `yes` (enabled)

Check out the [official documentation](https://github.com/Schniz/fnm/blob/master/docs/commands.md) for the available fnm variables.
