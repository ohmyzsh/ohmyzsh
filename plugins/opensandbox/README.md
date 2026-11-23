# OpenSandbox plugin

Adds three aliases, an `osbsh` wrapper, and cached, CLI-generated
completion for the [OpenSandbox CLI](https://github.com/opensandbox-group/OpenSandbox)
(`osb`).

To use it, add `opensandbox` to the plugins array in your zshrc file:

```zsh
plugins=(... opensandbox)
```

Requires `osb` v1.x on your `PATH` (`uv tool install opensandbox-cli` or
`pip install opensandbox-cli`); the plugin is a silent no-op when `osb`
is not installed.

## Aliases

Aliases cover the core sandbox workflow: list -> create -> run.

| Alias    | Command              | Why                                  |
| :------- | :------------------- | :----------------------------------- |
| `osbl`   | `osb sandbox list`   | Check what is running                |
| `osbnew` | `osb sandbox create` | Start a sandbox for a task           |
| `osbrun` | `osb command run`    | Run workloads in the sandbox         |

## `osbsh`

`osbsh [ID] [-w DIR]` opens an interactive terminal in a sandbox
(`osb terminal`). Without an ID it auto-selects the single **Running**
sandbox (parsed with `jq` or `python3`); if zero or multiple sandboxes
are Running, it prints an error on stderr and exits with status 1.

## Completion

`osb` ships its own Click-based completion. The plugin caches the output
of `_OSB_COMPLETE=zsh_source osb` in `$ZSH_CACHE_DIR/completions/_osb_completion`
on every shell start (uv-style, atomic move via `zf_mv`); `compinit`
binds it through the file's `#compdef osb` header. On the very first run
the file does not exist yet, so the plugin autoloads it and registers the
binding once; later shells pick it up from `fpath`.

The plugin additionally wraps that generated completer (`_osb`) and adds
live sandbox IDs with their state at the positions where the CLI expects
a `SANDBOX_ID` (e.g. `osb terminal <ID>`, `osb sandbox kill <ID>`) — the
generated completion offers nothing there. No subcommand or position
knowledge of the CLI is duplicated: a subcommand that is not covered
yields no IDs, never broken completion.

> **Upstream:** native ID completion belongs in the CLI itself — tracked
> in an [OpenSandbox issue](ISSUE_URL); once the CLI ships it, the
> `_osb` bridge can be dropped and the plugin stays uv-style only.
