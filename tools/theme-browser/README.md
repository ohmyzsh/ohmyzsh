# Theme Browser

Preview installed themes without changing your current prompt:

```zsh
omz theme browse
omz theme browse agn
omz theme preview agnoster
```

The browser filters theme names as you type and renders the highlighted theme using
the current directory, including synchronous Git information.

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

Using a theme changes the current session. It does not remove hooks or widgets installed
by the previous theme. Saving updates `ZSH_THEME` in `.zshrc` and reloads the shell.

## Limitations

- Previews run in a fresh shell, so plugin-dependent and interactive themes may be incomplete.
- Right prompts are labeled and shown separately rather than positioned by ZLE.
- The browser requires an interactive terminal with alternate-screen support.
- Theme code is isolated from your active shell, but it is not sandboxed. Preview only trusted themes.

## Local Testing

From this checkout, launch a disposable interactive shell:

```zsh
env ZSH="$PWD" zsh -dfi
source "$ZSH/lib/cli.zsh"
omz theme preview robbyrussell
omz theme browse
```

Run the regression suites with:

```zsh
zsh -df tools/theme-browser/tests/preview_test.zsh
zsh -df tools/theme-browser/tests/browser_test.zsh
```
