# fnm plugin

This plugin adds autocompletion for [fnm](https://github.com/Schniz/fnm) - a Node.js version manager.

To use it, add `fnm` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... fnm)
```

## Configuration Variables

These settings should go in your `.zshrc` file, before Oh My Zsh is sourced.

For example:

```sh
ZSH_FNM_AUTOSTART=true
...
plugins=(... fnm)
source "$ZSH/oh-my-zsh.sh"
```

The following variables are available to this plugin customization:

| Variable | Default | Meaning |
| :------- | :-----: | ------- |
| `ZSH_FNM_AUTOSTART` | `false` | Automatically starts fnm for the session, running the `fnm env` |
| `ZSH_FNM_USE_ON_CD` | `true` | Switch the Node.js version based on the requirements of the current directory (recommended) |

Check out the [official documentation](https://github.com/Schniz/fnm/blob/master/docs/commands.md) for the available fnm variables.
