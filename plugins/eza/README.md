# eza plugin

This provides aliases that invoke the [`eza`](https://github.com/eza-community/eza) utility rather than `ls`

To use it add `eza` to the plugins array in your zshrc file:

```zsh
plugins=(... eza)
```

## Configuration

All configurations are done using the `zstyle` command in the `:omz:plugins:eza` namespace.

**NOTE:** The configuring needs to be done prior to OMZ loading the plugins. When the plugin is loaded,
changing the `zstyle` won't have any effect.

### `dirs-first`

```zsh
zstyle ':omz:plugins:eza' 'dirs-first' yes|no
```

If `yes`, directories will be grouped first.

Default: `no`

### `git-status`

```zsh
zstyle ':omz:plugins:eza' 'git-status' yes|no
```

If `yes`, always add `--git` flag to indicate git status (if tracked / in a git repo).

Default: `no`

### `header`

```zsh
zstyle ':omz:plugins:eza' 'header' yes|no
```

If `yes`, always add `-h` flag to add a header row for each column.

Default: `no`

### `show-group`

```zsh
zstyle ':omz:plugins:eza' 'show-group' yes|no
```

If `yes` (default), always add `-g` flag to show the group ownership.

Default: `yes`

### `icons`

```zsh
zstyle ':omz:plugins:eza' 'icons' yes|no
```

If `yes`, sets the `--icons` option of `eza`, adding icons for files and folders.

Default: `no`

### `color-scale`

```zsh
zstyle ':omz:plugins:eza' 'color-scale' all|age|size
```

Highlight levels of field(s) distinctly. Use comma(,) separated list of `all`, `age`, `size`

Default: `none`

### `color-scale-mode`

```zsh
zstyle ':omz:plugins:eza' 'color-scale-mode' gradient|fixed
```

Choose the mode for highlighting:

- `gradient` (default) -- gradient coloring
- `fixed` -- fixed coloring

Default: `gradient`

### `size-prefix`

```zsh
zstyle ':omz:plugins:eza' 'size-prefix' (binary|none|si)
```

Choose the prefix to be used in displaying file size:

- `binary` -- use [binary prefixes](https://en.wikipedia.org/wiki/Binary_prefix) such as "Ki", "Mi", "Gi" and
  so on
- `none` -- don't use any prefix, show size in bytes
- `si` (default) -- use [Metric/S.I. prefixes](https://en.wikipedia.org/wiki/Metric_prefix)

Default: `si`

### `time-style`

```zsh
zstyle ':omz:plugins:eza' 'time-style' $TIME_STYLE
```

Sets the `--time-style` option of `eza`. (See `man eza` for the options)

Default: Not set, which means the default behavior of `eza` will take place.

### `hyperlink`

```zsh
zstyle ':omz:plugins:eza' 'hyperlink' yes|no
```

If `yes`, always add `--hyperlink` flag to create hyperlink with escape codes.

Default: `no`

## Aliases

**Notes:**

- Aliases may be modified by Configuration
- The term "files" without "only" qualifier means both files & directories

| Alias  | Command           | Description                                                                |
| ------ | ----------------- | -------------------------------------------------------------------------- |
| `la`   | `eza -la`         | List all files (except . and ..) as a long list                            |
| `ldot` | `eza -ld .*`      | List dotfiles only (directories shown as entries instead of recursed into) |
| `lD`   | `eza -lD`         | List only directories (excluding dotdirs) as a long list                   |
| `lDD`  | `eza -laD`        | List only directories (including dotdirs) as a long list                   |
| `ll`   | `eza -l`          | List files as a long list                                                  |
| `ls`   | `eza`             | Plain eza call                                                             |
| `lsd`  | `eza -d`          | List specified files with directories as entries, in a grid                |
| `lsdl` | `eza -dl`         | List specified files with directories as entries, in a long list           |
| `lS`   | `eza -l -ssize`   | List files as a long list, sorted by size                                  |
| `lT`   | `eza -l -snewest` | List files as a long list, sorted by date (newest last)                    |
