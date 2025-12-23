# zsh-vi-man plugin

Smart man page lookup for zsh vi mode. Press `K` (Shift-K) on any command or option to instantly open its man page.

To use it, add `zsh-vi-man` to the plugins array in your zshrc file:

```zsh
plugins=(... zsh-vi-man)
```

## Features

- **Smart Detection**: Automatically finds the right man page for subcommands (e.g., `git commit` → `man git-commit`)
- **Option Jumping**: Opens man page directly at the option definition (e.g., `grep -r` → jumps to `-r` entry)
- **Combined Options**: Works with combined short options (e.g., `rm -rf` → finds both `-r` and `-f`)
- **Value Extraction**: Handles options with values (e.g., `--color=always` → searches `--color`)
- **Pipe Support**: Detects correct command in pipelines (e.g., `cat file | grep -i` → opens `man grep`)
- **Multiple Formats**: Supports various man page styles (GNU, jq, find, etc.)

## Usage

1. Type a command (e.g., `ls -la` or `git commit --amend`)
2. Press `Escape` to enter vi normal mode
3. Move cursor to any word
4. Press **`K`** to open the man page

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

Set these variables **before** sourcing oh-my-zsh:

```zsh
# Change the trigger key (default: K)
ZVM_MAN_KEY='?'

# Use a different pager (default: less)
ZVM_MAN_PAGER='bat'
```

## Integration with zsh-vi-mode

This plugin works seamlessly with [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode). It automatically detects zsh-vi-mode and hooks into its lazy keybindings system.

For best results, ensure zsh-vi-mode is loaded before this plugin:

```zsh
plugins=(... zsh-vi-mode zsh-vi-man)
```

## Requirements

- zsh with vi mode enabled (built-in or via `vi-mode` plugin)
- `man` command available

## License

MIT License - see [LICENSE](https://github.com/TunaCuma/zsh-vi-man/blob/main/LICENSE) for details.
