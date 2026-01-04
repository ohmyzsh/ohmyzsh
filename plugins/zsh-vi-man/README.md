# zsh-vi-man plugin

Smart man page lookup for zsh vi mode (and emacs mode).

Press `K` in vi normal mode, `Ctrl-X k` in emacs mode, or `Ctrl-K` in vi insert mode on any
command or option to instantly open its man page. If your cursor is on an option (like `-r`
or `--recursive`), it will jump directly to that option in the man page.

To use it, add `zsh-vi-man` to the plugins array in your zshrc file:

```zsh
plugins=(... zsh-vi-man)
```

## Features

- **Smart Detection**: Automatically finds the right man page for subcommands
  (`git commit` → `man git-commit`, `docker run` → `man docker-run`)
- **Option Jumping**: Opens man page directly at the option definition
  (`grep -r` → jumps to `-r` entry)
- **Combined Options**: Works with combined short options (`rm -rf` → finds both `-r` and `-f`)
- **Value Extraction**: Handles options with values (`--color=always` → searches `--color`)
- **Pipe Support**: Detects correct command in pipelines (`cat file | grep -i` → opens `man grep`)
- **Multiple Formats**: Supports various man page styles (GNU, jq-style, find-style)

## Usage

### Vi Normal Mode (Default)

1. Type a command (e.g., `ls -la` or `git commit --amend`)
2. Press `Escape` to enter vi normal mode
3. Move cursor to any word
4. Press `K` to open the man page

### Emacs Mode / Vi Insert Mode

Without leaving insert mode or if using emacs mode:

- **Emacs mode**: Press `Ctrl-X` then `k`
- **Vi insert mode**: Press `Ctrl-K`

### Examples

| Command                | Cursor On      | Result                               |
| :--------------------- | :------------- | :----------------------------------- |
| `ls -la`               | `ls`           | Opens `man ls`                       |
| `ls -la`               | `-la`          | Opens `man ls`, jumps to `-l`        |
| `git commit --amend`   | `commit`       | Opens `man git-commit`               |
| `grep --color=auto`    | `--color=auto` | Opens `man grep`, jumps to `--color` |
| `cat file \| sort -r`  | `-r`           | Opens `man sort`, jumps to `-r`      |
| `find . -name "*.txt"` | `-name`        | Opens `man find`, jumps to `-name`   |

## Configuration

Set these variables **before** Oh My Zsh is sourced:

```zsh
# Vi normal mode key (default: K)
ZVM_MAN_KEY='?'

# Emacs mode key sequence (default: ^Xk, i.e., Ctrl-X k)
ZVM_MAN_KEY_EMACS='^X^K'  # Example: Ctrl-X Ctrl-K

# Vi insert mode key (default: ^K, i.e., Ctrl-K)
ZVM_MAN_KEY_INSERT='^H'   # Example: Ctrl-H

# Enable/disable emacs mode binding (default: true)
ZVM_MAN_ENABLE_EMACS=false

# Enable/disable vi insert mode binding (default: true)
ZVM_MAN_ENABLE_INSERT=false

# Use a different pager (default: less, supports nvim/vim)
ZVM_MAN_PAGER='nvim'
```

## Troubleshooting

**Keybindings not working?**

If keybindings don't work after sourcing the plugin, try running:

```zsh
zvm_man_rebind
```

This can happen if:

- Your plugin manager loads plugins before setting up keymaps
- You call `bindkey -e` or `bindkey -v` after the plugin loads
- Another plugin resets your keybindings

For persistent issues, add this to your `.zshrc` **after** sourcing Oh My Zsh:

```zsh
# Ensure zsh-vi-man bindings are set
zvm_man_rebind
```

## Integration with zsh-vi-mode

This plugin works seamlessly with [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode).
It automatically detects zsh-vi-mode and hooks into its lazy keybindings system.

## Author

- [Tuna Cuma](https://github.com/TunaCuma)

## License

MIT License - see [LICENSE](https://github.com/TunaCuma/zsh-vi-man/blob/main/LICENSE) for details.

