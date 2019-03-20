# `tig` plugin

This plugin adds some aliases for people who work with `tig` in
a regular basis. To use it, add `tig` to your plugins array:

```zsh
plugins=(... tig)
```

## Features

| Alias | Command        | Description                                     |
|-------|----------------|-------------------------------------------------|
| `tis` | `tig status`   | Show git status                                 |
| `til` | `tig log`      | Show git log                                    |
| `tib` | `tig blame -C` | `git-blame` a file detecting copies and renames |
