# Theme Browser

```zsh
omz theme browse
omz theme browse agn
omz theme preview agnoster
```

The browser renders only the highlighted theme, in your invoking directory with real,
synchronous Git information. Filtering is a case-insensitive literal substring match.
Names are deduplicated; resolution follows normal Oh My Zsh precedence:
`$ZSH_CUSTOM/<name>.zsh-theme`, `$ZSH_CUSTOM/themes/<name>.zsh-theme`, then
`$ZSH/themes/<name>.zsh-theme`. Nested custom themes are supported. The `random`
selector and names containing traversal components or control characters are excluded.

## Controls

| Key | Action |
| --- | --- |
| Up / Down, Ctrl-P / Ctrl-N | Previous / next theme |
| Page Up / Page Down | Move one page |
| Printable text | Filter names |
| Backspace | Delete the last filter character |
| Ctrl-U | Clear the filter |
| Enter | Open selection actions |
| Esc / Ctrl-C | Cancel without applying or saving |
| `u` in selection actions | Use the theme for this session |
| `s` in selection actions | Save as default and reload the shell |
| `b` or Enter in selection actions | Return to browsing |

Using a theme calls `omz theme use`: it does **not** remove hooks, widgets, or other
state installed by your previous theme. Saving calls `omz theme set`, edits `.zshrc`,
and reloads the shell. These actions happen only after leaving the browser and
restoring terminal state. Names containing shell punctuation cannot be saved through
the browser; configure those manually. No global aliases or keybindings are installed.

## Preview Limits

- Each preview runs in a fresh `zsh -df` worker, not your active shell. The worker
  inherits the directory and exported environment, but not non-exported theme
  settings, plugins, user `.zshrc`, or custom library overrides. System `zshenv`
  still runs as required by zsh.
- Previews initialize prompt helpers and precmd hooks. They show a successful
  previous command (status 0). Tests also exercise nonzero status rendering.
- Multiline left prompts are supported. Right prompts are deliberately labeled
  and displayed separately, not positioned as ZLE would position them.
- Interactive/async themes, plugin-dependent segments, terminal queries, and
  widget-driven prompts may be incomplete or unsupported. Themes still require
  their usual fonts for special glyphs; the browser itself requires no fonts.
- Workers have a three-second execution limit and a 32,000-byte output limit.
  Navigation cancels obsolete work. ANSI colors are retained; other terminal
  controls are filtered. Long lines and tall previews are clipped in the browser.
- The browser requires an interactive terminal with alternate-screen support and
  at least 40 columns by 16 rows. Smaller windows show a resize message; Esc still
  exits. `omz theme preview` also works without an interactive terminal.
- This is **shell-state isolation, not a security sandbox**. Only preview trusted
  themes: their code can write files, access the network, or deliberately detach
  processes. The supervisor cleans up ordinary descendants, not escaped processes.

No new third-party runtime is required. The implementation uses standard zsh modules
(`zpty`, `system`, `datetime`, `zselect`, `terminfo`) and platform utilities including
`stty`, `mktemp`, `mkfifo`, and `rm`. Git segments need Git as usual. Private temporary
files are removed when previews finish or are cancelled. Full OMZ startup, update
checks, and OMZ cache initialization are not invoked by workers. The old
`tools/theme_chooser.sh` is unchanged.

## Local Testing

From this checkout, launch a disposable interactive shell without reading your `.zshrc`:

```zsh
env ZSH="$PWD" zsh -dfi
```

Inside it, load the CLI and try previews. Change directory to a Git repository to
compare clean, dirty, and untracked-file states:

```zsh
source "$ZSH/lib/cli.zsh"
omz theme preview robbyrussell
omz theme preview agnoster
omz theme preview half-life
omz theme preview dieter
omz theme browse
```

This minimal shell is intended for preview/navigation testing. For a real session-use
test, load this checkout's full OMZ configuration in a disposable shell. Do not choose
Save unless you intend to edit your actual `.zshrc`; automated browser tests stub both
actions and never edit your configuration. Exit the disposable shell when finished.

Regression suites run without additional test frameworks:

```zsh
zsh -df tools/tests/theme-preview.zsh
zsh -df tools/tests/theme-browser.zsh
```

The tests cover resolution, prompt isolation, Git context, hook/status rendering,
terminal-control filtering, failures, time/output limits, descendant cleanup,
completion candidates, lazy loading, keyboard navigation, resizing, action dispatch,
and terminal restoration using real PTYs. Human visual testing in your terminal and
font is still required before proposing a PR. Linux/older-zsh testing remains pending.

## Footprint And Startup

Runtime code is roughly 18 KiB across the three `tools/theme-*.zsh` files, plus small
CLI wrappers and completion/help entries. Tests and this guide are additional text
files, not runtime dependencies. Measure the exact current footprint with:

```zsh
wc -c tools/theme-browser.zsh tools/theme-preview.zsh tools/theme-preview-worker.zsh
```

Normal shell startup only defines the CLI wrappers: none of the three tool files is
sourced, no browser modules are loaded, and no workers or browser I/O are started.
The regression suite verifies lazy loading. Startup timing should be considered
noise-sensitive; this prototype does not claim a measurable speed improvement.
