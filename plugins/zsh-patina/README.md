# zsh-patina plugin

Initializes [zsh-patina](https://github.com/michel-kraemer/zsh-patina), a
"blazingly fast Zsh plugin performing syntax highlighting of your command line
while you type 🌈"

To use it, add `zsh-patina` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... zsh-patina)
```

zsh-patina replaces [zsh-syntax-highlighting](../zsh-syntax-highlighting), so
enable only one of them. If zsh-syntax-highlighting is in the plugins array or
already loaded, this plugin prints a warning and does not activate.

## Binary location

If `zsh-patina` is not in your `PATH` when Oh My Zsh loads (eg: it lives in
`~/.cargo/bin`), set `ZSH_PATINA_BINARY` to its full path before sourcing
Oh My Zsh:

```zsh
ZSH_PATINA_BINARY=$HOME/.cargo/bin/zsh-patina
```

**Note:** you have to [install zsh-patina](https://github.com/michel-kraemer/zsh-patina#how-to-install) first.
