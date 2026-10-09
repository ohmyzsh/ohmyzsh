# Claude Code Plugin

The `claude-code` plugin adds several aliases and helper functions for [Claude Code](https://github.com/anthropics/claude-code), the CLI for Claude.

To use it, add `claude-code` to the plugins array of your zshrc file:

```zsh
plugins=(... claude-code)
```

## Configuration Variables

Set these in your `~/.zshrc` **before** the plugins line:

| Variable | Default | Description |
|----------|---------|-------------|
| `ZSH_CLAUDE_DEFAULT_MODEL` | _(unset)_ | Default model applied to all session aliases (e.g., `opus`, `sonnet`, `haiku`, or a full model ID) |
| `ZSH_CLAUDE_DEFAULT_EFFORT` | _(unset)_ | Default reasoning effort level (`low`, `medium`, `high`, `max`) |
| `ZSH_CLAUDE_DEFAULT_PERMISSION_MODE` | _(unset)_ | Default permission mode (`acceptEdits`, `bypassPermissions`, `default`, `dontAsk`, `plan`, `auto`) |
| `ZSH_CLAUDE_AUTO_CONTINUE` | `false` | Auto-resume last conversation on new shell start |

> **How defaults work:** All session-starting aliases (`cl`, `clc`, `clr`, `cln`, `clw`, etc.) automatically
> inject your configured defaults. If you also pass a flag explicitly (e.g., `cl --model opus`), the explicit
> flag takes precedence since it appears after the defaults on the command line.

### Example

```zsh
# ~/.zshrc
ZSH_CLAUDE_DEFAULT_MODEL="sonnet"
ZSH_CLAUDE_DEFAULT_EFFORT="high"
ZSH_CLAUDE_DEFAULT_PERMISSION_MODE="plan"
ZSH_CLAUDE_AUTO_CONTINUE=false

plugins=(... claude-code)
```

## Aliases

### Core

| Alias | Command | Description |
|-------|---------|-------------|
| `cl` | `claude` | Start interactive session |
| `clc` | `claude --continue` | Continue last conversation |
| `clr` | `claude --resume` | Open session picker |
| `clp` | `claude -p` | Headless/print mode |
| `clv` | `claude --version` | Show version |
| `clu` | `claude update` | Update Claude Code |

### Sessions

| Alias | Command | Description |
|-------|---------|-------------|
| `cln` | `claude -n` | Start a named session |
| `clw` | `claude -w` | Start in a git worktree |
| `clfork` | `claude --fork-session` | Fork current session |

### Auth

| Alias | Command | Description |
|-------|---------|-------------|
| `clas` | `claude auth status` | Check auth status |
| `clal` | `claude auth login` | Sign in |
| `clao` | `claude auth logout` | Sign out |

### Config

| Alias | Command | Description |
|-------|---------|-------------|
| `clmcp` | `claude mcp` | Manage MCP servers |
| `clag` | `claude agents` | List configured agents |

### Channels

| Alias | Command | Description | Plugin Install |
|-------|---------|-------------|----------------|
| `clch-tg` | `claude --channels plugin:telegram@...` | Start with Telegram channel | `/plugin install telegram@claude-plugins-official` |
| `clch-dc` | `claude --channels plugin:discord@...` | Start with Discord channel | `/plugin install discord@claude-plugins-official` |
| `clch <spec>` | `claude --channels <spec>` | Start with custom channel | — |

## Functions

| Function | Description | Example |
|----------|-------------|---------|
| `clm <model>` | Start with a specific model (also applies effort and permission-mode defaults) | `clm opus` |
| `cle <effort>` | Start with a specific effort level (also applies model and permission-mode defaults) | `cle high` |
| `clds` | Directory session — create or resume a session named after `$PWD` | `clds` |
| `clfp <pr>` | Resume sessions linked to a GitHub PR | `clfp 123` |

## Tab Completion

- `clm [TAB]` — completes model names (`opus`, `sonnet`, `haiku`)
- `cle [TAB]` — completes effort levels (`low`, `medium`, `high`, `max`)
