# Perms plugin

Plugin to handle some unix filesystem permissions quickly.

To use it, add `perms` to the plugins array in your zshrc file:

```zsh
plugins=(... perms)
```

## Usage

First of all, **CAUTION!**. The following functions are really harmful if you don't know what they exactly do. All three functions are going to change RECURSIVELY the permissions in files and/or directories.

Taking this into account, this plugin defines three different functions:

- `set755` recursively sets all given directories (default to .) to octal 755. It only affects directories.
- `set644` recursively sets all given files (default to .) to octal 644. It only affects regular files.
- `normalizeperms` is a wrapper around `set755` and `set644` applied to a specified directory or the current directory otherwise. It also prompts prior to execution unlike the other two aliases.
