# zellij

This plugin provides aliases and completions for [zellij](https://zellij.dev/), the terminal workspace
(multiplexer). To use it, add `zellij` to the plugins array in your zshrc file.

```zsh
plugins=(... zellij)
```

## Dynamic prefix

The default alias prefix is `z`. If `z` is already taken by another plugin (e.g., the
[suse](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/suse) plugin), the prefix
automatically falls back to `zj`.

## Aliases

| Alias      | Command                      | Description              |
| ---------- | ---------------------------- | ------------------------ |
| `z`/`zj`   | `zellij`                     | Zellij command           |
| `za`/`zja`  | `zellij attach`              | Attach to a session      |
| `zd`/`zjd`  | `zellij delete-session`      | Delete a session         |
| `zda`/`zjda` | `zellij delete-all-sessions` | Delete all sessions      |
| `zk`/`zjk`  | `zellij kill-session`        | Kill a session           |
| `zka`/`zjka` | `zellij kill-all-sessions`   | Kill all sessions        |
| `zl`/`zjl`  | `zellij list-sessions`       | List sessions            |
| `zr`/`zjr`  | `zellij run`                 | Run a command in a pane  |
| `zs`/`zjs`  | `zellij -s`                  | Start a named session    |

## Completions

This plugin caches the zellij completion script in the background (using the same approach as
the [gh](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/gh) plugin). On first load the
cache is generated; completions become available in the next shell session.
