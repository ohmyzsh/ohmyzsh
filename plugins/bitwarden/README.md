# bitwarden-cli plugin

This plugin adds completion for [Bitwarden CLI](https://bitwarden.com/help/cli/) and unlock and login helper functions.

To use it, add `bitwarden` to the plugins array in your zshrc file:

```zsh
plugins=(... bitwarden)
```

## Functions

| Function    | Description                                                                                     |
|-------------|-------------------------------------------------------------------------------------------------|
| `bw_login`  | Login bitwarden and auto update BW_SESSION env export in your ~/.zshrc or '$ZSH_CUSTOM' files.  |
| `bw_unlock` | Unlock bitwarden and auto update BW_SESSION env export in your ~/.zshrc or '$ZSH_CUSTOM' files. |

## Cache

This plugin caches the completion script and is automatically updated when the
plugin is loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH_CACHE_DIR/completions/_bw` completions script
- `$ZSH_CACHE_DIR/bw_cached_version` completions script
