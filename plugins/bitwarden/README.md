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

The completions are cached at `$ZSH_CACHE_DIR/completions/_bw`.
