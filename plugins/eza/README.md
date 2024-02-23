# eza plugin

This provides aliases that invoke the [`eza`](https://github.com/eza-community/eza) utility rather than `ls`

To use it add `eza` to the plugins array in your zshrc file:

```zsh
plugins=(... eza)
```

## Configuration

All configurations are done using the `zstyle` command in the `:omz:plugins:eza` namespace.


### `dirs-first`

```zsh
zstyle ':omz:plugins:eza' 'dirs-first' $BOOL
```

If `1`, directories will be grouped first.

Default: `0`


### `showgroup`

```zsh
zstyle ':omz:plugins:eza' 'showgroup' $BOOL
```

If `1` (default), always add `-g` flag to show the group ownership.

Default: `1`


### `time-style`

```zsh
zstyle ':omz:plugins:eza' 'time-style' $TIME_STYLE
```

Sets the `--time-style` option of `eza`. (See `man eza` for the options)

Default: Not set, which means the default behavior of `eza` will take place.


## Aliases

Note that aliases may be modified by Configuration.


| Alias   | Command           | Description                                                                 |
| ------- | ----------------- | --------------------------------------------------------------------------- |
| `la`    | `eza -la`         | List all files (except . and ..) as a long list                             |
| `ldot`  | `eza -ld .*`      | List all dotfiles (directories shown as entries instead of recursed into)   |
| `ll`    | `eza -l`          | List files as a long list                                                   |
| `ls`    | `eza`             | Plain eza call                                                              |
| `lS`    | `eza -l -ssize`   | List files as a long list, sorted by size                                   |
| `lT`    | `eza -l -snewest` | List files as a long list, sorted by date (newest last)                     |

