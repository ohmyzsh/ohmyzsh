# Man Plugin

This plugin provides a convenient shortcut to quickly view the manual (`man`) page for a command you've previously typed. It is especially useful when you're working in the terminal and want to look up usage details or options for a command without retyping it.

## Features
 - Automatically inserts `man` before the most recent command you've typed (or the one currently in the buffer).
 - If the command includes a subcommand (e.g., `git commit`), the plugin attempts to open a more specific manual page like `git-commit`, if available.
 - Smart fallback to the base command manual page if a more specific one doesn't exist.
 - Works by pressing a simple keyboard shorcut: <kbd>Esc</kbd> then typing `man`.

## Installation

To enable this plugin, add `man` to the `plugins` array in your `.zshrc`:

```zsh
plugins=(... man)
```

## Keyboard Shortcut

| Shortcut               | Description                                                          |
|------------------------|----------------------------------------------------------------------|
| <kbd>Esc</kbd> + `man` | Opens the man page for the previous or current command in the buffer |

## How It Works
 - If no command is typed in the current buffer, the plugin uses the last command from history.
 - If a command is already typed, it uses the contents of the buffer.
 - If the buffer already start with `man`, the plguin does nothing (to avoid duplication).
 - The plugin then tries to:
     - Show the manual for a combined command and subcommand (e.g., `git-commit`),
     - If that fails, it falls back to showing the manual for the base command (e.g., `git`).

For example:
```zsh
> git commit
# (then press <Esc> and type `man`)
# Result: opens the man page for git-commit if it exists, otherwise git
```
