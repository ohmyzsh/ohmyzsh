# OpenSandbox plugin

This plugin adds aliases for the [OpenSandbox CLI](https://github.com/opensandbox-group/OpenSandbox) (`osb`),
an `osbsh` wrapper that drops into a running sandbox, and completion with
dynamic sandbox IDs.

To use it, add `opensandbox` to the plugins array in your zshrc file:

```zsh
plugins=(... opensandbox)
```

Requires `osb` v1.x or newer on your `PATH` (install it via `uv tool install
opensandbox-cli` or `pip install opensandbox-cli`). JSON parsing uses `jq` if
available, `python3` otherwise.
The plugin is a silent no-op when `osb` is not installed.

## Aliases

Aliases cover the common sandbox workflow: `create -> run -> file transfer ->
endpoint -> kill`. Every one of these commands is used many times per session,
and the full form is long.

| Alias    | Command                | Why                                                          |
| :------- | :--------------------- | :----------------------------------------------------------- |
| `osbl`   | `osb sandbox list`     | Check what is running before every other step                |
| `osbnew` | `osb sandbox create`   | Start a sandbox for a task                                   |
| `osbrun` | `osb command run`      | Run workloads in the sandbox (the main loop)                 |
| `osbup`  | `osb file upload`      | Get files into the sandbox to work on                        |
| `osbdown`| `osb file download`    | Get results out of the sandbox                               |
| `osbep`  | `osb sandbox endpoint` | Reach a service port exposed by the sandbox                  |
| `osbres` | `osb sandbox resume`   | Continue after a pause instead of re-creating                |
| `osbpause`| `osb sandbox pause`    | Keep a sandbox around without paying for it running          |
| `osbkill`| `osb sandbox kill`     | Tear a sandbox down when the task is done                    |

The `template` command group is k8s-only (not supported by the default
runtime), so it has no aliases.

## `osbsh`

`osbsh [ID] [-w DIR]` opens an interactive terminal in a sandbox
(`osb terminal`). Without an ID it auto-selects the single **Running**
sandbox (`osb sandbox list -o json -s Running`, parsed with `jq` or
`python3`); if zero or multiple sandboxes are Running, it prints an error on
stderr and exits with status 1. Use it to drop into "the" sandbox without
typing its ID.

## Completion

The plugin generates the Click completion tree into
`$ZSH_CACHE_DIR/completions/_osb_click` (kubectl-style, atomic move) and
wraps it in `_osb`, which additionally offers live sandbox IDs
(`id (State)`) at every position where the CLI expects a `SANDBOX_ID`
(`terminal`, `sandbox ...`, `command ...`, `file ...`, `snapshot create`,
`egress ...`, `diagnostics ...`, `devops ...`). The ID list is cached for
5 seconds, so completion never forks `osb` on every TAB. A static
subcommand fallback keeps the first TAB working before the cache exists.
