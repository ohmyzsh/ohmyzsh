# Generic Colouriser plugin

This plugin adds wrappers for commands supported by [Generic Colouriser](https://github.com/garabik/grc):

To use it, add `grc` to the plugins array in your zshrc file:

```zsh
plugins=(... grc)
```

## Commands

The plugin sources the bundled alias generator from the installation,
available at `/etc/grc.zsh`. The complete list of alises may vary
depending on the installed version of `grc` on system.

For checking the complete list, grep on the list of active aliases:

```zsh
alias | grep grc
```
