# torrent

This plugin creates a Torrent file based on a [MagnetURI](https://en.wikipedia.org/wiki/Magnet_URI_scheme).

To use it, add `torrent` to the plugins array in your zshrc file.

```zsh
plugins=(... torrent)
```

## Plugin commands

* `magnet_to_torrent <MagnetURI>`: creates Torrent file.
