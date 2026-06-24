# ai-session-search

fzf-style fuzzy search across the session histories of multiple AI CLIs:
**Claude Code / Codex / Copilot / Gemini**. Hit a hotkey to pop up a list, type
`claude` / `codex` / `copilot` / `gemini` to filter by tool, and press Enter to
`resume` the session right in its original directory.

To use it, add `ai-session-search` to the plugins array in your zshrc file:

```zsh
plugins=(... ai-session-search)
```

## Requirements

This plugin requires [`fzf`](https://github.com/junegunn/fzf) (the picker, 0.35+
recommended) and [`jq`](https://stedolan.github.io/jq/) (to parse the session
files):

```sh
brew install fzf jq          # macOS
sudo apt install fzf jq      # Debian/Ubuntu
```

Browsing and previewing work with just `fzf` + `jq` — scanning reads the session
files directly. To actually *resume* a session you also need the matching CLI on
your `PATH` (`claude` / `codex` / `copilot` / `gemini`).

## Usage

Default keybinding: <kbd>Ctrl-X</kbd> <kbd>Ctrl-W</kbd> (does not clobber zsh's
built-in <kbd>Ctrl-W</kbd> backward-kill-word). You can also run it as a command:
`ai-sessions` or `ai-sessions codex` (with an initial filter term).

In the picker:

| Key     | Action |
|---------|--------|
| type    | fuzzy-filter (the provider name is part of each row, so typing `claude` narrows to Claude) |
| Enter   | resume the selected session in its original directory |
| Ctrl-O  | open the raw `.jsonl` in `$EDITOR` |
| Ctrl-/  | toggle the preview pane |
| Ctrl-R  | rescan |

## How it works

- **Claude**: scans `~/.claude/projects/<dir>/<uuid>.jsonl` (skips `subagents/`
  sub-agent sessions); `cwd` is read from the `cwd` field inside the file;
  resume uses `claude --resume <uuid>`.
- **Codex**: scans `~/.codex/sessions/YYYY/MM/DD/rollout-*.jsonl`; `cwd` and `id`
  come from `session_meta`; resume uses `codex resume <uuid>`.
- **Copilot**: scans `~/.copilot/session-state/<uuid>/events.jsonl`; `cwd` /
  model / version come from the `session.start` event, the `id` is the directory
  name; resume uses `copilot --resume=<uuid>`.
- **Gemini**: scans `~/.gemini/tmp/<hash>/logs.json` (gemini-cli format,
  **experimental**; empty if gemini-cli isn't installed; gemini-cli has no
  resume-by-id, so it just opens in the directory).

Each row's preview is the first real user message, with injected context like
`<environment_context>` and `AGENTS.md` filtered out. Sessions whose original
directory no longer exists are hidden (set `AISS_SHOW_MISSING=1` to keep them).
At this scale (dozens of files) live scanning is plenty — no cache needed.

## Settings

All these settings should go in your zshrc file, before Oh My Zsh is sourced.

| Variable | Default | Description |
|----------|---------|-------------|
| `AISS_KEYBIND` | `^X^W` | Keybinding for the picker widget (e.g. `^G`) |
| `AISS_CLAUDE_DIR` | `~/.claude/projects` | Claude Code sessions directory |
| `AISS_CODEX_DIR` | `~/.codex/sessions` | Codex sessions directory |
| `AISS_COPILOT_DIR` | `~/.copilot/session-state` | Copilot CLI sessions directory |
| `AISS_GEMINI_DIR` | `~/.gemini/tmp` | Gemini CLI sessions directory |
| `AISS_PREVIEW_LEN` | `100` | Chars of the preview snippet shown in the list |
| `AISS_SHOW_MISSING` | unset | Set to `1` to keep sessions whose directory was deleted |

> **Note:** `AISS_KEYBIND` must be set *before* Oh My Zsh sources the plugin.
