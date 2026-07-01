# opencode plugin

Zsh plugin for the [opencode](https://opencode.ai) AI coding agent.
Compatible with [oh‑my‑zsh](https://github.com/ohmyzsh/ohmyzsh).

## Prerequisites

- **opencode CLI** — install with `npm install -g opencode-ai`, or follow the
  [install guide](https://opencode.ai/docs). The plugin does nothing without
  the `opencode` command on your `$PATH`.
- **zsh 5.1+** — any modern zsh works. No oh‑my‑zsh dependency for the
  standalone path, but `$ZSH_CACHE_DIR` must be set if you want completions
  (oh‑my‑zsh sets this automatically; for standalone shells the plugin falls
  back to `$HOME/.cache/zsh`).

## Enable

### Oh‑my‑zsh

Add `opencode` to your plugins array in `.zshrc`:

```zsh
plugins=(... opencode)
```

### Standalone (source directly)

Clone the repo and source the plugin file from `.zshrc`:

```zsh
source /path/to/opencode.plugin.zsh
```

## Quick start

| If you want to...                | Type this          |
| -------------------------------- | ------------------ |
| Launch opencode in this project  | `oc`               |
| Pick up where you left off       | `occ`              |
| Ask a quick question, no TUI     | `ocr "question"`   |
| Attach to a remote server        | `oca <url>`        |
| Check your usage and costs       | `ocst`             |
| Upgrade to the latest version    | `ocup`             |

## Aliases

All aliases use the `oc` prefix. The scheme helps you guess them:

| After `oc` | What it means                     | Examples                              |
| ---------- | --------------------------------- | ------------------------------------- |
| 1 letter   | Flag name                         | `ocm` = `--model`, `ocp` = `--prompt` |
| 2 letters  | Subcommand                        | `ocr` = run, `ocmo` = models          |
| 3+ letters | Subcommand + flag or subcommand   | `ocmor` = models `--refresh`          |
| Natural    | Common verb from other tools      | `oclogin` / `oclogout`                |

Prefix `oc` runs `opencode` (the TUI). Add `c` for `--continue` to resume
where you left off: `occ`, `ocrc`.

| Alias    | Command                                       | Description                      |
| -------- | --------------------------------------------- | -------------------------------- |
| `oc`     | `opencode`                                    | Launch TUI                       |
| `occ`    | `opencode --continue`                         | Continue last session            |
| `ocfc`   | `opencode --fork --continue`                  | Fork last session                |
| `ocm`    | `opencode --model`                            | Launch with a specific model     |
| `ocp`    | `opencode --prompt`                           | Launch with an initial prompt    |
| `ocpu`   | `opencode --pure`                             | Launch without plugins           |
| `ocr`    | `opencode run`                                | Run non-interactive              |
| `ocrc`   | `opencode run --continue`                     | Continue in run mode             |
| `ocrs`   | `opencode run --share`                        | Run and share the session        |
| `ocrj`   | `opencode run --format json`                  | Run with JSON output             |
| `ocrf`   | `opencode run --file`                         | Run with files attached          |
| `ocra`   | `opencode run --attach`                       | Run attached to a server         |
| `ocrq`   | `opencode run --dangerously-skip-permissions` | Quick run (skip permission asks) |
| `ocs`    | `opencode serve`                              | Start headless server            |
| `ocw`    | `opencode web`                                | Start server with web UI         |
| `oca`    | `opencode attach`                             | Attach TUI to running server     |
| `ocacp`  | `opencode acp`                                | Start ACP server                 |
| `ocau`   | `opencode auth`                               | Manage credentials               |
| `oclogin`| `opencode auth login`                         | Log in to a provider             |
| `ocaul`  | `opencode auth list`                          | List authenticated providers     |
| `oclogout`| `opencode auth logout`                       | Log out of a provider            |
| `ocmo`   | `opencode models`                             | List available models            |
| `ocmor`  | `opencode models --refresh`                   | Refresh models cache             |
| `ocmov`  | `opencode models --verbose`                   | List models with metadata        |
| `ocmc`   | `opencode mcp`                                | Manage MCP servers               |
| `ocmca`  | `opencode mcp add`                            | Add an MCP server                |
| `ocmcl`  | `opencode mcp list`                           | List MCP servers                 |
| `ocmcau` | `opencode mcp auth`                           | Authenticate with an MCP server  |
| `ocmclo` | `opencode mcp logout`                         | Remove MCP credentials           |
| `ocmcd`  | `opencode mcp debug`                          | Debug MCP connection issues      |
| `ocag`   | `opencode agent`                              | Manage agents                    |
| `ocagl`  | `opencode agent list`                         | List agents                      |
| `ocagc`  | `opencode agent create`                       | Create a new agent               |
| `ocse`   | `opencode session`                            | Manage sessions                  |
| `ocsel`  | `opencode session list`                       | List sessions                    |
| `ocsed`  | `opencode session delete`                     | Delete a session                 |
| `ocst`   | `opencode stats`                              | Show usage statistics            |
| `ocstm`  | `opencode stats --models`                     | Show per-model usage breakdown   |
| `ocex`   | `opencode export`                             | Export session data as JSON      |
| `ocim`   | `opencode import`                             | Import session from JSON/URL     |
| `ocgh`   | `opencode github`                             | Manage GitHub agent              |
| `ocghi`  | `opencode github install`                     | Install GitHub agent             |
| `ocghr`  | `opencode github run`                         | Run GitHub agent                 |
| `ocpr`   | `opencode pr`                                 | Fetch PR and run opencode on it  |
| `ocpl`   | `opencode plugin`                             | Install a plugin                 |
| `ocplug` | `opencode plug`                               | Shorthand for `plugin`           |
| `ocplg`  | `opencode plugin --global`                    | Install plugin globally          |
| `ocdbg`  | `opencode debug`                              | Debugging and troubleshooting    |
| `ocdb`   | `opencode db`                                 | Database utilities               |
| `ocdbp`  | `opencode db path`                            | Print database file path         |
| `ocdbm`  | `opencode db migrate`                         | Migrate JSON data to SQLite      |
| `ocup`   | `opencode upgrade`                            | Upgrade opencode                 |
| `ocun`   | `opencode uninstall`                          | Uninstall opencode               |
| `occom`  | `opencode completion`                         | Print shell completion script    |

## Examples

```zsh
# Start or continue a session in the current project
oc

# Continue where you left off
occ

# Ask a one-shot question without entering the TUI
ocr "What does this function do?"

# List available models from all configured providers
ocmo

# Run with JSON output, useful for scripting
ocrj "Check for security issues" > audit.json

# Start a headless server that other terminals can attach to
ocs --port 4096

# Attach a TUI to that server from another terminal
oca http://localhost:4096

# Show token usage and cost
ocst

# Install a plugin
ocpl opencode-model-scout
```

## Completion

On the first shell startup after enabling this plugin, `opencode completion zsh`
runs in the background and caches the output to
`$ZSH_CACHE_DIR/completions/_opencode`. After that, tab-completion works for
all opencode commands and flags.

If completions are missing or outdated, regenerate them manually:

```zsh
opencode completion zsh > "$ZSH_CACHE_DIR/completions/_opencode"
```
