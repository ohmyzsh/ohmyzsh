# Perms plugin

Plugin to handle some unix filesystem permissions quickly.

To use it, add `perms` to the plugins array in your zshrc file:

```zsh
plugins=(... perms)
```

## Usage

* `set755` recursively sets all given directories (default to .) to octal 755.
* `set644` recursively sets all given files (default to .) to octal 644.
* `fixperms` is a wrapper around `set755` and `set644` applied to a specified directory or the current directory otherwise. It also prompts prior to execution unlike the other two aliases.
