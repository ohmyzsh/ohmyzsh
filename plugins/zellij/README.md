# zellij

This plugin provides aliases, functions, and completions for [zellij](https://zellij.dev/),
the terminal workspace (multiplexer). To use it, add `zellij` to the plugins array in your
zshrc file.

```zsh
plugins=(... zellij)
```

## Dynamic prefix

The default prefix is `zj`. To use the shorter `z` prefix instead, set the following variable
before oh-my-zsh is sourced:

```zsh
ZSH_ZELLIJ_PREFIX_Z=true
```

When `ZSH_ZELLIJ_PREFIX_Z` is set, the root alias (`z`) and sub-command prefix are handled
separately:

- If `z` is **not** taken → `z`=zellij, sub-commands use `z` prefix (`zl`, `za`, …)
- If `z` **is** taken (e.g., by zoxide) → `zj`=zellij, but sub-commands still use `z` prefix (`zl`, `za`, …)

This means only the root alias falls back to `zj`; the shorter sub-command shortcuts remain
usable.

All aliases and functions perform a conflict check before being defined — if a name is already
taken by another alias, function, or command, it is silently skipped.

## Aliases

| Alias (default) | Alias (with `z`) | Alias (`z` + conflict) | Command                      | Description              |
| ---------------- | ---------------- | ---------------------- | ---------------------------- | ------------------------ |
| `zj`             | `z`              | `zj`                   | `zellij`                     | Zellij command           |
| `zjl`            | `zl`             | `zl`                   | `zellij list-sessions`       | List sessions            |
| `zjs`            | `zs`             | `zs`                   | `zellij -s`                  | Start a named session    |
| `zjda`           | `zda`            | `zda`                  | `zellij delete-all-sessions` | Delete all sessions      |
| `zjka`           | `zka`            | `zka`                  | `zellij kill-all-sessions`   | Kill all sessions        |
| `zjr`            | —                | —                      | `zellij run`                       | Run a command in a pane     |
| `zjad`           | `zad`            | `zad`                  | `zellij action detach`             | Detach from current session |

## Functions

| Function (default) | Function (with `z`) | Command                            | Description            |
| ------------------- | ------------------- | ---------------------------------- | ---------------------- |
| `zja`               | `za`                | `zellij attach`                    | Attach to a session    |
| `zjd`               | `zd`                | `zellij delete-session`            | Delete a session       |
| `zjk`               | `zk`                | `zellij kill-session`              | Kill a session         |
| `zjas`              | `zas`               | `zellij action switch-session`     | Switch to a session    |

The following convenience functions are always available (unless the name is already taken):

| Function | Command                      | Description                        |
| -------- | ---------------------------- | ---------------------------------- |
| `zr`     | `zellij run --`              | Run a command in a pane            |
| `zrf`    | `zellij run --floating --`   | Run a command in a floating pane   |
| `ze`     | `zellij edit`                | Edit a file in a pane              |

## Help

Type `zjh` (or `zh` with `z` prefix) to see a summary of all available aliases and functions.

## Completions

This plugin caches the zellij completion script. On first load the cache is generated
synchronously; subsequent updates (when the `zellij` binary is newer than the cache) happen in
the background.

Session-aware completions are provided for `attach`, `delete-session`, and `kill-session`
functions — only relevant sessions (all, running, or exited) are offered.
