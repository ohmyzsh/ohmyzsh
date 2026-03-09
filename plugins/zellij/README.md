# zellij

This plugin provides aliases, functions, and completions for [zellij](https://zellij.dev/),
the terminal workspace (multiplexer). To use it, add `zellij` to the plugins array in your
zshrc file.

```zsh
plugins=(... zellij)
```

## Dynamic prefix

The default alias prefix is `zj`. To use the shorter `z` prefix instead, set the following
variable before oh-my-zsh is sourced:

```zsh
ZSH_ZELLIJ_PREFIX_Z=true
```

> **Note:** If `z` is already defined as an alias, function, or command by another plugin
> (e.g., zoxide), the `zj` prefix is used for the main `zellij` alias even when
> `ZSH_ZELLIJ_PREFIX_Z` is set.

## Aliases

| Alias (default) | Alias (with `z`) | Command                      | Description              |
| ---------------- | ---------------- | ---------------------------- | ------------------------ |
| `zj`             | `z`              | `zellij`                     | Zellij command           |
| `zjl`            | `zl`             | `zellij list-sessions`       | List sessions            |
| `zjs`            | `zs`             | `zellij -s`                  | Start a named session    |
| `zjda`           | `zda`            | `zellij delete-all-sessions` | Delete all sessions      |
| `zjka`           | `zka`            | `zellij kill-all-sessions`   | Kill all sessions        |
| `zjr`            | —                | `zellij run`                 | Run a command in a pane  |

## Functions

| Function (default) | Function (with `z`) | Command                        | Description                       |
| ------------------- | ------------------- | ------------------------------ | --------------------------------- |
| `zja`               | `za`                | `zellij attach`                | Attach to a session               |
| `zjd`               | `zd`                | `zellij delete-session`        | Delete a session                  |
| `zjk`               | `zk`                | `zellij kill-session`          | Kill a session                    |

The following convenience functions are always available (unless the name is already taken):

| Function | Command                      | Description                        |
| -------- | ---------------------------- | ---------------------------------- |
| `zr`     | `zellij run --`              | Run a command in a pane            |
| `zrf`    | `zellij run --floating --`   | Run a command in a floating pane   |
| `ze`     | `zellij edit`                | Edit a file in a pane              |

## Completions

This plugin caches the zellij completion script. On first load the cache is generated
synchronously; subsequent updates (when the `zellij` binary is newer than the cache) happen in
the background.

Session-aware completions are provided for `attach`, `delete-session`, and `kill-session`
functions — only relevant sessions (all, running, or exited) are offered.
