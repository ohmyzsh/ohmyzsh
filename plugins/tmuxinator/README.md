# Tmuxinator plugin

This plugin provides completion for [tmuxinator](https://github.com/tmuxinator/tmuxinator),
as well as aliases for frequent tmuxinator commands.

To use it add `tmuxinator` to the plugins array in your zshrc file.

```zsh
plugins=(... tmuxinator)
```

## Aliases

| Alias | Command          | Description              |
| ----- | ---------------- | ------------------------ |
| `txs` | tmuxinator start | Start Tmuxinator         |
| `txo` | tmuxinator open  | Open project for editing |
| `txn` | tmuxinator new   | Create project           |
| `txl` | tmuxinator list  | List projects            |
