# zellij

This plugin provides aliases and completions for [zellij](https://zellij.dev/), the terminal workspace
(multiplexer). To use it, add `zellij` to the plugins array in your zshrc file.

```zsh
plugins=(... zellij)
```

## Dynamic prefix

The default alias prefix is `zj`. To use the shorter `z` prefix instead, set the following
variable before oh-my-zsh is sourced:

```zsh
ZSH_ZELLIJ_PREFIX_Z=true
```

> **Note:** If `z` is already aliased by another plugin (e.g., zoxide), the prefix stays `zj`
> even when `ZSH_ZELLIJ_PREFIX_Z` is set.

## Aliases

| Alias (default) | Alias (with `z`) | Command                      | Description              |
| ---------------- | ---------------- | ---------------------------- | ------------------------ |
| `zj`             | `z`              | `zellij`                     | Zellij command           |
| `zja`            | `za`             | `zellij attach`              | Attach to a session      |
| `zjd`            | `zd`             | `zellij delete-session`      | Delete a session         |
| `zjda`           | `zda`            | `zellij delete-all-sessions` | Delete all sessions      |
| `zjk`            | `zk`             | `zellij kill-session`        | Kill a session           |
| `zjka`           | `zka`            | `zellij kill-all-sessions`   | Kill all sessions        |
| `zjl`            | `zl`             | `zellij list-sessions`       | List sessions            |
| `zjr`            | `zr`             | `zellij run`                 | Run a command in a pane  |
| `zjs`            | `zs`             | `zellij -s`                  | Start a named session    |

## Completions

This plugin caches the zellij completion script in the background (using the same approach as
the [gh](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gh) plugin). On first load the
cache is generated; completions become available in the next shell session.
