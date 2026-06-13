# iw plugin

This plugin adds tab completion for [`iw`](https://wireless.wiki.kernel.org/en/users/documentation/iw),
the standard Linux command-line tool for configuring wireless network interfaces.

To use it, add `iw` to the plugins array in your zshrc file:

```zsh
plugins=(... iw)
```

## Completion

Completion is generated dynamically by parsing the output of `iw help` and cached for
performance. The cache is stored in `$ZSH_CACHE_DIR/_iw_cache` and is automatically
regenerated when the installed version of `iw` changes.

The following command structure is completed:

| Level | Examples |
| ----- | -------- |
| Top-level commands | `dev`, `phy`, `wdev`, `reg`, `list`, `event`, … (discovered dynamically) |
| Interface / phy names | `wlan0`, `phy0` (discovered from `/sys/class/net` and `/sys/class/ieee80211`) |
| Subcommands | `dev <if> scan`, `dev <if> station`, `phy <phy> set`, … |
| Sub-subcommands | `dev <if> scan dump`, `dev <if> station get`, `phy <phy> set txpower`, … |

## Functions

| Function | Description |
| -------- | ----------- |
| `iw-clear-cache` | Delete the cached completion data (useful after upgrading `iw`) |

## Requirements

- `iw` must be installed and in `$PATH`
- Completion for a differently-named `iw` binary can be enabled with:

  ```zsh
  compdef _iw my-iw-binary
  ```
