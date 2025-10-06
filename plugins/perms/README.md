# Perms plugin

Plugin to handle some unix filesystem permissions quickly.

To use it, add `perms` to the plugins array in your zshrc file:

```zsh
plugins=(... perms)
```

## Usage

> **CAUTION:** these functions are harmful if you don't know what they do.

- `set755`: sets the permission to octal 755 for all given directories and their child directories (by default, starting from the current directory).

- `set644`: sets the permission to octal 644 for all files of the given directory (by default, the current directory), recursively. It will only affect regular files (no symlinks).

- `resetperms` is a wrapper around `set755` and `set644` applied to a specified directory or the current directory otherwise.
  It will set the permissions to 755 for directories, and 644 for files.

## Reference

- octal 644: _read and write_ for the owner, _read_ for the group and others users.
- octal 755: _read, write and execute_ permissions for the owner, and _read and execute_ for the group and others users.
