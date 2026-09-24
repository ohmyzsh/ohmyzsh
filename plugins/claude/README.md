# claude

Aliases and completion for [Claude Code](https://code.claude.com), the `claude`
CLI.

To use it, add `claude` to the plugins array in your `.zshrc`:

```zsh
plugins=(... claude)
```

If `claude` is not on `$PATH` the plugin does nothing, silently.

## Aliases

| Alias   | Command                   | Description                                   |
| ------- | ------------------------- | --------------------------------------------- |
| `cl`    | `claude`                  | Start an interactive session                  |
| `clc`   | `claude --continue`       | Continue the most recent session here         |
| `clr`   | `claude --resume`         | Resume by session id, or open the picker      |
| `clw`   | `claude --worktree`       | Start in a new git worktree                   |
| `clp`   | `claude --print`          | One-shot prompt, print and exit               |
| `clbg`  | `claude --bg`             | Start a session in the background             |
| `clag`  | `claude agents`           | Manage background sessions                    |
| `clat`  | `claude attach`           | Attach to a background session                |
| `cllog` | `claude logs`             | Print a background session's recent output    |
| `clmcp` | `claude mcp`              | Manage MCP servers                            |
| `clpl`  | `claude plugin`           | Manage Claude Code plugins                    |
| `clup`  | `claude update`           | Update Claude Code                            |
| `clur`  | `claude update && claude` | Update, then start a session (update and run) |

`clp` reads stdin, so it pipes well:

```zsh
git diff | clp "review this"
```

## Completion

`_claude` completes `claude` and, through zsh's alias expansion, every alias
above.

Static:

- every top-level flag and subcommand
- values for `--model`, `--effort`, `--permission-mode`, `--output-format`,
  `--input-format`, `--setting-sources` and `--scope`
- subcommands of `mcp`, `plugin`, `plugin marketplace`, `auth`, `auto-mode` and
  `project`

Live:

| Where                                     | What                                              |
| ----------------------------------------- | ------------------------------------------------- |
| `mcp get/remove/login/logout`             | MCP servers from `~/.claude.json` and `.mcp.json` |
| `plugin install`                          | Plugins available in your marketplaces            |
| `plugin enable` / `disable`               | Installed plugins that are disabled / enabled     |
| `plugin uninstall/update/details`         | Installed plugins                                 |
| `plugin marketplace remove/update`        | Configured marketplaces                           |
| `attach`, `logs`, `stop`, `rm`, `respawn` | Background sessions from `claude agents --json`   |
| `ultrareview`                             | Local and remote git branches                     |

The live lists need [`jq`](https://jqlang.org). Without it they come back empty
and everything else still works.

## Maintenance

`claude` can't generate its own completion, so the flag list is written by hand
against `claude --help` (2.1.281). When a new flag shows up, add it to the
`_arguments` call in `_claude`. After editing, reload with:

```zsh
rm -f ~/.zcompdump*; exec zsh
```
