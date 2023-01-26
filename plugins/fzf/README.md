# fzf

This plugin tries to find [junegunn's fzf](https://github.com/junegunn/fzf) based on where
it's been installed, and enables its fuzzy auto-completion and key bindings.

To use it, add `fzf` to the plugins array in your zshrc file:

```zsh
plugins=(... fzf)
```

## Settings

All these settings should go in your zshrc file, before Oh My Zsh is sourced.

### `FZF_BASE`

Set to fzf installation directory path:

```zsh
export FZF_BASE=/path/to/fzf/install/dir
```

### `FZF_DEFAULT_COMMAND`

Set default command to use when input is tty:

```zsh
export FZF_DEFAULT_COMMAND='<your fzf default command>'
```

If not set, the plugin will try to set it to these, in the order in which they're found:

- [`fd`](https://github.com/sharkdp/fd)
- [`rg`](https://github.com/BurntSushi/ripgrep)
- [`ag`](https://github.com/ggreer/the_silver_searcher)

### `DISABLE_FZF_AUTO_COMPLETION`

Set whether to load fzf auto-completion:

```zsh
DISABLE_FZF_AUTO_COMPLETION="true"
```

### `DISABLE_FZF_KEY_BINDINGS`

Set whether to disable key bindings (CTRL-T, CTRL-R, ALT-C):

```zsh
DISABLE_FZF_KEY_BINDINGS="true"
```

### Skip `dpkg` loading

If you have `dpkg` available in your `$PATH` but you don't want to load `fzf` from there, and facing some
issues, you can define this option before loading `oh-my-zsh` in order to skip that loading:

```zsh
zstyle ':omz:plugins:fzf' skip-dpkg yes
```
