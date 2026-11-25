# zellij

This plugin provides aliases, functions, and completions for [zellij](https://zellij.dev/),
the terminal workspace (multiplexer). To use it, add `zellij` to the plugins array in your
zshrc file.

```zsh
plugins=(... zellij)
```

## Aliases

| Alias  | Command                      | Description                 |
| ------ | ---------------------------- | --------------------------- |
| `zj`   | `zellij`                     | Zellij command              |
| `zjl`  | `zellij list-sessions`       | List sessions               |
| `zjs`  | `zellij -s`                  | Start a named session       |
| `zjda` | `zellij delete-all-sessions` | Delete all sessions         |
| `zjka` | `zellij kill-all-sessions`   | Kill all sessions           |
| `zjr`  | `zellij run`                 | Run a command in a pane     |
| `zjad` | `zellij action detach`       | Detach from current session |

## Functions

| Function | Command                          | Description                      |
| -------- | -------------------------------- | -------------------------------- |
| `zja`    | `zellij attach`                  | Attach to a session              |
| `zjd`    | `zellij delete-session`          | Delete a session (exited only)   |
| `zjdf`   | `zellij delete-session --force`  | Force-delete any session         |
| `zjk`    | `zellij kill-session`            | Kill a session                   |
| `zjas`   | `zellij action switch-session`   | Switch to a session              |
| `zjrf`   | `zellij run --floating --`       | Run a command in a floating pane |
| `zje`    | `zellij edit`                    | Edit a file in a pane            |

## Completions

This plugin caches the zellij completion script. On first load the cache is generated
synchronously; subsequent updates (when the `zellij` binary is newer than the cache) happen in
the background. The cache is written to a temporary file and moved into place, so a
partially written file is never loaded.

Session-aware completions are provided for `zja`, `zjdf` and `zjas` (all sessions), `zjk`
(running sessions) and `zjd` (exited sessions).
